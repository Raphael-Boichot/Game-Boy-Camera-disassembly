[README](../README.md) · [Section index](index.md)

## 10. Auto-exposure: what part of the image, and the full algorithm

**There are two genuinely different sampling mechanisms** in this code, easy to conflate — I did,
last round. Clearing that up:

### A. The pixel test of the gain probe and the offset searches — 12 pixels in the first tile row, NOT the main metering

`Cam_PixelTestHelper` (`0A:4C30`, called from the gain probe and from the offset search `Cam_ORegister_SAR_Search`) reads **four bytes** of the capture buffer at a fixed address (`[DE]`, `[DE+2]`, `[DE+4]`, `[DE+6]` with `DE = $A002` — tile 0, rows 1-4, plane 0 — or `$A082` in the factory routine) and counts the set bits in **columns 1-3 (bits 6-4)** of each byte: **12 pixels** (the test of bit 3 is jumped over at `0A:4C51`). It returns 1 when the count reaches 9 (8 in one pass of the threshold scan). The captures that feed it use a flat matrix, so it is a one-bit comparator read-out of the sensor, not photometry; these pixels lie in the first tile row of the frame buffer, the 8 lines above the 112-line photo (§18.3; the figure of §9 and §18.3 shows them next to the 168 metering reads).

### B. The continuous fine-adjustment loop — the real metering: 168 sparse tile-row reads, centre-weighted

`Cam_PopcountSampleLoop` (`0A:4FBD`), called from `Cam_MainDispatch` (the routine that runs once per live-preview frame) with `DE = $A320` and `BC = 0`, is **not a dense scan of a window**: it makes **168 reads of one tile row each** (2 bytes: plane 0, then plane 1, of an 8-pixel row of a tile; the helper `0A:5091` adds `popcount(plane 0) + 2 × popcount(plane 1)` through the 256-entry popcount table at `$7300`, i.e. the sum of the 2-bit pixel values of the 8 pixels; the larger the sum, the darker the picture). The reads step by 22 or 6 bytes, about one read per tile column and per iteration, the row inside the tile advancing by 3 each time. **Loop 1** is 10 iterations × 12 reads = 120 reads inside the box x 16-119, y 24-103; its running sum is then **doubled** (`sla c ; rl b`, `0A:5036`); **loop 2** is 6 iterations × 8 reads = 48 reads inside the central box x 32-95, y 40-87, added once. So Σ = 2·S₁ + S₂ is a sparse, **centre-weighted** sample (maximum Σ = 2 × 120 × 24 + 48 × 24 = 6,912). The iteration step `+$4F` (`0A:502A`) is `$103` bytes, so every second iteration of loop 1 starts on an **odd address**: 60 of the 120 reads take plane 1 of a row as "plane 0" and plane 0 of the next row as "plane 1" (whether that is intended is not known, ?).

The reads are sparse, not a dense 96×80 crop; the bounding box of the reads (x 16-119, y 24-103) is not an area that is measured. The geometry is read from the ROM bytes by `tcrf_check/tools/sensor_meter_geom.py`. **C in BGB:** the frame buffer of RAM bank 0 left by a live-view run gives Σ = 2 × 1,758 + 895 = 4,411 = `$113B`, exactly the last sum the ROM computed in that run (`assets/sensor/meter_check.txt`), and `L = floor(Σ / D59A)` holds on 236 of 236 dispatches of it.

**Where the reads sit, as BGB logged them (C; `tcrf_check/tools/sensor_meter_reads_bgb.py`, `tcrf_check/assets/sensor/meter_reads_bgb.csv`, `meter_reads_bgb.txt`).** A logging read watchpoint on `$A000-$AFFF` recorded the address register at the two reads of the helper (`0A:5093` plane 0, `0A:509E` plane 1) during a live-view run: 67 complete dispatches, each of them exactly the 168 addresses (120 + 48, plane 1 = address + 1) that the ROM-bytes executor gives, in the same order, all in RAM bank 0. The pattern is **not symmetric left to right**, and this is what the ROM does, not a drawing choice: loop 1 covers the tile columns 2-14 (x 16-119, 13 columns), whose mirror image about the frame centre x 63.5 would be 1-13 (x 8-111); 71 of its 120 reads lie right of the centre and 49 left, the centroid of loop 1 is x 69.6 (loop 2, tile columns 4-11, is centred: x 63.5) and the centroid of the whole sum (loop 1 counted twice) is x 68.6 against 63.5 for the frame. Vertically it is centred (loop 1 y 24-103, centroid 63.5; loop 2 y 40-87). Why the box is shifted by one tile to the right is not known (?). Of the 60 odd-address reads of loop 1, 8 start at byte 15 of a tile, so their second byte is byte 0 of the next tile to the right (the figure draws each read in the tile of its first byte).

