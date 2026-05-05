# Memory map

System-wide layout of the F8 address space, derived from disassembly of
U1/U12/U22 and observation of DCI/INS/OUTS instruction sites.

## Hardware

- CPU: **MK3850** F8
- Memory interface: **MK3853 SMI** — provides 16-bit address bus to off-chip
  ROM/RAM, the interrupt-vector register, and a programmable timer
- Other I/O: AY-5-1013A UART (parallel-control); video RAM (external SRAM,
  likely 2114 × 2); two 8-position DIP switches; keyboard connector
- Char-gen: **U39 EA 8316E244** (mask ROM) — wired to video shift-register
  chain; **not in CPU address space**
- Glyph/attribute data: **U55 MM2716Q** — addressable by CPU via DCI

## ROM regions

| Range            | Device | Source file                                | Notes |
|------------------|--------|--------------------------------------------|-------|
| `H'0000..H'03FF'` | U1   | `f2708_eprom_u1_6eaf59ae.bin`              | Reset entry @ `H'0000'` (`JMP H'0800'`); helpers and per-byte translation routines (heavy use of CPU port 0) |
| `H'0400..H'07FF'` | U12  | `mm2708q_eprom_u12_7162a6cc.bin`           | Library called from U1 and U22; trailing `H'07F0..H'07FF'` is unprogrammed `0xFF` padding |
| `H'0800..H'0BFF'` | U22  | `mm2708q_eprom_u22_7c7cc3dd.bin`           | Boot init @ `H'0818'`; primary 8-entry dispatch table @ `H'0800..H'0817'`; SMI ISR @ `H'0B99'` |
| `H'0C00..H'13FF'` | U55  | `mm2716q_eprom_u55_08658dd6.bin`           | **DATA-ONLY** — glyph/attribute tables (see `load_address_verification.md`); read via `DCI` + `LM`, never via `JMP`/`PI` |

## External RAM / peripheral regions (inferred from DCI targets)

| Address       | Hits          | Inferred role |
|---------------|---------------|---------------|
| `H'2000..'`   | U12:7B6       | Working / variable RAM (1 hit; exact extent TBD) |
| `H'5062'`     | U22:847       | Screen / cursor base — `DCI H'5062'; LR H,DC; LI H'20'; ST` is a fill-with-space loop, classic VRAM-clear |
| `H'8000..'`   | U12:6CC, 6E6; U22:BA4 | Peripheral or VRAM at 0x8000 — read in the SMI ISR (`H'0B99'`) immediately after entry: prime candidate for **UART data register** or status latch |
| `H'9C44'`     | U22:87A       | Probable scratch/VRAM offset (single hit) |

(Boundaries TBD — confirm by tracing per-region read/write patterns and the
external address-decode logic on the schematic.)

## Scratchpad RAM (CPU-internal, 64 bytes)

Layout per F8 architecture; named slots discovered so far:

| Address           | Name | Role |
|-------------------|------|------|
| `H'00..H'08'`     | r0..r8 | General scratchpad (r4 used as boot-time DIP-shadow at H'083E') |
| `H'09'`           | J    | W save in ISR (`LR J,W` at H'0B9A') |
| `H'0A..H'0B'`     | HU/HL | Cursor/buffer pointer pair (used as `H` for `DCI`) |
| `H'0C..H'0D'`     | KU/KL | K register pair (subroutine save) |
| `H'0E..H'0F'`     | QU/QL | Q register pair (computed jumps; saved/restored in ISR via auto-inc to scratchpad H'19'/H'1A') |
| `H'18..H'1A'`     | (ISR save area) | ISAR, QU, QL parked here on interrupt entry (LISU 3 ; LISL 0; LR I,A ×3) |
| `H'1B..H'3F'`     | (general / software stack) | Used via ISAR auto-inc/dec (boot writes 0xFB to scratchpad[H'1B'] in init) |

## I/O port assignments

