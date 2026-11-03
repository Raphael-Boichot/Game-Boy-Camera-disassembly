# Calibration example saves (camera `CE10245109`, owner 2026-11-02)

128 KB SRAM images of one camera (international ROM), each made by a **factory calibration** started from a save filled with `$AA` (docs §8), then a power cycle (the camera formatted every slot). They hold **no photo**: the 30 slots are empty and RAM bank 0 holds only the last raw capture of the calibration (a binarized frame of sensor noise). Kept as examples by the owner's decision; every other camera save stays out of git.

| file | calibration | vector `$04FF2-$04FFD` | checksum | md5 |
|---|---|---|---|---|
| `CE10245109_calibration_in_dark.sav` | in the dark (normal use afterwards) | `7E 7E 7E 7E 79 79 78 76 73 70 67 68` | `97 25` | `1422cc5359ccea6752c930c3e2c89232` |
| `CE10245109_calibration_in_intense_light.sav` | under an intense light (violent jittering afterwards) | `27 2C 4E 5B 27 33 5D 6D 80 9A BD B3` | `B7 51` | `0155348893a0e255c7d4d8eaa55ab790` |
| `CE10245109_calibration_in_varying_light.sav` | in light that changed during the run (jittering) | `27 2B 4D 7D 77 74 5D 6D 66 49 BC B3` | `FC 52` | `39ce49baeda7c4249b83f499c1cb3f11` |
| `blank_AA_128KB.sav` | none: 131,072 × `$AA`, the starting save (rebuilt: the uploaded copy had been converted to text, every byte replaced by `EF BF BD`) | twelve `$AA` → factory calibration at the next boot | `AA AA` | `be68df46e3cf60b559376a35f9fbb05d` |

In all three calibrated saves the echo at `$11FF2` equals the primary, both checksums are valid, and the tolerance bytes `$04FF0-$04FFF` stay `AA AA` (the calibration does not write them; retail saves hold `1B 13`). Analysis: docs §18.13 (vectors, band references, jitter), §8 (what the fast calibration sanity check would say), §18.15; derived table `../calib_vectors_light_CE10245109.csv` made by `tcrf_check/tools/calib_vector_bands.py`.
