# Never-executed traced code, by gating mechanism

Traced instructions: 60449; never executed: 2867 (5268 bytes, 4.7 %).

Base coverage: all executed code.

| class | components | instructions | bytes | of which forced-executed |
|---|---:|---:|---:|---:|
| GATED | 147 | 1188 | 2268 | 0 |
| TABLE | 48 | 1132 | 2023 | 0 |
| DEAD | 43 | 513 | 917 | 0 |
| RAMCODE | 0 | 0 | 0 | 0 |
| RETADDR | 0 | 0 | 0 | 0 |
| ORPHAN | 2 | 34 | 60 | 0 |

## 40 largest components

| first address | class | instrs | bytes | gating branches / dispatch-table entries |
|---|---|---:|---:|---|
| 04:5E4C | GATED | 254 | 405 | 04:5E4B(ft) |
| 03:657F | TABLE | 252 | 407 | 03:655D[1];03:655D[6];03:655D[7] |
| 05:5EC0 | TABLE | 223 | 412 | 05:5A67[23];05:5A67[24];05:5A67[25];05:5A67[26] |
| 00:1D45 | GATED | 130 | 315 | 00:1DA0(ft) |
| 09:64ED | GATED | 116 | 216 | 09:64EB(ft);09:665C(ft) |
| 08:46A3 | GATED | 87 | 220 | 08:45F5 |
| 05:6670 | TABLE | 73 | 158 | 05:475F[7] |
| 0A:5853 | TABLE | 70 | 87 | 0A:541A[13] effect table |
| 00:0781 | DEAD | 69 | 107 | flow:8;root:1 |
| 03:65B3 | TABLE | 67 | 98 | 03:655D[2] |
| 03:6983 | TABLE | 56 | 106 | 03:655D[10];03:655D[11];03:655D[12];03:655D[13] |
| 03:6901 | TABLE | 52 | 98 | 03:655D[8] |
| 05:71C3 | TABLE | 51 | 105 | 05:48C4[3] |
| 04:7C9D | DEAD | 49 | 90 | call:1;flow:7;root:1 |
| 00:1A7B | GATED | 42 | 80 | 00:1A79(ft) |
| 0A:5E40 | TABLE | 39 | 63 | 0A:541A[45] effect table |
| 0A:6037 | TABLE | 38 | 61 | 0A:541A[51] effect table |
| 0A:60B1 | TABLE | 38 | 61 | 0A:541A[53] effect table |
| 1F:53B9 | DEAD | 37 | 46 | flow:2;root:1 |
| 0A:6704 | TABLE | 35 | 57 | 0A:541A[83] effect table |
| 07:4A4D | DEAD | 32 | 65 | flow:2;root:1 |
| 00:1AEB | DEAD | 30 | 64 | flow:3;root:2 |
| 00:10AC | DEAD | 28 | 36 | root:1 |
| 07:6767 | ORPHAN | 27 | 50 | call:1;flow:1 |
| 03:6801 | TABLE | 25 | 55 | 03:655D[5] |
| 00:069F | DEAD | 24 | 43 | flow:2;root:1 |
| 06:48CB | GATED | 23 | 49 | 06:48AE |
| 03:67D5 | TABLE | 19 | 44 | 03:655D[4] |
| 07:4BEA | DEAD | 19 | 30 | flow:1;root:1 |
| 1F:53E7 | DEAD | 19 | 25 | root:1 |
| 07:4BC3 | DEAD | 17 | 39 | call:2;root:1 |
| 00:05E0 | GATED | 16 | 24 | 00:05D5 |
| 00:2523 | DEAD | 14 | 25 | root:1 |
| 05:517D | GATED | 14 | 31 | 05:517B(ft) |
| 06:71CC | DEAD | 14 | 24 | root:1 |
| 09:6D00 | DEAD | 14 | 18 | flow:1;root:1 |
| 09:721D | DEAD | 14 | 34 | root:1 |
| 00:253C | DEAD | 13 | 23 | root:1 |
| 0A:470D | GATED | 13 | 23 | 0A:470B(ft) |
| 07:6232 | GATED | 12 | 25 | 07:6230(ft) |

## 40 gating branches with the most code behind them

