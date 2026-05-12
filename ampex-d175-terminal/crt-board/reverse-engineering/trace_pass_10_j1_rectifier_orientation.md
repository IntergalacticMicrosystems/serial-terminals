# Trace Pass 10: J1 Rectifier Orientation

Status: diode-orientation pass using rectified front/back crops.

Update after user continuity: J1-to-diode endpoint mapping is now confirmed for the listed anode/cathode endpoints. Rail names remain pending output-side tracing.

## Source Images

- `overlays/rectified_j1_power_montage.jpg`
- `overlays/rectified_j1_rectifier_local_montage.jpg`
- `overlays/rectified_front_cr105_cr106_band_zoom.png`
- `overlays/rectified_front_cr101_cr104_band_zoom.png`
- `overlays/back_auto_mirrored_j1_rectifier_hi_res_candidate.png`

## Confirmed From Front Photo

`J1` is a five-pin transformer harness, with pin 5 closest to the bottom board edge per user confirmation.

The diode bands are readable enough to record orientation:

| Refdes | Cathode band side in component-side view | Confidence | Notes |
|---|---|---:|---|
| `CR105` | right | medium-high | Upper auxiliary rectifier/protection group. |
| `CR106` | right | medium-high | Same orientation as `CR105`. |
| `CR101` | left | high | Lower four-diode rectifier group. |
| `CR102` | left | high | Same orientation as `CR101`. |
| `CR103` | right | high | Opposite orientation from `CR101`/`CR102`. |
| `CR104` | right | high | Same orientation as `CR103`. |

The lower `CR101`-`CR104` group is therefore not four same-direction series diodes. It is a discrete rectifier / split-rail / doubler-style network and must be drawn from endpoint nets, not guessed from placement alone.

## User Continuity: J1 Endpoint Map

`J1` is numbered top to bottom, with pin 5 closest to the bottom board edge.

| J1 pin | Confirmed endpoint(s) |
|---:|---|
| 1 | `CR106` anode |
| 2 | `CR105` anode |
| 3 | `CR101` anode + `CR102` anode |
| 4 | `CR102` cathode + `CR103` anode |
| 5 | `CR104` anode + `CR101` cathode |

## Solder-Side Progress

The rectified and high-resolution solder-side crops show three useful structures:

- a five-pad vertical `J1` landing row near the left board edge,
- a central narrow rectifier island running between the lower diode endpoints,
- larger left/right copper islands that continue toward the bulk capacitors and other supply circuitry.

The high-resolution crop improves copper-border visibility, but the connector body, perspective at the board edge, and glare made the exact `J1` pin-to-diode endpoint assignment unsafe from photos alone. The user continuity table above resolves that blocker.

## Schematic Impact

Safe to add now:

- Diode orientation notes for `CR101`-`CR106`.
- A four-diode lower rectifier block with temporary endpoint nets.
- A separate upper `CR105`/`CR106` rectifier/protection block.
- Direct J1 pin connections to the confirmed diode endpoints in the table above.

Not safe yet:

- Calling `CR101`-`CR104` a simple bridge rectifier.
- Naming any resulting rail as `+B`, `+12V_RAW`, or similar solely from the photos.

## Next J1 Step

The next useful pass is a rectifier output table:

1. `CR105` cathode and `CR106` cathode.
2. `CR103` cathode and `CR104` cathode.
3. Bulk capacitor `C107` / nearby electrolytic polarity pads.
4. Temporary island IDs and eventual rail names for each copper region.

The J1 pin-to-diode input side no longer needs checking unless a later observation contradicts this table.
