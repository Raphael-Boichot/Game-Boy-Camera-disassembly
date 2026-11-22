# Bus-analyser recordings of the M64282FP register loads (the owner's)

The owner recorded the eight sensor registers as they reached the M64282FP of real cameras, with a logic analyser on the sensor's wires. These workbooks are copied unchanged (2026-11-22, owner's request) from his sensor repository, [Play-with-the-Game-Boy-Camera-Mitsubishi-M64282FP-sensor](https://github.com/Raphael-Boichot/Play-with-the-Game-Boy-Camera-Mitsubishi-M64282FP-sensor), commit `eae460ee9bacb716f38627a81c040a7ef81d1872` (GPL-3.0, like this repository):

* `camera1_2024/`: folder `Research on real camera 2024` (camera 1, the unit of docs §18.4-18.6). The three workbooks of docs §18 are `Search_for_sensor_at_boot.xlsx` (boot), `Calibration_procedure.xlsx` (factory calibration) and `Exposure_strategy_regular_camera_volts.xlsx` (live view); the others are the Hello Kitty and DEBAGAME ROMs on the same unit, a zeroed calibration vector (`00_save`), and the owner's working sheets (`Blank`, `Register_storage`, `Exposure_strategy_regular_camera`).
* `camera2/`: folder `Research on real Camera` (camera 2, an earlier unit; its probe wires are in another order, already handled in the workbooks): boot, two factory resets, normal use, violent exposure changes, and `Sensor_Registers.xlsx`.

Left in the owner's repository, not copied: the raw captures (`.sal`, Saleae Logic; the owner's procedure: open them in Saleae Logic, export the first five channels to CSV, decode with the Matlab / Octave scripts there), the saves (`.sav`: no save is committed here), and the PDF, PNG and JPG illustrations of camera 2.

Decoded here, byte for byte the committed files (checked 2026-11-22):

```bash
python3 tools/jp/sensor_decode.py sensor/recordings/camera1_2024/Search_for_sensor_at_boot.xlsx \
    sensor/recordings/camera1_2024/Calibration_procedure.xlsx \
    sensor/recordings/camera1_2024/Exposure_strategy_regular_camera_volts.xlsx OUT        # -> sensor/{boot,calibration,live}_rows.csv
python3 tools/jp/sensor_more_recordings.py sensor/recordings/camera1_2024 sensor/recordings/camera2 OUT \
    --saves "<clone of the sensor repository>/Research on real camera 2024"                # -> sensor/more_recordings/
```
