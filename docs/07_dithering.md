[README](../README.md) · [Section index](index.md)

## 7. Dithering pattern selection (high/low)

Traced fully to source. `Cam_BuildDitherMatrix`
(bank $0A `$42BA`) is a *dispatcher*, not itself the ramp builder — it branches three ways on
`$d59c`:

- **`$d59c == 0`** → `Cam_Dither_Flat` (`0A:440C`): writes the **same** 3-byte pattern (`$d583,$d584,$d585`) into
  all 16 register groups uniformly. A **flat/uniform threshold matrix** — effectively no spatial
  dithering, every 2×2 (or however the hardware groups them) cell gets an identical comparator
  value. This is one of the three live-view dither variants (set by the option cross, `06:6753`).
  It is **not** what the boot and calibration test captures use: those fill `$a006-$a035` with
  one flat value through their own inline loops (`0a:4738`, `4783`, `47ba`, `47f1`, `4827`,
  `4885`, `48a2`, `4968` and the three in `Cam_ThresholdConverge`, §18.3).
- **`$d59c == 1`** → `Cam_Dither_RampA` (`0A:4427`): a computed **linear 16-level ramp** from `$d583` in steps of
  `swap($d584-$d583)`, written across the matrix in the interleaved group order I found last
  session (not simple ascending order — matches the hardware's expected scan order for the 4×4
  comparator block).
- **else (≥2, the normal-photo path)** → the fall-through ramp code: same idea as `$d59c==1` but a
  visibly different write order/grouping (`$a006→$a024→$a01e→$a00c→$a015→$a033...` vs the other
  variant's `$a006,$a012,$a009,$a015` grouping) — **not yet fully diffed against variant 1**, but
  clearly a second, distinct interleaving. `$d59c` is set to **1** when the live view is entered
  (and **2** for the SHOOT variants with `$d7e3` = `$0a`, `$0b`, `$15`, `06:5e3e-5e47`), so the
  ordinary live view uses variant 1 and this one is the other two variants' (§18.7). **On screen
  (C, §18.12):** the first option of the option cross (Left key) is labelled ベタぬり with OFF / ON:
  ON = 0 (flat), OFF = 1, or 2 in the three variants named above.
- **Update 2026-10-18 (decoded cell by cell, §18.12; the write orders and the formula are C, the cell geometry is I):** the matrix is 16 cells x 3 bytes, cell n at `$A006 + 3n`. **`$D59C = 1` (`0A:4427`) is a 16-level ramp in 4x4 Bayer order**: the level of cell n (rows of four cells) is `0 12 3 15 / 8 4 11 7 / 2 14 1 13 / 10 6 9 5` (the textbook Bayer matrix, transposed), and byte k of a cell with level r is `a_k + floor(r (a_k+1 - a_k) / 16)` for the four anchors a b c d = `$D583-$D586`. **`$D59C = 2` (the fall-through, `0A:4307`) is not a second ramp order but four levels in 2x2 blocks of cells** (top-left 0, bottom-right 1, bottom-left 2, top-right 3; `a_k + floor(g (a_k+1 - a_k) / 4)`). `$D59C = 0` is the flat fill with the first value of each sequence. So the "2x2 cell" guess above is right for variant 2 only, and "not yet fully diffed against variant 1" is closed. Tool and table: `tcrf_check/tools/sensor_matrix_order.py`, `assets/sensor/dither_matrix_order.csv`.

**Table selection** (which 16-row, 4-bytes/row source table feeds `$d583-$d586`), from
`Cam_BuildDitherMatrix`'s own entry logic — confirmed, all 6 call sites in bank $0A checked:

```
B = $d587 (active gain index)   C = $d59b (CONTRAST setting 1-16, row = C-1)
if B == $d588 (winner of the gain probe, 0-3):   table = $7C20
elif B == $d589 (gain index of band 2, 4 or 5):  table = $7C60
elif B == $08:                                   table = $7C20
else:                                            table = $7C20   (default)
```

So `$7C20` serves bands 0, 1, 3 and 4 and **`$7C60` only while the active gain is `$d589`, i.e. in
band 2** (2-D edge mode, gain index 4 / 5, exposures 55-364 ms, §18.6): `$d589` is 4 or 5 for
every unit, and band 2 is the second band of the live view, not a bright-scene special case. What
band 2 gains from a table of its own is not established (?). The row index is the CONTRAST key
(1-16, default 8): row 1 = `80 8F D0 E6` (thresholds spread over `$80-$E6`), row 8 = `89 92 A2 D2`,
row 16 = `92 92 92 92` (a single flat threshold); all rows of the three tables are in
`tcrf_check/assets/sensor/dither_tables.csv` and no sensor register is written by the key (§18.7).

There is also a **third, completely unreferenced table** at bank $0A `$7CA0` (same shape, 16×4
bytes) — confirmed zero references anywhere in the ROM: genuine unused/leftover data.

---
