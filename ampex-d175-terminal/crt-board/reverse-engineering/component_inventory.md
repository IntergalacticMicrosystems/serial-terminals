# Component Inventory

This table starts from `../components.txt` and visible photo markings. Values and roles are provisional until confirmed by datasheets, photo close-ups, or continuity.

| Refdes | Marking / Value | Package / Form | Probable Role | Confidence | Notes |
|---|---|---|---|---:|---|
| `U101` | `LM323K` | TO-3 regulator | 5 V regulator | high | LM323K is a 5 V fixed regulator. Confirm pin mapping from underside pads and case connection. |
| `U102` | `MC7812CT` | TO-220 regulator | 12 V regulator | high | Likely local 12 V rail regulator. Confirm input/output pins from package orientation. |
| `U301` | probably `PC1031H2` / `uPC1031H2` | SIP, likely 10 pin | Vertical deflection IC | medium-high | Needs marking close-up. Related Ampex 219/230 video-board schematic uses `uPC1031H2` in the vertical section, supporting the role but not proving the exact D-175 pinout. |
| `Q201` | `MJ9434` / possibly `MPS9434` | transistor | Horizontal drive area | medium | Located near flyback/deflection power section. Related Ampex 219/230 schematic uses `MPS9434` as the horizontal drive transistor; D-175 marking should be rechecked. |
| `Q202` | `BU407` | power transistor | Horizontal output transistor | high | BU407 class part is consistent with CRT horizontal output use. Confirm C/B/E orientation from footprint and heatsink mounting. |
| `Q401` | `2N2896` | transistor | Video/blanking/CRT drive area | medium-high | User continuity confirms `E2` goes to the non-J2 side of `NS401` and `R405`, making this the confirmed local video/cathode-side cluster. |
| `T202` | `HSIN LING 3512880-01` | transformer/flyback-related | Horizontal / high-voltage transformer | medium | Need winding pin groups and board pin map. |
| `NS401` | neon bulb | lamp | HV/protection/indicator | medium-high | User continuity confirms non-J2 side ties to `E2`; opposite side is in the J2/reference-side cluster. |
| `NS501` | neon bulb | lamp | HV/protection/indicator | medium | In `500` section, likely focus/brightness/protection related. |
| `VR501` | Focus | trimmer/pot | Focus adjustment | high | Front silkscreen. |
| `VR502` | BRT | trimmer/pot | Brightness adjustment | high | Front silkscreen. |
| `VR301` | V. SIZE | trimmer/pot | Vertical size | high | Front silkscreen. |
| `VR302` | V. LIN | trimmer/pot | Vertical linearity | high | Front silkscreen. |
| `VR320` | HOLD | trimmer/pot | Sync/hold adjustment | medium | Refdes suffix partly uncertain from photo. |
| `J4` | Deflection yoke | connector | Yoke harness | high | Adjacent to yoke label. Match to `CRT-deflection-conn.jpg`. |
| `CR101`-`CR104` | diode markings visible, likely rectifiers | axial diodes | Transformer-secondary rectifier group | medium-high | `CR101`/`CR102` cathode bands face left; `CR103`/`CR104` cathode bands face right. Confirm endpoint nets before naming the topology. |
| `CR105`-`CR106` | diode markings visible | axial diodes | Second transformer-secondary rectifier/protection group | medium-high | Both cathode bands face right. Above `J1` near `C105`/`C106`; exact role still depends on endpoint tracing. |
| `FB201`-`FB204` | ferrite bead / link symbols | axial beads or fusible links | Horizontal/high-voltage filtering or protection | medium | Located near `Q202`/horizontal section. |
| `C101`-`C108` | electrolytic/film/ceramic mix | capacitors | Input and regulator filtering | medium | `C101`-`C103` appear near AC rectifier; large electrolytics are rail filters. |
| `C201`-`C206` | electrolytic/film mix | capacitors | Horizontal/flyback support | medium | Around `T202`, `Q201`, `Q202`, and `CR202`. |
| `C301`-`C311` | electrolytic/ceramic mix | capacitors | Vertical deflection timing/output | medium | Around `U301`, `VR301`, `VR302`. |
| `C401` | capacitor | capacitor | CRT/video section | low | Near `Q401`, `NS401`. |
| `C501`-`C509` | high-voltage/film/ceramic mix | capacitors | Focus/brightness/CRT support | medium | Around `VR501`, `VR502`, CRT wiring, neon bulbs. |

## Numbering Inference

The reference designator hundreds digit appears to correspond to circuit blocks:

- `100`: AC input / regulator / low-voltage supply.
- `200`: horizontal output / flyback / high-voltage power.
- `300`: vertical deflection and geometry.
- `400`: CRT neck / video / blanking.
- `500`: focus / brightness / CRT support controls.

This is an inference from placement and labels; use it only as a tracing aid.

## Immediate Pinout References Needed

- `LM323K` TO-3 pinout and case connection.
- `MC7812CT` TO-220 pinout.
- `BU407` package pinout.
- `MJ9434` package pinout.
- `2N2896` package pinout.
- `uPC1031H2` SIP pinout after exact marking is confirmed.

## Related Manual Support

The local Ampex 219/230 service manual includes a related `3515240` video-board schematic using `uPC1031H2`, `MPS9434`, a horizontal output transistor, focus/brightness controls, and CRT socket `E*` labels. See `service_manual_cross_reference.md`; use it as comparison evidence only because the D-175 wire colors and board assembly differ.
