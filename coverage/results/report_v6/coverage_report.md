# Coverage report (merged from 1 checkpoint(s))

Executed ROM bytes (opcode+operand): **108854**; ROM bytes read as data: **909137**; RAM addresses executed: **16**

Static trace: 60449 instruction starts, 117627 code bytes, 1256 table-word bytes.

## 1. Traced instructions executed, per bank

| bank | traced instr | executed (any) | % | organic (inputs only) | forced-state only | never | traced code bytes |
|---|---|---|---|---|---|---|---|
| 00 | 6800 | 6016 | 88.5 | 5324 (78.3%) | 692 | 784 | 11896 |
| 02 | 2467 | 2352 | 95.3 | 2037 (82.6%) | 315 | 115 | 4520 |
| 03 | 7324 | 6760 | 92.3 | 6551 (89.4%) | 209 | 564 | 14701 |
| 04 | 6615 | 6063 | 91.7 | 5938 (89.8%) | 125 | 552 | 13474 |
| 05 | 7233 | 6498 | 89.8 | 3628 (50.2%) | 2870 | 735 | 14798 |
| 06 | 6466 | 6355 | 98.3 | 6297 (97.4%) | 58 | 111 | 12834 |
| 07 | 6509 | 6032 | 92.7 | 4716 (72.5%) | 1316 | 477 | 13639 |
| 08 | 2758 | 2656 | 96.3 | 2639 (95.7%) | 17 | 102 | 5658 |
| 09 | 5367 | 4756 | 88.6 | 4592 (85.6%) | 164 | 611 | 10971 |
| 0A | 6778 | 6493 | 95.8 | 4363 (64.4%) | 2130 | 285 | 11091 |
| 1F | 2132 | 1954 | 91.7 | 1777 (83.3%) | 177 | 178 | 4045 |
| **all** | 60449 | 55935 | 92.5 | 47862 (79.2%) | 8073 | 4514 | |

*organic* = reached by button input only from a real save (no memory pokes in the lineage); *forced-state only* = executed only after a run poked a RAM variable to satisfy/flip a logged exit condition or forced a mode (reachability not proven). Forced-state runs that left the known code were discarded, so the forced-state set contains no executed opcode outside the trace by construction.

## 2. Organically executed opcodes NOT at a traced instruction start

Total 0: 0 fall inside a traced instruction (mis-aligned entry / overlapping code), 0 are outside any traced code (tracer gaps).

## 3. Static roots (extra_roots.json): executed or not

74 roots executed (32 organically), 60 never executed.

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
| 00:03F0 | **no** | OAM-DMA stub: 10-byte image copied by 00:03E2 into HRAM $FF80 and run by `call $FF80` (00:02A7); ROM address of the image |
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

240 runs total, 82 of >=16 bytes; bytes in never-executed traced instructions: 4514

## 5. ROM bytes read as data (outside traced code)

814930 bytes in total.

Extents (gap<=16): 967, written to data_extents.csv.

