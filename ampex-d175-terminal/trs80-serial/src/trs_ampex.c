#ifndef _WIN32
#define _POSIX_C_SOURCE 200809L
#endif

#include <SDL.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef _WIN32
#  include <windows.h>
#else
#  include <fcntl.h>
#  include <signal.h>
#  include <sys/ioctl.h>
#  include <termios.h>
#  include <unistd.h>
#endif

#include "trs.h"
#include "trs_ampex.h"

#define TRS_COLS         64
#define TRS_ROWS         16
#define TRS_CELLS        (TRS_COLS * TRS_ROWS)

#define AMPEX_COLS       80
#define AMPEX_ROWS       24
#define OFFSET_COL       8
#define OFFSET_ROW       4

#define BORDER_ROW_TOP   (OFFSET_ROW - 1)
#define BORDER_ROW_BOT   (OFFSET_ROW + TRS_ROWS)
#define BORDER_COL_LEFT  (OFFSET_COL - 1)
#define BORDER_COL_RIGHT (OFFSET_COL + TRS_COLS)

#define ESC             0x1B
#define GFX_ENTER       'F'
#define GFX_EXIT        'G'
#define CUR_ADDR        'Y'
#define ERASE_TO_EOS    'J'

#define BOX_TL          0x6C
#define BOX_TR          0x6D
#define BOX_BL          0x6B
#define BOX_BR          0x6E
#define BOX_H           0x68
#define BOX_V           0x69

#define KEY_HOLD_MS     50
#define HOST_ESCAPE     0x1C
#define HELP_PREFIX     0x1F      /* HELP key on Ampex sends 0x1F 0x48 */

#ifdef _WIN32
static HANDLE       serial_fd = INVALID_HANDLE_VALUE;
static DCB          saved_dcb;
static COMMTIMEOUTS saved_timeouts;
static int          saved_state_valid = 0;
#else
static int            serial_fd = -1;
static struct termios saved_termios;
static int            saved_state_valid = 0;
#endif

static int serial_is_open(void)
{
#ifdef _WIN32
    return serial_fd != INVALID_HANDLE_VALUE;
#else
    return serial_fd >= 0;
#endif
}

static unsigned char shadow[TRS_CELLS];
static unsigned char dirty[TRS_CELLS];
static int          dirty_any = 0;

volatile int trs_ampex_quit_requested = 0;

int text80x24 = 0;

static struct {
    int       active;
    long long deadline_ms;
    int       keysym;
} pressed_keys[16];

static int keydebug = 0;

void trs_ampex_set_keydebug(int on)
{
    keydebug = on ? 1 : 0;
}

static int menu_active = 0;
static int menu_sel = 0;

static long long now_ms(void)
{
#ifdef _WIN32
    return (long long)GetTickCount64();
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (long long)ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
#endif
}

static void short_sleep_ms(int ms)
{
#ifdef _WIN32
    Sleep(ms);
#else
    struct timespec ts = { ms / 1000, (long)(ms % 1000) * 1000 * 1000 };
    nanosleep(&ts, NULL);
#endif
}

static void short_sleep_us(int us)
{
#ifdef _WIN32
    /* Windows Sleep granularity is 1 ms; round up. */
    Sleep((us + 999) / 1000);
#else
    struct timespec ts = { us / 1000000, (long)(us % 1000000) * 1000 };
    nanosleep(&ts, NULL);
#endif
}

/* Inter-byte pacing: sleep this long after every byte clocks out, on top
 * of the natural 520 us bit-time at 19200 baud. Lets the terminal's
 * firmware drain its input ring before we feed it the next char. */
#define INTER_BYTE_SLEEP_US 400

static int serial_write_chunk(const unsigned char *p, int n)
{
#ifdef _WIN32
    DWORD written = 0;
    if (!WriteFile(serial_fd, p, (DWORD)n, &written, NULL))
        return -1;
    return (int)written;
#else
    ssize_t w = write(serial_fd, p, (size_t)n);
    if (w < 0) {
        if (errno == EAGAIN || errno == EWOULDBLOCK)
            return 0;
        if (errno == EINTR)
            return 0;
        return -1;
    }
    return (int)w;
#endif
}

static int serial_read_chunk(unsigned char *p, int n)
{
#ifdef _WIN32
    DWORD got = 0;
    if (!ReadFile(serial_fd, p, (DWORD)n, &got, NULL))
        return -1;
    return (int)got;
#else
    ssize_t r = read(serial_fd, p, (size_t)n);
    if (r < 0) {
        if (errno == EAGAIN || errno == EWOULDBLOCK)
            return 0;
        return -1;
    }
    return (int)r;
#endif
}

/* Drain everything in-flight: kernel TTY queue + UART FIFO must be empty
 * before we return. With IXON, this also blocks while output is paused
 * by an XOFF, so the next out_byte() will only proceed once the terminal
 * has released us with XON. */
static void serial_drain(void)
{
#ifdef _WIN32
    FlushFileBuffers(serial_fd);
#else
    tcdrain(serial_fd);
#endif
}

/* Send one byte and wait for it to physically clock onto the wire before
 * returning. This keeps at most a single byte buffered anywhere below us
 * so the terminal's XOFF can stop output within one byte instead of after
 * a 4 KB backlog drains. */
