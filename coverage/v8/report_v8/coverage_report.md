# Coverage report (merged from 1 checkpoint(s))

Executed ROM bytes (opcode+operand): **112359**; ROM bytes read as data: **1004879**; RAM addresses executed: **18**

Static trace: 60449 instruction starts, 117627 code bytes, 1256 table-word bytes.

## 1. Traced instructions executed, per bank

| bank | traced instr | executed (any) | % | organic (inputs only) | forced-state only | never | traced code bytes |
|---|---|---|---|---|---|---|---|
| 00 | 6800 | 6306 | 92.7 | 5724 (84.2%) | 582 | 494 | 11896 |
| 02 | 2467 | 2456 | 99.6 | 2193 (88.9%) | 263 | 11 | 4520 |
| 03 | 7324 | 6785 | 92.6 | 6557 (89.5%) | 228 | 539 | 14701 |
| 04 | 6615 | 6256 | 94.6 | 5959 (90.1%) | 297 | 359 | 13474 |
| 05 | 7233 | 6646 | 91.9 | 3628 (50.2%) | 3018 | 587 | 14798 |
| 06 | 6466 | 6391 | 98.8 | 6327 (97.9%) | 64 | 75 | 12834 |
| 07 | 6509 | 6372 | 97.9 | 6205 (95.3%) | 167 | 137 | 13639 |
| 08 | 2758 | 2663 | 96.6 | 2641 (95.8%) | 22 | 95 | 5658 |
| 09 | 5367 | 5177 | 96.5 | 4615 (86.0%) | 562 | 190 | 10971 |
| 0A | 6778 | 6512 | 96.1 | 4382 (64.7%) | 2130 | 266 | 11091 |
| 1F | 2132 | 2018 | 94.7 | 1777 (83.3%) | 241 | 114 | 4045 |
| **all** | 60449 | 57582 | 95.3 | 50008 (82.7%) | 7574 | 2867 | |

*organic* = reached by button input only from a real save (no memory pokes in the lineage); *forced-state only* = executed only after a run poked a RAM variable to satisfy/flip a logged exit condition or forced a mode (reachability not proven). Forced-state runs that left the known code were discarded, so the forced-state set contains no executed opcode outside the trace by construction.

## 2. Organically executed opcodes NOT at a traced instruction start

Total 0: 0 fall inside a traced instruction (mis-aligned entry / overlapping code), 0 are outside any traced code (tracer gaps).

## 3. Static roots (extra_roots.json): executed or not

75 roots executed (32 organically), 59 never executed.