| branch | instr | side | target | instrs reachable | tested variable |
|---|---|---|---|---:|---|
| 04:5E4B | `ret nz` | fallthrough | 04:5E4C | 254 |  |
| 00:1DA0 | `ret z` | fallthrough | 00:1DA1 | 130 | $FFC3 sgb_present |
| 09:665C | `jr nz,$669a` | fallthrough | 09:665E | 114 | $D00D ([0] image-reducer accumulators+11) |
| 08:45F5 | `jp nz,$46a3` | taken | 08:46A3 | 87 | $D806 `print_extra_flag` (bit 0) |
| 00:1A79 | `jr z,$1adc` | fallthrough | 00:1A7B | 42 | $DC27 prn_status |
| 09:64EB | `jr nz,$64f2` | fallthrough | 09:64ED | 34 | $D00D ([0] image-reducer accumulators+11) |
| 06:48AE | `jr nz,$48cb` | taken | 06:48CB | 23 |  |
| 00:05D5 | `jr z,$05e0` | taken | 00:05E0 | 16 |  |
| 05:517B | `jr z,$519c` | fallthrough | 05:517D | 14 | $FF26 NR52 |
| 0A:470B | `jr nz,$4724` | fallthrough | 0A:470D | 13 |  |
| 07:6230 | `jr nz,$624b` | fallthrough | 07:6232 | 12 | $D502 (sprite_anim_frame[15]+2) |
| 03:6262 | `jr z,$627b` | fallthrough | 03:6264 | 11 |  |
| 05:653C | `ret z` | fallthrough | 05:653D | 11 |  |
| 05:7178 | `ret z` | fallthrough | 05:7179 | 11 |  |
| 04:4863 | `jr z,$4877` | fallthrough | 04:4865 | 10 | $FFA2 keys_new |
| 04:491D | `ret z` | fallthrough | 04:491E | 10 | $FFA2 keys_new |
| 04:75C3 | `jr z,$75dd` | fallthrough | 04:75C5 | 9 | $D7C1 border_number |
| 05:542E | `jr nz,$5445` | taken | 05:5445 | 9 | $FFA1 keys_held |
| 05:5432 | `jr nz,$5456` | taken | 05:5456 | 9 | $FFA1 keys_held |
| 05:6033 | `jr c,$603e` | taken | 05:603E | 9 |  |
| 09:6C57 | `jr z,$6c6b` | fallthrough | 09:6C59 | 9 |  |
| 1F:492E | `jr z,$4940` | taken | 1F:4940 | 9 |  |
| 1F:49D9 | `jr z,$49e3` | taken | 1F:49E3 | 9 |  |
| 00:080E | `jr nz,$081f` | fallthrough | 00:0810 | 8 |  |
| 00:1E91 | `ret z` | fallthrough | 00:1E92 | 8 | $FFC4 sgb_mask_active |
| 00:258D | `jr nc,$259e` | fallthrough | 00:258F | 8 |  |
| 03:6532 | `ret z` | fallthrough | 03:6533 | 8 |  |
| 05:496B | `jr z,$497a` | fallthrough | 05:496D | 8 |  |
| 05:49C0 | `jr z,$49cd` | fallthrough | 05:49C2 | 8 |  |
| 05:69A7 | `jr z,$69b9` | fallthrough | 05:69A9 | 8 | $FFA1 keys_held |
| 05:6AF7 | `ret z` | fallthrough | 05:6AF8 | 8 | $FFC8 frame_counter |
| 00:1B23 | `jr z,$1b30` | fallthrough | 00:1B25 | 7 | $DC0D prn_state |
| 03:6298 | `jr z,$62ab` | fallthrough | 03:629A | 7 |  |
| 05:497C | `jr z,$4989` | fallthrough | 05:497E | 7 |  |
| 05:661A | `jr z,$6629` | fallthrough | 05:661C | 7 |  |
| 05:7156 | `jr z,$7165` | fallthrough | 05:7158 | 7 | $FFA2 keys_new |
| 05:7167 | `jr z,$7176` | fallthrough | 05:7169 | 7 |  |
| 09:652B | `jr nz,$6540` | fallthrough | 09:652D | 7 | $D016 ([7] collision mask 0 (silhouette of image A)+22) |
| 09:6545 | `jr nz,$655a` | fallthrough | 09:6547 | 7 | $D01F ([7] collision mask 0 (silhouette of image A)+31) |
| 00:06F4 | `jr nz,$06ca` | fallthrough | 00:06F6 | 6 |  |
