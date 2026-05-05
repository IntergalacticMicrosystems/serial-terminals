# Handlers and code organisation

Phase-3 catalogue of routines identified in the disassembly. Mirrors
`ampex-d175-terminal/disassembly/handlers.md` — names assigned from
call-site context, body annotations refined as we trace through more code.

## Reset / boot

```
RESET (U1:H'0000')        JMP H'0800' (= dispatch_table[0] in U22)
                           │
                           ▼
boot_init (U22:H'0818')   CLR ; OUTS 0 ; OUTS 1     — clear A, both CPU ports
                          LI  H'40' ; LR 4,A        — r4 ← 0x40 (DIP-shadow seed?)
                          LISU 3 ; LISL 3 ;
                          LI  H'FB' ; LR S,A        — scratchpad[H'1B'] ← 0xFB
                          LISU 2                    — ISARU = 2 (page H'10..H'17')
                          INS 0 ; NI H'02'          — read CPU port 0, mask bit 1
                          SL 4 ; AS 4 ; LR D,A      — shift/add into ISAR-D slot
                          LI  H'20' ; LR S,A        — scratchpad[H'18'] ← 0x20
                          PI  H'07C5'               — call helper in U22
                          SL 4 ; SR 1 ; SL 4 ;
                          XI H'F0' ; OUTS 0          — bit-twiddle, write back to port 0
                          LI  H'3F' ; LR 0,A; LR 1,A — r0 = r1 = 0x3F (initial cursor?)
                          LI  H'57' ; LR 2,A         — r2 = 0x57 (constant — TBD)
                          ; ---- SMI interrupt-vector setup ----
                          LIS H'0B' ; OUTS H'0C'     — vector hi  = 0x0B
                          LI  H'99' ; OUTS H'0D'     — vector lo  = 0x99
                          LIS 1     ; OUTS H'0E'     — int-control = 1 (enable)
                          PI  H'0777'                — call (final pre-screen-clear setup)
                          ; ---- screen clear loop ----
                          DCI ext_screen_base        — DC ← H'5062'
                          LR H,DC ; LR DC,H          — H = 0x5062 (cursor cache)
boot_screen_clear:
                          LR  DC,H ; LI H'20' ; ST   — *DC++ ← ' '
                          PI  H'0612'                — call U12 helper (advance H?)
                          XI  H'40' ; BF 4,—         — loop until Z is set (boundary check)
                          LR  HL,A ; PI H'04EF'      — finalise screen-clear
                          JMP H'029F'                — into U1 main entry point
```

## Main entry point (post-init)

`JMP H'029F'` from `H'085A'` lands in **U1** at address H'029F'. This is
the first instruction executed under the running interrupt regime, and is
the most likely candidate for the **main idle / poll loop**. Tracing its
body is the next concrete reverse-engineering step.

## Interrupt service

| Vector address | Source     | Handler         | Notes |
|----------------|------------|-----------------|-------|
| `H'0B99'`      | MK3853 SMI external interrupt or timer | `smi_isr` (U22) | Set up at boot via `OUTS H'0C'/H'0D'/H'0E'`. Body immediately reads peripheral at `DCI H'8000'` — strong indication of a **byte-from-UART** handler |

### `smi_isr` (U22:H'0B99')

Entry-point prologue (before any peripheral access):

```
        LR   6,A                ; r6 ← A (save accumulator)
        LR   J,W                ; J  ← W (save status / ICB)
        LR   A,IS               ; A  ← ISAR
        LISU 3 ; LISL 0          ; ISAR = H'18'
        LR   I,A                ; scratchpad[H'18'] ← saved ISAR; ISAR++
        LR   A,QU
        LR   I,A                ; scratchpad[H'19'] ← QU; ISAR++
        LR   A,QL
        LR   S,A                ; scratchpad[H'1A'] ← QL
        LR   Q,DC               ; Q ← DC (save data counter)
        DCI  H'8000'            ; DC ← peripheral data register
        CLR ; AS 1 ; LR IS,A    ; ISAR ← (0 + r1) — index into a table?
        LM                      ; A ← *DC++        — read the byte the
                                ;                    interrupt is signalling
        …
```

Saved-context layout (scratchpad page 3):

| Slot      | Value at entry |
|-----------|----------------|
| `H'09'` (J)   | W (status reg + ICB) |
| `H'18'`       | ISAR           |
| `H'19'`       | QU             |
| `H'1A'`       | QL             |
| `r6`          | A              |
| `Q` (H'0E/0F') | DC            |

