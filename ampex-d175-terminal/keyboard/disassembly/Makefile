# Regenerates the MCS-48 disassembly listing for the Ampex D-175 keyboard ROM.
#
# Tool: tools/mcs48dasm.py (in this repo). The 8039 reset vector lives at
# $0000 and the chip executes external program ROM (the 2716 dumped as
# U2-D2716.bin). Origin is therefore $0000.
#
# Usage:
#   make              # regenerate listing + strings
#   make U2.asm
#   make strings
#   make clean

ROM_DIR := ..
TOOLS   := ../../tools
DASM    := python3 $(TOOLS)/mcs48dasm.py
STRINGS := python3 $(TOOLS)/extract_strings.py

ORIGIN_U2 := 0x0000

.PHONY: all strings clean
all: U2.asm strings

U2.asm: $(ROM_DIR)/U2-D2716.bin U2.sym
	@echo "mcs48dasm $< -> $@  (origin $(ORIGIN_U2))"
	$(DASM) -g $(ORIGIN_U2) -S U2.sym -o $@ $<

strings: strings_U2.txt

strings_U2.txt: $(ROM_DIR)/U2-D2716.bin
	$(STRINGS) --base $(ORIGIN_U2) $< > $@

clean:
	rm -f U2.asm strings_U2.txt
