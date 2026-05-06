# Trace Pass 04: Yoke And CRT Neck Photos

Status: photo plus user continuity evidence.

## Source Images

- `../CRT-deflection.jpg`
- `../CRT-deflection2.jpg`
- `../CRT-deflection-conn.jpg`
- `../CRT-Neck-connector.jpg`
- `overlays/yoke_neck_photo_montage.jpg`

## Deflection Yoke

Readable yoke label fragments:

- likely Ampex/assembly number ending in `79-01`; earlier read as `3512679-01`.
- `584143`
- `TYPE90912`
- `ZENITH`
- `TAIWAN`
- date/lot fragment `8527` or similar.

The plug photo shows the four yoke harness wires in this visible order, viewed from the wire-entry side of the unplugged connector:

1. black
2. red
3. white
4. blue

The board-side pin order is now user-confirmed:

| J4 pin | Wire | Assigned net | Evidence |
|---:|---|---|---|
| 1 | blue | `V_YOKE_BLUE` | Pin 1 is toward top of PCB; red-blue pair measures 3.2 ohms. |
| 2 | white | `H_YOKE_WHITE` | Black-white pair measures 0 ohms. |
| 3 | red | `V_YOKE_RED` | Red-blue pair measures 3.2 ohms. |
| 4 | black | `H_YOKE_BLACK` | Black-white pair measures 0 ohms. |

Confirmed coil pairs:

- red/blue = 3.2 ohms, assigned vertical yoke.
- black/white = 0 ohms, assigned horizontal yoke.

The horizontal/vertical assignment follows the usual CRT pattern where the lower-resistance yoke winding is horizontal. The `0 ohms` reading should be treated as very low resistance rather than a literal short unless a more precise meter shows otherwise. Polarity/phase is not assigned.

## CRT Neck Socket

The socket face has molded pin numbers visible around the circumference. The visible wire colors are:

- red
- blue
- black
- brown
- green
- yellow
- separate loose black clip lead

User continuity results:

| Socket pin | Wire | Board pad/refdes | Net |
|---:|---|---|---|
| 1 | green | `E1` | `CRT_E1_GREEN` |
| 2 | yellow | `E2` | `CRT_E2_YELLOW` |
| 3 | brown | `E3` | `CRT_E3_BROWN` |
| 4 | black | same place as `J2` | `EARTH_CRT_AQUADAG` |
| 5 | none | none | NC |
| 6 | red | `E6` | `CRT_E6_RED` |
| 7 | blue | `E7` | `CRT_E7_BLUE` |

- The loose black clip lead is continuous to `J2`, so it is also `EARTH_CRT_AQUADAG`.
- The colored socket wires should remain electrode-unnamed until the CRT tube type/pinout is known.

## Smallest Checks To Break The Remaining Blockers

For the CRT socket:

- Identify the CRT tube type from the bell/neck label if visible.
- Use the CRT tube pinout to map socket pins 1-7 to heater, cathode, grid, and focus/accelerator functions.
- Trace board pads `E1`, `E2`, `E3`, `E6`, and `E7` into the `400`/`500` circuit sections.

## Schematic Rule

Add `J4` as a four-pin yoke connector with `V_YOKE_BLUE`, `H_YOKE_WHITE`, `V_YOKE_RED`, and `H_YOKE_BLACK`. Add the CRT socket as a numbered connector with board pads `E1`, `E2`, `E3`, `E6`, `E7`, pin 4 tied to `EARTH_CRT_AQUADAG`, and pin 5 NC. Do not assign CRT electrode names until the CRT tube pinout is known.

Related manual note:

- The Ampex 219/230 `3515240` video-board schematic uses the same `E1`/`E2`/`E3`/`E6`/`E7` style labels and suggests `E2` is the cathode/video-drive node and `E7` is in the focus network. Because the D-175 socket wire colors differ from the manual, keep these as hypotheses until local D-175 continuity confirms them. See `service_manual_cross_reference.md`.
