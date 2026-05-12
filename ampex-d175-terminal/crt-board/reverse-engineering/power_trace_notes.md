# Power Trace Notes

Status: first photo-only pass. Treat these as working notes, not a finished schematic.

## Source Crops

Generated helper crops:

- `overlays/crop_front_power_left.png`
- `overlays/crop_back_power_left.png`
- `overlays/crop_back_mirrored_power_left.png`
- `overlays/crop_front_regulators_vertical.png`

## Visible Power-Area Topology

### AC Input / Rectifier

- `J1` is the lower-left connector marked `AC IN`.
- User confirmed `J1` is a 5-pin connector, not 4-pin.
- User confirmed all `J1` wires come from the main transformer.
- User confirmed the pin closest to the bottom PCB edge is pin 5.
- User confirmed wire colors:
  - pins 1 and 2: yellow
  - pin 3: grey
  - pins 4 and 5: brown
- `CR101`, `CR102`, `CR103`, and `CR104` sit immediately next to `J1` and are laid out like a discrete rectifier group. Trace pass 10 confirms mixed diode orientation: `CR101`/`CR102` cathodes face left, while `CR103`/`CR104` cathodes face right.
- `CR105` and `CR106` sit above `J1`, forming a second rectifier group near `C105` and `C106`.
- User continuity confirms `J1` endpoint mapping: pin 1 to `CR106` anode, pin 2 to `CR105` anode, pin 3 to `CR101`/`CR102` anodes, pin 4 to `CR102` cathode plus `CR103` anode, and pin 5 to `CR104` anode plus `CR101` cathode.
- `C101`, `C102`, `C103`, and `C104` are printed next to the rectifier-diode positions; the exact component population and role need close-up confirmation.
- The solder side shows broad copper regions in this area, consistent with rectified power rails rather than logic-level signal routing.

Working interpretation:

- `J1` is a transformer-secondary harness, not mains input.
- The yellow pair on pins 1-2 likely forms one AC secondary.
- The brown pair on pins 4-5 likely forms another AC secondary.
- The grey lead on pin 3 may be a center tap, shield/reference, or separate secondary lead; do not assign function until traced.
- `CR101`-`CR104` probably form a primary rectifier network for a high-energy raw DC rail, but the mixed diode orientation means this should not be called a simple bridge until endpoint nets are assigned.
- Do not call this rail `+12V_RAW` or `+5V_RAW` yet. The nearby large electrolytics and CRT monitor topology make `B+_RAW` / `RAW_HV_DC` more likely for at least part of this section.

The earlier four-conductor J1 interpretation is superseded. Exact J1-to-diode input endpoint mapping is now confirmed; output-side rail naming remains pending.

### Large Electrolytics

- Multiple large electrolytics are visible in the lower-left and center-left power area.
- At least one can appears to be marked in the hundreds-of-volts range; exact value/voltage is not reliable from the current crop.
- Polarity arrows and plus marks are visible in several places, but the exact negative/positive pad association should be confirmed on the mirrored solder image before net naming.

Working interpretation:

- One or more large capacitors are likely reservoir caps for rectified B+ or an intermediate supply.
- The low-voltage regulators probably derive from a lower-voltage secondary or downstream supply, not necessarily directly from this high-voltage raw rail.

### `U101 LM323K`

- `U101` is visible on the right-side heatsink area and is identified as `LM323K`.
- The LM323K is a fixed +5 V, 3 A TO-3 regulator.
- User confirmed the two U101 mounting screws are soldered on the back side and are the traces it is connected to.
- User confirmed the four heatsink mounting screws are electrically connected.
- LM323K TO-3 pinout references identify the metal case as regulated +5 V output.

Next trace objective:

- Treat the U101 case/screw/heatsink trace network as `+5V`, while still tracing the two isolated pins to identify input and common.

### `U102 MC7812CT`

- `U102` is identified as `MC7812CT`.
- Standard TO-220 positive regulator pinout is input, ground, output when viewed from the front, with the tab/heatsink connected to ground for common MC78xx packages.
- User confirmed board orientation: pin 1 is toward the top of the PCB, and pin 3 is closest to the PCB edge.

Next trace objective:

- Use pin 1 as input, pin 2 as ground/common, and pin 3 as regulated `+12V`.
- Trace whether pin 2/common is tied to PCB common only, earth/aquadag `J2`, or both.

## Confirmed External Pinout References

- `MC7812CT`: fixed +12 V positive regulator; pin 1 input, pin 2 ground, pin 3 output, tab connected to pin 2 according to common MC78xx TO-220 references.
- `BU407`: NPN high-voltage power transistor for horizontal deflection; one datasheet source gives TO-220 top-view pins as B-C-E, with pin 2 connected to the mounting base/tab.
- `LM323K`: fixed +5 V, 3 A TO-3 regulator; exact pin/case mapping still needs a package-specific datasheet view before assigning board pads.

## Immediate Ambiguities

- Whether `J1` is mains AC or a transformer secondary feed is not yet proven from photos alone.
- The full rectifier node assignment cannot be completed from the current overview crop without either a sharper underside crop or manual continuity.
- The large capacitor values/voltages are partly obscured and should be transcribed from close-ups.
- `U101` case/heatsink is now treated as confirmed `+5V` from user-provided mounting-screw continuity plus the LM323K case/output convention; its two isolated pins still need input/common assignment on the board.

## Minimal Continuity Checks To Avoid Over-Tracing

If manual testing is allowed later, these four unpowered checks would resolve the power block quickly:

1. Rectifier output nodes from `CR105`/`CR106`/`CR103`/`CR104` cathodes to nearby capacitor polarity pads.
2. Negative terminals of the large electrolytics to the labeled ground connector `J2`.
3. `U101` case to board ground or output/common pads.
4. `U102` tab/pin 2 to board ground.