| Port       | Device   | Function |
|------------|----------|----------|
| `H'00'`    | CPU port 0 | Heavy R/W traffic in U1/U12. Likely the **UART data path** (transmit/receive byte) or character translation latch. Many `INS 0` reads and `OUTS 0` writes in U1's translation routines. |
| `H'01'`    | CPU port 1 | Read-only via `INS 1` — likely status/strobes (UART TBMT/DAV/PE/FE/OE bits, DIP-switch positions, keyboard-strobe). |
| `H'04'..H'07'` | external (PIO?) | R/W. `OUTS H'04', OUTS H'06'` and `INS H'04', INS H'05', INS H'06', INS H'07'` all appear in U22/U12. **Likely a MK3861 PIO** (or external decode) at port group 1 servicing the AY-5-1013A UART control/status lines, baud-rate generator, and board-level configuration latches. |
| `H'08'`    | external   | `INS H'08'` (U22:89E, 915) and `OUTS H'08'` (U22:890). Probable second PIO port group 2 or an extended-decode latch. |
| `H'0A'`    | external   | `INS H'0A'` (U22:8C7, 90E) and `OUTS H'0A'` (U22:88F). Same group as port 8. |
| `H'0C'`    | MK3853 SMI | **Interrupt vector HIGH byte.** Boot writes `0x0B` here (U22:83E) — sets the high byte of the ISR address. |
| `H'0D'`    | MK3853 SMI | **Interrupt vector LOW byte.** Boot writes `0x99` here (U22:841) — combined with port 0x0C this places the ISR at `H'0B99'`. |
| `H'0E'`    | MK3853 SMI | **Interrupt control / mask register.** Boot writes `0x01` (U22:843) to enable the timer/external interrupt source. |
| `H'32'` (long-form `IN`)   | external | `IN H'32'` at U22:907. Long-form `IN` (8-bit port, opcode `0x26 ii`) talks through external decode — purpose TBD. |
| `H'93'` (long-form `OUT`)  | external | `OUT H'93'` at U22:959. Same external-decode path; purpose TBD. |

## Interrupt vector

Set during boot init at U22:83D-843:

```
LIS  H'0B'   ; A = 0x0B
OUTS H'0C'   ; SMI vector hi
LI   H'99'   ; A = 0x99
OUTS H'0D'   ; SMI vector lo
LIS  H'01'
OUTS H'0E'   ; SMI int-control = 1 (enable)
```

→ **ISR enters at `H'0B99'`** in U22. Prologue:

```
LR   6,A         ; r6 ← A (save accumulator)
LR   J,W         ; J ← W (save status reg + ICB)
LR   A,IS        ; A ← ISAR
LISU 3 ; LISL 0  ; ISAR ← H'18'
LR   I,A         ; scratchpad[H'18'] ← saved ISAR; ISAR ← H'19'
LR   A,QU
LR   I,A         ; scratchpad[H'19'] ← QU; ISAR ← H'1A'
LR   A,QL
LR   S,A         ; scratchpad[H'1A'] ← QL
LR   Q,DC        ; Q ← DC (save data counter)
DCI  H'8000'     ; DC ← peripheral / RX register
…
```

The fact that the ISR jumps straight to `DCI H'8000'` and reads with `LM`
implies H'8000' is the **data path of an interrupt-driven peripheral** —
most likely the AY-5-1013A's received-data byte (latched on DAV strobe).
The SMI external-interrupt input is then probably wired to UART DAV.

## Cross-ROM call map

(See `jump_tables_*.txt` for raw extracted tables.)

- **U1 → U12** (8 PI sites in U1's first 0x200 bytes).
- **U22 → U12** (PI calls at `H'0A19'`→`H'05FB'/H'0624'`, `H'0B47'`→`H'0593'/H'0793'`, plus several scattered).
- **U22 → U22** (intra-ROM dispatch via primary table at `H'0800..H'0817'`).
- **U22 → U1** (rare; verify when symbolicating).
- **U12 → U22 / U12 → U1** — searches pending.

## Primary dispatch table (`H'0800..H'0817'`)

8 entries, 3 bytes each (`JMP H'XXXX'`):

| Index | Target    | Tentative role |
|-------|-----------|----------------|
| 0     | `H'0818'` | **Cold boot init** (`LIS 0; OUTS 0; OUTS 1; …`) — entered from reset (`U1:0000` `JMP H'0800'`) |
| 1     | `H'09F9'` | TBD — likely a re-entry / mode entry |
| 2     | `H'0A10'` | TBD |
| 3     | `H'0A19'` | TBD (calls U12:5FB and U12:624) |
| 4     | `H'0A1F'` | TBD |
| 5     | `H'0A31'` | TBD |
| 6     | `H'0B81'` | TBD |
| 7     | `H'0B41'` | TBD |
