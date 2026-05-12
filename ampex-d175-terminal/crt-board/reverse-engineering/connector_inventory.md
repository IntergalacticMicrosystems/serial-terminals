# Connector Inventory

Status: first photo-only pass. Pin numbering is provisional unless the board silkscreen explicitly shows it.

| Refdes | Visible Label / Function | Pins | Observed Wiring / Marking | Confidence | Notes |
|---|---|---:|---|---:|---|
| `J1` | `AC IN` | 5 | White board connector at lower left | high | User confirmed all wires come from the main transformer. Pin 5 is closest to the bottom PCB edge. Pins 1-2 yellow, pin 3 grey, pins 4-5 brown. Trace pass 11 records diode endpoint mapping. |
| `J2` | `GROUND` | likely 1 or 2 | White connector/tab near left-center, silkscreen says `GROUND` | high | User confirmed this plug connects to earth ground and the metal ring around the CRT tube. Treat as `EARTH_CRT_AQUADAG` until board common tie is traced. |
| `J4` | Deflection yoke | 4 | Pin 1 toward top of PCB: 1 blue, 2 white, 3 red, 4 black | high | User measured red-blue = 3.2 ohms and black-white = 0 ohms. Black/white is assigned horizontal as the lower-resistance pair; red/blue is assigned vertical. Polarity/phase is not assigned. |
| `J5` | unknown option/header | 2? | Unpopulated footprint near `CR104` and rectifier area | low | May be option jumper/test point. Do not assign function yet. |
| CPU board harness | CPU board | 10 | Top-left wire bundle marked 1-10 on front photo | medium | Carries signals/power between main logic and CRT board. Related manual suggests this class of board needs +12 V, horizontal sync, vertical sync, video, and returns, but D-175 pinout remains pending. |
| CRT neck connector | CRT socket | 7 | Pins: 1 green/E1, 2 yellow/E2, 3 brown/E3, 4 black/J2-aquadag, 5 NC, 6 red/E6, 7 blue/E7. Loose black clip is continuous to J2. | high for wiring, medium for electrode function | E2 is confirmed to the non-J2 side of NS401/R405 and is the local video/cathode-side node; other E* electrode names still need CRT type/pinout or local tracing. |

## Connector-First Trace Order

1. `J2` ground.
2. `J1` AC input and rectifier.
3. `J4` yoke connector.
4. CPU board harness.
5. CRT neck socket.

## Open Questions

- What are the voltages/functions of the yellow/yellow, grey, and brown/brown transformer leads?
- Where, if anywhere, does `J2` earth/aquadag ground tie to PCB signal/common ground?
- What are the CRT socket electrode functions for pads `E1`, `E3`, `E6`, and `E7`? `E2` is now confirmed as the local video/cathode-side node.
- What is the CRT tube type and socket pinout?

## Pad Map Status

`pad_map.csv` has rows for `J1`, `J2`, and `J4`. `J2` is user-confirmed as earth/aquadag. `J1` is user-confirmed as a 5-pin main-transformer harness; trace pass 11 records confirmed diode-node mapping.
