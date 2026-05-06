# Trace Pass 06: Rectified Photo Alignment

Status: new primary photo-tracing workflow.

## Conclusion

The front/back photos are good enough to build the schematic if they are first rectified into a common board coordinate system. The board is single-sided, so once the solder side is mirrored and perspective-corrected, copper islands can be matched to front-side component bodies and reference designators.

The previous crop-by-crop approach was too conservative because local crops did not preserve global geometry. A full-board rectification makes the J1/rectifier area, CRT neck pads, CPU-board harness, and yoke connector line up well enough for systematic tracing.

## Generated Files

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\align_board_photos.ps1
```

Generated primary files:

- `overlays/front_board_rectified.png`
- `overlays/back_board_rectified.png`
- `overlays/front_back_rectified_blend.png`
- `overlays/rectified_full_front_back_montage.jpg`
- `overlays/rectified_j1_power_montage.jpg`

The board coordinate space is 2400 x 3200 pixels. Coordinates in these images are now stable enough to use in `pad_map.csv`.

## Current Alignment Quality

Good enough for:

- Matching connector pads to visible connector pin labels.
- Matching axial resistor/diode lead pads to reference designators.
- Following single-sided copper islands through low/moderate density areas.
- Building a partial schematic by functional block.

Use caution around:

- The lower-right/front side, where the CRT/heatsink assembly hides the board corner used for rectification.
- Tall components, because parallax moves the top of the part body even when its solder pads align.
- Large electrolytics and the flyback area, where component bodies hide front-side lead positions.
- Very wide masked copper pours, where the trace boundary is visible but the electrical node can span large areas.

## Practical Tracing Method

For each block:

1. Open the rectified front, rectified back, and blend for the same crop.
2. On the front image, mark component lead positions and reference designators.
3. On the back image, follow the copper island from each matching pad.
4. Record every island as a temporary net in `net_register.csv`.
5. Only promote the net to a functional name when a connector, regulator pinout, diode polarity, or manual-supported local trace confirms it.

## J1/Rectifier Impact

`overlays/rectified_j1_power_montage.jpg` shows the J1 pins and `CR101`-`CR106` pads in the same coordinate frame. This is now traceable as a copper-island task, not a photo-registration blocker.

The remaining hard part is ordinary schematic extraction:

- identify which J1 pad lands on which copper island,
- identify each `CR101`-`CR106` anode/cathode pad,
- merge islands through the wide copper pours,
- then name the resulting raw rails using diode direction and capacitor polarity.

## Next Recommended Block

Start with the CRT neck/video cluster rather than J1. It has more front-side reference designators and a related-manual cross-reference, so it should produce component-level schematic wins faster:

- `E2`/yellow to `Q401`/`R402`/`NS401`.
- `E7`/blue to focus control `VR501`.
- `E1`/green and `E6`/red to brightness/focus high-voltage protection.
- `E3`/brown to local ground/aquadag or separate CRT node.

After that, use the same method for J1 and the CPU-board harness.
