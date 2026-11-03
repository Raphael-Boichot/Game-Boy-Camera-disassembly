# Never-executed traced code, by gating mechanism

Traced instructions: 60449; never executed: 12587 (24147 bytes, 20.8 %).

Base coverage: organic execution only; "of which forced" = executed in forced-state runs (pokes / forced modes).

| class | components | instructions | bytes | of which forced-executed |
|---|---:|---:|---:|---:|
| GATED | 329 | 3764 | 7542 | 2384 |
| TABLE | 146 | 8231 | 15578 | 5642 |
| DEAD | 43 | 582 | 1011 | 43 |
| RAMCODE | 1 | 6 | 10 | 0 |
| RETADDR | 1 | 2 | 2 | 2 |
| ORPHAN | 1 | 2 | 4 | 2 |

## 40 largest components

| first address | class | instrs | bytes | gating branches / dispatch-table entries |
|---|---|---:|---:|---|
| 00:080C | TABLE | 1091 | 2375 | 07:4004[11];07:4004[12];07:4004[16];07:4004[20] |
| 05:4925 | TABLE | 571 | 1196 | 05:475F[0];05:475F[1];05:475F[7];05:4806[0] |
| 00:1615 | TABLE | 569 | 1041 | 05:5A67[0];05:5A67[10];05:5A67[11];05:5A67[12] |
| 09:6441 | TABLE | 528 | 1083 | 09:5FE7[11];09:5FE7[12] |
| 05:49BB | GATED | 466 | 952 | 05:67E4(ft);05:6DF8(ft) |
| 05:5EC0 | TABLE | 262 | 467 | 05:5A67[23];05:5A67[24];05:5A67[25];05:5A67[26] |
| 04:5E4C | GATED | 255 | 406 | 04:5E4B(ft) |
| 03:657F | TABLE | 252 | 407 | 03:655D[1];03:655D[6];03:655D[7] |
| 00:2B08 | GATED | 242 | 561 | 00:2AF1;00:2AF8;00:2AFE;00:2B02;00:2B06(ft) |
| 02:4A6B | TABLE | 194 | 327 | call:7;far:1;flow:7 |
| 0A:6411 | TABLE | 192 | 261 | 0A:541A[72] effect table |
| 05:4795 | GATED | 188 | 452 | 05:4793(ft) |
| 0A:5D27 | TABLE | 188 | 257 | 0A:541A[40] effect table |
| 07:45FD | TABLE | 179 | 431 | 07:4004[17];07:4004[9] |
| 04:4D1B | TABLE | 143 | 333 | 04:464D[10] |
| 05:4758 | GATED | 143 | 273 | 05:4757(ft) |
| 00:1D45 | GATED | 130 | 315 | 00:1DA0(ft) |
| 0A:6516 | TABLE | 125 | 192 | 0A:541A[73] effect table;0A:541A[74] effect table;0A:541A[75] effect table;0A:541A[76] effect table |
| 05:553B | GATED | 121 | 239 | 05:5539(ft) |
| 0A:5C80 | TABLE | 120 | 167 | 0A:541A[39] effect table |
| 0A:636A | TABLE | 120 | 167 | 0A:541A[71] effect table |
| 03:66DC | TABLE | 117 | 249 | 03:655D[3] |
| 02:462F | TABLE | 107 | 190 | call:1;far:1;flow:7 |
| 08:45EC | GATED | 92 | 232 | 08:45EA(ft) |
| 07:4759 | TABLE | 81 | 216 | 07:4004[13] |
| 0A:5F39 | TABLE | 79 | 128 | 0A:541A[49] effect table |
| 00:3388 | TABLE | 78 | 185 | 00:3019[6];00:3019[7] |
| 07:44BD | TABLE | 78 | 176 | 07:4004[14];07:4004[5] |
| 0A:5FB9 | TABLE | 78 | 126 | 0A:541A[50] effect table |
| 07:418A | GATED | 75 | 169 | 07:4133 |
| 0A:6617 | TABLE | 73 | 120 | 0A:541A[81] effect table |
| 0A:5BD5 | TABLE | 72 | 101 | 0A:541A[37] effect table |
| 0A:668F | TABLE | 71 | 117 | 0A:541A[82] effect table |
| 0A:5853 | TABLE | 70 | 87 | 0A:541A[13] effect table |
| 00:0781 | DEAD | 69 | 107 | flow:8;root:1 |
| 00:069F | DEAD | 68 | 96 | flow:4;root:1 |
| 03:65B3 | TABLE | 67 | 98 | 03:655D[2] |
| 0A:62B8 | TABLE | 66 | 96 | 0A:541A[69] effect table |
| 05:68B6 | TABLE | 64 | 137 | 05:475F[11] |
| 05:6ECA | TABLE | 64 | 137 | 05:4806[9] |

