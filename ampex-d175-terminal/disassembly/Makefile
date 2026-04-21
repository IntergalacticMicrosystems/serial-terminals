# Regenerates Z80 disassembly listings for the Ampex D-175 code ROMs.
#
# Tool: z80dasm 1.1.6 (Ubuntu/Debian apt package). On Windows hosts the
# commands are dispatched through WSL automatically via the Z80DASM wrapper.
#
# Usage:
#   make              # regenerate all listings
#   make U4.asm       # regenerate a single ROM
#   make strings      # re-extract printable strings
#   make clean
#
# Load addresses are WORKING hypotheses until Phase 1 verification passes
# (see README.md). If a listing is full of mid-instruction branch targets,
# the origin here is wrong.

ROM_DIR := ../EPROM_dumps

# Detect WSL shim on Windows (MSYS/Git Bash). On native Linux, use z80dasm directly.
UNAME := $(shell uname -s)
ifneq (,$(findstring MINGW,$(UNAME)))
Z80DASM := wsl -e z80dasm
else ifneq (,$(findstring MSYS,$(UNAME)))
Z80DASM := wsl -e z80dasm
else
Z80DASM := z80dasm
endif

DASM_FLAGS := -a -l -t -z

ROMS := U4 U5 U6 U8

.PHONY: all strings clean
all: $(addsuffix .asm,$(ROMS)) strings

U4.asm: ORIGIN := 0x0000
U5.asm: ORIGIN := 0x2000
U6.asm: ORIGIN := 0x4000
U8.asm: ORIGIN := 0xB000

U4.asm: $(ROM_DIR)/U4-TMS2764JL.bin
U5.asm: $(ROM_DIR)/U5-TMS2764JL.bin
U6.asm: $(ROM_DIR)/U6-AM2732-1DC.bin
U8.asm: $(ROM_DIR)/U8-AM2732-1DC.bin

%.asm:
	@echo "z80dasm $< -> $@  (origin $(ORIGIN))"
	@if [ -f $*.sym ]; then \
		$(Z80DASM) $(DASM_FLAGS) -g $(ORIGIN) -S $*.sym -o $@ $< ; \
	else \
		$(Z80DASM) $(DASM_FLAGS) -g $(ORIGIN) -o $@ $< ; \
	fi

strings: strings_U4.txt strings_U5.txt strings_U6.txt strings_U8.txt

strings_U4.txt: $(ROM_DIR)/U4-TMS2764JL.bin
	python3 ../tools/extract_strings.py --base 0x0000 $< > $@
strings_U5.txt: $(ROM_DIR)/U5-TMS2764JL.bin
	python3 ../tools/extract_strings.py --base 0x2000 $< > $@
strings_U6.txt: $(ROM_DIR)/U6-AM2732-1DC.bin
	python3 ../tools/extract_strings.py --base 0x4000 $< > $@
strings_U8.txt: $(ROM_DIR)/U8-AM2732-1DC.bin
	python3 ../tools/extract_strings.py --base 0xB000 $< > $@

clean:
	rm -f U4.asm U5.asm U6.asm U8.asm strings_U*.txt
