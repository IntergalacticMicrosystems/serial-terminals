#ifndef _WIN32
#define _POSIX_C_SOURCE 200809L
#endif

#include <SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#  include <windows.h>
#else
#  include <signal.h>
#endif

#include "trs.h"
#include "trs_ampex.h"

extern char trs_uart_name[];

const char *program_name;

#ifdef _WIN32
static const char *serial_port = "COM3";
#else
static const char *serial_port = "/dev/ttyUSB0";
#endif

static int do_probe = 0;
static int do_keydebug = 0;
static const char *sextant_perm = NULL;

#ifdef _WIN32
static BOOL WINAPI win_console_handler(DWORD event)
{
    switch (event) {
        case CTRL_C_EVENT:
        case CTRL_BREAK_EVENT:
        case CTRL_CLOSE_EVENT:
        case CTRL_LOGOFF_EVENT:
        case CTRL_SHUTDOWN_EVENT:
            trs_ampex_quit_requested = 1;
            return TRUE;
    }
    return FALSE;
}
#else
static void sigint_handler(int sig)
{
    (void)sig;
    trs_ampex_quit_requested = 1;
}
#endif

static void on_exit_cleanup(void)
{
    trs_ampex_close();
}

static void print_usage(void)
{
    printf("Usage: trs80-ampex [options]\n"
         "\n"
         "trs80-ampex options:\n"
         "  --serial-port PATH   Ampex D175 serial device (default %s)\n"
         "  --gfx-probe          Draw the 64 sextant glyphs + the 0x80-0xBF\n"
         "                       identity mapping, then exit. Use to verify\n"
         "                       bit ordering against the hardware.\n"
         "  --keydebug           Print each incoming serial byte as hex on\n"
         "                       stderr. Useful for diagnosing keyboard\n"
         "                       and flow-control behavior.\n"
         "  --sextant-perm ABCDEF  Permute the 6 TRS-80 sextant bits to Ampex\n"
         "                       bits. Default 103254 (swap L/R per row, to\n"
         "                       match D175 hardware). Each digit is the\n"
         "                       destination Ampex bit for TRS-80 bit 0..5\n"
         "                       (TL,TR,ML,MR,BL,BR). 012345 = identity.\n"
         "  -h, --help           Show this help\n", serial_port);
    puts(
         "\n"
         "Pass-through sdltrs options (single-dash):\n"
         "  -romfile PATH        Model I ROM image\n"
         "  -d0 FILE ... -d7 FILE   Disk images\n"
         "  -c FILE              Cassette image\n"
         "  -cpm MHZ             CPU clock override\n"
         "  -sound               Enable cassette/beeper audio (off by default)\n"
         "  (see sdltrs docs for full list)\n"
         "\n"
         "Host escape while running: Ctrl-\\ then q=quit, r=reset, b=break.");
}

static int extract_our_flags(int *argc_io, char **argv)
{
    int argc = *argc_io;
    int out  = 1;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-h") == 0 ||
            strcmp(argv[i], "-help") == 0 ||
            strcmp(argv[i], "--help") == 0) {
            print_usage();
            exit(EXIT_SUCCESS);
        }
        if (strcmp(argv[i], "--serial-port") == 0 || strcmp(argv[i], "-serial-port") == 0) {
            if (i + 1 >= argc) {
                fprintf(stderr, "trs80-ampex: --serial-port requires a path\n");
                exit(EXIT_FAILURE);
            }
            serial_port = argv[++i];
            continue;
        }
        if (strncmp(argv[i], "--serial-port=", 14) == 0) {
            serial_port = argv[i] + 14;
            continue;
        }
        if (strcmp(argv[i], "--gfx-probe") == 0) {
            do_probe = 1;
            continue;
        }
        if (strcmp(argv[i], "--keydebug") == 0) {
            do_keydebug = 1;
            continue;
        }
        if (strcmp(argv[i], "--sextant-perm") == 0) {
            if (i + 1 >= argc) {
                fprintf(stderr, "trs80-ampex: --sextant-perm requires 6-char permutation\n");
                exit(EXIT_FAILURE);
            }
            sextant_perm = argv[++i];
            continue;
        }
        if (strncmp(argv[i], "--sextant-perm=", 15) == 0) {
            sextant_perm = argv[i] + 15;
            continue;
        }
        argv[out++] = argv[i];
    }
    *argc_io = out;
    argv[out] = NULL;
    return 0;
}

int main(int argc, char *argv[])
{
    program_name = strrchr(argv[0], DIR_SLASH);
    if (program_name == NULL)
        program_name = argv[0];
    else
        program_name++;

    int user_wants_sound = 0;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-sound") == 0) {
            user_wants_sound = 1;
            break;
        }
    }

    extract_our_flags(&argc, argv);
    trs_parse_command_line(argc, argv);
    trs_uart_name[0] = '\0';
    if (!user_wants_sound)
        trs_sound = 0;

    if (trs_model != 1) {
        fprintf(stderr, "trs80-ampex: only Model I is supported; forcing -model 1\n");
        trs_model = 1;
    }

    trs_sdl_init();

    if (trs_ampex_open(serial_port) < 0)
        exit(EXIT_FAILURE);
    atexit(on_exit_cleanup);

    if (sextant_perm)
        trs_ampex_set_sextant_perm(sextant_perm);
    if (do_keydebug)
        trs_ampex_set_keydebug(1);

    if (do_probe) {
        trs_ampex_probe();
        trs_ampex_close();
        return EXIT_SUCCESS;
    }

#ifdef _WIN32
    SetConsoleCtrlHandler(win_console_handler, TRUE);
#else
    struct sigaction sa = { 0 };
    sa.sa_handler = sigint_handler;
    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);
#endif

    trs_reset(1);
    trs_ampex_clear_screen();
    trs_ampex_draw_border();
    trs_screen_refresh();

    z80_run(1);

    trs_ampex_close();
    puts("Quitting.");
    return EXIT_SUCCESS;
}
