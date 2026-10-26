[README](../README.md) · [Section index](index.md)

## 9. Masked pixel lines (123–128)

**Numbering.** The raw frame has 128 lines, y = 0-127 (tile rows 0-15, `$A000-$AFFF`, §18.3). "Lines 123-128" counts from 1 and is y = 122-127,
the last six lines: bytes +4 to +15 of each of the 16 tiles of tile row 15, `$AF04-$AF0F`, `$AF14-$AF1F` ... `$AFF4-$AFFF` (flat `.sav` offsets `0x0F04-0x0FFF`). MAME's model has 123 sensor lines,
y = 0-122, and never writes y = 123-127 (§18.12): the two ranges differ by the line y = 122, which is not scene either in the frame measured below (?). The figure below puts these lines next to the pixels the code reads.

**What the code shows (C).** The auto-exposure metering never samples below **y=103** (§5, §10), and the pixel test of the calibration reads only y = 1-4 of tiles 0 and 8 (§18.3):
neither touches the masked lines.

![The 128 x 128 raw frame by increasing SRAM address: the calibration pixels (A, B), the exposure metering reads, the shown area and the saturated lines 123-128](../tcrf_check/assets/sensor/pixel_map_128x128.png)

**What the code cannot show.** The owner observes that these rows read back a constant saturation voltage (the maximum the sensor can return); that is a property
of the M64282FP silicon, not something the firmware does: the firmware stores whatever the sensor returns
at those addresses (?). AntonioND's documentation only says *"the actual sensor image is 128×126 or so"*
and defines a `GBCAM_SENSOR_EXTRA_LINES=8` margin in the emulator sample code, which is a software margin
for the edge-enhancement convolution (neighbour pixels past the visible 112 rows), not necessarily the same
thing as physically masked reference pixels. The header of MAME's `camera.cpp` calls the sensor "128*123
pixel" and its model has 123 sensor lines (`SENSOR_HEIGHT`; §18.12): a second statement of the 123-line
figure, not a measurement, and MAME never writes y = 123-127, so it does not say what the sensor puts
there (?).

**What one real frame shows (C for that frame; `tcrf_check/tools/frame_line_stats.py`, `tcrf_check/assets/sensor/frame_line_stats_owner.csv`).** A full 128 x 128 frame supplied by the owner on 2026-10-20 (an 8-bit readout with 245 grey levels, address 0x0000 = the top left pixel; the picture is not kept in the repository). Lines 123-127 are flat on all 128 pixels: 223-226, standard deviation 0.5-0.6. Line 122 is not scene either: 225 in the left half, a mean of 244.7 in the right half (248 over most of it) while the scene just above reads about 100; line 121 dips to 0 in its right part. The scene clips at the same level: 3,664 of the 15,616 pixels of lines 0-121 (23 %) read 223-226 and 234 read more (highlights). So the saturated lines are y = 122-127, the owner's 123-128 counted from 1, and the flat level (225) is the clipping level of that readout. The top lines 0-7 are ordinary image lines: a mean of 53-56 with no step at line 8 (52-53), and the 12 + 12 pixels of the calibration test read 53-59 (A) and 53-56 (B), like the dark scene around them. Column 0 reads about 25 levels below columns 1-3 on lines 0-12 (29 against 54.5); the pixel test uses columns 1-3 and skips it (I). One frame at an unknown exposure and gain, not the boot's (0.256 ms): it shows what the lines look like, not what the boot test sees.

**What the software path does (C).** The raw 4096-byte (128×128) buffer format is preserved through to the
saved photos: the ROM-baked Album B pictures are full 128×128 dumps, and the same `$1000`-byte copy size is
used when the live `$A000` capture buffer is moved around in bank $006. Nothing crops or discards rows
y = 122-127; whatever the sensor returns there is stored like any other pixel data, and the album and print
screens only show 112 of the 128 rows. A datasheet pointer or probing data would be needed to say more
(whether the game does anything conditional on that region): see §12.

---
