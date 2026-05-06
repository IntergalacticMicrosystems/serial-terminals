# Trace Pass 02: Connectors And Regulator Pad Seeds

Status: photo-derived seed pass. This file records what can be named from the current photos before full front/back alignment.

## New Crops

- `overlays/crop_front_j1_j2_power.png`
- `overlays/crop_back_j1_j2_power.png`
- `overlays/crop_front_u102.png`
- `overlays/crop_back_u102_area.png`
- `overlays/crop_front_u102_wide.png`
- `overlays/crop_back_u101_u102_wide.png`
- `overlays/crop_back_mirrored_u101_u102_wide.png`

## J1 AC Input

The component side clearly shows `J1` next to the text `AC IN`.

Visible facts:

- User confirmed five connector positions.
- All J1 wires come from the main transformer.
- Pin 5 is closest to the bottom edge of the PCB.
- Pin colors:
  - pin 1: yellow
  - pin 2: yellow
  - pin 3: grey
  - pin 4: brown
  - pin 5: brown
- `CR101`-`CR104` are directly adjacent and arranged like a discrete bridge rectifier.
- `CR105` and `CR106` are above the connector and appear to form a second rectifier group.
- The front photo supports treating the connector pin order as top-to-bottom for documentation, but it does not prove electrical pin numbering.

Working pad IDs:

- `P0001` = `J1` position 1, yellow wire.
- `P0002` = `J1` position 2.
- `P0003` = `J1` position 3.
- `P0004` = `J1` position 4.
- `P0016` = `J1` position 5, brown wire, closest to bottom PCB edge.

Updated topology call:

- `J1` is a five-conductor transformer harness, not mains input.
- Pins 1-2 yellow are likely one secondary pair.
- Pins 4-5 brown are likely another secondary pair.
- Pin 3 grey is unresolved.

The corrected solder-side search exposes a likely five-pad `J1` row, but exact J1-to-diode endpoint mapping remains pending. See `trace_pass_03_j1_photo_alignment.md`.

## J2 Ground

The component-side overview labels `J2` as `GROUND`.

Working pad ID:

- `P0005` = `J2` earth/aquadag ground contact or contacts, confirmed `N013`.

User confirmation:

- The J2 plug connects to earth ground and the metal ring around the CRT tube.

Open issue:

- The tie point, if any, between `J2` earth/aquadag and PCB signal/common ground still needs tracing.

## J4 Deflection Yoke

The component-side photo shows `J4` beside the deflection yoke connector.

Working pad IDs:

- `P0006`-`P0009` = `J4` positions 1-4, provisional top-to-bottom order.

Cross-photo note:

- `CRT-deflection-conn.jpg` shows harness wire order from one view as black, red, white, blue.
- Board-side orientation is still unresolved, so no `H_YOKE_*` or `V_YOKE_*` assignment is made yet.

## U101 LM323K

`U101` is confirmed as `LM323K`, a TO-3 +5 V regulator.

Working pad IDs:

- `P0010` = input pin, physical pin still orientation-dependent.
- `P0011` = ground/common pin, physical pin still orientation-dependent.
- `P0012` = case/heatsink/mechanical connection, now treated as `+5V`.

User confirmation:

- The two screws that attach U101 are soldered on the back side and are the traces it connects to.
- The four screws that attach the heatsink are electrically connected.
- With the LM323K TO-3 case/output pinout, this makes the U101 screw/heatsink network the `+5V` output net.

Open issue:

- The two isolated TO-3 pins still need orientation-resolved mapping to input and common.

## U102 MC7812CT

`U102` is confirmed as `MC7812CT`, but its body/pins are partly hidden by the heatsink in the current front photo.

Working pad IDs:

- `P0013` = pin 1 input.
- `P0014` = pin 2 ground/common.
- `P0015` = pin 3 +12 V output.

User confirmation:

- Pin 1 is toward the top of the PCB.
- Pin 3 is closest to the PCB edge.
- `MC7812CT` pinout is pin 1 input, pin 2 ground, pin 3 output.

## What Is Blocked By Photos

The current image set is good for component identification and broad block tracing, but not enough for exact pad-level work in these areas:

- `J1` pin mapping to `CR101`-`CR106` endpoints.
- `J2` tie point, if any, to PCB common ground.
- `U101` two isolated TO-3 pins around the large heatsink.

Recommended non-invasive next action:

- Add straight-on close-ups of the solder side under `J1`, `J2`, and `U101`.

Recommended minimal continuity checks if close-ups are not practical:

- `J2` to `U102` tab/pin 2.
- `J2` to large electrolytic negative terminals.
- `U101` case to `J2`.
- `J1` pins to `CR101`-`CR104` diode ends.
