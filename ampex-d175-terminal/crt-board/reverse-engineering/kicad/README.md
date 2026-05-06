# KiCad Workspace

Starter KiCad 10 project for the CRT board reverse-engineered schematic.

Files:

- `ampex_d175_crt_board.kicad_pro`
- `ampex_d175_crt_board.kicad_sch`

Current state:

- The schematic is a block map, not yet a component-level electrical schematic.
- Blocks are intentionally used where pin mapping is not confirmed.
- Replace blocks with real symbols as `pad_map.csv` and `net_register.csv` mature.
- `pad_map.csv` now has seed placeholders for `J1`, `J2`, `J4`, `U101`, and `U102`.
- `J1` is user-confirmed as a 5-pin main-transformer harness: pins 1-2 yellow, pin 3 grey, pins 4-5 brown; pin 5 is closest to the lower PCB edge.
- `J1` nets are named `J1_YEL_1`, `J1_YEL_2`, `J1_GRY_3`, `J1_BRN_4`, and `J1_BRN_5` until their rectified rail functions are traced.
- `J4` is user-confirmed as pin 1 toward the top of PCB: 1 blue, 2 white, 3 red, 4 black. Red-blue measures 3.2 ohms and is assigned vertical; black-white measures 0 ohms and is assigned horizontal.
- CRT socket continuity is user-confirmed: pin 1 green/E1, pin 2 yellow/E2, pin 3 brown/E3, pin 4 black/J2-aquadag, pin 5 NC, pin 6 red/E6, pin 7 blue/E7. Electrode functions remain pending CRT tube pinout.
- The related Ampex 219/230 `3515240` video-board schematic suggests `E2` is cathode/video drive and `E7` is focus, but the D-175 wire colors differ, so those names are still provisional.
- The CPU-board harness remains a 10-position block. A related manual suggests expected signal classes (`+12V`, horizontal/vertical sync, video, and returns), but no D-175 harness pin functions are assigned yet.
- `align_board_photos.ps1` now creates board-rectified front/back/blend images. Use those overlays as the primary source for replacing blocks with real component symbols; reserve continuity checks for ambiguous ties.
- The first rectified CRT neck/video trace pass places `E1`, `E2`, `E3`, `E6`, and `E7` in board coordinates and separates the 500-series electrode network from the lower `Q401` video-output cluster.
- `exports/ampex_d175_crt_board.pdf` has been generated successfully.
- `exports/erc.rpt` currently reports 0 violations for the block-map sheet.

Useful commands:

```powershell
& 'C:\Program Files\KiCad\10.0\bin\kicad-cli.exe' sch export pdf .\ampex_d175_crt_board.kicad_sch -o .\exports\ampex_d175_crt_board.pdf
& 'C:\Program Files\KiCad\10.0\bin\kicad-cli.exe' sch erc .\ampex_d175_crt_board.kicad_sch -o .\exports\erc.rpt
```

The local sandbox currently prints HKCU registry warnings from `kicad-cli`, but the CLI commands still run.

Avoid running multiple KiCad CLI commands against the same project in parallel; KiCad may emit a transient project-lock parse warning. Sequential export/ERC runs are clean.
