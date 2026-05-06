# Tracing Workflow

## Goal

Produce a KiCad schematic and netlist for the CRT board with confidence annotations and a short list of remaining physical checks.

## Artifacts To Maintain

- `component_inventory.md` - component identities and roles.
- `net_register.csv` - traced nets and confidence.
- `pad_map.csv` - pad IDs, component pins, and image coordinates.
- `block_notes.md` - circuit interpretation by functional block.
- `kicad/` - final schematic project.
- `overlays/` - generated or manually prepared annotated image layers.

## Pass 1: Image Normalization

1. Create auto-oriented copies of `Front.jpg` and `Back.jpg`.
2. Perspective-correct both images against the rectangular board outline.
3. Mirror the auto-oriented solder side.
4. Align front/back using mounting holes, connector pads, long slots, and large component pin groups.
5. Export:
   - `overlays/front_normalized.png`
   - `overlays/back_mirrored_normalized.png`
   - `overlays/front_back_overlay.png`

For the current non-perspective-corrected pass, use `overlays/front_auto.png` and `overlays/back_auto_mirrored.png`. Do not use older `back_mirrored.png` crops for new coordinate decisions unless they have been regenerated from the updated script.

Current repeatable alignment workflow:

```powershell
powershell -ExecutionPolicy Bypass -File .\align_board_photos.ps1
```

This creates `overlays/front_board_rectified.png`, `overlays/back_board_rectified.png`, and `overlays/front_back_rectified_blend.png` in a common 2400 x 3200 board coordinate space. Use these for pad/component matching before declaring a photo trace blocked.

## Pass 2: Pad Map

1. Assign all visible pads stable IDs: `P0001`, `P0002`, etc.
2. Map each pad to a component reference where visible.
3. Record uncertainty instead of guessing hidden pins.
4. Use connector pin order conventions only after visual confirmation.

## Pass 3: Net Register

1. Trace copper islands from the mirrored solder-side image.
2. Assign temporary net names: `N001`, `N002`, etc.
3. Merge nets only when the copper connection is visually continuous or confirmed by continuity.
4. Flag suspected solder bridges, occluded traces, and unclear pad separations.

## Pass 4: Electrical Naming

Promote temporary nets to names only when there is evidence:

- Regulator pinout confirms `+5V`, `+12V`, or raw DC rails.
- Electrolytic polarity and rectifier direction confirm supply rails.
- Yoke harness color/pairing and connector pads confirm deflection nets.
- CRT neck socket pinout confirms heater, cathode, grid, focus, and related nets.
- Deflection IC datasheet confirms sync, pump-up/output, supply, feedback, and oscillator pins.

## Pass 5: Schematic Capture

1. Create KiCad symbols or use stock symbols for standard parts.
2. Draw by functional block.
3. Use named nets for rails and connectors.
4. Preserve temporary net IDs as labels or comments where function remains unknown.
5. Run KiCad ERC and record expected warnings.

## Minimal Electrical Checks

Use only unpowered continuity checks where photo evidence is insufficient:

- Transformer/flyback winding groups at `T202`.
- CRT neck socket wire-to-pin mapping.
- Yoke connector pin numbering and coil-pair grouping.
- Regulator and TO-3 case connections.
- Ambiguous trace separations around dense solder-side areas.

## First Tracing Targets

Trace these in order because each one names many otherwise anonymous nets:

1. `J1` AC input through `CR101`-`CR104` and the bulk electrolytics.
2. `J2` ground connector to establish the board return net.
3. `U101 LM323K` pins/case to identify `+5V`, raw input, and common.
4. `U102 MC7812CT` pins to identify `+12V` and its input rail.
5. `J4` yoke connector pads to the `U301` vertical section and `Q202`/horizontal section.
6. `U301` pin fanout around `VR301` and `VR302`.
7. CRT neck connector wiring to `Q401`, `VR501`, `VR502`, and high-voltage/focus components.

## OpenCV Automation Candidates

Only automate where it saves review time:

- Detect solder pads as bright blobs on `Back.jpg`.
- Extract likely copper regions by thresholding green board versus exposed/soldered copper.
- Generate a numbered pad coordinate table for manual correction.
- Produce transparent overlays for each provisional net island.

Do not rely on automatic segmentation for final connectivity around solder blobs, large pads, scratched areas, or narrow gaps.

## Tooling

Recommended primary workflow:

- GIMP/Inkscape for image correction and manual overlays.
- PCB ReTrace or PCB Tracer for structured photo tracing and possible KiCad export.
- KiCad for canonical schematic capture.
- OpenCV scripts if manual alignment or pad extraction becomes repetitive.