### The full algorithm, in readable pseudocode

In the spirit of the prototype's `AKARUSA`/`CNTR2`/`CNTR3` naming — here is the retail routine with
meaningful names, **as established in the sensor-register pass (§18.6)** and checked on a real camera's bus recording
(207 of 207 live steps) and in BGB (2,377 of 2,377 dispatches; bank $0A):

```
# ---- once per live-preview frame, after a capture completes (Cam_MainDispatch, A = $D59A) ----
def Cam_MainDispatch(setpoint):                      # setpoint = D59A, default 84 (the BRIGHTNESS key)
    select_SRAM_bank(0)                              # the frame buffer, not general SRAM
    sigma = 2 * S1 + S2                              # Cam_PopcountSampleLoop 0A:4FBD: 120 + 48 sparse tile-row reads (§B);
                                                     # one read = popcount(plane 0) + 2 * popcount(plane 1) of an 8-pixel row
    level = 0                                        # quotient by repeated subtraction, capped at 159
    while sigma >= setpoint and level < 159:
        sigma -= setpoint; level += 1                # (the remainder is dropped)
    s = ShiftTable[level]                            # 160 bytes at 0A:7B00
    e = D596:D597                                    # sensor registers C1:C0; exposure = e * 16 us
    if level >= 36: e = min(e + (e >> s), 0xFFFF)    # large sum = dark picture -> longer exposure
    else:           e = e - (e >> s)
    # s = 16 (level 35, 36, 37): e >> 16 = 0, no change

    # ---- the band state machine: only the current band's two thresholds are tested ----
    band 0 (reg1 $20,  H-edge):        e >= $0030 -> band 1, e = $0048;      e < $0010 -> e = $0010
    band 1 (reg1 $E0-$E3, 2-D edge):   e >= $1200 -> band 2, e = $0D80;      e < $0031 -> band 0, e = $001F
    band 2 (reg1 $E4/$E5):             e >= $6000 -> band 3, e = $3500;      e < $0800 -> band 1, e = $0B00
    band 3 (reg1 $E8):                 e >= $C000 -> band 4, e = $8500;      e < $2800 -> band 2, e = $4500
    band 4 (reg1 $0A,  positive):      (saturates at $FFFF);                 e < $6000 -> band 3, e = $8C00
    # on a switch: reg1 = band id, reg7 = D5C1+n, reg0 = D5C6+n | $80 (the five boot results), dither matrix rebuilt
    write A002/A003 = e                              # the five registers go out with the next capture start
```

**The correction table** (`0A:7B00`, **160** bytes, not 256): the shifts run 2, 3, 3, 3, 4, … up to 9 at L = 34, are **16 (= no
correction) for L = 35, 36, 37**, are 9 at L = 38 and fall to 5-6 around L = 44-49, 4-5 for L = 50-79 and 3 from L = 80 on. A
shift `s` is a correction of 2^-s of the exposure per frame: 25 % at the extreme (`s` = 2, L = 0, a very bright picture), 12.5 %
for L ≥ 80 (a very dark one), and a **dead band of three levels around the setpoint** with tiny steps (`s` = 9, 0.2 %) just
outside it. **I:** a proportional controller with a dead band, shaped not to hunt. (`tcrf_check/assets/sensor/live_exposure_bands.png` shows the bands and the exposure of a real
live recording.)

The loop samples 168 tile rows of the frame every frame (centre-weighted, §B), divides the pixel sum by the BRIGHTNESS setpoint `$D59A`, corrects the
16-bit exposure by 2^-s of itself and hands over between **five sensor bands** (reg 1 / reg 7 / reg 0 sets, in datasheet terms in
§18.6) when the exposure leaves the band's range. The loop does not compare the measurement with a target taken from the
SRAM calibration vector: the vector does not enter the loop; it only decides, at boot, which offset O each band uses (§6, §18.4).

---