## 40 gating branches with the most code behind them

| branch | instr | side | target | instrs reachable | tested variable |
|---|---|---|---|---:|---|
| 04:5E4B | `ret nz` | fallthrough | 04:5E4C | 255 |  |
| 00:2AF1 | `jp nz,$2bc6` | taken | 00:2BC6 | 170 | $DC44 lnk_connected |
| 05:4757 | `ret z` | fallthrough | 05:4758 | 143 | $FFA2 keys_new |
| 00:1DA0 | `ret z` | fallthrough | 00:1DA1 | 130 | $FFC3 sgb_present |
| 05:5539 | `jr z,$555f` | fallthrough | 05:553B | 121 | $D8B3 performance-screen control cursor 0..4 |
| 08:45EA | `jr z,$45fe` | fallthrough | 08:45EC | 92 | $D803 `print_job_index` |
| 00:2AF8 | `jr nz,$2b3a` | taken | 00:2B3A | 86 | $DC51 lnk_stage |
| 07:4133 | `jr nz,$418a` | taken | 07:418A | 75 | $D561 photo_count |
| 03:6443 | `jr c,$6450` | taken | 03:6450 | 52 |  |
| 05:540F | `jr z,$5477` | fallthrough | 05:5411 | 51 | $FFA1 keys_held |
| 05:4793 | `jr z,$47f9` | fallthrough | 05:4795 | 44 | $FFA2 keys_new |
| 00:115F | `jr z,$1169` | fallthrough | 00:1161 | 42 |  |
| 00:121B | `jr z,$1225` | fallthrough | 00:121D | 42 |  |
| 00:1A79 | `jr z,$1adc` | fallthrough | 00:1A7B | 42 | $DC27 prn_status |
| 05:452D | `ret z` | fallthrough | 05:452E | 42 |  |
| 09:6393 | `ret z` | fallthrough | 09:6394 | 37 | $D00D ([0] image-reducer accumulators+11) |
| 07:6744 | `jr nc,$6759` | taken | 07:6759 | 35 | $D865 `shoot_boss_hits` |
| 00:12EE | `jr nz,$1313` | taken | 00:1313 | 34 |  |
| 04:759A | `jr z,$75e8` | fallthrough | 04:759C | 32 | $D67E slider_redraw |
| 05:54F1 | `jr nz,$5505` | taken | 05:5505 | 32 | $D8C2 D8C0 saved at Start press |
| 05:54F8 | `jr nc,$5505` | taken | 05:5505 | 32 | $D8C3 Start hold counter |
| 00:3199 | `jr z,$31ae` | fallthrough | 00:319B | 31 |  |
| 05:48EF | `ret z` | fallthrough | 05:48F0 | 30 |  |
| 05:4965 | `ret z` | fallthrough | 05:4966 | 30 |  |
| 05:67E4 | `ret z` | fallthrough | 05:67E5 | 30 | $FFA2 keys_new |
| 05:6DF8 | `ret z` | fallthrough | 05:6DF9 | 30 | $FFA2 keys_new |
| 05:56CB | `jr nz,$56d0` | taken | 05:56D0 | 26 | $D8B9 NR51 mask (channel enables) |
| 07:57E8 | `jr nz,$583a` | taken | 07:583A | 26 | $D818 `shoot_rapid_flag` |
| 00:1A22 | `jr z,$1a48` | fallthrough | 00:1A24 | 24 | $DC0B prn_comp_enable |
| 00:0AF9 | `jr nz,$0b15` | taken | 00:0B15 | 23 |  |
| 06:48AE | `jr nz,$48cb` | taken | 06:48CB | 23 |  |
| 00:07EF | `ret z` | fallthrough | 00:07F0 | 21 | $FFD0 copy_req_flag |
| 00:149B | `jr z,$14e0` | fallthrough | 00:149D | 21 | $D944 (**SOUND I** modulation: depth (0..99), speed (0..99), mode (0..2)+2) |
| 00:1517 | `jr z,$155c` | fallthrough | 00:1519 | 21 | $D989 (**SOUND II** modulation depth, speed, mode+2) |
| 05:5097 | `jr z,$50ad` | fallthrough | 05:5099 | 21 | $D8B2 (animator slots: finished flags (`$D8B2` = slot 3)+3) |
| 06:6BDD | `jr nz,$6c18` | taken | 06:6C18 | 21 |  |
| 00:2B02 | `jr z,$2b20` | taken | 00:2B20 | 20 | $FF01 SB (serial data) |
| 0A:4EA7 | `jr z,$4ed0` | fallthrough | 0A:4EA9 | 20 | $FF8E diff_or_value |
| 02:4D8A | `jr nc,$4db5` | taken | 02:4DB5 | 19 |  |
| 02:4DD9 | `jr nc,$4e0f` | taken | 02:4E0F | 19 |  |