| bank | data-read bytes | extents | traced-code bytes | untraced&unread bytes |
|---|---|---|---|---|
| 00 | 4488 | 27 | 11896 | 0 |
| 01 | 16131 | 1 | 0 | 253 |
| 02 | 11864 | 7 | 4520 | 0 |
| 03 | 1681 | 42 | 14701 | 2 |
| 04 | 2867 | 41 | 13474 | 43 |
| 05 | 1460 | 53 | 14798 | 126 |
| 06 | 3547 | 43 | 12834 | 3 |
| 07 | 2718 | 54 | 13639 | 27 |
| 08 | 10499 | 25 | 5658 | 227 |
| 09 | 5380 | 51 | 10971 | 33 |
| 0A | 5293 | 3 | 11091 | 0 |
| 0B | 119 | 47 | 0 | 16265 |
| 0C | 15220 | 16 | 0 | 1164 |
| 0D | 15478 | 10 | 0 | 906 |
| 0E | 15114 | 6 | 0 | 1270 |
| 0F | 16384 | 1 | 0 | 0 |
| 10 | 11644 | 45 | 0 | 4740 |
| 11 | 16290 | 1 | 0 | 94 |
| 12 | 16384 | 1 | 0 | 0 |
| 13 | 16384 | 1 | 0 | 0 |
| 14 | 14273 | 8 | 0 | 2111 |
| 15 | 15838 | 5 | 0 | 546 |
| 16 | 16384 | 1 | 0 | 0 |
| 17 | 12408 | 27 | 0 | 3976 |
| 18 | 16384 | 1 | 0 | 0 |
| 19 | 13676 | 47 | 0 | 2708 |
| 1A | 16069 | 3 | 0 | 315 |
| 1B | 16051 | 4 | 0 | 333 |
| 1C | 15102 | 25 | 0 | 1282 |
| 1D | 16384 | 1 | 0 | 0 |
| 1E | 15595 | 11 | 0 | 789 |
| 1F | 12324 | 65 | 4045 | 15 |
| 20 | 16384 | 1 | 0 | 0 |
| 21 | 16384 | 1 | 0 | 0 |
| 22 | 16383 | 1 | 0 | 1 |
| 23 | 16158 | 1 | 0 | 226 |
| 24 | 16019 | 1 | 0 | 365 |
| 25 | 15249 | 12 | 0 | 1135 |
| 26 | 14845 | 9 | 0 | 1539 |
| 27 | 15747 | 12 | 0 | 637 |
| 28 | 12449 | 10 | 0 | 3935 |
| 29 | 7942 | 8 | 0 | 8442 |
| 2A | 12361 | 59 | 0 | 4023 |
| 2B | 1234 | 27 | 0 | 15150 |
| 2C | 13975 | 43 | 0 | 2409 |
| 2D | 15572 | 7 | 0 | 812 |
| 2E | 16384 | 1 | 0 | 0 |
| 2F | 11205 | 7 | 0 | 5179 |
| 30 | 16384 | 1 | 0 | 0 |
| 31 | 15574 | 2 | 0 | 810 |
| 32 | 11398 | 9 | 0 | 4986 |
| 33 | 6935 | 15 | 0 | 9449 |
| 34 | 15940 | 11 | 0 | 444 |
| 35 | 15194 | 4 | 0 | 1190 |
| 36 | 16384 | 1 | 0 | 0 |
| 37 | 16097 | 4 | 0 | 287 |
| 38 | 16096 | 4 | 0 | 288 |
| 39 | 16212 | 1 | 0 | 172 |
| 3A | 16168 | 3 | 0 | 216 |
| 3B | 6797 | 1 | 0 | 9587 |
| 3C | 9048 | 35 | 0 | 7336 |
| 3D | 16211 | 1 | 0 | 173 |
| 3E | 16384 | 1 | 0 | 0 |
| 3F | 16384 | 1 | 0 | 0 |

## 6. ROM bank selection

Banks selected at least once: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F 20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F

Banks selected organically: 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F 20 21 22 23 24 25 26 27 28 29 2A 2C 2D 2E 2F 30 31 32 33 34 35 36 37 38 39 3A 3B 3C 3D 3E 3F

Banks never selected: 

D1 banks (no static reference): 2B:19 site(s), 0 organic, 2D:21 site(s), 3 organic, 2E:20 site(s), 3 organic, 30:28 site(s), 2 organic, 31:24 site(s), 4 organic, 32:24 site(s), 3 organic, 33:18 site(s), 3 organic, 34:27 site(s), 5 organic, 35:26 site(s), 5 organic, 37:24 site(s), 3 organic, 3A:25 site(s), 3 organic, 3B:24 site(s), 1 organic, 3C:23 site(s), 4 organic, 3D:29 site(s), 3 organic

