#include <SDL.h>
#include <stdio.h>
#include "trs.h"

/* PasteManager replacements (sdltrs's paste uses SDL clipboard). */
int  PasteManagerStartPaste(void)           { return 0; }
void PasteManagerStartCopy(const char *s)   { (void)s; }
void PasteManagerEndCopy(void)              { }
int  PasteManagerGetChar(Uint16 *c)         { (void)c; return 0; }
char *PasteManagerGetClipboard(void)        { return NULL; }
int  PasteStart(void)                       { return 0; }
int  PasteChar(Uint8 *c)                    { (void)c; return 0; }
void PasteCopy(const char *s)               { (void)s; }

/* gui_rect / gui_text are called from trs_sdl_gui.c which we compile in.
 * We never enter a GUI flow, but the link needs them. */
void gui_rect(int x, int y, int w, int h, int frame) { (void)x; (void)y; (void)w; (void)h; (void)frame; }
void gui_text(const char *text, int col, int row, int len, int font) { (void)text; (void)col; (void)row; (void)len; (void)font; }

/* Model III/4 and clone hardware not reachable on Model I serial target. */
void grafyx_write_x(int v)                                { (void)v; }
void grafyx_write_y(int v)                                { (void)v; }
void grafyx_write_data(int v)                             { (void)v; }
int  grafyx_read_data(void)                               { return 0xff; }
void grafyx_write_mode(int v)                             { (void)v; }
int  grafyx_read_mode(void)                               { return 0; }
void grafyx_write_xoffset(int v)                          { (void)v; }
void grafyx_write_yoffset(int v)                          { (void)v; }
void grafyx_write_overlay(int v)                          { (void)v; }
void grafyx_m3_reset(void)                                { }
void grafyx_m3_write_mode(int v)                          { (void)v; }
int  grafyx_m3_write_byte(unsigned int p, int b)          { (void)p; (void)b; return 0; }
Uint8 grafyx_m3_read_byte(unsigned int p)                 { (void)p; return 0; }

void hrg_onoff(int enable)                                { (void)enable; }
void hrg_write_data(int address, int data)                { (void)address; (void)data; }
int  hrg_read_data(int address)                           { (void)address; return 0xff; }

int  lowe_le18_read(void)                                 { return 0; }
void lowe_le18_write_data(int v)                          { (void)v; }
void lowe_le18_write_control(int v)                       { (void)v; }

/* m6845_crtc_reset is in trs_io.c; m6845_cursor/screen/text come from there too if compiled. */
void m6845_cursor(unsigned int p, int s, int e, int vis)  { (void)p; (void)s; (void)e; (void)vis; }
void m6845_screen(int c, int l, int r, int f)             { (void)c; (void)l; (void)r; (void)f; }
void m6845_text(int onoff)                                { (void)onoff; }

void eg3210_char(int ch, int sl, int byte)                { (void)ch; (void)sl; (void)byte; }

void genie3s_char(int ch, int sl, int byte)               { (void)ch; (void)sl; (void)byte; }
void genie3s_hrg(int v)                                   { (void)v; }
void genie3s_hrg_write(unsigned int p, int b)             { (void)p; (void)b; }
Uint8 genie3s_hrg_read(unsigned int p)                    { (void)p; return 0; }

void trs_get_mouse_pos(int *x, int *y, unsigned int *b)   { *x = 0; *y = 0; *b = 0; }
void trs_set_mouse_pos(int x, int y)                      { (void)x; (void)y; }
void trs_get_mouse_max(int *x, int *y, unsigned int *s)   { *x = 0; *y = 0; *s = 0; }
void trs_set_mouse_max(int x, int y, unsigned int s)      { (void)x; (void)y; (void)s; }
