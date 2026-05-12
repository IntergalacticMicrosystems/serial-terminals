# Trace Pass 09: E2 / E3 / J2 Bridge

Status: bridge crop from the CRT electrode strip down into the `Q401` video cluster.

Update after user continuity: `E2` is confirmed to the non-J2 side of `NS401` and `R405`. The earlier photo-only E2 blocker is resolved; use `N017` as the master `E2` / video active node.

## Source Images

- `overlays/rectified_front_e2_to_q401_bridge.png`
- `overlays/rectified_back_e2_to_q401_bridge.png`
- `overlays/rectified_blend_e2_to_q401_bridge.png`
- `overlays/rectified_e2_to_q401_bridge_montage.jpg`
- `overlays/rectified_back_e2_to_q401_bridge_analysis.jpg`
- `overlays/rectified_back_e2_e3_local_2x.png`
- `overlays/rectified_blend_e2_e3_local_2x.png`
- `overlays/rectified_back_j2_to_q401_left_bus_2x.png`
- `overlays/front_auto_e2_e3_hi_res_candidate.png`
- `overlays/back_auto_mirrored_e2_q401_hi_res_candidate.png`

## What Changed

The bridge crop removes the gap between the earlier `E*` pad zoom and the lower `Q401` zoom. This gives one continuous solder-side view from the yellow/brown CRT electrode landings down through `J2`, `A7`/`A8`, `Q401`, `R401`/`R402`/`R404`/`R406`, `C401`, `R405`, and `NS401`.

## Confirmed / Promoted

### `N021` is an alias of the J2-side bus

The broad left-side copper island from trace pass 08 can now be followed through the `J2` area in the bridge crop. It is no longer just a local `Q401` island. Treat it as the same J2/aquadag reference bus unless a later close-up contradicts this.

Net-register impact:

- Keep `N013` as the master net name: `EARTH_CRT_AQUADAG`.
- Mark `N021` as a superseded local alias for the same visible bus.

### `E3` is likely on the J2-side bus

The brown `E3` landing overlays a solder-side branch coming off the same wide left-side bus. The branch can be seen in both the rectified solder image and the enhanced blend.

Confidence: medium-high.

Reason for not making this a hard final rename yet: the brown wire body and the nearby large electrolytic partly obscure the front-side barrel/lead, so the last millimeter of the physical landing is not as clean as the J2 bus itself. The related Ampex 219/230 video-board schematic also uses `E3` as a ground/reference-side CRT node, so the photo and comparison schematic agree.

## Resolved By Continuity

### `E2` to the video active node

User continuity confirms `E2` goes to the non-J2 side of `NS401` and `R405`.

This confirms the functional interpretation suggested by the related Ampex 219/230 schematic:

- `E2` is the CRT cathode/video-drive node.
- `E2` connects to the local video output network through the non-J2 side of `R405` on the D-175 board.
- `NS401` protects between the video/cathode node and the CRT reference side.

Use the D-175 continuity result over the related manual's exact resistor numbering.

## Current Local Graph

| Node | Current net ID | Status after this pass | Notes |
|---|---|---|---|
| J2/aquadag broad left bus | `N013` | confirmed master | Includes `J2`; visually extends into the lower `Q401` reference side. |
| Former `Q401` left bus | `N021` | superseded alias | Use `N013` for schematic work. |
| `E3` brown landing | `N018` | candidate merge with `N013` | Photo-supported, medium-high confidence; one continuity check would make it final. |
| `Q401` active column | `N022` | superseded alias of `N017` | User continuity confirms `E2` to the non-J2 side of `NS401` and `R405`. |
| Upper `Q401` / `C502` island | `N023` | still provisional | Functional role still pending. |
| `E2` yellow landing | `N017` | confirmed video active node | Confirmed to non-J2 side of `NS401` and `R405`. |

## Schematic Impact

Safe to draw now:

- `J2`, CRT socket pin 4, loose CRT clip, and the broad left-side bus as `EARTH_CRT_AQUADAG` / `N013`.
- The `Q401` lower reference side with a note that its left-side bus is now visually tied to `J2`.
- `E3` as a likely J2-side/reference node, flagged as medium-high confidence rather than final.

Still keep provisional:

- Exact `Q401` transistor pin roles.
- Exact CRT electrode name if the tube pinout later uses a designation more specific than cathode/video node.

## Smallest Useful Continuity Checks

Remaining useful unpowered check:

1. `E3` brown landing to `J2`: expected continuous if the photo interpretation is correct.

No powered testing is needed for this check.
