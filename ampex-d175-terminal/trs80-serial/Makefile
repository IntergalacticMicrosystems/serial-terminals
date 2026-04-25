SDLTRS_DIR := vendor/sdltrs/src

SDLTRS_CORE := \
    dis.c error.c \
    trs_cassette.c trs_clones.c trs_cmd_rom.c \
    trs_cp500.c trs_disk.c trs_hard.c trs_imp_exp.c \
    trs_interrupt.c trs_io.c trs_memory.c trs_mkdisk.c \
    trs_options.c trs_printer.c trs_sdl_gui.c trs_sdl_keyboard.c \
    trs_state_save.c trs_stringy.c trs_uart.c z80.c

AMPEX_SRC := \
    src/trs_ampex.c \
    src/trs_ampex_stubs.c \
    src/trs_main_serial.c

COMMON_CFLAGS := -std=c99 -O2 -Wall \
    -Wno-unused-parameter -Wno-unused-function \
    -Wno-unused-variable -Wno-unused-but-set-variable \
    -Wno-missing-braces -Wno-stringop-truncation \
    -Wno-format-truncation \
    -DSDL2 \
    -DPACKAGE_VERSION=\"trs80-ampex-0.1\" \
    -DPACKAGE_STRING=\"trs80-ampex\ 0.1\" \
    -Iinclude -I$(SDLTRS_DIR)

# ---- Linux / POSIX build -------------------------------------------------
BUILD_DIR := build
SDL_CFLAGS := $(shell pkg-config --cflags sdl2)
SDL_LIBS   := $(shell pkg-config --libs sdl2)
CFLAGS  := $(COMMON_CFLAGS) -D_GNU_SOURCE $(SDL_CFLAGS)
LIBS    := $(SDL_LIBS) -lm

SDLTRS_OBJS := $(SDLTRS_CORE:%.c=$(BUILD_DIR)/sdltrs/%.o)
AMPEX_OBJS  := $(AMPEX_SRC:src/%.c=$(BUILD_DIR)/%.o)
OBJS        := $(SDLTRS_OBJS) $(AMPEX_OBJS)
DEPS        := $(OBJS:.o=.d)

BIN := $(BUILD_DIR)/trs80-ampex

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) -o $@ $^ $(LIBS)

$(BUILD_DIR)/sdltrs/%.o: $(SDLTRS_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

$(BUILD_DIR)/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

-include $(DEPS)

# ---- Windows cross-build (mingw-w64) -------------------------------------
WIN_BUILD_DIR   := build-win
WIN_CC          := x86_64-w64-mingw32-gcc
WIN_SDL_ROOT    := third_party/SDL2-2.30.11/x86_64-w64-mingw32
WIN_SDL_INCLUDE := $(WIN_SDL_ROOT)/include
WIN_SDL_LIB     := $(WIN_SDL_ROOT)/lib
WIN_SDL_DLL     := $(WIN_SDL_ROOT)/bin/SDL2.dll

WIN_CFLAGS := $(COMMON_CFLAGS) -D_WIN32_WINNT=0x0601 \
    -I$(WIN_SDL_INCLUDE) -I$(WIN_SDL_INCLUDE)/SDL2
WIN_LIBS   := -L$(WIN_SDL_LIB) -lmingw32 -lSDL2main -lSDL2 -lwinmm \
    -lsetupapi -lole32 -loleaut32 -limm32 -lversion -luuid -mconsole

WIN_SDLTRS_OBJS := $(SDLTRS_CORE:%.c=$(WIN_BUILD_DIR)/sdltrs/%.o)
WIN_AMPEX_OBJS  := $(AMPEX_SRC:src/%.c=$(WIN_BUILD_DIR)/%.o)
WIN_OBJS        := $(WIN_SDLTRS_OBJS) $(WIN_AMPEX_OBJS)
WIN_DEPS        := $(WIN_OBJS:.o=.d)

WIN_BIN := $(WIN_BUILD_DIR)/trs80-ampex.exe

win: $(WIN_BIN) $(WIN_BUILD_DIR)/SDL2.dll

$(WIN_BIN): $(WIN_OBJS)
	$(WIN_CC) -o $@ $^ $(WIN_LIBS)

$(WIN_BUILD_DIR)/sdltrs/%.o: $(SDLTRS_DIR)/%.c
	@mkdir -p $(dir $@)
	$(WIN_CC) $(WIN_CFLAGS) -MMD -MP -c -o $@ $<

$(WIN_BUILD_DIR)/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(WIN_CC) $(WIN_CFLAGS) -MMD -MP -c -o $@ $<

$(WIN_BUILD_DIR)/SDL2.dll: $(WIN_SDL_DLL)
	@mkdir -p $(dir $@)
	cp $< $@

-include $(WIN_DEPS)

# ---- housekeeping --------------------------------------------------------
clean:
	rm -rf $(BUILD_DIR) $(WIN_BUILD_DIR)

.PHONY: all win clean
