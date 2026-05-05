# MIME-2A Mainboard — Photo Identification

Identification of components visible in `mime2a_mainboard_full.jpg`,
`mime2a_mainboard_left.jpg`, and `mime2a_mainboard_right.jpg`.

Manufacturer's mark is at the bottom-right edge of the board: stylized **m**
logo with **`MICRO-TERM, INC.`** wordmark, alongside the FCC/UL marks and what
appears to be a board revision/date code stamp.

The board is a single-sided (or double-sided) green-soldermask PCB with the
processor/ROM cluster at left-of-centre, the video/UART section on the right,
and a linear power supply along the left edge.

## Functional layout (overview)

```
 +---------------------------------------------------------------+
 | PSU      |  CPU + ROM cluster   |  Video / character gen      |
 | (heat-   |  3850 + 3853 +       |  generator ROM, RAM,        |
 |  sinks,  |  three 2708 EPROMs   |  shift registers, dot-clock |
 |  caps,   |  + 2716 EPROM        |                             |
 |  regs)   |                      |  AY-5-1013A UART            |
 |          |                      |  Baud-rate gen, DIP switch  |
 +---------------------------------------------------------------+
            edge connector / keyboard / aux I/O along bottom
```

## Left photo — power supply and CPU cluster

### Power supply (left edge)

- **3 voltage regulators** in TO-220 packages bolted to black finned
  heatsinks. Standard MIME-2A rails are +5 V, +12 V, and −12 V (the latter
  needed for the AY-5-1013A UART and RS-232 line drivers); regulator types
  are most likely 7805 / 7812 / 7912 but the body markings are not legible
  in the photo.
- **Large axial/radial electrolytic capacitors** (filter caps) — at least
  three visible blue-sleeved cans. One labelled fragment reads "85 °C"
  (industrial-grade rating).
- **Smaller blue radial electrolytics** scattered for local decoupling.
- **Bridge rectifier** or discrete-diode bridge near the regulators
  (small black square package visible).
- **Red LED** (power-on indicator) just to the right of the regulator stack.
- Solder pads at the very edge for transformer secondary leads.

### Processor / ROM cluster (centre-left)

- **3 × EPROM in 24-pin DIP with quartz window**, arranged in a vertical
  column. These are the three **2708** EPROMs — `U1`, `U12`, `U22` from the
  ROM dumps directory (`f2708_eprom_u1_*.bin`, `mm2708q_eprom_u12_*.bin`,
  `mm2708q_eprom_u22_*.bin`), 1 KB each, mapping to `0x0000` / `0x0400` /
  `0x0800`.
- Just to the right of the EPROM column: **two large 40-pin DIPs side-by-
  side**, both with the Fairchild/Mostek "F" logo style packaging. Per the
  user, these are:
  - **Mostek/Fairchild 3850** — F8 CPU
  - **Mostek/Fairchild 3853** — Static Memory Interface (SMI). Provides the
    address bus to the off-chip ROM/RAM (since the 3850 has no address bus
    of its own — see `references/romc-bus.md`), the interrupt-vector
    register, and a programmable timer.
- **24-pin DIP labelled `DM74LS244`** — National Semiconductor octal
  three-state buffer / line driver, just below the 3850. Likely buffering
  the address bus driven by the 3853 to fan out to ROM and external RAM.
- **Small silver crystal can** (HC-style cylinder) — main system clock.
- **Trimmer / variable capacitor** (small yellow ceramic) — clock-trim or
  video timing trim.
- A scattering of 14- and 16-pin **74LS-series TTL** glue logic to the
  right of and below the CPU pair (decoders / buffers / latches; specific
  part numbers not readable at this resolution).
- Blue **8-position DIP switch** near the bottom — almost certainly the
  configuration-options switch (baud rate / parity / terminal modes).

## Right photo — video and UART section

### UART / serial section

