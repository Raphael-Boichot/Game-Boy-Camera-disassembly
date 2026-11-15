[README](../README.md) · [Section index](index.md)

## 12. Open questions

Only what is still open; what was answered is in the sections named in the contents. Evidence tags as elsewhere. Settled 2026-11-15: `F34-F35` (an edit leaves it stale, §3.8 / §11.5) and the sound ids (each named by the moment that requests it; the hot-spot picker reaches all 64 entries of its list; four ids are requested by nothing, final: §2.12, §2.14); removed the same day, already closed: the calibration vector (§18.13) and the TCRF open points (`tcrf_check/TCRF_CHECKLIST.md`).

**SRAM** (§3.8, §11.9)
- Who writes `1B 13` in a real camera (the Hello Kitty ROM does, at the end of its SRAM-initialisation routine; the retail ROMs never do), and why the fast calibration sanity check needs two tolerances (27 and 19) for the `AFFC` / `AFFD` pair.

**Sensor and calibration** (§18.9)
- Why the first test capture of the gain probe uses the matrix byte `$D5`; the printing menus (no extra captures seen in BGB, the printer helper was not attached); the SRAM of the recorded unit, to compare with the vector implied by its threshold scans (§18.5).

**Other**
- The open points of the BGB comparison (§16.10, §16.11 "what this walk does not prove", §17).

---
