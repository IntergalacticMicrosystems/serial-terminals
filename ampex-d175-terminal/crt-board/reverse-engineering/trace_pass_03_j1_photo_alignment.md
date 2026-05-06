# Trace Pass 03: Corrected J1 Photo Alignment

Status: photo pass pushed to current limit.

## Correction

The first mirrored solder-side working image was made without first applying the EXIF orientation from `Back.jpg`. That made the earlier `back_mirrored.png` crops useful for broad visual context but unsafe for pad-level alignment.

Canonical images for new work:

- `overlays/front_auto.png`
- `overlays/back_auto.png`
- `overlays/back_auto_mirrored.png`
- `overlays/j1_front_back_corrected_montage.jpg`

## J1 Region Findings

The corrected component-side crop, `overlays/crop_front_auto_j1_corrected.png`, shows:

- `J1` is the five-pin `AC IN` transformer harness.
- Pin 5 is the bottom-most connector pin, per user confirmation.
- `CR105`/`CR106` sit above `J1` with nearby `C105`/`C106`.
- `CR101`-`CR104` sit to the right/lower-right of `J1` with nearby `C101`-`C104` and bulk electrolytics.

The corrected mirrored solder-side crops, especially `overlays/crop_back_auto_mirrored_j1_pads_zoom1.png` and `overlays/crop_back_auto_mirrored_j1_pads_zoom2.png`, show a likely five-pad connector row near the lower-left of the crop. This row is the best current candidate for the `J1` solder pads.

## Candidate Solder-Side Grouping

The photo supports this grouping but not exact pin-to-net assignment:

| Candidate group | Likely component(s) | Confidence | Notes |
|---|---|---:|---|
| Lower-left five-pad vertical/diagonal row | `J1` pins 1-5 | Medium | Shape and location match the front-side connector region. Individual pin order is inferred from front-side geometry plus the user-confirmed bottom pin 5, but not proven from copper continuity. |
| Pad columns immediately to the right of the likely `J1` row | `CR101`-`CR104` endpoints and local capacitors | Medium | Matches the physical diode stack, but overlapping rectangular lands make endpoint identity ambiguous. |
| Upper pads near wide copper pours | `CR105`/`CR106`, `C105`/`C106`, and bulk capacitor rail nodes | Medium | Grouping matches the component-side positions. Exact diode endpoint mapping is still unresolved. |
| Wide lower/right copper pours | rectified/raw rail area | Medium | Likely high-energy raw DC or return rail nodes, but naming requires diode direction plus capacitor polarity continuity. |

## What Can Be Added To The Schematic

No new component-level rectifier wiring should be added yet. The photo pass justifies keeping the KiCad block as:

- `J1` five transformer leads: `J1_YEL_1`, `J1_YEL_2`, `J1_GRY_3`, `J1_BRN_4`, `J1_BRN_5`.
- unresolved rectifier groups: `CR101`-`CR104` and `CR105`/`CR106`.

## Current Blocker

The exact endpoint mapping from `J1` pins to `CR101`-`CR106` cannot be proven from the available photos. The limiting factors are:

- The solder-side photo is angled and not perspective-corrected.
- The likely `J1` pads and diode/capacitor pads are close together and similarly shaped.
- Some wide copper pours disappear under solder mask and glare.
- The diode bodies hide their component-side lead landings enough that front/back matching is not deterministic.

## Smallest Unpowered Checks To Break The Blocker

If avoiding a broad manual continuity pass, do only these checks:

- `J1` pin 1 to both ends of `CR105` and `CR106`.
- `J1` pin 2 to both ends of `CR105` and `CR106`.
- `J1` pin 3 to both ends of `CR101`-`CR106`.
- `J1` pin 4 to both ends of `CR101`-`CR104`.
- `J1` pin 5 to both ends of `CR101`-`CR104`.

That should reveal whether the yellow pair feeds the two-diode group, whether the brown pair feeds the four-diode group, and whether the grey lead is a center tap/reference or part of a separate winding.