| new bank | sites (writer bank:pc xcount) |
|---|---|
| 00 | 00:039C x3888952, 00:03A9 x192254462, 00:045D x2475, 00:0469 x76446, 00:0475 x81988, 00:0593 x16 … |
| 01 | 00:0191 x13492, 00:0231 x3506, 00:03A9 x19964, 00:045D x10, 00:0469 x9541, 00:05AB x260 … |
| 02 | 00:03A9 x5766, 00:045D x17, 00:0469 x6481, 00:0475 x111548, 00:05AB x188, 00:05AE x120 … |
| 03 | 00:039C x32770821, 00:03A9 x9642, 00:045D x2, 00:0469 x5817, 00:0475 x230227, 00:05AB x136 … |
| 04 | 00:039C x59106628, 00:045D x21194, 00:0469 x5469, 00:0475 x321320, 00:05AB x124, 00:05AE x112 … |
| 05 | 00:039C x8014576, 00:0469 x4824, 00:0475 x1195364, 00:05AB x108, 00:05AE x112, 00:05B1 x112 … |
| 06 | 00:039C x20261079, 00:0469 x5650, 00:0475 x1563581, 00:05AB x176, 00:05AE x112, 00:05B1 x116 … |
| 07 | 00:039C x33387648, 00:03A9 x1391, 00:045D x4, 00:0469 x3854, 00:0475 x1161074, 00:05AB x68 … |
| 08 | 00:039C x16073183, 00:0469 x5238, 00:0475 x1934197, 00:04EF x56606, 00:057B x4664, 00:05AB x140 … |
| 09 | 00:039C x18928658, 00:03A9 x5046, 00:0469 x5837, 00:0475 x331592, 00:05AB x136, 00:05AE x120 … |
| 0A | 00:0469 x2675, 00:0475 x640, 00:05AB x72, 00:05AE x88, 00:05B1 x36, 00:05B4 x44 … |
| 0B | 00:0469 x8921, 00:05AB x260, 00:05AE x212, 00:05B1 x248, 00:05B4 x168, 00:062D x776 … |
| 0C | 00:045D x135831, 00:0469 x2463, 00:05AB x52, 00:05AE x48, 00:05B1 x44, 00:05B4 x64 … |
| 0D | 00:045D x65353, 00:0469 x7338, 00:05AB x188, 00:05AE x132, 00:05B1 x172, 00:05B4 x160 … |
| 0E | 00:045D x1495, 00:0469 x3062, 00:0593 x666, 00:05AB x68, 00:05AE x56, 00:05B1 x84 … |
| 0F | 00:045D x70818, 00:0469 x9786, 00:0593 x6706, 00:05AB x276, 00:05AE x80, 00:05B1 x356 … |
| 10 | 00:03A9 x5874, 00:045D x7873, 00:0469 x7447, 00:0500 x48, 00:0593 x147688, 00:05AB x80 … |
| 11 | 00:03A9 x736, 00:045D x120723, 00:0469 x5334, 00:05AB x144, 00:05AE x140, 00:05B1 x68 … |
| 12 | 00:045D x44682, 00:0469 x4857, 00:05AB x132, 00:05AE x104, 00:05B1 x96, 00:05B4 x96 … |
| 13 | 00:039C x2, 00:045D x61842, 00:0469 x4586, 00:05AB x124, 00:05AE x80, 00:05B1 x136 … |
| 14 | 00:045D x32871, 00:0469 x3397, 00:05AB x92, 00:05AE x64, 00:05B1 x88, 00:05B4 x68 … |
| 15 | 00:045D x638727, 00:0469 x5413, 00:05AB x184, 00:05AE x120, 00:05B1 x124, 00:05B4 x76 … |
| 16 | 00:039C x90, 00:045D x238440, 00:0469 x3305, 00:05AB x100, 00:05AE x88, 00:05B1 x88 … |
| 17 | 00:045D x974320, 00:0469 x3169, 00:05AB x104, 00:05AE x64, 00:05B1 x116, 00:05B4 x40 … |
| 18 | 00:045D x100961, 00:0469 x4328, 00:05AB x88, 00:05AE x108, 00:05B1 x80, 00:05B4 x116 … |
| 19 | 00:045D x5562, 00:0469 x3094, 00:05AB x88, 00:05AE x72, 00:05B1 x64, 00:05B4 x60 … |
| 1A | 00:045D x13473, 00:0469 x2956, 00:05AB x92, 00:05AE x64, 00:05B1 x60, 00:05B4 x60 … |
| 1B | 00:039C x5, 00:045D x31182, 00:0469 x5958, 00:0593 x1096, 00:05AB x132, 00:05AE x128 … |
| 1C | 00:045D x17533, 00:0469 x8008, 00:05AB x192, 00:05AE x216, 00:05B1 x260, 00:05B4 x228 … |
| 1D | 00:039C x1, 00:045D x8867, 00:0469 x2743, 00:05AB x72, 00:05AE x76, 00:05B1 x72 … |
| 1E | 00:045D x289125, 00:0469 x3234, 00:05AB x60, 00:05AE x76, 00:05B1 x92, 00:05B4 x52 … |
| 1F | 00:045D x14, 00:0469 x3303, 00:05AB x60, 00:05AE x44, 00:05B1 x120, 00:05B4 x60 … |
| 20 | 00:03A9 x3026, 00:045D x94056, 00:0469 x16795, 00:05AB x212, 00:05AE x396, 00:05B1 x204 … |
| 21 | 00:045D x1560811, 00:0469 x7931, 00:05AB x148, 00:05AE x192, 00:05B1 x124, 00:05B4 x228 … |
| 22 | 00:045D x35615, 00:0469 x5305, 00:05AB x124, 00:05AE x128, 00:05B1 x84, 00:05B4 x116 … |
| 23 | 00:039C x16, 00:045D x45932, 00:0469 x6520, 00:05AB x120, 00:05AE x164, 00:05B1 x160 … |
| 24 | 00:045D x120379, 00:0469 x2558, 00:05AB x56, 00:05AE x44, 00:05B1 x36, 00:05B4 x56 … |
| 25 | 00:03A9 x922, 00:045D x118930, 00:0469 x3940, 00:0593 x337, 00:05AB x116, 00:05AE x92 … |
| 26 | 00:045D x205473, 00:0469 x4673, 00:05AB x88, 00:05AE x116, 00:05B1 x136, 00:05B4 x96 … |
| 27 | 00:045D x1154582, 00:0469 x4620, 00:05AB x100, 00:05AE x80, 00:05B1 x132, 00:05B4 x100 … |
| 28 | 00:045D x18085, 00:0469 x4554, 00:05AB x104, 00:05AE x96, 00:05B1 x92, 00:05B4 x144 … |
| 29 | 00:045D x260, 00:0469 x1998, 00:05AB x64, 00:05AE x56, 00:05B1 x32, 00:05B4 x32 … |
| 2A | 00:039C x452, 00:045D x1171, 00:0469 x11227, 00:05AB x324, 00:05AE x320, 00:05B1 x268 … |
| 2B | 00:045D x4, 00:0469 x2094, 00:05AB x60, 00:05AE x52, 00:05B1 x44, 00:05B4 x8 … |
| 2C | 00:045D x21821, 00:0469 x2123, 00:05AB x52, 00:05AE x40, 00:05B1 x40, 00:05B4 x44 … |
| 2D | 00:039C x1, 00:045D x24448, 00:0469 x2529, 00:05AB x64, 00:05AE x68, 00:05B1 x64 … |
| 2E | 00:045D x7564, 00:0469 x2264, 00:05AB x40, 00:05AE x64, 00:05B1 x60, 00:05B4 x36 … |
| 2F | 00:045D x6834, 00:0469 x3934, 00:05AB x92, 00:05AE x80, 00:05B1 x140, 00:05B4 x52 … |
| 30 | 00:039C x14, 00:045D x1987, 00:0469 x8775, 00:05AB x120, 00:05AE x324, 00:05B1 x148 … |
| 31 | 00:039C x4, 00:045D x25382, 00:0469 x5602, 00:05AB x136, 00:05AE x136, 00:05B1 x104 … |
| 32 | 00:039C x22, 00:045D x663, 00:0469 x4142, 00:05AB x132, 00:05AE x96, 00:05B1 x88 … |
| 33 | 00:045D x243, 00:0469 x3237, 00:05AB x52, 00:05AE x68, 00:05B1 x112, 00:05B4 x36 … |
| 34 | 00:039C x2, 00:045D x21165, 00:0469 x3383, 00:0493 x26001, 00:0500 x2251, 00:05AB x52 … |
| 35 | 00:045D x27162, 00:0469 x4487, 00:0493 x30357, 00:0500 x2359, 00:05AB x128, 00:05AE x144 … |
| 36 | 00:045D x303091, 00:0469 x2045, 00:05AB x52, 00:05AE x44, 00:05B1 x52, 00:05B4 x24 … |
| 37 | 00:039C x14, 00:045D x678, 00:0469 x3311, 00:05AB x56, 00:05AE x76, 00:05B1 x124 … |
| 38 | 00:045D x411, 00:0469 x2709, 00:05AB x32, 00:05AE x24, 00:05B1 x80, 00:05B4 x72 … |
| 39 | 00:045D x201, 00:0469 x2251, 00:05AB x48, 00:05AE x48, 00:05B1 x68, 00:05B4 x28 … |
| 3A | 00:039C x18, 00:045D x127, 00:0469 x5187, 00:05AB x160, 00:05AE x128, 00:05B1 x116 … |
| 3B | 00:045D x8, 00:0469 x2133, 00:05AB x40, 00:05AE x48, 00:05B1 x72, 00:05B4 x16 … |
| 3C | 00:045D x105369, 00:0469 x3046, 00:05AB x60, 00:05AE x52, 00:05B1 x96, 00:05B4 x52 … |
| 3D | 00:039C x4, 00:045D x39, 00:0469 x2820, 00:05AB x44, 00:05AE x52, 00:05B1 x116 … |
| 3E | 00:039C x42, 00:045D x282, 00:0469 x10575, 00:0493 x268, 00:0500 x10, 00:05AB x224 … |
| 3F | 00:039C x42, 00:03A9 x249239, 00:045D x85162, 00:0469 x36490, 00:0593 x4, 00:05AB x164 … |

