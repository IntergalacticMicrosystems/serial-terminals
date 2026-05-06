# Trace Pass 07: CRT Neck / Video Cluster

Status: first component-level trace using board-rectified images.

## Source Images

- `overlays/rectified_front_crt_video_tall.png`
- `overlays/rectified_back_crt_video_tall.png`
- `overlays/rectified_blend_crt_video_tall.png`
- `overlays/rectified_crt_video_tall_montage.jpg`
- `overlays/rectified_crt_e_pads_zoom_montage.jpg`
- `overlays/rectified_crt_q401_zoom_montage.jpg`

## What The Rectified Overlay Confirms

The CRT neck wire landings can now be placed in board coordinates and matched to solder-side pads:

| Board pad | Socket wire | Net | Approx board coordinate | Trace status |
|---|---|---|---|---|
| `E1` | green | `CRT_E1_GREEN` | `205,1135` | confirmed landing; electrode function pending |
| `E2` | yellow | `CRT_E2_YELLOW` | `105,1260` | confirmed landing; likely video/cathode path, still pending local confirmation |
| `E3` | brown | `CRT_E3_BROWN` | `245,1395` | confirmed landing; do not merge with aquadag yet |
| `E6` | red | `CRT_E6_RED` | `235,1020` | confirmed landing; electrode function pending |
| `E7` | blue | `CRT_E7_BLUE` | `270,910` | confirmed landing; likely focus-style path, still pending local confirmation |

The blue `E7` lead sits directly beside `R510` in the rectified overlay. The red `E6`, green `E1`, yellow `E2`, and brown `E3` leads form a vertical electrode pad strip beside `R509`, `R507`, `R512`, `C507`/`C508`, and the `NS501` area.

The lower video-output cluster is also aligned well enough for tracing:

- `Q401`
- `C502`
- `R401`
- `R402`
- `R404`
- `R406`
- `C401`
- `R405`
- `NS401`
- adjacent rectifier/protection diode below the cluster

## Manual Cross-Check

The related Ampex 219/230 video-board schematic is still not a direct copy, but its topology matches the D-175 placement:

- `E2` is the likely cathode/video-drive node because the related schematic routes `E2` through the video output transistor/protection network.
- `E7` is likely a focus electrode because the related schematic routes `E7` through the focus network.
- `E1` and `E6` are likely brightness/grid/accelerator style electrodes, but the exact electrode names are still not safe without the CRT tube pinout or a local trace through the 500-series network.

## Local Trace Progress

The rectified back image shows the following useful copper-island structure:

- The electrode pad strip is not a single common node; the `E*` wires land on separate nearby solder islands.
- The lower `Q401`/`R401`-`R406` cluster uses two close vertical pad columns and can be traced as a local video amplifier/protection network.
- `J2`/aquadag remains visually near the CRT/video area, but `E3` should not be merged with `EARTH_CRT_AQUADAG` unless the solder-side copper path is followed through or continuity confirms it.

## What Is Safe To Put In The Schematic Now

Safe:

- Add a numbered CRT socket block with `E1`, `E2`, `E3`, `E6`, `E7`, pin 4 to `EARTH_CRT_AQUADAG`, and pin 5 NC.
- Add a local CRT/video block containing `Q401`, `R401`, `R402`, `R404`, `R405`, `R406`, `C401`, `C502`, `NS401`, and the `E2` note as likely cathode/video.
- Add a 500-series brightness/focus electrode block containing `R507`-`R512`, `C505`-`C508`, `NS501`, `VR501`, `VR502`, and `CR503`.

Not safe yet:

- Renaming `E2` to `CRT_K`/cathode.
- Renaming `E7` to focus.
- Merging `E3` with `J2`/aquadag.
- Assigning CRT grid/accelerator names to `E1` and `E6`.

## Next Extraction Step

Trace the `Q401` cluster as a small graph from the rectified back image:

1. Mark left and right pads of `R401`, `R402`, `R404`, `R406`, `C401`, and `R405`.
2. Mark the visible `Q401` pins and `C502` polarity pads.
3. Follow only local copper islands and assign temporary net names.
4. Confirm whether `E2` lands on the same island as `R402`/`NS401`/the video output node.

This should produce the first real component-level schematic fragment without needing more photos.
