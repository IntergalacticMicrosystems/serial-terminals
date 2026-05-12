# Photo Inventory

| File | Size | Role | Use Notes |
|---|---:|---|---|
| `../Front.jpg` | 3024 x 4032 | Component-side overview | Best source for reference designators, trimmer names, connector labels, polarity marks, and block placement. Not ideal for hidden pins under large parts and heatsinks. |
| `../Back.jpg` | 5712 x 4284 source, 4284 x 5712 after EXIF auto-orient | Solder/copper-side overview | Primary source for net tracing. Auto-orient, then mirror before overlaying with `Front.jpg`. Trace contrast is good, but glare, scratches, solder blobs, and edge distortion need manual review. |
| `../CRT-deflection.jpg` | 1440 x 1080 | Yoke label and coil structure | Confirms yoke assembly label appears to include `3512679-01`, `584143`, and `TYPE90912`; some text remains uncertain. |
| `../CRT-deflection2.jpg` | 1440 x 1080 | Yoke solder tabs and harness | Shows red, blue, white, and black wires soldered to yoke tabs. Useful for mapping the two deflection coil pairs. |
| `../CRT-deflection-conn.jpg` | 1440 x 1080 | Yoke harness connector | Shows 4-pin connector wire order: black, red, white, blue, viewed from the wire-entry side in the photo. Confirm orientation against PCB `J4` footprint before assigning pin numbers. |
| `../CRT-Neck-connector.jpg` | 1440 x 1080 | CRT neck socket | Shows CRT socket face with molded pin numbers and wire colors. Needs a back-side or pin-side continuity map to assign CRT electrode functions confidently. |

## Additional Photos Wanted

These would reduce manual continuity checks:

- Straight-on, full-board component-side image with less perspective distortion.
- Straight-on, full-board solder-side image with board edges fully visible.
- Close-up of `U301` marking and pins.
- Close-up of `U101`, `U102`, `Q201`, `Q202`, `Q401`, and any TO-220/TO-3 pin wiring.
- Close-up of `T202` pins and any silkscreen near the transformer/flyback area.
- Close-up of all board connectors with visible designators and pin numbers.
- Close-up of the CRT neck socket from the wire side if accessible.

## Alignment Notes

- Use the four mounting holes and long vertical slots as alignment landmarks.
- Auto-orient `Back.jpg`, then mirror it horizontally before aligning to `Front.jpg`.
- Use `overlays/back_auto_mirrored.png` as the canonical component-side-facing solder image. Older crops from `overlays/back_mirrored.png` are superseded because they were made before the EXIF-orientation issue was caught.
- Treat edge regions near cable exits and the large right-side heatsink/flyback area as lower confidence until verified against close-ups.

## Generated Working Images

