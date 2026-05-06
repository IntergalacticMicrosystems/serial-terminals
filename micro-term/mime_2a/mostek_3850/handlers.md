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

`JMP H'029F'` from boot-end `H'085A'` lands in **U1** at address H'029F',
which is just two instructions:

```
        PI   H'0703'                    ; 29f: 28 07 03   call U12:0703 (EI/POP gate?)
        JMP  H'0806'                    ; 2a2: 29 08 06   jump to dispatch_entry_2
```

This is **not the main loop** — it is a final post-init "enable interrupts
and enter steady state" sequence. The actual main control loop entry is
`dispatch_entry_2` at U22:`H'0A10'` (= `mode_entry_2`).

### `U12:H'0703'` — preload-charrom helper

```
        LR   K,P                ; 703: save return address
        DCI  H'0C00'            ; 704: DC ← U55 charrom_data_base
        LM                      ; 707: A ← *DC++ (read first U55 byte)
        PK                      ; 708: return to caller
```

Sole purpose: arm `DC` to point one byte past the start of `U55` so that
subsequent `LM` reads in the running system pull glyph data sequentially.
The `EI ; POP ; DI` sequence at `H'0710'..H'0712'` is **not** part of this
routine — it is a separate entry point reached via a different K-value
(probably the ISR exit path or a save/restore stub).

## Main control loop — `mode_entry_2 (U22:H'0A10')`

Entered as `JMP H'0806'` (= `dispatch_entry_2`) from boot's tail.

```
mode_entry_2 (a10):
        CLR ; AS 4              ; A = r4 (config flags shadow)
        BP   mode_entry_4       ; if positive, skip the helper-pair calls
        PI   H'0624' (U12)      ; primary helper
        BP   mode_entry_4       ; if positive, skip
        PI   H'05FB' (U12)      ; sub_05FB — heavy-use byte-handler
        PI   H'0624' (U12)      ; primary helper again
        ; falls through to mode_entry_4 ↓

mode_entry_4 (a1f):
        LIS  H'01' ; NS 4       ; A = 1 AND r4 (test bit 0 of config)
        BF   4 → H'0A99'        ; if Z=0, take the loop branch below
        PI   dispatch_entry_7   ; call dispatch[7] = mode_entry_6 (work)
        BM   mode_entry_4       ; loop back if minus
        …                       ; main work + state-machine tail
```

**The main idle/work loop tail** is at `H'0A99'`:

```
        LR   A,4 ; OI H'01'     ; set bit 0 of r4 ("busy" flag)
        LR   4,A
        PI   dispatch_entry_7   ; call mode_entry_6 (the work routine)
        BF   1,H'0A99'          ; loop while sign-bit clear
```

So **`dispatch_entry_7` (=`mode_entry_6` at H'0B41') is the per-iteration
work routine**, and `mode_entry_4` is the polling driver that calls it
in a loop guarded by the sign-flag.

## ISR body — UART RX → 8-byte ring buffer

(Continuing from the prologue documented above.)

```
        LR   Q,DC               ; ba3: save DC into Q
        DCI  H'8000'            ; ba4: DC ← peripheral (UART RX register)
        CLR ; AS 1              ; ba7: A = r1 (head-of-buffer pointer)
        LR   IS,A               ; ba9: ISAR = A (use r1 as scratchpad index)
        LM                      ; baa: A ← *DC++  ← read RX byte from UART
        BT   4,H'0BF3'          ; bab: if Z (byte == 0?) → exit-error path
        NI   H'7F'              ; bad: A &= 0x7F (strip parity bit)
        LR   D,A                ; baf: *(IS)- ← A (store, ISAR--)
        BT   4,H'0BB5'          ; bb0: …
        INC                     ; bb2: A++
        BT   1,H'0BC0'          ; bb3: …
        INS  1                  ; bb5: read CPU port 1 (UART status flags)
        NI   H'03'              ; bb6: mask bits 0..1 — parity / framing err
        XI   H'01'              ; bb8: XOR with 1
        BT   4,H'0BC0'          ; bba: branch if Z (no error)
        LR   A,4 ; SL 4         ; bbc: A = r4 << 4 (shift config bits)
        BT   1,H'0BF3'          ; bbe: if minus → exit
        ; --- ring buffer wrap (BR7-driven 8-byte loop) ---
        LR   A,IS               ; bc0: A = current ISAR
        BR7  H'0BCB'            ; bc1: if ISARL ≠ 7, branch (no wrap)
        AI   H'F8'              ; bc3: A -= 8 (wrap pointer)
        CI   H'1F'              ; bc5: compare against 0x1F
        BF   4,H'0BCB'          ; bc7: branch if not at boundary
        LISU 7                  ; bc9: ISARU = 7 (page 7)
        LR   A,IS               ; bca: A = ISAR
        LR   1,A                ; bcb: r1 = A (save updated head pointer)
```