| root | executed | note |
|---|---|---|
| 00:0008 | yes (organic) | rst $08 vector body (wait for VBlank flag; falls through into rst $10 body); tracer only special-cases `rst $08` |
| 00:0010 | yes (organic) | rst $10 vector body (HL = flag address; halt until ISR sets it) |
| 00:0018 | yes (organic) | rst $18 vector body = jump-table dispatcher (pop hl; HL+2*A; jp hl) |
| 00:0060 | forced-state only | joypad interrupt vector $60 = `jp $0389` (a reti); tracer lists only $40/$48/$50/$58 |
| 00:0210 | yes (organic) | soft reset: VBlank ISR does `ld hl,$0210 ; push hl ; reti` at 00:031A when the reset key combo is held (a second copy of the boot sequence 0 |
| 00:0367 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:0380 | yes (organic) | serial/joypad IRQ dispatcher: return address `ld hl,$0380; push hl` then `push bc; ret` into the [$FFC6] table (00:0368) |
| 00:038A | yes (organic) | body of the inline mode-table dispatcher `call $038A` (special-cased by the tracer) |
| 00:03A6 | yes (organic) | return address pushed by the $038A dispatcher (`ld de,$03a6; push de; jp hl`): restores ROM bank, ret |
| 00:03D4 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:03DB | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:03F0 | forced-state only | OAM-DMA stub: 10-byte image copied by 00:03E2 into HRAM $FF80 and run by `call $FF80` (00:02A7); ROM address of the image |
| 00:057F | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:069F | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:0751 | forced-state only | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:0762 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:0773 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:0781 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:08BB | yes (organic) | body of the one-way far jump helper `call $08BB` (special-cased) |
| 00:08C1 | yes (organic) | body of the far-call helper `call $08C1` (special-cased) |
| 00:10AC | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:190B | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:190F | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:19A2 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:1AEB | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:1C2F | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:1C56 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:24F1 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:2523 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:253C | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 00:2E82 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 03:57BE | yes (organic) | cooperative task entry: PC stored as split immediates `ld a,$be ; ld [$d6fd],a ; ld a,$57 ; ld [$d6fe],a` (03:562D); resumed by the yield/sw |
| 03:5847 | yes (organic) | cooperative task entry stored at $d70d/$d70e by 03:5637 (3rd task of the scene started at 03:5614) |
| 03:5A7A | yes (organic) | cooperative task entry stored at $d6fd/$d6fe by 03:5919 (2nd task of the scene started at 03:5900; yield = 03:59AF) |
| 03:5B00 | yes (organic) | cooperative task entry stored at $d70d/$d70e by 03:5923 (3rd task of the scene started at 03:5900) |
| 03:5F69 | yes (organic) | return address pushed before `jp hl` at 03:5F68 (per-step callback DE, 36 steps); loop body + tail jump to DE |
| 03:5F92 | yes (organic) | return address pushed before `jp hl` at 03:5F91 (same helper, subtract variant) |
| 03:655B | forced-state only | return address pushed before the jump-table `jp hl` at 03:655A (`ld hl,$655b ; push hl`): `pop bc ; ret` |
| 04:6403 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 04:6412 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 04:7C9D | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 05:622D | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 05:7F1C | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 05:7F33 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 06:71CC | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 07:41C8 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 07:4A4D | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 07:4BC3 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 07:4BEA | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 07:503D | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 07:792D | yes (organic) | return address pushed before `jp hl` at 07:792C (helper $7900 loop continuation) |
| 07:7AF1 | yes (organic) | callback of the 6-byte-entry tables (7985,79E5,7A43,7A5E,7A85,7AAC,7AD3) walked by helper 07:7900 (`push bc; jp hl` at 07:792C) |
| 07:7AF6 | yes (organic) | callback of the 6-byte-entry tables (7985,79E5,7A43,7A5E,7A85,7AAC,7AD3) walked by helper 07:7900 (`push bc; jp hl` at 07:792C) |
| 07:7AFB | yes (organic) | callback of the 6-byte-entry tables (7985,79E5,7A43,7A5E,7A85,7AAC,7AD3) walked by helper 07:7900 (`push bc; jp hl` at 07:792C) |
| 07:7B00 | yes (organic) | callback of the 6-byte-entry tables (7985,79E5,7A43,7A5E,7A85,7AAC,7AD3) walked by helper 07:7900 (`push bc; jp hl` at 07:792C) |
| 07:7B05 | yes (organic) | callback of the 6-byte-entry tables (7985,79E5,7A43,7A5E,7A85,7AAC,7AD3) walked by helper 07:7900 (`push bc; jp hl` at 07:792C) |
| 07:7BF4 | yes (organic) | return address pushed before `jp hl` at 07:7BF3 (frame-animation helper $7BDC: loads 4 tile blocks, then tail-jumps to the callback) |
| 07:7C63 | yes (organic) | return address pushed before `jp hl` at 07:7C62 (animation helper $7C4B) |
| 07:7CD2 | yes (organic) | return address pushed before `jp hl` at 07:7CD1 (animation helper $7CBA) |
| 07:7D11 | yes (organic) | frame-wait helper called by the three animation helpers (`call $7D11` from 7C10/7C80/7CEF), runs the pushed callback every VBlank |
| 07:7D28 | yes (organic) | return address pushed before `jp hl` at 07:7D27 (callback invoked from the wait loop at $7D11) |
| 09:6D00 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 09:721D | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 0A:4C53 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 0A:5ABD | yes (organic) | bank 0A `jp hl` at 5419 table $541A entry 32 (A=32: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5B37 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 35 (A=35: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5B86 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 36 (A=36: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5BD5 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 37 (A=37: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5C3A | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 38 (A=38: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5C80 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 39 (A=39: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5D27 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 40 (A=40: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5E28 | yes (organic) | bank 0A `jp hl` at 5419 table $541A entry 41 (A=41: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5E2E | yes (organic) | bank 0A `jp hl` at 5419 table $541A entry 42 (A=42: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5E34 | yes (organic) | bank 0A `jp hl` at 5419 table $541A entry 43 (A=43: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5E3A | yes (organic) | bank 0A `jp hl` at 5419 table $541A entry 44 (A=44: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5E40 | **no** | bank 0A `jp hl` at 5419 table $541A entry 45 (A=45: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5E7F | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 46 (A=46: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5EBF | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 47 (A=47: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5EFC | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 48 (A=48: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5F39 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 49 (A=49: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:5FB9 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 50 (A=50: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6037 | **no** | bank 0A `jp hl` at 5419 table $541A entry 51 (A=51: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6074 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 52 (A=52: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:60B1 | **no** | bank 0A `jp hl` at 5419 table $541A entry 53 (A=53: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:60EE | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 54 (A=54: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:612B | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 55 (A=55: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:616B | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 56 (A=56: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61AB | **no** | bank 0A `jp hl` at 5419 table $541A entry 57 (A=57: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61AC | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 58 (A=58: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61AD | **no** | bank 0A `jp hl` at 5419 table $541A entry 59 (A=59: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61AE | **no** | bank 0A `jp hl` at 5419 table $541A entry 60 (A=60: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61AF | **no** | bank 0A `jp hl` at 5419 table $541A entry 61 (A=61: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61B0 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 62 (A=62: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61B1 | **no** | bank 0A `jp hl` at 5419 table $541A entry 63 (A=63: block 1 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:61B2 | yes (organic) | bank 0A `jp hl` at 5419 table $541A entry 64 (A=64: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:621B | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 65 (A=65: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6269 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 66 (A=66: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:62B8 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 69 (A=69: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6318 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 70 (A=70: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:636A | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 71 (A=71: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6411 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 72 (A=72: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6516 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 73 (A=73: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:651C | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 74 (A=74: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6522 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 75 (A=75: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6528 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 76 (A=76: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:652E | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 77 (A=77: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:656A | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 78 (A=78: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:65A5 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 79 (A=79: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:65DE | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 80 (A=80: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6617 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 81 (A=81: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:668F | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 82 (A=82: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6704 | **no** | bank 0A `jp hl` at 5419 table $541A entry 83 (A=83: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:673D | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 84 (A=84: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6776 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 85 (A=85: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:67AF | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 86 (A=86: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:67E8 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 87 (A=87: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6824 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 88 (A=88: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:685F | **no** | bank 0A `jp hl` at 5419 table $541A entry 89 (A=89: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6860 | forced-state only | bank 0A `jp hl` at 5419 table $541A entry 90 (A=90: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6861 | **no** | bank 0A `jp hl` at 5419 table $541A entry 91 (A=91: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6862 | **no** | bank 0A `jp hl` at 5419 table $541A entry 92 (A=92: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6863 | **no** | bank 0A `jp hl` at 5419 table $541A entry 93 (A=93: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6864 | **no** | bank 0A `jp hl` at 5419 table $541A entry 94 (A=94: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:6865 | **no** | bank 0A `jp hl` at 5419 table $541A entry 95 (A=95: block 2 of 3, A = [bank6:$60DB+idx] / 0/$20/$40 via far call 06:781D -> 0A:7CFE -> 5406) |
| 0A:7CE6 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 0A:7CEC | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:46DD | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:4A61 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:4FBC | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:524B | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:53B9 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:53E7 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:5743 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |
| 1F:7FF3 | **no** | DEAD-CODE (unreferenced): decodes cleanly to ret/jp, no call/jp/ld operand, table word or split-immediate points here |

## 4. Traced code never executed (contiguous runs of instruction starts, >= 16 bytes)

192 runs total, 62 of >=16 bytes; bytes in never-executed traced instructions: 2867

## 5. ROM bytes read as data (outside traced code)

892703 bytes in total.

Extents (gap<=16): 859, written to data_extents.csv.

| bank | data-read bytes | extents | traced-code bytes | untraced&unread bytes |
|---|---|---|---|---|
| 00 | 4488 | 27 | 11896 | 0 |
| 01 | 16384 | 1 | 0 | 0 |
| 02 | 11864 | 7 | 4520 | 0 |
| 03 | 1683 | 42 | 14701 | 0 |
| 04 | 2910 | 41 | 13474 | 0 |
| 05 | 1586 | 53 | 14798 | 0 |
| 06 | 3550 | 43 | 12834 | 0 |
| 07 | 2745 | 54 | 13639 | 0 |
| 08 | 10726 | 21 | 5658 | 0 |
| 09 | 5411 | 51 | 10971 | 2 |
| 0A | 5293 | 3 | 11091 | 0 |
| 0B | 10251 | 88 | 0 | 6133 |
| 0C | 16384 | 1 | 0 | 0 |
| 0D | 16375 | 1 | 0 | 9 |
| 0E | 16384 | 1 | 0 | 0 |
| 0F | 16384 | 1 | 0 | 0 |
| 10 | 16331 | 2 | 0 | 53 |
| 11 | 16384 | 1 | 0 | 0 |
| 12 | 16384 | 1 | 0 | 0 |
| 13 | 16384 | 1 | 0 | 0 |
| 14 | 15251 | 7 | 0 | 1133 |
| 15 | 16384 | 1 | 0 | 0 |
| 16 | 16384 | 1 | 0 | 0 |
| 17 | 16369 | 1 | 0 | 15 |
| 18 | 16384 | 1 | 0 | 0 |
| 19 | 16368 | 1 | 0 | 16 |
| 1A | 16327 | 3 | 0 | 57 |
| 1B | 16345 | 1 | 0 | 39 |
| 1C | 16235 | 2 | 0 | 149 |
| 1D | 16384 | 1 | 0 | 0 |
| 1E | 16373 | 1 | 0 | 11 |
| 1F | 12336 | 65 | 4045 | 3 |
| 20 | 16384 | 1 | 0 | 0 |
| 21 | 16384 | 1 | 0 | 0 |
| 22 | 16384 | 1 | 0 | 0 |
| 23 | 16384 | 1 | 0 | 0 |
| 24 | 16384 | 1 | 0 | 0 |
| 25 | 15799 | 14 | 0 | 585 |
| 26 | 15545 | 11 | 0 | 839 |
| 27 | 16051 | 9 | 0 | 333 |
| 28 | 13360 | 64 | 0 | 3024 |
| 29 | 8806 | 64 | 0 | 7578 |
| 2A | 13721 | 39 | 0 | 2663 |
| 2B | 16384 | 1 | 0 | 0 |
| 2C | 16384 | 1 | 0 | 0 |
| 2D | 15582 | 6 | 0 | 802 |
| 2E | 16384 | 1 | 0 | 0 |
| 2F | 11440 | 38 | 0 | 4944 |
| 30 | 16384 | 1 | 0 | 0 |
| 31 | 15574 | 2 | 0 | 810 |
| 32 | 13077 | 17 | 0 | 3307 |
| 33 | 11776 | 37 | 0 | 4608 |
| 34 | 16356 | 2 | 0 | 28 |
| 35 | 16040 | 6 | 0 | 344 |
| 36 | 16384 | 1 | 0 | 0 |
| 37 | 16223 | 3 | 0 | 161 |
| 38 | 16384 | 1 | 0 | 0 |
| 39 | 16384 | 1 | 0 | 0 |
| 3A | 16176 | 4 | 0 | 208 |
| 3B | 16216 | 1 | 0 | 168 |
| 3C | 16309 | 2 | 0 | 75 |
| 3D | 16235 | 1 | 0 | 149 |
| 3E | 16384 | 1 | 0 | 0 |
| 3F | 16384 | 1 | 0 | 0 |

## 6. ROM bank selection

Banks selected at least once: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F

Banks selected organically: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F

Banks never selected: 

D1 banks (no static reference): 2B:27 site(s), 3 organic, 2D:29 site(s), 3 organic, 2E:25 site(s), 3 organic, 30:37 site(s), 2 organic, 31:31 site(s), 4 organic, 32:30 site(s), 4 organic, 33:28 site(s), 3 organic, 34:33 site(s), 5 organic, 35:33 site(s), 7 organic, 37:31 site(s), 3 organic, 3A:30 site(s), 5 organic, 3B:32 site(s), 4 organic, 3C:26 site(s), 4 organic, 3D:35 site(s), 5 organic

| new bank | sites (writer bank:pc xcount) |
|---|---|
| 00 | 00:039C x4793953, 00:03A9 x244548804, 00:0440 x576, 00:045D x5109, 00:0469 x215559, 00:0475 x89686 … |
| 01 | 00:0191 x14564, 00:0231 x4661, 00:039C x6, 00:03A9 x52233, 00:045D x16, 00:0469 x39926 … |
| 02 | 00:039C x4, 00:03A9 x35164, 00:045D x34, 00:0469 x27617, 00:0475 x115095, 00:051C x915946 … |
| 03 | 00:039C x44002423, 00:03A9 x22458, 00:045D x9, 00:0469 x23308, 00:0475 x277413, 00:0500 x6 … |
| 04 | 00:039C x72453030, 00:03A9 x516988, 00:045D x23734, 00:0469 x22769, 00:0475 x365872, 00:051C x783 … |
| 05 | 00:039C x11488751, 00:03A9 x8418, 00:0469 x21215, 00:0475 x1505684, 00:051C x731783, 00:0520 x912856 … |
| 06 | 00:039C x25609379, 00:03A9 x364844, 00:0469 x24006, 00:0475 x1705995, 00:051C x548205, 00:0520 x731012 … |
| 07 | 00:039C x43971811, 00:03A9 x66406, 00:045D x14, 00:0469 x15765, 00:0475 x1334388, 00:051C x732769 … |
| 08 | 00:039C x19894482, 00:03A9 x15470, 00:0469 x22573, 00:0475 x2234723, 00:04EF x60677, 00:051C x365320 … |
| 09 | 00:039C x23524919, 00:03A9 x8780, 00:0469 x24670, 00:0475 x393257, 00:051C x2007169, 00:0520 x732135 … |
| 0A | 00:03A9 x9805, 00:0469 x11368, 00:0475 x676, 00:051C x368493, 00:0520 x550698, 00:05AB x72 … |
| 0B | 00:045D x35, 00:0469 x36957, 00:051C x372342, 00:0520 x553979, 00:05AB x260, 00:05AE x212 … |
| 0C | 00:045D x145860, 00:0469 x9994, 00:051C x1279776, 00:0520 x1463026, 00:05AB x52, 00:05AE x48 … |
| 0D | 00:039C x14, 00:045D x80701, 00:0469 x29139, 00:051C x915127, 00:0520 x732566, 00:0593 x2 … |
| 0E | 00:039C x1, 00:045D x1814, 00:0469 x12408, 00:051C x1279014, 00:0520 x366729, 00:0593 x783 … |
| 0F | 00:045D x85403, 00:0469 x42342, 00:051C x183891, 00:0520 x1869, 00:0593 x9546, 00:05AB x276 … |
| 10 | 00:03A9 x14254, 00:045D x8793, 00:0469 x32490, 00:0493 x3, 00:0500 x48, 00:051C x366649 … |
| 11 | 00:039C x24, 00:03A9 x736, 00:045D x136671, 00:0469 x22552, 00:051C x1098657, 00:0520 x734328 … |
| 12 | 00:045D x58343, 00:0469 x20334, 00:051C x17555, 00:0520 x18638, 00:05AB x132, 00:05AE x104 … |
| 13 | 00:039C x2, 00:045D x80951, 00:0469 x19537, 00:051C x922353, 00:0520 x1288755, 00:05AB x124 … |
| 14 | 00:039C x1, 00:045D x41464, 00:0469 x14747, 00:051C x184487, 00:0520 x732198, 00:05AB x92 … |
| 15 | 00:045D x725582, 00:0469 x24898, 00:0500 x5, 00:051C x183025, 00:0520 x183466, 00:05AB x184 … |
| 16 | 00:039C x223107, 00:045D x273340, 00:0469 x13954, 00:051C x913417, 00:0520 x1094730, 00:05AB x100 … |
| 17 | 00:045D x1084264, 00:0469 x14100, 00:051C x2272, 00:0520 x186609, 00:05AB x104, 00:05AE x64 … |
| 18 | 00:039C x9152, 00:045D x117812, 00:0469 x17476, 00:051C x734641, 00:0520 x1463646, 00:05AB x88 … |
| 19 | 00:039C x36210, 00:045D x8385, 00:0469 x12469, 00:051C x735892, 00:0520 x4630, 00:05AB x88 … |
| 1A | 00:045D x17119, 00:0469 x12525, 00:051C x185889, 00:0520 x4256, 00:05AB x92, 00:05AE x64 … |
| 1B | 00:039C x5, 00:045D x33499, 00:0469 x25712, 00:051C x183419, 00:0520 x365171, 00:0593 x1468 … |
| 1C | 00:039C x2, 00:045D x22082, 00:0469 x35814, 00:0475 x3, 00:051C x367373, 00:0520 x366886 … |
| 1D | 00:039C x1, 00:045D x10693, 00:0469 x11451, 00:051C x549718, 00:0520 x548838, 00:05AB x72 … |
| 1E | 00:045D x322097, 00:0469 x12621, 00:051C x6385500, 00:0520 x5108777, 00:05AB x60, 00:05AE x76 … |
| 1F | 00:039C x14, 00:045D x66, 00:0469 x13433, 00:051C x2919177, 00:0520 x3467894, 00:05AB x60 … |
| 20 | 00:03A9 x119616, 00:045D x106490, 00:0469 x75108, 00:051C x1459337, 00:0520 x729916, 00:05AB x212 … |
| 21 | 00:03A9 x50886, 00:045D x1825481, 00:0469 x32643, 00:051C x186055, 00:0520 x731086, 00:05AB x148 … |
| 22 | 00:045D x44003, 00:0469 x21538, 00:051C x190145, 00:0520 x190833, 00:05AB x124, 00:05AE x128 … |
| 23 | 00:039C x35, 00:045D x57212, 00:0469 x27270, 00:051C x731110, 00:0520 x732008, 00:05AB x120 … |
| 24 | 00:045D x139724, 00:0469 x10203, 00:051C x912763, 00:0520 x2553959, 00:05AB x56, 00:05AE x44 … |
| 25 | 00:03A9 x922, 00:045D x137151, 00:0469 x16764, 00:051C x548346, 00:0520 x911990, 00:0593 x337 … |
| 26 | 00:045D x236042, 00:0469 x19722, 00:051C x729962, 00:0520 x730852, 00:05AB x88, 00:05AE x116 … |
| 27 | 00:045D x1449091, 00:0469 x19269, 00:051C x186144, 00:0520 x1681, 00:05AB x100, 00:05AE x80 … |
| 28 | 00:039C x3, 00:045D x21788, 00:0469 x19905, 00:051C x365822, 00:0520 x913604, 00:05AB x104 … |
| 29 | 00:045D x467, 00:0469 x8399, 00:051C x366590, 00:0520 x549764, 00:05AB x64, 00:05AE x56 … |
| 2A | 00:039C x495, 00:045D x1510, 00:0469 x50967, 00:051C x1098200, 00:0520 x551142, 00:05AB x324 … |
| 2B | 00:045D x362, 00:0469 x8788, 00:051C x3572, 00:0520 x368594, 00:05AB x60, 00:05AE x52 … |
| 2C | 00:039C x2, 00:045D x23679, 00:0469 x8459, 00:051C x734114, 00:0520 x553332, 00:05AB x52 … |
| 2D | 00:039C x1, 00:045D x26235, 00:0469 x9917, 00:051C x551234, 00:0520 x551173, 00:05AB x64 … |
| 2E | 00:045D x8544, 00:0469 x9179, 00:051C x4381788, 00:0520 x4380752, 00:05AB x40, 00:05AE x64 … |
| 2F | 00:039C x34, 00:045D x7743, 00:0469 x16775, 00:051C x913724, 00:0520 x731911, 00:05AB x92 … |
| 30 | 00:039C x224200, 00:045D x2518, 00:0469 x39502, 00:051C x191576, 00:0520 x9705, 00:05AB x120 … |
| 31 | 00:039C x4, 00:03A9 x119141, 00:045D x25769, 00:0469 x23672, 00:051C x11256, 00:0520 x192167 … |
| 32 | 00:039C x174420, 00:045D x938, 00:0469 x16643, 00:051C x191455, 00:0520 x189387, 00:05AB x132 … |
| 33 | 00:039C x4, 00:045D x412, 00:0469 x12463, 00:051C x1286751, 00:0520 x1289674, 00:05AB x52 … |
| 34 | 00:039C x10, 00:045D x23451, 00:0469 x13233, 00:0493 x28288, 00:0500 x3332, 00:051C x4330 … |
| 35 | 00:039C x94732, 00:045D x28094, 00:0469 x19330, 00:0493 x31060, 00:0500 x2763, 00:051C x1650453 … |
| 36 | 00:045D x305660, 00:0469 x8507, 00:051C x187116, 00:0520 x1464661, 00:05AB x52, 00:05AE x44 … |
| 37 | 00:039C x19, 00:045D x911, 00:0469 x13158, 00:051C x555138, 00:0520 x919893, 00:05AB x56 … |
| 38 | 00:039C x2, 00:045D x598, 00:0469 x10395, 00:051C x186681, 00:0520 x733121, 00:05AB x32 … |
| 39 | 00:039C x22, 00:045D x318, 00:0469 x8676, 00:051C x916917, 00:0520 x552736, 00:05AB x48 … |
| 3A | 00:039C x127, 00:045D x221, 00:0469 x22213, 00:051C x184839, 00:0520 x730575, 00:05AB x160 … |
| 3B | 00:039C x1, 00:045D x69, 00:0469 x8344, 00:051C x370038, 00:0520 x369644, 00:05AB x40 … |
| 3C | 00:045D x106121, 00:0469 x12187, 00:051C x1825161, 00:0520 x1642699, 00:05AB x60, 00:05AE x52 … |
| 3D | 00:039C x6, 00:045D x132, 00:0469 x11895, 00:051C x3107245, 00:0520 x2745769, 00:05AB x44 … |
| 3E | 00:039C x7446, 00:03A9 x37155, 00:045D x1307, 00:0469 x44013, 00:0475 x17, 00:0493 x1308 … |
| 3F | 00:039C x331, 00:03A9 x273687, 00:045D x96375, 00:0469 x98676, 00:051C x1466988, 00:0520 x917101 … |

### 6b. Call sites that selected each D1 data bank (level 0 = nearest `call` on the stack when the bank register was written)

| bank | call sites (caller bank:pc, count, organic count) |
|---|---|
| 2B | 00:0AD7 x16595 (0); 00:2F2D x1708 (0); 00:0333 x291 (291); 04:5910 x284 (284); 04:591E x283 (283); 00:020D x278 (0); 04:5A9D x270 (266); 00:021D x42 (0) … |
| 2D | 04:5A9D x14374 (2990); 00:2F2D x2500 (0); 04:58DE x1916 (1908); 00:020D x501 (0); 00:0333 x309 (293); 00:0AD7 x263 (0); 00:021D x76 (0); 07:5F35 x24 (0) … |
| 2E | 04:58DE x2378 (2338); 00:2F2D x2076 (0); 04:5A9D x1423 (1413); 00:0333 x503 (37); 00:0AD7 x488 (0); 00:020D x335 (0); 00:02AB x94 (0); 00:5D3D x57 (0) … |
| 30 | 00:0AD7 x23949 (0); 00:02AB x17394 (0); 00:2F2D x9090 (0); 00:020D x1833 (0); 00:021D x904 (0); 04:58DE x746 (642); 04:5A9D x650 (626); 00:0333 x261 (0) … |
| 31 | 08:5474 x23834 (429); 00:2F2D x5468 (0); 00:0333 x1676 (832); 08:5400 x1577 (779); 00:020D x1001 (0); 00:0AD7 x555 (0); 00:02AB x264 (61); 00:31BB x240 (0) … |
| 32 | 00:2F2D x4002 (0); 00:31BB x840 (0); 00:020D x706 (0); 08:5400 x474 (388); 00:0333 x467 (379); 00:34EF x308 (0); 00:319C x272 (0); 08:5474 x248 (224) … |
| 33 | 00:2F2D x2722 (0); 00:020D x408 (0); 00:0333 x345 (294); 08:5400 x330 (279); 00:0AD7 x257 (0); 08:5474 x212 (204); 00:021D x40 (0); 08:54B9 x32 (32) … |
| 34 | 08:5079 x18285 (1578); 08:5055 x13477 (1557); 00:2F2D x3026 (0); 00:31BB x1512 (0); 00:0333 x1491 (1210); 00:319C x1392 (0); 00:020D x558 (0); 08:50C1 x443 (395) … |
| 35 | 08:5079 x28268 (1822); 08:5055 x25131 (1818); 00:2F2D x4746 (0); 00:0333 x2009 (1737); 00:020D x837 (0); 08:50C1 x752 (653); 08:509D x751 (652); 00:31BB x656 (576) … |
| 37 | 00:2F2D x2984 (0); 04:4469 x1076 (726); 00:0333 x752 (361); 00:0AD7 x508 (0); 00:020D x507 (0); 04:43EF x319 (235); 04:43D4 x249 (181); 06:5CFF x184 (160) … |
| 3A | 00:31B4 x6524 (6524); 00:2F2D x5548 (0); 00:31BB x2048 (2048); 00:020D x1085 (0); 04:4469 x796 (684); 00:0333 x572 (484); 00:0AD7 x421 (0); 04:43EF x229 (201) … |
| 3B | 00:2F2D x1728 (0); 00:31B4 x1680 (1680); 04:4469 x792 (792); 00:0333 x540 (540); 00:0AD7 x509 (0); 00:020D x292 (0); 04:43EF x174 (174); 04:43D4 x121 (121) … |
| 3C | 00:0333 x194092 (16520); 02:4CFF x68208 (2259); 03:5C60 x11223 (651); 03:5C0A x4012 (2448); 03:5BF4 x3009 (1836); 00:2F2D x2738 (0); 00:0AD7 x762 (0); 04:4469 x694 (694) … |
| 3D | 00:0AD7 x8031 (0); 00:2F2D x2676 (0); 04:4469 x588 (588); 00:31B4 x560 (560); 00:020D x535 (0); 00:0333 x486 (439); 04:43EF x233 (233); 00:193D x205 (0) … |

## 7. Code executed from RAM/HRAM

FF80, FF81, FF82, FF83, FF84, FF85, FF86, FF87, FF88, FF89
