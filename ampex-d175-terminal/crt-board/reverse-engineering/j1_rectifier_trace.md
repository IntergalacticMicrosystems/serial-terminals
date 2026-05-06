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

The five transformer leads mean this is not a single two-wire AC input. The most likely monitor-board patterns are:

- one transformer secondary feeding a full bridge or voltage doubler for a high-energy raw rail,
- another transformer secondary feeding low-voltage/regulator supplies,
- a center tap, shield, or reference lead on the grey wire.

The photos do not yet prove which of those patterns applies.

## Current Working Hypotheses

These are deliberately phrased as hypotheses, not schematic facts:

- Yellow/yellow pins 1-2 are likely one AC secondary.
- Brown/brown pins 4-5 are likely one AC secondary.
- Grey pin 3 may be a center tap, shield, reference, or separate single-ended lead.
- `CR101`-`CR104` likely create a rectified rail associated with one of the transformer secondary groups.
- `CR105`/`CR106` likely create a second rectified rail or clamp/protection path.

## Current Photo Limit

The corrected mirrored solder-side crops expose a plausible `J1` five-pad row and nearby diode/capacitor pad groups, but they do not prove the individual `J1` pin-to-diode endpoint mapping.

Reasons:

- The solder-side photo has enough perspective distortion that front/back pad matching is approximate.
- `J1`, `CR101`-`CR106`, and nearby capacitors use clustered rectangular pads with wide pours between them.
- Some copper transitions are hidden under mask/glare or blocked by component-side bodies.

## What To Trace Next

Use either a better straight-on solder-side close-up or the smallest continuity pass:

1. Trace each visible diode cathode-band end in `CR101`-`CR106`.
2. Associate each diode endpoint with the closest J1 pin landing region.
3. Use capacitor polarity marks to name only the rectified outputs that are visually clear.

If photo evidence remains ambiguous, these are the smallest useful unpowered checks:

- J1 pin 1 to both ends of `CR105` and `CR106`.
- J1 pin 2 to both ends of `CR105` and `CR106`.
- J1 pin 3 to diode endpoints and capacitor negative/positive pads.
- J1 pins 4 and 5 to `CR101`-`CR104` endpoints.

## Schematic Rule

Do not draw a final bridge, center-tap rectifier, or doubler in KiCad until at least the diode endpoint mapping is confirmed. For now, represent `J1` as a five-pin transformer harness feeding unresolved rectifier groups.
