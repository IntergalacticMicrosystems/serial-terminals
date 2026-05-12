# Trace Pass 08: Q401 Video Local Graph

Status: first local copper-island graph from board-rectified photos.

Update: trace pass 09 follows local island `QA` / `N021` through the `J2` bridge area and supersedes it with master net `N013` (`EARTH_CRT_AQUADAG`). The rest of this file is retained as the original local graph.

## Source Images

- `overlays/rectified_front_q401_cluster.png`
- `overlays/rectified_back_q401_cluster.png`
- `overlays/rectified_blend_q401_cluster.png`
- `overlays/rectified_q401_cluster_montage.jpg`
- `overlays/rectified_back_crt_q401_zoom_enhanced.png`

## Components In The Crop

Visible front-side references:

- `J2` ground/aquadag connector area.
- `A7` / `A8` ground-side wire landings.
- `Q401` area and nearby `C502`.
- `R401`, `R402`, `R404`, `R406`.
- `C401`.
- `R405`.
- `NS401`.
- Lower rectifier/protection diode at the edge of the crop.

The physical part body alignment still has parallax error, but the through-hole pads line up well enough to separate the solder-side islands.

## Local Islands

| Local island | Net register | Confidence | Observed in rectified back image |
|---|---|---:|---|
| `QA` | `N021` / `CRT_VIDEO_J2_SIDE_BUS` | medium | Wide left-side copper island around the `J2`/`A7`/`A8` area and the left pad column of the `R401`-`R406`/`C401`/`R405` cluster. Candidate `EARTH_CRT_AQUADAG` extension. |
| `QB` | `N022` / `Q401_ACTIVE_COLUMN_A` | medium | Central/right pad column for the same resistor/capacitor stack. This island is visually separated from the wide J2-side bus by solder-mask gaps. |
| `QC` | `N023` / `Q401_UPPER_RAIL_OR_COUPLING_NODE` | low-medium | Upper wide trace near `C502`, `Q401`, and the top of the video cluster. It appears separate from `QA` and `QB`, but component-body occlusion makes the exact front-side pin assignment uncertain. |

## Interpretation

This confirms the lower video cluster is not random point-to-point wiring; it has a clear repeated structure:

- one side of several parts in the `R401`/`R402`/`R404`/`R406`/`C401`/`R405` stack references the wide left-side island,
- the opposite side lands on one or more separate active islands,
- the active islands then route toward the `Q401`/`C502` area and the CRT electrode pad strip.

The wide left-side island likely ties into the known `J2` earth/aquadag node, but it is kept as `N021` instead of directly merged with `N013` until the exact copper path from `J2` through the left column is verified. This avoids accidentally treating a nearby isolated video-ground island as chassis/aquadag ground.

## What This Lets Us Draw Next

Safe for a schematic draft:

- Draw the `Q401` video-output cluster as a component group with temporary net labels `N021`, `N022`, and `N023`.
- Annotate `N021` as candidate `EARTH_CRT_AQUADAG`/CRT reference.
- Keep `E2` as likely cathode/video output, but do not connect it to `N022` until the path from `E2` to `R402`/`NS401` is visually followed in the next crop.

Not safe yet:

- Assigning `Q401` collector/base/emitter from photo alone.
- Declaring `N021 == N013` without one final copper-path check.
- Renaming `N022` as `CRT_K` or `VIDEO_OUT`.

## Next Crop

The next crop should bridge the electrode pad strip to the `Q401` cluster:

- board coordinates approximately `x=0..520`, `y=1180..1900`,
- include `E2`, `E3`, `R512`, `R509`, `R507`, `C502`, `Q401`, and the top of `R401`/`R402`.

Goal: prove or reject whether `E2` shares a continuous island with the video-output side of `R402`/`NS401`.
