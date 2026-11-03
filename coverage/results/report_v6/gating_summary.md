# Never-executed traced code, by gating mechanism

Traced instructions: 60449; never executed: 4514 (8773 bytes, 7.5 %).

Base coverage: all executed code.

| class | components | instructions | bytes | of which forced-executed |
|---|---:|---:|---:|---:|
| GATED | 196 | 1620 | 3235 | 0 |
| TABLE | 62 | 2340 | 4547 | 0 |
| DEAD | 43 | 527 | 942 | 0 |
| RAMCODE | 1 | 6 | 10 | 0 |
| RETADDR | 0 | 0 | 0 | 0 |
| ORPHAN | 3 | 21 | 39 | 0 |

## 40 largest components

| first address | class | instrs | bytes | gating branches / dispatch-table entries |
|---|---|---:|---:|---|
| 09:6441 | TABLE | 525 | 1077 | 09:5FE7[11];09:5FE7[12] |
| 05:5EC0 | TABLE | 262 | 467 | 05:5A67[23];05:5A67[24];05:5A67[25];05:5A67[26] |
| 04:5E4C | GATED | 255 | 406 | 04:5E4B(ft) |
| 03:657F | TABLE | 252 | 407 | 03:655D[1];03:655D[6];03:655D[7] |
| 00:2B3A | GATED | 219 | 507 | 00:2AF1;00:2AF8 |
| 07:45FD | TABLE | 179 | 431 | 07:4004[17];07:4004[9] |
| 04:4D1B | TABLE | 143 | 333 | 04:464D[10] |
| 00:1D45 | GATED | 130 | 315 | 00:1DA0(ft) |
| 02:462F | TABLE | 107 | 190 | call:1;far:1;flow:7 |
| 08:46A3 | GATED | 87 | 220 | 08:45F5 |
| 05:6670 | TABLE | 73 | 158 | 05:475F[7] |
| 05:6A82 | TABLE | 71 | 143 | 05:4806[1] |
| 0A:5853 | TABLE | 70 | 87 | 0A:541A[13] effect table |
| 00:0781 | DEAD | 69 | 107 | flow:8;root:1 |
| 03:65B3 | TABLE | 67 | 98 | 03:655D[2] |
| 05:7149 | TABLE | 60 | 122 | 05:48C4[2] |
| 03:6983 | TABLE | 56 | 106 | 03:655D[10];03:655D[11];03:655D[12];03:655D[13] |
| 03:6901 | TABLE | 52 | 98 | 03:655D[8] |
| 05:71C3 | TABLE | 51 | 105 | 05:48C4[3] |
| 04:7C9D | DEAD | 49 | 90 | call:1;flow:7;root:1 |
| 00:1A7B | GATED | 42 | 80 | 00:1A79(ft) |
| 0A:5E40 | TABLE | 39 | 63 | 0A:541A[45] effect table |
| 0A:6037 | TABLE | 38 | 61 | 0A:541A[51] effect table |
| 0A:60B1 | TABLE | 38 | 61 | 0A:541A[53] effect table |
| 1F:53B9 | DEAD | 37 | 46 | flow:2;root:1 |
| 07:6759 | GATED | 35 | 64 | 07:6744 |
| 0A:6704 | TABLE | 35 | 57 | 0A:541A[83] effect table |
| 07:4A4D | DEAD | 32 | 65 | flow:2;root:1 |
| 00:1AEB | DEAD | 30 | 64 | flow:3;root:2 |
| 1F:491B | TABLE | 30 | 57 | 1F:4276[46] sound cmd |
| 1F:53E7 | DEAD | 29 | 40 | flow:1;root:1 |
| 00:10AC | DEAD | 28 | 36 | root:1 |
| 03:6801 | TABLE | 25 | 55 | 03:655D[5] |
| 1F:49C6 | TABLE | 25 | 45 | 1F:4276[50] sound cmd |
| 00:069F | DEAD | 24 | 43 | flow:2;root:1 |
| 07:46CE | GATED | 24 | 54 | 07:46CC(ft) |
| 09:63F8 | GATED | 24 | 55 | 09:63F7(ft) |
| 06:48CB | GATED | 23 | 49 | 06:48AE |
| 03:67D5 | TABLE | 19 | 44 | 03:655D[4] |
| 04:6129 | GATED | 19 | 52 | 04:6115 |

## 40 gating branches with the most code behind them

