# Ampex D-175 Emulation Code Reference

**Scope:** this document rebuilds the ESC-sequence dispatch reference from the
disassembly (U4, U5, U6). It **supersedes** the escape-sequence tables in
`../agents.md`, which contains significant errors — several of which are
demonstrated below.

Everything here is derived from code, not from reference terminals. A command
listed as "implemented" means the translation table routes it to a dispatched
handler; what that handler actually *does* is an open question for per-handler
tracing (see [§7](#7-open-handler-behavior)).

---

## 1. Dispatch architecture

### 1.1 Lead-in detection  (U4 : 0x187A)

The firmware does **not** use `CP 0x1B` to detect ESC. The lead-in character
is user-configurable (SET-UP option **K LEAD-IN CODE**: `ESC` or `TILDE`), so
the current lead-in byte lives in RAM and is compared via `CP (HL)`:

```
U4:0x1873   ld a,(0AA29h)     ; terminal-state flags
            and 00Dh          ; only treat lead-in as ESC in the right modes
            jr z, not_escape
U4:0x187A   ld a, c           ; C = received byte
            ld hl, 0AA99h     ; * RAM: current lead-in byte *
            cp (hl)
            jr z, enter_esc   ; match  -> enter ESC state
```

The lead-in byte at `0xAA99` is seeded at boot and on SET-UP save by
`U4:0x058E`:

```
U4:0x058E   ld hl, 0AAB9h     ; user-config byte (bit 7 = TILDE mode)
            bit 7,(hl)
            ld a, 07Eh        ; default TILDE ('~')
            jr nz, store
            ld a, 01Bh        ; else ESC
store:      ld (0AA99h), a
```

This is why no `FE 1B` (CP 1Bh) byte-pair exists anywhere in the 28 KB of code
ROM — confirmed by exhaustive search.

### 1.2 ESC state machine  (U6 : 0x4A10)

All byte arrivals route through the state machine at `U6:0x4A10`, called from
`U4:0x1891`. It maintains three bytes of state:

| Address | Role |
|---|---|
| `0xAA25` | state counter (0 = idle, 0xFF = expecting command byte, 1..5 = collecting params) |
| `0xAA23` | latest input byte (command letter, then successive param bytes) |
| `0xAA26` | saved arity (total bytes in the sequence including the command) |

Parameter bytes are stashed in a small buffer at `0xA94C`.

Flow:

1. **First byte (lead-in)** → `state = 0xFF`; return, wait for next byte.
2. **Second byte (command letter)** → index the translation table at
   `0xA983 + cmd` and read its byte value → map to arity 1..5 → if arity > 1,
   store command at `0xA94C + (arity-1)`, decrement state, wait for more.
3. **Subsequent bytes (params)** → decrement state, stash at
   `0xA94C + state`. When state reaches 0, replay buffer: for
   `i = 1..arity`, load `0xA94C + (i-1)` into `0xAA23` and call the
   per-byte dispatcher `U4:sub_13AF`. That dispatcher uses the table value
   as its handler selector.

### 1.3 Arity from translation-table value  (U6 : 0x4A42)

The byte value `v = RAM[0xA983 + cmd]` determines how many bytes follow the
command. The code is literally:

| `v`        | Arity (incl. command) |
|:----------:|:---------------------:|
| `0x00`     | 1  (unimplemented — falls through to default handler) |
| `0x01..05` | 5  (command + 4 params) |
| `0x06..0A` | 4 |
| `0x0B..14` | 3 |
| `0x15..28` | 2  (command + 1 param) |
| `≥ 0x29`   | 1  (single-byte command — `v` itself is a handler index) |

Values ≥ 0x29 are "fast-path" single-byte commands where the table value
directly names the handler. Values < 0x29 are multi-byte commands with
a parameterized handler whose index is `v` itself.

### 1.4 The RAM translation table  (0xA983 .. 0xAA22)

160 bytes covering command bytes 0x00 through 0x9F:

| RAM range | Command byte range |
|---|---|
| `0xA983..0xA9A2` | 0x00..0x1F (control codes — almost always zeroed) |
| `0xA9A3..0xAA02` | 0x20..0x7F (printable ASCII — most ESC letters live here) |
| `0xAA03..0xAA22` | 0x80..0x9F (extended — 8-bit commands via bit-7-set lead-in) |

Command bytes 0xA0..0xFF are **not** in the dispatch table and do not route
through this path.

---

## 2. Per-emulation loader  (U4 : 0x0381)

On boot and on SET-UP change, `U4:0x0381` rebuilds the RAM table based on
`RAM[0xAABB] & 0x0F` (the active emulation index 0..10).

Three base tables are copied from ROM, then optionally patched:

| Emul range | Base address (96/128 B) | Aux address (32 B) | Patch table(s) |
|---|---|---|---|
| 0..6 (AMPEX..TV920) | `U4:0x1DEE` → `0xA9A3` (96 B) | `U4:0x1D61` → `0xAA03` (32 B) | `U4:0x0433` + `U4:0x0445` |
| 7 (TV950) | `U5:0x2014` → `0xA9A3` (96 B) | `U4:0x1D61` → `0xAA03` (32 B) | `U4:0x0445` entry #6 (record at 0x1DBE) |
| 8..10 (H1500..H1420) | `U4:0x1F1E` → `0xA983` (128 B) | `U4:0x1DCB` → `0xAA03` (32 B) | `U4:0x0441` for emuls 9..10 |

A **patch record** at the pointer-table entry is:
`<count> <off1> <val1> <off2> <val2> ...`. Each pair overwrites one byte of
the RAM table. This is how emulations that share a base differentiate
themselves — AMPEX uses the raw base; VT52 applies ~20 letter remappings.

Patch logic:

- Emulations 1..6 apply a second-pass patch into the `0xAA03` region indexed
  by `emul_index - 1` out of `U4:0x0445`.
- Emulation 0 (AMPEX) uses the base unmodified.
- Emulation 7 (TV950) applies the 7th entry of the `U4:0x0445` table
  (pointer `0x1DBE`, a 6-pair patch record into `0xAA03`). The table is
  7 entries deep; emuls 1..6 use the first six and TV950 uses the last.
- Emulations 8..10 use a third base and a separate patch table at
  `U4:0x0441` (2 entries, for H1410 and H1420; H1500 uses the base
  unmodified).

---

## 3. Emulation state byte: `0xAABB`

`0xAABB` is the primary SET-UP byte. Known bit fields discovered so far:

| Bits | Meaning |
|---|---|
| `& 0x0F` | emulation index (0 = AMPEX, 1 = IQ120, 2 = REG25, 3 = ADM5, 4 = VIEWPOINT, 5 = VT52, 6 = TV920, 7 = TV950, 8 = H1500, 9 = H1410, 10 = H1420) |
| `& 0xF0` | upper nibble — other SET-UP flags, not decoded yet |

And `0xAAB9` holds the lead-in / misc flags byte (bit 7 → TILDE lead-in).

The emulation order is not an invention — it is the order of the labels
inside the SET-UP menu text at `U6:0x4A9F`:

```
R EMULATION :.AMPEX.IQ120.REG25.ADM5 .VIEWP.VT52 .TV920.TV950.H1500.H1410.H1420*
```

---

## 4. Reconstructed per-emulation tables

Full byte-by-byte reconstructions (160 B each, only non-zero entries shown)
are in `xlate_tables.txt`. A summary of command coverage per emulation:

| # | Emul | Non-zero commands | Unique handlers |
|---|---|---|---|
| 0 | AMPEX | (see `xlate_tables.txt`) | baseline |
| 1 | IQ120 | patched from AMPEX | — |
| 2 | REG25 | patched from AMPEX | — |
| 3 | ADM5  | patched from AMPEX | — |
| 4 | VIEWP | patched from AMPEX | — |
| 5 | VT52  | patched from AMPEX | — |
| 6 | TV920 | patched from AMPEX | — |
| 7 | TV950 | separate U5-resident base | — |
| 8..10 | H15xx / H14xx | separate base | — |

---

## 5. VT52 case study — cross-check against SerialTetris

`SerialTetris/ampex.py` emits a small, empirically-verified set of VT52
sequences. Each one is traced through the reconstructed VT52 table below:

| Sequence emitted | VT52 table entry | Arity | Verdict |
|---|---|---|---|
| `ESC Y <row> <col>` cursor address | `[0x59] = 0x0C` | 3 | ✓ matches SerialTetris (cursor moves) |
| `ESC J` erase-to-end-of-screen | `[0x4A] = 0x37` | 1 | ✓ matches SerialTetris |
| `ESC t` erase-to-EOL (Ampex deviation) | `[0x74] = 0x81` | 1 | ✓ matches project memory note |
| `ESC K` (classic VT52 "erase to EOL") | `[0x4B] = 0x36` | 1 | ★ **different handler** from ESC t — VT52 ESC K in Ampex mode is NOT erase-to-EOL. Confirms why project uses ESC t. |

### Errors in `agents.md` demonstrated

`agents.md` claims VT52 mode lacks ESC A (up), ESC D (left), ESC H (home) and
ESC Z (identify). The reconstructed VT52 table refutes all four:

| ESC seq | `agents.md` | VT52 table entry | Reality |
|---|---|---|---|
| ESC A | "missing" | `[0x41] = 0x3C` | implemented (handler 0x3C) |
| ESC B | — | `[0x42] = 0x3D` | implemented |
| ESC C | — | `[0x43] = 0x4D` | implemented |
| ESC D | "missing" | `[0x44] = 0x52` | implemented (handler 0x52) |
| ESC F | — | `[0x46] = 0x3A` | implemented |
| ESC G | — | `[0x47] = 0x3B` | implemented |
| ESC H | "missing" | `[0x48] = 0x3E` | implemented (handler 0x3E) |
| ESC I | — | `[0x49] = 0x6E` | implemented |
| ESC J | — | `[0x4A] = 0x37` | implemented |
| ESC K | — | `[0x4B] = 0x36` | implemented (see note above) |
| ESC Z | "missing" | `[0x5A] = 0x6B` | implemented (handler 0x6B) |

All "missing" claims in `agents.md` for VT52 are incorrect. Handlers exist
for all classic VT52 cursor-move, erase and identify commands.

---

## 6. Command byte → handler index

When `v = tbl[cmd]` is ≥ 0x29, `v` itself is the handler index consumed by
`U4:sub_13AF`. Common values that appear across multiple emulations:

| Handler | Where seen | Likely role |
|---|---|---|
| `0x35` | VT52 ESC 0, IQ120/REG25 ESC '0' | numeric parameter "0" latch? |
| `0x36` | VT52 ESC K, REG25 ESC K | mode-dependent (NOT erase-EOL in VT52) |
| `0x37` | VT52 ESC J | erase to end of screen |
| `0x3A..0x3F` | VT52 ESC F,G,H,A,B,L | graphics-on/off, home, cursor up/down |
| `0x4D` | VT52 ESC C | cursor right |
| `0x52` | VT52 ESC D | cursor left |
| `0x6B` | VT52 ESC Z | identify |
| `0x81` | VT52 ESC t (+ other emuls) | Ampex erase-to-EOL |

Mapping these handler indices to concrete behavior requires tracing
`U4:sub_13AF` and is the primary remaining work item.

---

## 7. Ring pipeline and handler dispatch (fully resolved)

### 7.1 Pipeline

```
  UART RX (0x8000 interrupt)                Keyboard (0x9000)
        │                                          │
        ▼                                          ▼
   ┌──────────────┐                     ┌──────────────────┐
   │ RX ring      │                     │ KB ring 0xA930+   │
   │ 0xA930..3F   │                     │ (16 B, mod 16)    │
   └──────┬───────┘                     └─────────┬────────┘
          │  sub_17CF dequeues, routes by bit 7:  │
          │  ≥0x80 → U8:0xB00F (Star overlay)     │
          │  <0x80 → l1873 (ESC detector)          │
          ▼                                        ▼
   ┌──────────────────────────────────────────────────┐
   │ l1873 / state machine U6:0x4A10                   │
   │  • detects lead-in (cp (ram_leadin_byte))         │
   │  • collects 1..5-byte ESC sequences               │
   │  • sub_13AF enqueues finished sequence into ring  │
   │    with bit-7 set on the command letter           │
   │  • sub_17B6 enqueues raw data bytes (bit 7 clear) │
   └─────────────────────┬────────────────────────────┘
                         ▼
              ┌──────────────────────┐
              │ 0xA800 local ring    │   (256 B; tail 0xA944, head 0xA945)
              └──────────┬───────────┘
                         │
            ┌────────────┴───────────────┐
            ▼                            ▼
   ┌──────────────┐            ┌───────────────────┐
   │ U6:l4960     │            │ U4:l1319 (TX/echo)│
   │ display loop │            │ reads byte, for   │
   │ calls        │            │ bit-7 entries     │
   │ sub_4981     │            │ prepends lead-in  │
   │ (see 7.2)    │            │ then sub_1540     │
   └──────┬───────┘            │ enqueues to 0xA900│
          │                    └──────────┬────────┘
          ▼                               ▼
   ┌──────────────┐            ┌───────────────────┐
   │ CRTC writes  │            │ UART TX @ 0x8000  │
   │ 0xC000/0xD000│            │ drained by flow-  │
   │ (sub_15F7)   │            │ control loop      │
   └──────────────┘            └───────────────────┘
```

### 7.2 The dispatcher at `U4:0x0AAF`

`sub_4981` (U6) is the display-side byte-dispatch on every ring read. For
bytes with bit 7 set, it falls through via `l49dd: jp U4:0x0AAF`, which
is the **master dispatcher** and does exactly this:

```
U4:0x0AAF   ld a, c                ; C = byte from ring (bit 7 set)
            and 0x7F                ; A = command letter (0x20..0x7F)
            ld c, a
            ld hl, 0A983h           ; RAM translation table for active emul
            ld b, 0
            add hl, bc              ; HL = &tbl[cmd]
            ld a, (hl)              ; A = handler index
            ld hl, 020AAh           ; MASTER JUMP TABLE in U5 ROM
            ld e, a ; ld d, 0
            add hl, de ; add hl, de ; HL = 0x20AA + 2*index
            ld e, (hl) ; inc hl ; ld d, (hl) ; ex de, hl
            jp (hl)                 ; tail-call handler
```

So `tbl[cmd]` is a handler index `0..0x83` and the **master jump table
at `U5:0x20AA`** (132 × 2 bytes = 0x108 B, ending `0x21B1`) translates it
to a handler address in U4/U5/U6.

### 7.3 The no-op handler

Index values whose jump-table slot holds `U5:0x2798` are effective
no-ops — that address contains a single `RET` instruction (0xC9). A
translation-table value of 0x00, 0x01, 0x02, 0x05, 0x08, 0x09, 0x0A,
0x12, 0x13, 0x14, 0x28, 0x58, 0x68, 0x69, 0x6A, 0x71 all land on this
RET. When a table entry routes to one of these indices, the command is
parsed (so the arity count consumes the right number of parameter
bytes) but the action is a silent no-op.

### 7.4 Reference data

Two regenerable reference files are produced by helper scripts:

- `handler_jump_table.txt` (`../tools/dump_handler_table.py`) — every
  index 0x00..0x83 with its U4/U5/U6 handler address.
- `resolved_handlers.txt` (`../tools/resolve_handlers.py`) — per
  emulation, every non-no-op (cmd → handler-address) mapping. This is
  the definitive "what does ESC X do in mode Y" table for the active
  commands of each emulation.

### 7.5 VT52 handler addresses (confirmed)

| ESC | tbl-value | arity | handler | Evidence matches SerialTetris / observed behavior |
|---|---|---|---|---|
| `ESC Y` row col | `0x0C` | 3 | `U5:0x3523` | Cursor address. SerialTetris uses this. |
| `ESC J` | `0x37` | 1 | `U6:0x4445` | Erase to end of screen. SerialTetris uses this. |
| `ESC K` | `0x36` | 1 | `U6:0x43D5` | *Different handler from ESC t* — confirms project note that EOL erase is `ESC t` in Ampex VT52 mode. |
| `ESC t` | `0x81` | 1 | `U6:0x43CB` | Erase to EOL (Ampex extension). |
| `ESC A` | `0x3C` | 1 | `U5:0x2F65` | Cursor up. |
| `ESC B` | `0x3D` | 1 | `U5:0x2F61` | Cursor down. |
| `ESC C` | `0x4D` | 1 | `U5:0x2F54` | Cursor right. |
| `ESC D` | `0x52` | 1 | `U5:0x2F59` | Cursor left. |
| `ESC H` | `0x3E` | 1 | `U5:0x33AF` | Home. |
| `ESC F` | `0x3A` | 1 | `U5:0x28ED` | Graphics on. |
| `ESC G` | `0x3B` | 1 | `U5:0x2903` | Graphics off. |
| `ESC Z` | `0x6B` | 1 | `U5:0x2A0F` | Identify response. |

The `U5:0x2F54..0x2F65` handlers are adjacent — they form a cursor-
motion handler cluster (left/down/right/up), a tight block of ~20 bytes
per direction.

### 7.6 Commands shared across emulations

Different letters in different emulations can share one handler. Two
useful examples:

| Emul / cmd | tbl-value | Shared handler at | What it is |
|---|---|---|---|
| AMPEX `ESC =` | `0x0C` | `U5:0x3523` | cursor address (ADM-style) |
| VT52 `ESC Y` | `0x0C` | `U5:0x3523` | cursor address (VT52-style) |
| AMPEX `ESC Y` | `0x37` | `U6:0x4445` | erase to end of screen (Ampex convention) |
| VT52 `ESC J` | `0x37` | `U6:0x4445` | erase to end of screen (VT52 convention) |

This resolves the final structural question about the emulation
system: per-emulation ESC commands map to a *shared* pool of ~50
actual handler routines. Emulations differ only in which letter
selects which pool entry.

## 8. Upper nibble of `0xAABB`

Separate from the low-nibble emulation index, the upper nibble encodes a
**screen / timing configuration** that is preserved across emulation
changes. Evidence:

- `U4:0x1980` reads `0xAABB`, masks `0xF0`, ORs in a newly-chosen
  low-nibble value, and writes back. This is the emulation-change
  writer. The upper nibble is explicitly kept.
- `U4:0x05CB` reads `0xAABB`, masks `0xF0`, rotates right 3 positions,
  indexes a 32-byte table at `U4:0x029C` by the result, and performs
  two `OUTI` writes. Table has 16 two-byte entries — one per upper-nibble
  value. Almost certainly a CRTC-register pair write that switches the
  display timing / resolution.
- `U5:0x235E` increments the upper nibble with wrap (0x0 ← 0xF),
  preserving the low nibble. Triggered by a SET-UP key that cycles this
  setting.

The 16-state space matches the V / printer-baud option count in the
SET-UP menu (16 baud rates), so `0xAABB[7:4]` is most likely the
**printer baud-rate index**. Final confirmation would require tracing
who calls `U4:sub_05CB` and which port is set up in register C.

## 9. Commands in the 0x80..0x9F range

The translation table covers command bytes `0x00..0x9F` via the aux
region `0xAA03..0xAA22`. The aux region has 14 non-zero entries in the
emul 0..7 base (`U4:0x1D61`) and 9 in the emul 8..10 base
(`U4:0x1DCB`), all with small arity codes (1..0x17):

| Base / emuls | Non-zero 0x8N commands |
|---|---|
| U4:0x1D61 (0..7)   | 0x87..0x8F, 0x91, 0x93, 0x9A, 0x9E, 0x9F |
| U4:0x1DCB (8..10)  | 0x87..0x8A, 0x8D, 0x90, 0x91, 0x93, 0x9F |

These commands are **not reachable through the normal UART input gate**:
`U4:sub_17CF` routes every input byte `>= 0x80` to `U8:0xB00F` (Star
overlay) before the ESC detector (`l1873`) runs, so `ram_esc_byte` never
receives a value in `0x80..0x9F` through the standard path. Empirically,
then, the `0x8N` entries are either legacy (reserved for a path that
existed in an earlier revision) or invoked internally from U5/U6 code
that writes directly to `ram_esc_byte` without going through `sub_17CF`.

No such internal invocation was located in this pass. The 0x8N-range
entries in the table are kept in the reconstruction for completeness;
they should not be treated as "supported commands" in any emulation
until a caller is identified.

## 10. Files consulted

- `../EPROM_dumps/U4-TMS2764JL.bin` — lead-in detector (0x187A), state-byte
  seed (0x058E), emulation loader (0x0381), base translation tables
  (0x1D61, 0x1DCB, 0x1DEE, 0x1F1E), patch pointer tables
  (0x0433, 0x0441, 0x0445), patch applier (0x040D).
- `../EPROM_dumps/U5-TMS2764JL.bin` — main entry (0x243D), TV950 base
  translation table (0x2014).
- `../EPROM_dumps/U6-AM2732-1DC.bin` — ESC state machine (0x4A10),
  translation-table reader (0x4A37), SET-UP menu text (0x4A9F).
- `xlate_tables.txt` — full byte-by-byte per-emulation reconstruction.
- `patch_records.txt` — dump of every patch record with addresses,
  cross-referenced to command bytes.
- `../tools/dump_xlate_tables.py` — regenerates `xlate_tables.txt`.
- `../tools/dump_patch_records.py` — regenerates `patch_records.txt`.