Confirmed system-level finds:

- `H'8000'` = **AY-5-1013A receive-data register** (read once per
  interrupt). The strip-parity (`NI H'7F'`) and the framing/parity error
  check (`INS 1 ; NI H'03' ; XI H'01'`) are unmistakable UART RX handling.
- **CPU port 1 bits 0..1** = UART status flags: parity-error and
  framing-error (or overrun-error). Bit pattern is checked for exactly
  `0x01` so one specific bit is the "OK" code; the other bit is fail.
- **Scratchpad page 7 (`H'38..H'3F'`)** = 8-byte UART RX ring buffer.
  Maintained by `BR7`-driven wrap-around (`BR7` branches when ISARL ≠ 7,
  i.e. ISAR has not just hit `H'.F'`); the head pointer lives in `r1`.
- `r4` = **configuration flags shadow**, set at boot from CPU-port-0 bit
  1 plus other bits, shifted/tested throughout the main loop and ISR.

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

## Two-level dispatch table at U22:`H'0A5D'`

```
a5d:    LM                ; A ← *DC          (DC pre-set by caller)
a5e:    LR QL,A           ; QL ← A           ; first table byte = low byte
a5f:    LIS H'09'         ; A ← 9
a60:    LR QU,A           ; QU ← 9           ; high byte = 0x09 → Q = H'09xx'
a61:    LR DC,Q           ; DC ← Q           ; switch DC to U22:H'09xx'
a62:    LM                ; A ← *DC          ; second table fetch (action byte)
a63:    LR 8,A
a64:    INS 1 ; NI H'03'  ; check UART error flags
a67-:    …                ; dispatch on second-table byte
```

Two-stage indexed lookup: a primary table (loaded by the caller via `DCI`)
yields a one-byte index into a **secondary table at `H'0900..H'09FF'`**;
the byte fetched there controls the next action. The bytes in `H'0900..H'091F'`
disassemble as F8 instructions but **no JMP/PI/BR ever lands there** —
they are read only via `LM`, so the region is **data**, not code.

This is the central "translate a primary-table-driven state into a secondary
action code" mechanism — analogous to the Ampex emulation_codes.md xlate
tables, but at half the structural depth.

## Cursor advance — the H register pair as `(line, column)`

The HU/HL scratchpad pair (`H` register) holds the current cursor position.
Advance is split across two helpers in U12:

- **`sub_0612`** (U12:`H'0612'`) — advance **HU (line counter)**:
  ```
  LR A,HU ; INC ; CI H'57'
  BT 1,H'061B'      ; if HU+1 still ≤ 0x57, just store
  AI H'E8'          ; else HU += -0x18 (= -24)
  LR HU,A ; SL 1 ; SR 1 ; PK
  ```
  HU cycles in `H'40..H'57'` = **24 lines**. Hits the line-wrap when HU
  rolls past `H'57'`; the `AI H'E8'` brings it back to `H'40'`.

