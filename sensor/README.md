# Sensor: recordings, calibration saves and checks

AI slop, do not trust until human validation.

The image sensor (Mitsubishi M64282FP) as the camera ROMs drive it: real data and the checks made on it, moved here from
`tcrf_check/assets/sensor/` on 2026-11-14 (owner: a topic folder like `link_protocol/`; nothing here is TCRF material). It serves every
camera ROM: the Hello Kitty forced runs use the same calibration routes. The docs are §5-§10 and §18, with the readable guide in
[`docs/19_sensor_guide.md`](../docs/19_sensor_guide.md); the scripts are `tools/jp/sensor_*.py`, `calib_*.py`, `bgb_calib_sanity_check.py`.

* `calibration_saves/`: three real saves of camera CE10245109 calibrated in the dark, in intense light and in varying light (owner), and
  the blank save of 128 KiB of `$AA` that makes the boot run the factory calibration.
* `bgb/`: BGB recordings of the register writes and captures (boot, `$AA` boot, `$FD` / `$FF` boot combos, live view in several lights).
* `more_recordings/`, `dither_variants/`: further captures and the dither tables they gave.
* The csv / txt files: the register sites, calibration rows, dither matrix order, exposure, SAR and meter checks, the 128 x 128 pixel map.