static void out_byte(unsigned char b)
{
    for (;;) {
        int n = serial_write_chunk(&b, 1);
        if (n == 1)
            break;
        if (n < 0)
            return;
        short_sleep_ms(1);
    }
    serial_drain();
    short_sleep_us(INTER_BYTE_SLEEP_US);
}

static void out_bytes(const unsigned char *p, int n)
{
    for (int i = 0; i < n; i++)
        out_byte(p[i]);
}

static void out_flush(void)
{
    serial_drain();
}

static void out_cursor(int row, int col)
{
    unsigned char seq[4] = { ESC, CUR_ADDR, (unsigned char)(0x20 + row), (unsigned char)(0x20 + col) };
    out_bytes(seq, 4);
}

static void out_esc(unsigned char cmd)
{
    out_byte(ESC);
    out_byte(cmd);
}

static unsigned char remap_sextant(unsigned char trs_mask);

static void classify_cell(unsigned char c, int *is_gfx, unsigned char *glyph)
{
    if (c < 0x20) {
        *is_gfx = 0;
        *glyph  = ' ';
    } else if (c < 0x80) {
        *is_gfx = 0;
        *glyph  = c;
    } else {
        *is_gfx = 1;
        *glyph  = 0x20 + remap_sextant(c & 0x3F);
    }
}

