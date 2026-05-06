# References

External references used to guide component identification and pinout checks. These are aids only; board photos and continuity remain the authority for the reconstructed schematic.

## Local Manual References

- `Docs/3515021-01_Ampex_230_219_Service_Manual_198506.pdf`, pages 74-76: related Ampex 219/230 `PWBA - VIDEO BOARD`, drawing `3515240`, including a CRT socket wiring table, component reference table, and schematic sheet 3.
- Rendered working images are under `overlays/manual_pages/`. See `service_manual_cross_reference.md` for the comparison and confidence limits.

## Component References

- DigiKey `MC7812CT` product page: identifies the part as a fixed +12 V, 1 A TO-220 positive regulator.
- MCC `MC7812CT` datasheet mirror: shows TO-220 pinout as pin 1 input, pin 2 ground, pin 3 output.
- DigiKey `LM323K` product page: identifies the part as a fixed +5 V, 3 A TO-3 regulator.
- UTMEL `LM323K` article/datasheet links: identifies LM323K as a three-terminal TO-3 positive regulator with preset 5 V output and includes a pinout figure.
- BU406/BU407 datasheet mirror: identifies `BU407` as an NPN silicon power transistor with B-C-E TO-220 pin order and pin 2 connected to the mounting base/tab.
- ST `BU407` datasheet mirror: describes `BU407` as a high-current NPN silicon transistor used in horizontal deflection output stages for small/medium CRTs and monochrome computer terminals.
- `uPC1031H2` datasheet mirrors: identify the part family as a vertical deflection device; exact `U301` marking still needs confirmation.

## URLs

- `LM323K` DigiKey: https://www.digikey.com/en/products/detail/stmicroelectronics/LM323K/634740
- `LM323K` UTMEL: https://www.utmel.com/components/lm323k-voltage-regulator-lm323k-datasheet-pinout-equivalent?id=1078
- `MC7812CT` DigiKey: https://www.digikey.com/en/products/detail/onsemi/MC7812CT/592244
- `MC7812CT` MCC datasheet mirror: https://media.digikey.com/pdf/data%20sheets/micro%20commercial%20pdfs/mc7812ct%28to-220%29.pdf
