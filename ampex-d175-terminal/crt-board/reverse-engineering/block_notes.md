# Block Notes

## Power Input And Rectification

Likely located around `J1`, `CR101` through `CR104`, large electrolytics, fuses or fusible resistors, and `U101` / `U102`.

First tracing target:

- AC input connector pins.
- Bridge rectifier topology.
- Bulk capacitor positive/negative nodes.
- `LM323K` input/output/common.
- `MC7812CT` input/output/common.

First photo pass:

- `J1` is visibly marked `AC IN`.
- `CR101`-`CR104` are arranged next to `J1` in a bridge-rectifier-like cluster.
- The nearby large electrolytics and broad copper make this a high-energy raw rail area. It should be treated as `B+_RAW_OR_RAW_HV_DC` until the AC source and capacitor voltage ratings are confirmed.
- `J2` is explicitly marked `GROUND` on the component side and should be used as the starting landmark for the board return net.

See `power_trace_notes.md`.

## Horizontal / High Voltage

Likely located around `Q202 BU407`, `Q201 MJ9434`, `T202`, `CR202`, `FB201` through `FB204`, and the flyback/heatsink area.

High-risk ambiguities:

- Transformer winding groups are difficult to infer from photos alone.
- High-voltage output lead and focus/screen divider paths may not be fully visible.
- TO-3/TO-220 case connections must be confirmed from package and mounting hardware.

## Vertical Deflection

Likely centered on `U301`, the `VR301 V. SIZE` and `VR302 V. LIN` controls, and nearby capacitors/resistors.

`U301` is probably `uPC1031H2`, which external part references identify as a vertical deflection device. Treat this as provisional until a photo close-up and pinout check confirm the exact part.

## CRT Neck / Video / Brightness

Likely centered on `Q401 2N2896`, `VR501 FOCUS`, `VR502 BRT`, `NS401`, `NS501`, CRT socket wiring, and `400` / `500` component clusters.

Do not assign CRT electrode names from wire color alone. Use CRT socket pin numbers and continuity to the board connector/pads.

## Deflection Yoke

The yoke harness has visible black, red, white, and blue conductors. `CRT-deflection-conn.jpg` shows connector order from one view as black, red, white, blue. Pin numbering depends on connector orientation at `J4`.

Likely next verification:

- Determine coil pairs by visual solder tabs or unpowered resistance.
- Map the 4-pin harness to `J4`.
