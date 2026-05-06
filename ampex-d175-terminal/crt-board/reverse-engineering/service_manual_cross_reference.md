# Service Manual Cross-Reference

Status: related-reference comparison, not a substitute for D-175 continuity.

## Source

Local file:

- `../../Docs/3515021-01_Ampex_230_219_Service_Manual_198506.pdf`

Relevant rendered pages:

- `overlays/manual_pages/service_manual_page_74.png`
- `overlays/manual_pages/service_manual_page_75.png`
- `overlays/manual_pages/service_manual_page_76.png`
- `overlays/manual_pages/service_manual_page_76_crt_socket_label_text_crop.png`

The useful drawing is Ampex `3515240`, `PWBA - VIDEO BOARD`, sheet 3 of 3. It is from the Ampex 219/230 service manual, not the D-175 CRT board, so it is comparative evidence only.

## Why It Matters

The related video board uses many familiar CRT-board blocks:

- `uPC1031H2` vertical deflection IC.
- Horizontal output/flyback section.
- Brightness and focus controls.
- CRT socket pads named `E1`, `E2`, `E3`, `E4`, `E6`, and `E7`.
- Spark-gap/neon protection around the CRT electrode leads.

The D-175 board photo shows similar local structure around `Q401`, `NS401`, `R401`-`R406`, `VR501` focus, `VR502` brightness, and `E1`/`E2`/`E3`/`E6`/`E7`.

## Important Difference

The manual's CRT socket wiring table does not match the D-175 wire colors:

| Manual `3515240` socket board | Manual color | D-175 continuity result |
|---|---|---|
| `E1` / `N1` | white | socket pin 1 green to `E1` |
| `E6` / `N2` | yellow | socket pin 6 red to `E6` |
| `E7` / `N3` | blue | socket pin 7 blue to `E7` |
| `E3` / `N6` | black | socket pin 3 brown to `E3`; socket pin 4 black to `J2`/aquadag |
| `E4` / `N4` | red | no confirmed D-175 `E4` socket lead yet |
| `N5` | orange | no D-175 orange lead |

This means the manual cannot be copied directly into the D-175 schematic.

## Useful Manual-Derived Hints

Treat these as hypotheses until D-175 copper or continuity confirms them:

| D-175 pad | D-175 wire | Manual hint | Working interpretation |
|---|---|---|---|
| `E2` | yellow | manual labels `E2` at the video output/cathode circuit | likely CRT cathode/video drive |
| `E7` | blue | manual routes `E7` through the focus network | likely focus electrode |
| `E1` | green | manual routes `E1` through a high-voltage/resistor/spark-gap network near brightness/focus circuitry | likely grid/accelerator-style CRT electrode; exact name pending |
| `E6` | red | manual routes `E6` through a high-voltage/resistor/spark-gap network | likely grid/accelerator-style CRT electrode; exact name pending |
| `E3` | brown | manual uses `E3` as a CRT ground-side node | D-175 must be checked before calling it ground because socket pin 4 black is already confirmed to `J2`/aquadag |

## D-175 Photo Correlation

`overlays/crop_front_auto_crt_neck_left.png` shows:

- `E7` beside the blue socket wire.
- `E6` beside the red socket wire.
- The green wire landing beside a partially visible `E1` marking.
- The brown wire landing beside `E3`.
- The yellow wire landing in the same vertical CRT-neck pad group, likely `E2` per user continuity.
- The `Q401`/`R401`/`R402`/`R404`/`R406`/`C401`/`NS401` cluster below the neck leads, matching the kind of cathode/video output cluster shown in the related manual.

## Next Minimal Checks

These are the smallest unpowered checks to convert the manual hints into D-175 facts:

- `E2`/yellow to `R402` and `NS401`; this would strongly confirm `E2` as cathode/video drive.
- `E7`/blue to the `FOCUS` control (`VR501`) wiper or series parts; this would confirm `E7` as focus.
- `E1`/green and `E6`/red to `VR502` brightness and nearby spark-gap/neon protection parts; this would sort the remaining grid/accelerator electrodes.
- `E3`/brown to `J2`/aquadag; this determines whether `E3` is another ground-side CRT node or a separate electrode.
- Read the CRT tube type from the glass label if possible; that is the cleanest way to name the socket electrodes.

## Schematic Rule

The D-175 schematic may include manual-derived notes beside the CRT socket block, but electrode names should remain provisional until confirmed by D-175 continuity or the actual CRT tube pinout.
