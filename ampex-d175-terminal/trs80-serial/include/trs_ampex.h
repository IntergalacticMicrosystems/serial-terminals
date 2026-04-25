#ifndef _TRS_AMPEX_H
#define _TRS_AMPEX_H

int  trs_ampex_open(const char *device);
void trs_ampex_close(void);
int  trs_ampex_draw_border(void);
void trs_ampex_clear_screen(void);
void trs_ampex_flush(void);
void trs_ampex_poll_input(void);
void trs_ampex_age_key_releases(void);
void trs_ampex_probe(void);
void trs_ampex_set_sextant_perm(const char *perm6);
void trs_ampex_set_keydebug(int on);

extern volatile int trs_ampex_quit_requested;

#endif
