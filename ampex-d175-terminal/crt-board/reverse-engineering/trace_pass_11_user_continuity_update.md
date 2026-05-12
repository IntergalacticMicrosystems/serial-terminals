# Trace Pass 11: User Continuity Update

Status: unpowered continuity results incorporated into the photo trace.

## CRT Video Node

User continuity confirms:

- `E2` goes to the non-J2 side of `NS401`.
- `E2` goes to the non-J2 side of `R405`.

This resolves the photo-only blocker from trace pass 09. Use `N017` as the master net for the confirmed `E2` / video active node. Earlier local net `N022` is now a superseded alias of `N017`.

Interpretation:

- `E2` is confirmed as the local `Q401` video/cathode-side node.
- The related Ampex 219/230 schematic calls this node the CRT cathode/video-drive node; the D-175 board uses `R405`/`NS401` in the confirmed path, so keep D-175 component references authoritative.

## J1 To Rectifier Endpoints

User continuity, with `J1` numbered from top to bottom and pin 5 closest to the lower PCB edge:

| J1 pin | Wire color | Confirmed connected diode endpoint(s) |
|---:|---|---|
| 1 | yellow | `CR106` anode |
| 2 | yellow | `CR105` anode |
| 3 | grey | `CR101` anode + `CR102` anode |
| 4 | brown | `CR102` cathode + `CR103` anode |
| 5 | brown | `CR104` anode + `CR101` cathode |

This resolves the J1-to-diode endpoint blocker from trace pass 10 for the listed diode ends.

## Still Unnamed

Do not name the resulting rectifier output rails yet. The following endpoints still need output-side tracing before assigning functional rail names:

- `CR105` cathode.
- `CR106` cathode.
- `CR103` cathode.
- `CR104` cathode.
- Nearby bulk capacitor polarity nodes, especially around `C107` and the large electrolytics.

Once those are mapped, the lower rectifier group can be drawn as a real component-level schematic fragment instead of a block.