The fact that the saved DC is parked in `Q` (not in scratchpad) is unusual
but consistent — `Q` is then free to be reloaded for indirect-jump dispatch
later in the body if the ISR needs to vector on the byte read from `H'8000'`.

## Primary jump table — `dispatch_table @ H'0800'`

Reached by:
- Reset (`U1:H'0000'` → `JMP H'0800'`) — index 0 only
- Possibly other call-sites that load the entry index in advance and then
  jump via `LR P0,Q` (TBD)

| Index | Target           | Tentative role                                              |
|-------|------------------|-------------------------------------------------------------|
| 0     | `H'0818'` `boot_init`                | **Cold boot** (only entered from reset) |
| 1     | `H'09F9'` `mode_entry_1`             | TBD — mode/reset re-entry candidate    |
| 2     | `H'0A10'` `mode_entry_2`             | TBD                                    |
| 3     | `H'0A19'` `mode_entry_3`             | Calls U12:`sub_05FB` and U12:`sub_0624` — likely operator-input handler |
| 4     | `H'0A1F'` `mode_entry_4`             | TBD                                    |
| 5     | `H'0A31'` `mode_entry_5`             | TBD                                    |
| 6     | `H'0B81'` `mode_entry_7`             | TBD                                    |
| 7     | `H'0B41'` `mode_entry_6`             | TBD — calls U12:`sub_0593` and U12:`sub_0793` (`pi_table` at U22:`H'0B47'`) |

## U12 callees (cross-ROM API)

| Address    | Callers (sites)             | Tentative role                                       |
|------------|-----------------------------|------------------------------------------------------|
| `H'04DB'`  | U1:`H'013B'`                | TBD                                                  |
| `H'058F'`  | U1:`H'0159'`,`'0188'`,`'0195'` | **Common entry** — pi-table partner repeatedly paired with sequential targets `H'05F5'`,`H'05FB'`,`H'0601'`. Strong hint this is a 3-state / 3-mode helper |
| `H'0593'`  | U22:`H'0B47'`               | TBD                                                  |
| `H'05B4'`  | U12:`H'0450'`               | TBD                                                  |
| `H'05E9'`  | U12:`H'04E7'`               | TBD                                                  |
| `H'05F5'`  | U1:`H'0159'`                | TBD — pairs with `sub_058F`                          |
| `H'05FB'`  | U1:`H'0188'`; U12:`H'04F0'`; U22:`H'0A19'` | **Frequently called** — TBD; possibly the byte-input dispatcher |
| `H'0601'`  | U1:`H'0195'`                | TBD                                                  |
| `H'0612'`  | U1:`H'013B'`; U22:`H'084F'` (boot screen-clear) | **Cursor-advance helper** — invoked once per character store during screen-clear |
| `H'0624'`  | U22:`H'0A19'`               | TBD                                                  |
| `H'06F8'`  | U1:`H'00EC'`                | TBD                                                  |
| `H'0703'`  | U1:`H'00EC'`                | TBD                                                  |
| `H'0712'`  | U12:`H'04E7'`,`'04F0'`      | Intra-ROM helper (called by two pi-tables)           |
| `H'0793'`  | U22:`H'0B47'`               | TBD                                                  |

## Open questions for next pass

1. **What is at `H'029F'` in U1?** This is where boot ends — almost
   certainly the main loop entry. Trace it forward from the listing.
2. **Is `dispatch_table` ever entered with index ≠ 0?** Search for any
   computed-jump or call-via-Q sites that target `H'0800'`.
3. **What is at `H'8000'`?** The first read in the ISR. Almost certainly
   the AY-5-1013A receive-data byte (DAV-strobed). Confirm by tracing the
   ISR body to whether the byte gets routed to the screen, the keyboard
   buffer, or a state-machine variable.
4. **`H'5062'` as VRAM cursor base** — the screen-clear loop fills with
   `0x20` (space char) starting at this address. The natural assumption
   is the screen RAM is mapped at `H'5000..H'52FF'` (768 bytes ≈ 80×24 ÷
   slack) or `H'5000..H'52FF'` for a smaller line count. Confirm by
   tracing the cursor-advance helper (`U12:H'0612'`) and the screen extent.
5. **DIP-switch read at boot** (`INS 0; NI H'02'`) — bit 1 of CPU port 0
   selects something at boot. The masked value drives a 1-bit shift used
   in port-0 assembly. This is most likely the **half-duplex** vs
   **full-duplex** DIP switch position, since it appears very early.
6. **`OUT H'93'` and `IN H'32'`** — these long-form 8-bit-port instructions
   reach external decode logic, not the SMI/PIO. Their purpose is hardware-
   specific (probably video timing latch or attribute mode select).