### 6b. Call sites that selected each D1 data bank (level 0 = nearest `call` on the stack when the bank register was written)

| bank | call sites (caller bank:pc, count, organic count) |
|---|---|
| 2B | 00:0AD7 x16595 (0); 00:2F2D x1708 (0); 00:020D x278 (0); 00:021D x42 (0); 00:1D3D x12 (0); 00:593D x8 (0); 3D:781F x8 (0); 00:0745 x5 (0) … |
| 2D | 04:5A9D x12896 (1512); 00:2F2D x2500 (0); 04:58DE x1001 (993); 00:020D x501 (0); 00:0AD7 x263 (0); 00:0333 x137 (121); 00:021D x76 (0); 07:5F35 x24 (0) … |
| 2E | 00:2F2D x2076 (0); 04:58DE x1370 (1330); 04:5A9D x634 (624); 00:0AD7 x488 (0); 00:0333 x482 (16); 00:020D x335 (0); 00:02AB x94 (0); 00:5D3D x57 (0) … |
| 30 | 00:0AD7 x23949 (0); 00:02AB x17394 (0); 00:2F2D x9090 (0); 00:020D x1833 (0); 00:021D x904 (0); 04:58DE x488 (384); 00:0333 x261 (0); 04:5A9D x224 (200) … |
| 31 | 08:5474 x23591 (186); 00:2F2D x5468 (0); 00:0333 x1433 (589); 08:5400 x1345 (547); 00:020D x1001 (0); 00:0AD7 x555 (0); 00:02AB x253 (50); 00:31BB x240 (0) … |
| 32 | 00:2F2D x4002 (0); 00:31BB x840 (0); 00:020D x706 (0); 08:5400 x334 (248); 00:0333 x328 (240); 00:34EF x308 (0); 00:319C x272 (0); 00:021D x98 (0) … |
| 33 | 00:2F2D x2722 (0); 00:020D x408 (0); 00:0AD7 x257 (0); 00:0333 x155 (104); 08:5400 x147 (96); 08:5474 x50 (42); 00:021D x40 (0); 00:593D x16 (0) … |
| 34 | 08:5079 x17698 (991); 08:5055 x12893 (973); 00:2F2D x3026 (0); 00:31BB x1512 (0); 00:319C x1392 (0); 00:0333 x947 (666); 00:020D x558 (0); 08:50C1 x275 (227) … |
| 35 | 08:5079 x27568 (1122); 08:5055 x24428 (1115); 00:2F2D x4746 (0); 00:0333 x1438 (1166); 00:020D x837 (0); 00:0AD7 x530 (0); 08:50C1 x522 (423); 08:509D x522 (423) … |
| 37 | 00:2F2D x2984 (0); 00:0AD7 x508 (0); 00:020D x507 (0); 00:0333 x392 (1); 04:4469 x354 (4); 06:5CFF x184 (160); 06:5D40 x184 (160); 06:5D2B x184 (160) … |
| 3A | 00:2F2D x5548 (0); 00:31B4 x3948 (3948); 00:020D x1085 (0); 00:0AD7 x421 (0); 00:0333 x287 (199); 00:021D x152 (0); 00:1D3D x130 (0); 04:4469 x112 (0) … |
| 3B | 00:2F2D x1728 (0); 00:0AD7 x509 (0); 00:020D x292 (0); 00:021D x30 (0); 00:011D x28 (0); 06:5D2B x16 (16); 06:5D15 x16 (16); 06:5CFF x16 (16) … |
| 3C | 00:0333 x193830 (16258); 02:4CFF x68100 (2151); 03:5C60 x11211 (639); 03:5C0A x3968 (2404); 03:5BF4 x2976 (1803); 00:2F2D x2738 (0); 00:0AD7 x762 (0); 00:020D x551 (0) … |
| 3D | 00:0AD7 x8031 (0); 00:2F2D x2676 (0); 00:020D x535 (0); 00:193D x205 (0); 00:1D3D x201 (0); 00:0333 x193 (146); 00:021D x66 (0); 3D:781F x64 (0) … |

## 7. Code executed from RAM/HRAM

FF80, FF81, FF82, FF83, FF84, FF85, FF86, FF87, FF88, FF89
