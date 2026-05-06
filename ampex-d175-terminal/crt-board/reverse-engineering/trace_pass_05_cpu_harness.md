# Trace Pass 05: CPU-Board Harness

Status: photo/manual guide; exact pinout still blocked.

## Source Images

- `overlays/crop_front_auto_cpu_harness.png`
- `overlays/crop_back_auto_mirrored_cpu_harness_wide.png`
- related manual schematic: `overlays/manual_pages/service_manual_page_76.png`

## D-175 Photo Facts

The top-left harness is a 10-position wire bundle marked `CPU BOARD` on the source image. The board-side labels visibly include pins:

- `6`
- `5`
- `4`
- `3`
- `2`
- `1`
- `9`
- `10`

The visible wire colors by the printed labels appear to include:

| Visible printed pin | Visible wire color | Confidence |
|---:|---|---:|
| 6 | red | medium |
| 5 | black or dark gray | medium |
| 4 | orange/salmon | medium |
| 3 | blue | medium |
| 2 | yellow | medium |
| 1 | black/dark | low-medium |
| 9 | purple | medium |
| 10 | green | medium |

Pins 7 and 8 are not confidently visible in the current crop. The wire bundle includes additional dark/white conductors whose exact printed pin numbers are obscured by the tie wrap and routing.

## Solder-Side Observation

`overlays/crop_back_auto_mirrored_cpu_harness_wide.png` shows the harness pad fan-out and several long traces leaving the connector area, but the exact pin-to-function mapping is not safe to assign from the photo alone. The trace bundle quickly enters the vertical/focus/control area and is partly confused by overlapping adjacent pads.

## Related Manual Signal Guide

The related Ampex 219/230 `3515240` video-board schematic shows this class of CRT board receiving:

- `+12V, HOR`
- `GND, HOR`
- `SYNC, HOR`
- `GND, HOR SYNC`
- `+12V, VER`
- `GND, VER`
- `SYNC, VER`
- `VIDEO`
- `VIDEO GND`

The D-175 harness has 10 positions, so those signal names are plausible search targets. They are not assigned to D-175 pins yet.

## Smallest Checks To Break The Blocker

With power off:

- CPU harness pins to `U102` pin 3 / `+12V`.
- CPU harness pins to `U102` pin 2 / board common.
- CPU harness pins to `VR320`/hold and `U301` sync-related pins.
- CPU harness pins to `Q401`/video input network.
- CPU harness pins to `VIDEO GND`/local video return if distinguishable from board common.

## Schematic Rule

Keep the CPU harness as a 10-position block until at least the `+12V`, return, horizontal sync, vertical sync, and video/video-ground pins are confirmed locally on the D-175 board.