#ifdef _WIN32
static int configure_com(const char *device)
{
    char path[64];
    if (strncmp(device, "\\\\.\\", 4) == 0 || strchr(device, ':') != NULL)
        snprintf(path, sizeof(path), "%s", device);
    else
        snprintf(path, sizeof(path), "\\\\.\\%s", device);

    serial_fd = CreateFileA(path,
                            GENERIC_READ | GENERIC_WRITE,
                            0, NULL, OPEN_EXISTING, 0, NULL);
    if (serial_fd == INVALID_HANDLE_VALUE) {
        fprintf(stderr, "trs80-ampex: CreateFile %s: error %lu\n",
                path, (unsigned long)GetLastError());
        return -1;
    }

    /* Shrink kernel output queue to 1 byte so XOFF stops us promptly. */
    SetupComm(serial_fd, 4096, 1);

    DCB dcb;
    memset(&dcb, 0, sizeof(dcb));
    dcb.DCBlength = sizeof(dcb);
    if (!GetCommState(serial_fd, &dcb)) {
        fprintf(stderr, "trs80-ampex: GetCommState: error %lu\n", (unsigned long)GetLastError());
        goto fail;
    }
    saved_dcb = dcb;

    COMMTIMEOUTS to;
    if (!GetCommTimeouts(serial_fd, &to)) {
        fprintf(stderr, "trs80-ampex: GetCommTimeouts: error %lu\n", (unsigned long)GetLastError());
        goto fail;
    }
    saved_timeouts = to;
    saved_state_valid = 1;

    dcb.BaudRate = CBR_19200;
    dcb.fBinary  = TRUE;
    dcb.fParity  = FALSE;
    dcb.ByteSize = 8;
    dcb.Parity   = NOPARITY;
    dcb.StopBits = ONESTOPBIT;
    dcb.fOutxCtsFlow = FALSE;
    dcb.fOutxDsrFlow = FALSE;
    dcb.fDtrControl  = DTR_CONTROL_ENABLE;
    dcb.fRtsControl  = RTS_CONTROL_ENABLE;
    dcb.fInX  = TRUE;
    dcb.fOutX = TRUE;
    dcb.XonChar  = 0x11;
    dcb.XoffChar = 0x13;
    dcb.XonLim   = 512;
    dcb.XoffLim  = 512;
    dcb.fNull = FALSE;
    dcb.fAbortOnError = FALSE;
    if (!SetCommState(serial_fd, &dcb)) {
        fprintf(stderr, "trs80-ampex: SetCommState: error %lu\n", (unsigned long)GetLastError());
        goto fail;
    }

    to.ReadIntervalTimeout         = MAXDWORD;
    to.ReadTotalTimeoutMultiplier  = 0;
    to.ReadTotalTimeoutConstant    = 0;
    to.WriteTotalTimeoutMultiplier = 0;
    to.WriteTotalTimeoutConstant   = 500;
    if (!SetCommTimeouts(serial_fd, &to)) {
        fprintf(stderr, "trs80-ampex: SetCommTimeouts: error %lu\n", (unsigned long)GetLastError());
        goto fail;
    }

    return 0;

fail:
    CloseHandle(serial_fd);
    serial_fd = INVALID_HANDLE_VALUE;
    saved_state_valid = 0;
    return -1;
}
#else
static int configure_tty(const char *device)
{
    serial_fd = open(device, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (serial_fd < 0) {
        fprintf(stderr, "trs80-ampex: open %s: %s\n", device, strerror(errno));
        return -1;
    }
    struct termios t;
    if (tcgetattr(serial_fd, &t) < 0) {
        fprintf(stderr, "trs80-ampex: tcgetattr: %s\n", strerror(errno));
        close(serial_fd);
        serial_fd = -1;
        return -1;
    }
    saved_termios = t;
    saved_state_valid = 1;
    cfmakeraw(&t);
    cfsetispeed(&t, B19200);
    cfsetospeed(&t, B19200);
    t.c_cflag |= CS8 | CREAD | CLOCAL;
    t.c_cflag &= ~(PARENB | CSTOPB);
    t.c_iflag |= IXON | IXOFF | IXANY;
    t.c_iflag &= ~(INLCR | IGNCR | ICRNL);
    t.c_cc[VMIN]  = 0;
    t.c_cc[VTIME] = 0;
    if (tcsetattr(serial_fd, TCSANOW, &t) < 0) {
        fprintf(stderr, "trs80-ampex: tcsetattr: %s\n", strerror(errno));
        close(serial_fd);
        serial_fd = -1;
        saved_state_valid = 0;
        return -1;
    }
    return 0;
}
#endif

int trs_ampex_open(const char *device)
{
#ifdef _WIN32
    if (configure_com(device) < 0)
        return -1;
#else
    if (configure_tty(device) < 0)
        return -1;
#endif
    memset(shadow, ' ', sizeof(shadow));
    memset(dirty, 0, sizeof(dirty));
    dirty_any = 0;
    return 0;
}

void trs_ampex_close(void)
{
    if (!serial_is_open())
        return;
#ifdef _WIN32
    if (saved_state_valid) {
        SetCommState(serial_fd, &saved_dcb);
        SetCommTimeouts(serial_fd, &saved_timeouts);
    }
    CloseHandle(serial_fd);
    serial_fd = INVALID_HANDLE_VALUE;
#else
    if (saved_state_valid)
        tcsetattr(serial_fd, TCSANOW, &saved_termios);
    close(serial_fd);
    serial_fd = -1;
#endif
    saved_state_valid = 0;
}

void trs_ampex_clear_screen(void)
{
    out_cursor(0, 0);
    out_esc(ERASE_TO_EOS);
    out_flush();
}

int trs_ampex_draw_border(void)
{
    /* The Ampex's input buffer is roughly 64 bytes and its XOFF watermark
     * is too close to full to save us, so we chunk long runs and pause
     * between chunks to keep the buffer at most half full. */
    const int BORDER_SLEEP_MS = 5;
    const int BORDER_CHUNK    = 4;

    out_esc(GFX_ENTER);

    out_cursor(BORDER_ROW_TOP, BORDER_COL_LEFT);
    out_byte(BOX_TL);
    for (int c = 0; c < TRS_COLS; c++) {
        out_byte(BOX_H);
        if ((c + 1) % BORDER_CHUNK == 0)
            short_sleep_ms(BORDER_SLEEP_MS);
    }
    out_byte(BOX_TR);
    short_sleep_ms(BORDER_SLEEP_MS);

    for (int r = 0; r < TRS_ROWS; r++) {
        out_cursor(OFFSET_ROW + r, BORDER_COL_LEFT);
        out_byte(BOX_V);
        out_cursor(OFFSET_ROW + r, BORDER_COL_RIGHT);
        out_byte(BOX_V);
        short_sleep_ms(BORDER_SLEEP_MS);
    }

    out_cursor(BORDER_ROW_BOT, BORDER_COL_LEFT);
    out_byte(BOX_BL);
    for (int c = 0; c < TRS_COLS; c++) {
        out_byte(BOX_H);
        if ((c + 1) % BORDER_CHUNK == 0)
            short_sleep_ms(BORDER_SLEEP_MS);
    }
    out_byte(BOX_BR);
    short_sleep_ms(BORDER_SLEEP_MS);

    out_esc(GFX_EXIT);
    out_flush();
    return 0;
}

/* Runtime-configurable bit permutation for sextants.
 * sextant_bitmap[i] says "where does TRS-80 bit i go in the Ampex mask".
 * Default {1,0,3,2,5,4} (perm "103254"): the Ampex D175 uses the opposite
 * left/right bit ordering within each sextant row compared to the TRS-80
 * Model I, so every L/R pair is swapped. Confirmed empirically against
 * hardware with tools/make_gfx_table_rom.py.
 * Pass --sextant-perm 012345 to restore identity mapping. */
static unsigned char sextant_bitmap[6] = {1, 0, 3, 2, 5, 4};

void trs_ampex_set_sextant_perm(const char *perm6)
{
    if (!perm6 || strlen(perm6) != 6)
        return;
    unsigned char seen = 0;
    unsigned char tmp[6];
    for (int i = 0; i < 6; i++) {
        if (perm6[i] < '0' || perm6[i] > '5')
            return;
        tmp[i] = perm6[i] - '0';
        if (seen & (1u << tmp[i]))
            return;
        seen |= (1u << tmp[i]);
    }
    memcpy(sextant_bitmap, tmp, 6);
}

static unsigned char remap_sextant(unsigned char trs_mask)
{
    unsigned char out = 0;
    for (int i = 0; i < 6; i++)
        if (trs_mask & (1u << i))
            out |= (1u << sextant_bitmap[i]);
    return out;
}

/* Probe: bypass the emulator, write every sextant glyph in a labelled
 * grid (rows 2..5, cols 0..F) so you can compare against the chargen.
 * Exits after writing. */
void trs_ampex_probe(void)
{
    trs_ampex_clear_screen();

    /* Header row: column labels 0..F in text mode at row 0, cols 4..36 */
    out_cursor(0, 0);
    const char *hdr = "    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F";
    for (const char *p = hdr; *p; p++)
        out_byte((unsigned char)*p);

    /* For each high-nibble row (2..5), emit 16 sextant cells */
    for (int hi = 2; hi <= 5; hi++) {
        out_cursor(1 + (hi - 2) * 2, 0);
        out_byte('0' + hi);
        out_byte(':');
        out_byte(' ');
        out_byte(' ');
        out_esc(GFX_ENTER);
        for (int lo = 0; lo < 16; lo++) {
            unsigned char code = (hi << 4) | lo;
            out_byte(code);
            out_byte(' ');
            out_byte(' ');
        }
        out_esc(GFX_EXIT);
    }

    /* Also emit what the TRS-80 identity mapping produces for each of the
     * 64 block-graphic codes, labelled so you can compare visually. */
    out_cursor(10, 0);
    const char *msg = "TRS-80 0x80-0xBF -> Ampex glyph (identity map):";
    for (const char *p = msg; *p; p++)
        out_byte((unsigned char)*p);
    for (int hi = 0; hi < 4; hi++) {
        out_cursor(12 + hi * 2, 0);
        out_byte('8' + hi);
        out_byte(':');
        out_byte(' ');
        out_byte(' ');
        out_esc(GFX_ENTER);
        for (int lo = 0; lo < 16; lo++) {
            unsigned char trs = 0x80 | (hi << 4) | lo;
            unsigned char mapped = 0x20 + remap_sextant(trs & 0x3F);
            out_byte(mapped);
            out_byte(' ');
            out_byte(' ');
        }
        out_esc(GFX_EXIT);
    }

    out_flush();
}

void trs_ampex_flush(void)
{
    if (!dirty_any || !serial_is_open() || menu_active)
        return;

    int last_r = -1, last_c = -1;
    int in_gfx = 0;

    for (int pos = 0; pos < TRS_CELLS; pos++) {
        if (!dirty[pos])
            continue;

        int r = pos / TRS_COLS;
        int c = pos % TRS_COLS;
        int is_gfx;
        unsigned char glyph;
        classify_cell(shadow[pos], &is_gfx, &glyph);

        int need_cursor_move = !(r == last_r && c == last_c + 1);

        /* Toggle gfx mode based on this cell's type. Cursor moves are
         * emitted WITHIN graphics mode (matching the SerialTetris
         * convention) — the Ampex's ESC parser handles ESC Y mid-gfx,
         * but ESC G clears alt-charset state and breaks rendering. */
        if (is_gfx && !in_gfx) {
            out_esc(GFX_ENTER);
            in_gfx = 1;
        } else if (!is_gfx && in_gfx) {
            out_esc(GFX_EXIT);
            in_gfx = 0;
        }

        if (need_cursor_move)
            out_cursor(OFFSET_ROW + r, OFFSET_COL + c);

        out_byte(glyph);
        dirty[pos] = 0;
        last_r = r;
        last_c = c;
    }

    if (in_gfx)
        out_esc(GFX_EXIT);

    dirty_any = 0;
    out_flush();
}

void trs_screen_write_char(unsigned int position, Uint8 character)
{
    if (position >= TRS_CELLS)
        return;
    if (shadow[position] != character) {
        shadow[position] = character;
        dirty[position]  = 1;
        dirty_any        = 1;
    }
}

void trs_screen_refresh(void)
{
    for (int i = 0; i < TRS_CELLS; i++)
        dirty[i] = 1;
    dirty_any = 1;
    trs_ampex_flush();
}

void trs_screen_update(void)
{
    trs_ampex_flush();
}

void trs_screen_reset(void)
{
    memset(shadow, ' ', sizeof(shadow));
    memset(dirty, 0, sizeof(dirty));
    dirty_any = 0;
    trs_ampex_clear_screen();
    trs_ampex_draw_border();
}

void trs_screen_init(int resize)
{
    (void)resize;
}

void trs_screen_mode(int mode, int flag)
{
    (void)mode;
    (void)flag;
}

void trs_screen_80x24(int flag)
{
    (void)flag;
}

void trs_screen_caption(void)
{
}

void trs_sdl_init(void)
{
    if (SDL_Init(SDL_INIT_TIMER) != 0) {
        fprintf(stderr, "trs80-ampex: SDL_Init: %s\n", SDL_GetError());
    }
    atexit(SDL_Quit);
}

void trs_exit(int confirm)
{
    (void)confirm;
    trs_ampex_quit_requested = 1;
    trs_ampex_close();
    exit(0);
}

void trs_disk_led(int drive, int on_off)      { (void)drive; (void)on_off; }
void trs_hard_led(int drive, int on_off)      { (void)drive; (void)on_off; }
void trs_turbo_led(void)                       { }

static int find_or_alloc_press_slot(int keysym)
{
    for (size_t i = 0; i < sizeof(pressed_keys)/sizeof(pressed_keys[0]); i++) {
        if (pressed_keys[i].active && pressed_keys[i].keysym == keysym)
            return (int)i;
    }
    for (size_t i = 0; i < sizeof(pressed_keys)/sizeof(pressed_keys[0]); i++) {
        if (!pressed_keys[i].active)
            return (int)i;
    }
    return -1;
}

static void record_press(int keysym)
{
    int slot = find_or_alloc_press_slot(keysym);
    if (slot < 0)
        return;
    pressed_keys[slot].active      = 1;
    pressed_keys[slot].keysym      = keysym;
    pressed_keys[slot].deadline_ms = now_ms() + KEY_HOLD_MS;
}

static void inject_key(int keysym)
{
    if (keydebug) {
        fprintf(stderr, "  -> trs keysym 0x%x\n", keysym);
        fflush(stderr);
    }
    trs_xlate_keysym(keysym);
    record_press(keysym);
}

void trs_ampex_age_key_releases(void)
{
    long long t = now_ms();
    for (size_t i = 0; i < sizeof(pressed_keys)/sizeof(pressed_keys[0]); i++) {
        if (pressed_keys[i].active && t >= pressed_keys[i].deadline_ms) {
            trs_xlate_keysym(pressed_keys[i].keysym | 0x10000);
            pressed_keys[i].active = 0;
        }
    }
}

/* ---- Full-screen HELP menu ------------------------------------------ */

extern const char *trs_disk_getfilename(int unit);
extern int          trs_disk_getwriteprotect(int unit);
extern const char *trs_cassette_getfilename(void);
extern int          trs_state_save(const char *filename);
extern int          trs_state_load(const char *filename);
extern int          trs_write_config_file(const char *filename);
extern int          trs_load_config_file(void);
extern void         trs_disk_insert(int drive, const char *name);
extern void         trs_disk_remove(int drive);
extern void         trs_cassette_insert(const char *name);
extern void         trs_cassette_remove(void);
extern char         trs_state_file[];
extern char         trs_config_file[];

/* forward */
struct menu_page;
typedef void (*menu_act_fn)(int arg);

typedef struct {
    const char  *label;
    menu_act_fn  act;
    int          arg;
} menu_entry_t;

typedef struct menu_page {
    const char         *title;
    const menu_entry_t *items;
    int                 item_count;
    int                 show_disks;     /* include disk/cassette status rows */
} menu_page_t;

static const menu_page_t *cur_page;
static char   msg_text[128] = {0};

enum menu_mode_e {
    MM_PAGE       = 0,
    MM_PATH_INPUT = 1,
    MM_ABOUT      = 2,
};
static int mm = MM_PAGE;

/* path-input state */
static char         path_buf[256];
static int          path_len    = 0;
static const char  *prompt_text = "";
static int          path_action = 0;   /* which operation to execute on submit */
static int          path_drive  = 0;

static void out_text(const char *s)
{
    for (; *s; s++) out_byte((unsigned char)*s);
}

static void out_textn(const char *s, int n)
{
    for (int i = 0; i < n && s[i]; i++) out_byte((unsigned char)s[i]);
}

static void clear_screen_area(void)
{
    out_cursor(0, 0);
    out_esc(ERASE_TO_EOS);
}

static void draw_full_box(void)
{
    out_esc(GFX_ENTER);
    out_cursor(0, 0);
    out_byte(0x6C);
    for (int c = 1; c < AMPEX_COLS - 1; c++) out_byte(0x68);
    out_byte(0x6D);
    for (int r = 1; r < AMPEX_ROWS - 1; r++) {
        out_cursor(r, 0);
        out_byte(0x69);
        out_cursor(r, AMPEX_COLS - 1);
        out_byte(0x69);
    }
    out_cursor(AMPEX_ROWS - 1, 0);
    out_byte(0x6B);
    for (int c = 1; c < AMPEX_COLS - 1; c++) out_byte(0x68);
    out_byte(0x6E);
    out_esc(GFX_EXIT);
}

static const char *safe_str(const char *s)
{
    return (s && s[0]) ? s : "(empty)";
}

#define FOOTER_ROW      (AMPEX_ROWS - 2)

/* item rows start here; each page can have up to ~12 items before scroll */
#define ITEM_ROW0  (cur_page->show_disks ? 9 : 4)

static void set_message(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(msg_text, sizeof(msg_text), fmt, ap);
    va_end(ap);
}

static void draw_footer(const char *default_text)
{
    out_cursor(FOOTER_ROW, 1);
    for (int c = 1; c < AMPEX_COLS - 1; c++) out_byte(' ');
    out_cursor(FOOTER_ROW, 2);
    if (msg_text[0]) {
        out_byte(' ');
        out_text(msg_text);
        out_byte(' ');
    } else {
        out_text(default_text);
    }
}

static const char *short_path(const char *s)
{
    if (!s || !s[0]) return "(empty)";
    int n = (int)strlen(s);
    if (n <= 58) return s;
    static char buf[72];
    snprintf(buf, sizeof(buf), "...%s", s + (n - 55));
    return buf;
}

static void draw_page_item(int i)
{
    if (i < 0 || i >= cur_page->item_count) return;
    out_cursor(ITEM_ROW0 + i, 6);
    out_byte(i == menu_sel ? '>' : ' ');
    out_byte(' ');
    out_text(cur_page->items[i].label);
}

static void draw_page_selector(int i)
{
    if (i < 0 || i >= cur_page->item_count) return;
    out_cursor(ITEM_ROW0 + i, 6);
    out_byte(i == menu_sel ? '>' : ' ');
}

static void draw_page(void)
{
    clear_screen_area();
    draw_full_box();

    /* title */
    int tlen = (int)strlen(cur_page->title);
    out_cursor(0, (AMPEX_COLS - tlen - 2) / 2);
    out_byte(' ');
    out_text(cur_page->title);
    out_byte(' ');

    /* optional disk/cassette status block */
    if (cur_page->show_disks) {
        for (int i = 0; i < 4; i++) {
            char line[80];
            snprintf(line, sizeof(line), "D%d: %s%s", i,
                     short_path(trs_disk_getfilename(i)),
                     (trs_disk_getfilename(i) && trs_disk_getfilename(i)[0] &&
                      trs_disk_getwriteprotect(i)) ? "  [WP]" : "");
            out_cursor(3 + i, 4);
            out_text(line);
        }
        out_cursor(7, 4);
        char cline[80];
        snprintf(cline, sizeof(cline), "Cas: %s", short_path(trs_cassette_getfilename()));
        out_text(cline);
    }

    /* items */
    for (int i = 0; i < cur_page->item_count; i++)
        draw_page_item(i);

    draw_footer(" arrows = navigate   Enter = select   ESC/HELP = back ");
    out_flush();
}

static void draw_path_input(void)
{
    clear_screen_area();
    draw_full_box();

    out_cursor(0, 2);
    out_text(" File path ");

    out_cursor(3, 4);
    out_text(prompt_text);

    out_cursor(6, 4);
    out_text("Path: ");
    out_textn(path_buf, path_len);
    out_byte('_');

    draw_footer(" type path   Enter = confirm   Backspace = erase   ESC/HELP = cancel ");
    out_flush();
}

static void draw_about(void)
{
    clear_screen_area();
    draw_full_box();

    out_cursor(0, (AMPEX_COLS - 17) / 2);
    out_text(" About trs80-ampex ");

    out_cursor(3, 8);
    out_text("trs80-ampex 0.1  -  TRS-80 Model I emulator over serial");
    out_cursor(4, 8);
    out_text("Based on sdltrs (jengun/sdltrs) by Jens Guenther et al.");
    out_cursor(5, 8);
    out_text("Ampex D175 VT52 serial backend by Matt Westveld.");

    out_cursor(8, 8);
    out_text("Host escape sequences (outside the menu):");
    out_cursor(9, 10);
    out_text("Ctrl-\\ q  = quit");
    out_cursor(10, 10);
    out_text("Ctrl-\\ r  = reset");
    out_cursor(11, 10);
    out_text("Ctrl-\\ b  = break");
    out_cursor(13, 8);
    out_text("HELP key  = open this menu");
    out_cursor(14, 8);
    out_text("ESC key   = cancel / close menu");

    draw_footer(" press ESC or HELP to return ");
    out_flush();
}

static void menu_redraw(void)
{
    switch (mm) {
        case MM_PAGE:       draw_page();        break;
        case MM_PATH_INPUT: draw_path_input();  break;
        case MM_ABOUT:      draw_about();       break;
    }
}

/* Action IDs passed via menu_entry.arg for path-input actions */
enum path_action_id {
    PA_INSERT_DISK = 1,
    PA_INSERT_CASS,
    PA_SAVE_STATE,
    PA_LOAD_STATE,
    PA_SAVE_CONFIG,
};

/* -------- page definitions -------- */
static const menu_page_t main_page;
static const menu_page_t disk_page;
static const menu_page_t cass_page;
static const menu_page_t config_page;
static const menu_page_t reset_page;

static void go_page(const menu_page_t *p)
{
    cur_page = p;
    menu_sel = 0;
    mm = MM_PAGE;
    menu_redraw();
}

/* nav */
static void act_goto(int arg) {
    (void)arg;
    const menu_page_t *pages[] = { &main_page, &disk_page, &cass_page, &config_page, &reset_page };
    go_page(pages[arg]);
}
static void act_about(int arg) { (void)arg; mm = MM_ABOUT; menu_redraw(); }

/* direct actions */
static void menu_close_and_restore(void);

static void act_cancel(int arg) { (void)arg; menu_close_and_restore(); }
static void act_quit(int arg)   { (void)arg; trs_ampex_quit_requested = 1; menu_close_and_restore(); }
static void act_soft_reset(int arg) { (void)arg; menu_close_and_restore(); trs_reset(0); }
static void act_hard_reset(int arg) { (void)arg; menu_close_and_restore(); trs_reset(1); }

static void act_disk_eject(int drive) {
    trs_disk_remove(drive);
    set_message(" ejected drive %d ", drive);
    draw_page();
}
static void act_cass_eject(int arg) {
    (void)arg;
    trs_cassette_remove();
    set_message(" cassette ejected ");
    draw_page();
}

/* path-input triggers */
static void enter_path(int action_id, int drive_arg,
                       const char *prompt, const char *preset)
{
    path_action = action_id;
    path_drive  = drive_arg;
    prompt_text = prompt;
    path_len    = 0;
    path_buf[0] = 0;
    if (preset) {
        for (; *preset && path_len < (int)sizeof(path_buf) - 1; preset++)
            path_buf[path_len++] = *preset;
        path_buf[path_len] = 0;
    }
    mm = MM_PATH_INPUT;
    menu_redraw();
}

static void act_disk_insert(int drive) {
    char buf[64];
    snprintf(buf, sizeof(buf), "Insert disk in drive %d - enter path:", drive);
    enter_path(PA_INSERT_DISK, drive, buf, NULL);
}
static void act_cass_insert(int arg) {
    (void)arg;
    enter_path(PA_INSERT_CASS, 0, "Insert cassette - enter path:", NULL);
}
static void act_save_state(int arg) {
    (void)arg;
    enter_path(PA_SAVE_STATE, 0, "Save state - enter path:", trs_state_file);
}
static void act_load_state(int arg) {
    (void)arg;
    enter_path(PA_LOAD_STATE, 0, "Load state - enter path:", trs_state_file);
}
static void act_save_config(int arg) {
    (void)arg;
    enter_path(PA_SAVE_CONFIG, 0, "Save configuration - enter path:", trs_config_file);
}
static void act_load_config(int arg) {
    (void)arg;
    int ok = trs_load_config_file();
    if (ok == 0) set_message(" config loaded: %s ", trs_config_file);
    else         set_message(" error loading config: %s ", trs_config_file);
    draw_page();
}

/* -------- page contents -------- */
static const menu_entry_t main_items[] = {
    {"Floppy Disk Management",        act_goto,  1},
    {"Cassette / Tape Management",    act_goto,  2},
    {"Configuration / State Files",   act_goto,  3},
    {"Reset / Power",                 act_goto,  4},
    {"About",                         act_about, 0},
    {"Quit emulator",                 act_quit,  0},
    {"Cancel (close menu)",           act_cancel,0},
};
static const menu_page_t main_page = {
    " TRS-80 Ampex -- Main Menu ",
    main_items, 7, 1,
};

static const menu_entry_t disk_items[] = {
    {"Insert disk in drive 0 ...",  act_disk_insert, 0},
    {"Insert disk in drive 1 ...",  act_disk_insert, 1},
    {"Insert disk in drive 2 ...",  act_disk_insert, 2},
    {"Insert disk in drive 3 ...",  act_disk_insert, 3},
    {"Eject drive 0",               act_disk_eject,  0},
    {"Eject drive 1",               act_disk_eject,  1},
    {"Eject drive 2",               act_disk_eject,  2},
    {"Eject drive 3",               act_disk_eject,  3},
    {"Back to main menu",           act_goto,        0},
};
static const menu_page_t disk_page = {
    " Floppy Disk Management ",
    disk_items, 9, 1,
};

static const menu_entry_t cass_items[] = {
    {"Insert cassette ...",        act_cass_insert, 0},
    {"Eject cassette",             act_cass_eject,  0},
    {"Back to main menu",          act_goto,        0},
};
static const menu_page_t cass_page = {
    " Cassette / Tape Management ",
    cass_items, 3, 0,
};

static const menu_entry_t config_items[] = {
    {"Save state to file ...",     act_save_state,  0},
    {"Load state from file ...",   act_load_state,  0},
    {"Save configuration ...",     act_save_config, 0},
    {"Load configuration (default path)", act_load_config, 0},
    {"Back to main menu",          act_goto,        0},
};
static const menu_page_t config_page = {
    " Configuration / State Files ",
    config_items, 5, 0,
};

static const menu_entry_t reset_items[] = {
    {"Soft reset (CPU only)",       act_soft_reset,  0},
    {"Hard reset (power-on)",       act_hard_reset,  0},
    {"Back to main menu",           act_goto,        0},
};
static const menu_page_t reset_page = {
    " Reset / Power ",
    reset_items, 3, 0,
};

static void menu_open(void)
{
    menu_active = 1;
    menu_sel    = 0;
    mm          = MM_PAGE;
    cur_page    = &main_page;
    msg_text[0] = 0;
    trs_paused  = 1;
    menu_redraw();
}

static void menu_close_and_restore(void)
{
    menu_active = 0;
    trs_paused  = 0;
    msg_text[0] = 0;
    trs_ampex_clear_screen();
    trs_ampex_draw_border();
    for (int i = 0; i < TRS_CELLS; i++)
        dirty[i] = 1;
    dirty_any = 1;
    trs_ampex_flush();
}

static void finalize_path_action(void)
{
    path_buf[path_len] = 0;
    if (path_len == 0) {
        set_message(" (cancelled -- empty path) ");
        mm = MM_PAGE;
        cur_page = &main_page;
        menu_sel = 0;
        menu_redraw();
        return;
    }

    int ok = -1;
    const char *what = "";
    const menu_page_t *return_to = &main_page;
    switch (path_action) {
        case PA_INSERT_DISK:
            trs_disk_insert(path_drive, path_buf);
            what = "disk inserted";
            ok = (trs_disk_getfilename(path_drive) &&
                  trs_disk_getfilename(path_drive)[0]) ? 0 : -1;
            return_to = &disk_page;
            break;
        case PA_INSERT_CASS:
            trs_cassette_insert(path_buf);
            what = "cassette inserted";
            ok = (trs_cassette_getfilename() &&
                  trs_cassette_getfilename()[0]) ? 0 : -1;
            return_to = &cass_page;
            break;
        case PA_SAVE_STATE:
            ok = trs_state_save(path_buf);
            what = "state saved";
            return_to = &config_page;
            break;
        case PA_LOAD_STATE:
            ok = trs_state_load(path_buf);
            what = "state loaded";
            return_to = &config_page;
            break;
        case PA_SAVE_CONFIG:
            ok = trs_write_config_file(path_buf);
            what = "config saved";
            return_to = &config_page;
            break;
        default: break;
    }
    if (ok == 0)
        set_message(" %s: %s ", what, path_buf);
    else
        set_message(" error (%s): %s ", what, path_buf);

    cur_page = return_to;
    menu_sel = 0;
    mm       = MM_PAGE;
    menu_redraw();
}

static void menu_enter(void)
{
    msg_text[0] = 0;
    switch (mm) {
        case MM_PAGE: {
            const menu_entry_t *e = &cur_page->items[menu_sel];
            if (e->act) e->act(e->arg);
            break;
        }
        case MM_PATH_INPUT:
            finalize_path_action();
            break;
        case MM_ABOUT:
            cur_page = &main_page;
            menu_sel = 0;
            mm       = MM_PAGE;
            menu_redraw();
            break;
    }
}

static void menu_arrow(int delta)
{
    int had_msg = msg_text[0] != 0;
    msg_text[0] = 0;

    if (mm != MM_PAGE) return;

    int old = menu_sel;
    menu_sel += delta;
    if (menu_sel < 0)                      menu_sel = 0;
    if (menu_sel >= cur_page->item_count)  menu_sel = cur_page->item_count - 1;
    if (old != menu_sel) {
        draw_page_selector(old);
        draw_page_selector(menu_sel);
    }
    if (had_msg)
        draw_footer(" arrows = navigate   Enter = select   ESC/HELP = back ");
    out_flush();
}

static void menu_cancel_sub(void)
{
    /* ESC/HELP: submenu -> main; main -> close. Path input/about -> main. */
    if (mm == MM_PATH_INPUT || mm == MM_ABOUT) {
        cur_page = &main_page;
        menu_sel = 0;
        mm       = MM_PAGE;
        menu_redraw();
        return;
    }
    if (cur_page == &main_page) {
        menu_close_and_restore();
    } else {
        cur_page = &main_page;
        menu_sel = 0;
        menu_redraw();
    }
}

static void path_input_append(unsigned char b)
{
    if (b == 0x08 || b == 0x7F) {
        if (path_len > 0) {
            path_len--;
            path_buf[path_len] = 0;
        }
        menu_redraw();
        return;
    }
    if (b >= 0x20 && b < 0x7F) {
        if (path_len < (int)sizeof(path_buf) - 1) {
            path_buf[path_len++] = (char)b;
            path_buf[path_len] = 0;
        }
        menu_redraw();
    }
}

int trs_ampex_in_menu(void)
{
    return menu_active;
}

static void handle_host_escape(unsigned char b)
{
    switch (b) {
        case 'q': case 'Q':
            trs_ampex_quit_requested = 1;
            break;
        case 'r': case 'R':
            trs_reset(0);
            break;
        case 'b': case 'B':
            trs_reset_button_interrupt(1);
            trs_reset_button_interrupt(0);
            break;
        default:
            break;
    }
}

void trs_ampex_poll_input(void)
{
    static int esc_pending = 0;
    static int host_pending = 0;
    static int help_pending = 0;
    unsigned char buf[64];

    if (!serial_is_open())
        return;

    int n = serial_read_chunk(buf, (int)sizeof(buf));
    if (n <= 0)
        return;

    if (keydebug) {
        fprintf(stderr, "rx:");
        for (int i = 0; i < n; i++)
            fprintf(stderr, " %02x", buf[i]);
        fprintf(stderr, "\n");
        fflush(stderr);
    }

    for (int i = 0; i < n; i++) {
        unsigned char b = buf[i];

        if (help_pending) {
            help_pending = 0;
            if (b == 'H' || b == 'h') {
                if (menu_active) menu_cancel_sub();
                else             menu_open();
            } else if (b == 'I' || b == 'i') {
                /* HELP+I -> TRS-80 CLEAR (sdltrs keysym 0x10a). */
                inject_key(0x10a);
            }
            continue;
        }
        if (b == HELP_PREFIX) {
            help_pending = 1;
            continue;
        }

        if (host_pending) {
            host_pending = 0;
            handle_host_escape(b);
            continue;
        }
        if (b == HOST_ESCAPE) {
            host_pending = 1;
            continue;
        }

        if (esc_pending) {
            esc_pending = 0;
            if (menu_active) {
                if (b == 'A') menu_arrow(-1);
                else if (b == 'B') menu_arrow(+1);
                /* C/D left/right: ignore in menu */
            } else {
                switch (b) {
                    case 'A': inject_key(0x111); break;
                    case 'B': inject_key(0x112); break;
                    case 'C': inject_key(0x09);  break;
                    case 'D': inject_key(0x08);  break;
                    default:  break;
                }
            }
            continue;
        }
        if (b == ESC) {
            esc_pending = 1;
            continue;
        }

        if (menu_active) {
            if (b == 0x0D || b == 0x0A) {
                menu_enter();
            } else if (b == 0x7F) {
                /* 0x7F is the Ampex D175 ESCAPE key. In path-input it
                 * deletes the last char; elsewhere it cancels the menu. */
                if (mm == MM_PATH_INPUT)
                    path_input_append(b);
                else
                    menu_close_and_restore();
            } else if (mm == MM_PATH_INPUT) {
                path_input_append(b);
            }
            continue;
        }

        if (b == 0x7F) {
            inject_key(0x08);
        } else if (b < 0x20 && b != '\r' && b != '\n' && b != 0x08) {
            /* ignore other C0 controls */
        } else if (b == '\n') {
            inject_key('\r');
        } else {
            inject_key(b);
        }
    }
}

void trs_get_event(int wait)
{
    (void)wait;
    trs_ampex_poll_input();
    trs_ampex_age_key_releases();
    trs_ampex_flush();
    if (trs_ampex_quit_requested)
        trs_continuous = 0;
}

Uint8 mem_video_page_read(int vaddr);

/* Save/load hooks for trs_state_save.c */
void trs_main_save(FILE *file) { (void)file; }
void trs_main_load(FILE *file) { (void)file; }

int trs_sdl_savebmp(const char *filename) { (void)filename; return -1; }

void trs_sdl_sound_update(void) { }

