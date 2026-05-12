# J1 Rectifier Trace

Status: working topology note, updated after user confirmation that `J1` is a 5-pin main-transformer harness.

## Confirmed J1 Harness

| J1 pin | Wire color | Source | Working net |
|---:|---|---|---|
| 1 | yellow | main transformer | `J1_YEL_1` |
| 2 | yellow | main transformer | `J1_YEL_2` |
| 3 | grey | main transformer | `J1_GRY_3` |
| 4 | brown | main transformer | `J1_BRN_4` |
| 5 | brown | main transformer | `J1_BRN_5` |

Pin 5 is closest to the bottom edge of the PCB.

## Photo-Derived Rectifier Grouping

Use the corrected EXIF-aware solder-side image set from `trace_pass_03_j1_photo_alignment.md` for pad-level decisions. Earlier non-auto-oriented mirrored crops are superseded.

The component side shows two rectifier areas around `J1`:

- Upper group: `CR105`, `CR106`, with nearby `C105`, `C106`.
- Lower/right group: `CR101`, `CR102`, `CR103`, `CR104`, with nearby `C101`-`C104` and bulk electrolytics.

Trace pass 10 adds diode orientation:

- `CR105` and `CR106`: cathode bands face right.
- `CR101` and `CR102`: cathode bands face left.
- `CR103` and `CR104`: cathode bands face right.

Trace pass 11 adds user continuity:

| J1 pin | Confirmed diode endpoint(s) |
|---:|---|
| 1 | `CR106` anode |
| 2 | `CR105` anode |
| 3 | `CR101` anode + `CR102` anode |
| 4 | `CR102` cathode + `CR103` anode |
| 5 | `CR104` anode + `CR101` cathode |

The five transformer leads mean this is not a single two-wire AC input. The most likely monitor-board patterns are:

- one transformer secondary feeding a full bridge or voltage doubler for a high-energy raw rail,
- another transformer secondary feeding low-voltage/regulator supplies,
- a center tap, shield, or reference lead on the grey wire.

The photos do not yet prove which of those patterns applies.

## Current Working Hypotheses

These are deliberately phrased as hypotheses, not schematic facts:

- Yellow/yellow pins 1-2 feed `CR106`/`CR105` anodes respectively.
- Brown/brown pins 4-5 feed the lower rectifier network nodes listed above.
- Grey pin 3 feeds the common `CR101`/`CR102` anode node.
- `CR101`-`CR104` likely create a rectified rail, split rail, or doubler associated with one of the transformer secondary groups. The mixed diode orientations mean this should not be assumed to be a simple bridge until endpoint nets are assigned.
- `CR105`/`CR106` likely create a second rectified rail or clamp/protection path.

## Current Photo Limit

The corrected mirrored solder-side crops expose a plausible `J1` five-pad row and nearby diode/capacitor pad groups, but they did not prove the individual `J1` pin-to-diode endpoint mapping. User continuity now supplies the endpoint table above.

Reasons:

- The solder-side photo has enough perspective distortion that front/back pad matching is approximate.
- `J1`, `CR101`-`CR106`, and nearby capacitors use clustered rectangular pads with wide pours between them.
- Some copper transitions are hidden under mask/glare or blocked by component-side bodies.

## What To Trace Next

Use either a better straight-on solder-side close-up or the smallest continuity pass:

1. Trace `CR105` cathode and `CR106` cathode.
2. Trace `CR103` cathode and `CR104` cathode.
3. Use capacitor polarity marks to name only the rectified outputs that are visually clear.

If photo evidence remains ambiguous, these are the smallest useful unpowered checks:

- `CR105` cathode to nearby capacitor positive/negative pads.
- `CR106` cathode to nearby capacitor positive/negative pads.
- `CR103` and `CR104` cathodes to `C107` and the nearby large electrolytic nodes.

## Schematic Rule

Do not draw a final bridge, center-tap rectifier, or doubler in KiCad until the output-side diode/capacitor nodes are confirmed. It is now safe to connect `J1` pins to the diode endpoints listed in trace pass 11.