| File | Purpose |
|---|---|
| `overlays/front_auto.png` | Canonical auto-oriented component-side reference photo. |
| `overlays/back_auto.png` | Canonical auto-oriented solder-side photo before mirroring. |
| `overlays/back_auto_mirrored.png` | Canonical mirrored solder-side image for component-side overlay tracing. |
| `overlays/front_reference.png` | Auto-oriented copy of the component-side reference photo. |
| `overlays/back_mirrored.png` | Legacy mirrored solder-side filename retained for existing notes; prefer `back_auto_mirrored.png`. |
| `overlays/photo_contact_sheet.jpg` | Quick visual index of the current source photos. |
| `overlays/crop_front_j1_j2_power.png` | Component-side `J1` / rectifier crop. |
| `overlays/crop_back_j1_j2_power.png` | Attempted solder-side crop for `J1` / `J2`; not sufficient for pad assignment. |
| `overlays/crop_front_u102_wide.png` | Component-side crop of `U102` area; heatsink blocks most of the regulator body. |
| `overlays/crop_back_u101_u102_wide.png` | Solder-side crop around regulator/heatsink area. |
| `overlays/crop_back_mirrored_u101_u102_wide.png` | Mirrored solder-side crop around regulator/heatsink area. |
| `overlays/crop_front_auto_j1_corrected.png` | Corrected component-side crop of `J1`, `CR101`-`CR106`, and nearby capacitors. |
| `overlays/crop_back_auto_mirrored_j1_pads_zoom1.png` | Corrected mirrored solder-side close-up of likely `J1`/rectifier pad cluster. |
| `overlays/crop_back_auto_mirrored_j1_pads_zoom2.png` | Wider corrected mirrored solder-side view of `J1`/rectifier pad cluster. |
| `overlays/crop_back_auto_mirrored_rectifier_zoom.png` | Corrected mirrored solder-side crop emphasizing diode/capacitor endpoint candidates. |
| `overlays/j1_front_back_corrected_montage.jpg` | Side-by-side component/solder reference for the corrected `J1` search. |
| `overlays/yoke_neck_photo_montage.jpg` | Side-by-side reference for the deflection yoke, yoke plug, and CRT neck socket photos. |
| `overlays/crop_front_auto_crt_neck_left.png` | Component-side crop of D-175 CRT neck wire landings and nearby video/focus parts. |
| `overlays/crop_front_auto_cpu_harness.png` | Component-side crop of the top-left CPU-board harness and visible pin numbers. |
| `overlays/crop_back_auto_mirrored_cpu_harness_wide.png` | Corrected mirrored solder-side crop of the CPU-board harness pad fan-out. |
| `overlays/front_board_rectified.png` | Component-side photo perspective-corrected into canonical board coordinates. |
| `overlays/back_board_rectified.png` | Mirrored solder-side photo perspective-corrected into the same board coordinates. |
| `overlays/front_back_rectified_blend.png` | Blend of rectified front/back images for matching pads to components. |
| `overlays/rectified_full_front_back_montage.jpg` | Side-by-side front/back board-rectified comparison. |
| `overlays/rectified_j1_power_montage.jpg` | Board-rectified J1/rectifier front/back/blend montage. |
| `overlays/rectified_j1_rectifier_local_montage.jpg` | Enlarged board-rectified `J1` / `CR101`-`CR106` local montage. |
| `overlays/rectified_front_cr105_cr106_band_zoom.png` | Front-side diode-band zoom for `CR105`/`CR106`. |
| `overlays/rectified_front_cr101_cr104_band_zoom.png` | Front-side diode-band zoom for `CR101`-`CR104`. |
| `overlays/back_auto_mirrored_j1_rectifier_hi_res_candidate.png` | High-resolution mirrored solder-side source crop for the `J1`/rectifier area. |
| `overlays/rectified_crt_video_tall_montage.jpg` | Board-rectified CRT neck/video front/back/blend montage. |
| `overlays/rectified_crt_e_pads_zoom_montage.jpg` | Zoomed board-rectified electrode pad strip. |
| `overlays/rectified_crt_q401_zoom_montage.jpg` | Zoomed board-rectified `Q401`/video-output cluster. |
| `overlays/rectified_q401_cluster_montage.jpg` | Board-rectified `Q401` local front/back/blend montage for pad-island tracing. |
| `overlays/rectified_e2_to_q401_bridge_montage.jpg` | Board-rectified bridge from `E2`/`E3` down through `J2` and the `Q401` video/reference cluster. |
| `overlays/rectified_back_e2_to_q401_bridge_analysis.jpg` | Raw/enhanced/edge solder-side bridge montage for copper-border tracing. |
| `overlays/rectified_back_e2_e3_local_2x.png` | Local solder-side zoom of the `E2`/`E3` branch area. |
| `overlays/rectified_blend_e2_e3_local_2x.png` | Enhanced blend zoom of the `E2`/`E3` branch area. |
| `overlays/rectified_back_j2_to_q401_left_bus_2x.png` | Solder-side zoom following the broad `J2`-side bus into the `Q401` reference side. |
| `overlays/front_auto_e2_e3_hi_res_candidate.png` | High-resolution source crop of the front-side `E2`/`E3` wire landings. |
| `overlays/back_auto_mirrored_e2_q401_hi_res_candidate.png` | High-resolution mirrored solder-side crop covering the `E2`/`E3`/`J2`/`Q401` bridge. |
| `overlays/manual_pages/service_manual_page_76.png` | Render of related Ampex 219/230 `PWBA - VIDEO BOARD` schematic page from the local service manual. |
| `overlays/manual_pages/service_manual_page_76_crt_socket_label_text_crop.png` | Crop of the related manual's CRT socket / video / focus section. |