- **`sub_0601`** (U12:`H'0601'`) — advance **HL (column counter)**:
  ```
  LR A,HL ; INC ; CI H'CF'
  BF 1,H'0610'      ; if HL+1 ≤ 0xCF, branch to "store"
  ; else compare HU XOR r2 (target line); zero HL on match
  ```
  HL cycles in `0..H'CF'` = **208 increments**. The exact width per
  character cell (1 byte, 2 bytes for char+attribute, …) is still to be
  determined from the screen-fill loop; HL = 0xCF wrap is consistent
  with 80×2 + control-bytes or with extended-graphics modes.

`H'5062' + (line - 0x40) * line_stride + HL` is the working hypothesis for
the VRAM physical address of the cursor cell.

## `mode_entry_6` — the per-iteration work routine (U22:`H'0B41'`)

Called via `PI dispatch_entry_7` from the main polling loop. Body:

```
b41:    LR   K,P                ; save return (PI-style call)
b42:    PI   sub_0712 (U12)     ; intra-ROM helper
b45:    BR   H'0B4A'            ; skip the next call
b47:    PI   sub_0593 (U12)     ; (unreachable from b41 — alternate entry?)
b4a:    PI   sub_0793 (U12)     ; main per-iter helper
b4d:    BT   4,H'0B6F'          ; if Z, skip the keyboard-scan path

        ; --- keyboard-strobe and flow-control logic ---
b4f:    CLR ; AS 3              ; A ← r3 (current byte under processing)
b51:    BF   1,H'0B15'          ; if positive, jump to alt path
b53:    OI   H'80' ; LR 3,A     ; r3 |= 0x80 (mark byte as "live")
b56:    INS  1                  ; read CPU port 1
b57:    NI   H'10'              ; mask bit 4 — KEYBOARD STROBE
b59:    BF   4,H'0B91'          ; if no key pressed, branch out
b5b:    LR   A,3 ; NI H'7F'     ; strip mark bit
b5e:    LR   3,A
b5f:    CI   H'13'              ; compare with 0x13 = Ctrl-S (XOFF)
b61:    BF   4,H'0B67'          ; if not XOFF, continue
b63:    LI   H'FD' ; NS S       ; clear flow-control bit in scratchpad flag
b67:    PI   H'06C1'            ; call helper
b6a:    LI   H'20' ; NS S       ; (set/clear another flag)
```

Confirmed system-level finds:

- **CPU port 1 bit 4** = **keyboard strobe** (data-available from the
  parallel ASCII keyboard).
- **Ctrl-S / XOFF (0x13)** is detected for software flow control —
  classic terminal flow-control pattern.
- **`r3`** = byte currently being processed (with bit 7 used as a "live"
  flag to disambiguate fresh vs. stale).

## Open questions for next pass
2. **`U12:sub_05FB` body** — most-called helper across U1, U12, U22.
   Strong candidate for the central byte-dispatcher / state machine.
3. **`H'5062'` as VRAM cursor base** — the screen-clear loop fills with
   `0x20` (space char) starting at this address. The natural assumption
   is the screen RAM is mapped at `H'5000..H'52FF'` (768 bytes ≈ 80×24 ÷
   slack) or a smaller line count. Confirm by tracing the cursor-advance
   helper (`U12:H'0612'`) and the screen extent.
4. **In-ROM data tables in U22** at `H'08DE'` (loaded by `DCI H'08DE'`
   at H'0A40') — appears to be a translation/lookup table accessed via
   `LM`. Currently unidasm interprets these bytes as instructions that
   happen to round-trip; should be re-tagged as `DB` once the table
   stride and meaning are confirmed.
5. **`OUT H'93'` and `IN H'32'`** — these long-form 8-bit-port instructions
   reach external decode logic, not the SMI/PIO. Their purpose is hardware-
   specific (probably video timing latch or attribute mode select).
6. **DIP switch enumeration** — bit 1 of CPU port 0 is read at boot
   (`INS 0; NI H'02'`); the other 7 bits and CPU port 1's high bits
   need to be mapped to specific DIP switch positions (baud, parity,
   word length, etc. per typical 1970s terminal conventions).