- **40-pin DIP marked `AY-5-1013A`** — General Instruments / AMI UART.
  This is the canonical 1970s UART used in dozens of terminals and
  modems; needs +5 V and −12 V (one reason the PSU has a negative rail).
  Programmed via parallel control pins (parity/word-length/stop-bits)
  rather than memory-mapped registers.
- **Crystal oscillator can** (large silver cylinder, top-left of right
  photo) — likely the **baud-rate generator clock** (e.g. 2.4576 MHz or
  4.9152 MHz feeding a divider chain or a dedicated BRG chip). Not the
  CPU clock, which is on the left side of the board.
- A second blue **8-position DIP switch** at lower-right — typically
  baud-rate select on terminals of this era.

### Video / character-generator section

- **24-pin DIP with quartz window** in the lower-right region — this is
  the **2716 EPROM** at `U55` (`mm2716q_eprom_u55_*.bin`, 2 KB,
  mapping to `0x0C00`). Its position adjacent to the dot-clock crystal
  and shift-register logic is consistent with U55 holding video display
  code rather than character glyphs.
- A second masked/EPROM-style 24-pin DIP nearby — corresponds to **U39**,
  the `EA 8316E244` 2 KB mask ROM (`ea_8316e244_mask_rom_u39_*.bin`).
  This is the **character generator ROM** (5×7 or similar dot-matrix
  glyph table). Mask ROMs cannot be re-programmed; replacement requires
  a 2716 + adapter (see f8-3850-asm skill notes on patching).
- Multiple **rows of 16-pin DIPs** arrayed across the centre-right of
  the board — typical of a row of **shift registers** (e.g. 74LS166
  parallel-load shifters) feeding the video serializer, plus
  **character-line counter** logic and **video RAM** (likely 2114-style
  1Kx4 SRAM, or 2102 1Kx1 SRAM banks).
- **Trimmer cap** in the video region — dot-clock or video-timing
  adjustment.
- **6-pin Molex-style connector** at the top-right edge — likely the
  **keyboard connector** (parallel ASCII keyboard with strobe + ground
  + power, common on serial terminals of this vintage).

## Bottom edge (full image)

- A **40-pin / 50-pin edge-connector-style header** along the bottom — the
  main I/O / backplane connection, probably carrying RS-232, video, and
  power-rail returns.
- Smaller secondary header to the right — auxiliary I/O.

## Cross-reference to ROM dump filenames

| Photo region | Designator | Part | Dump file |
|---|---|---|---|
| Centre-left, 3-up column | U1 | 2708 (1 KB EPROM) | `f2708_eprom_u1_6eaf59ae.bin` |
| Centre-left, 3-up column | U12 | MM2708Q (1 KB EPROM) | `mm2708q_eprom_u12_7162a6cc.bin` |
| Centre-left, 3-up column | U22 | MM2708Q (1 KB EPROM) | `mm2708q_eprom_u22_7c7cc3dd.bin` |
| Right, near video logic | U55 | MM2716Q (2 KB EPROM) | `mm2716q_eprom_u55_08658dd6.bin` |
| Right, near char-gen | U39 | EA 8316E244 (2 KB mask ROM) | `ea_8316e244_mask_rom_u39_f12e73c0.bin` |

Total program/character ROM: 7 KB (5 KB program across U1/U12/U22/U55 plus
2 KB character generator at U39).

## What is not legible from these photos

- Specific 74LS- part numbers on most of the small DIPs.
- Voltage-regulator part numbers (covered by heatsinks).
- Crystal frequencies (would need close-up of the crystal can markings).
- DIP-switch silkscreen labels (function of each switch position).
- The board's revision number and date code (visible as a stamp at the
  bottom-right, but not resolvable here).

A higher-resolution close-up of the crystal cans, the DIP-switch silkscreen,
and the row of small DIPs in the video section would let us pin down the
exact baud-rate generator scheme and video-RAM organisation.