| branch | instr | side | target | instrs reachable | tested variable |
|---|---|---|---|---:|---|
| 04:5E4B | `ret nz` | fallthrough | 04:5E4C | 255 |  |
| 00:2AF1 | `jp nz,$2bc6` | taken | 00:2BC6 | 160 | $DC44 lnk_connected |
| 00:1DA0 | `ret z` | fallthrough | 00:1DA1 | 130 | $FFC3 sgb_present |
| 08:45F5 | `jp nz,$46a3` | taken | 08:46A3 | 87 | $D806 `print_extra_flag` (bit 0) |
| 00:2AF8 | `jr nz,$2b3a` | taken | 00:2B3A | 86 | $DC51 lnk_stage |
| 00:1A79 | `jr z,$1adc` | fallthrough | 00:1A7B | 42 | $DC27 prn_status |
| 07:6744 | `jr nc,$6759` | taken | 07:6759 | 35 | $D865 `shoot_boss_hits` |
| 07:46CC | `jr z,$46fb` | fallthrough | 07:46CE | 24 | $DC59 lnk_cmd_rx |
| 09:63F7 | `ret c` | fallthrough | 09:63F8 | 24 | $D047 ([7] collision mask 1+7) |
| 06:48AE | `jr nz,$48cb` | taken | 06:48CB | 23 |  |
| 04:6115 | `jr nz,$6129` | taken | 04:6129 | 19 | $D800 `extras_launch_flag` (return-to-mode-4 flag) |
| 0A:427A | `jr c,$42ad` | fallthrough | 0A:427C | 19 |  |
| 00:33F2 | `jr nz,$3404` | taken | 00:3404 | 18 | $DBC5 print_last_page |
| 00:2E1C | `ret z` | fallthrough | 00:2E1D | 17 | $DC43 lnk_turn |
| 07:46FD | `ret z` | fallthrough | 07:46FE | 17 |  |
| 00:05D5 | `jr z,$05e0` | taken | 00:05E0 | 16 |  |
| 09:5CBA | `jr nc,$5cd8` | fallthrough | 09:5CBC | 16 |  |
| 05:517B | `jr z,$519c` | fallthrough | 05:517D | 14 | $FF26 NR52 |
| 07:625D | `ret c` | fallthrough | 07:625E | 14 | $D502 (sprite_anim_frame[15]+2) |
| 00:1E87 | `ret z` | fallthrough | 00:1E88 | 13 | $FFC3 sgb_present |
| 04:485D | `jr nz,$4877` | fallthrough | 04:485F | 13 | $FFA1 keys_held |
| 04:4918 | `ret nz` | fallthrough | 04:4919 | 13 | $FFA1 keys_held |
| 07:584F | `ret z` | fallthrough | 07:5850 | 13 | $FFA1 keys_held |
| 0A:470B | `jr nz,$4724` | fallthrough | 0A:470D | 13 |  |
| 07:6230 | `jr nz,$624b` | fallthrough | 07:6232 | 12 | $D502 (sprite_anim_frame[15]+2) |
| 03:6262 | `jr z,$627b` | fallthrough | 03:6264 | 11 |  |
| 05:653C | `ret z` | fallthrough | 05:653D | 11 |  |
| 07:45A9 | `jr nz,$45c4` | fallthrough | 07:45AB | 11 | $DC4F lnk_half_done |
| 07:4851 | `ret z` | fallthrough | 07:4852 | 11 |  |
| 04:75C3 | `jr z,$75dd` | fallthrough | 04:75C5 | 9 | $D7C1 border_number |
| 05:542E | `jr nz,$5445` | taken | 05:5445 | 9 | $FFA1 keys_held |
| 05:5432 | `jr nz,$5456` | taken | 05:5456 | 9 | $FFA1 keys_held |
| 07:4235 | `jr nz,$424d` | taken | 07:424D | 9 | $D5F5 saved_dc52 |
| 07:4838 | `jr z,$484f` | fallthrough | 07:483A | 9 | $FFA2 keys_new |
| 00:080E | `jr nz,$081f` | fallthrough | 00:0810 | 8 |  |
| 00:258D | `jr nc,$259e` | fallthrough | 00:258F | 8 |  |
| 03:6532 | `ret z` | fallthrough | 03:6533 | 8 |  |
| 04:4819 | `jr c,$482b` | fallthrough | 04:481B | 8 | $D5D8 photo_index |
| 05:496B | `jr z,$497a` | fallthrough | 05:496D | 8 |  |
| 05:49C0 | `jr z,$49cd` | fallthrough | 05:49C2 | 8 |  |
