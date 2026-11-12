[README](../README.md) · [Section index](index.md)

## 12. Open questions

Only what is still open; what was answered is in the sections named in the contents. Evidence tags as elsewhere.

**SRAM** (§3.8, §11.9)
- `F34-F35`: 52 non-zero mismatches among 369 used slots (25 in one save); no code that compares the value was found; `bank0:$16F4` splits it into 4 nibbles for the sound driver (the P.VOICE, §16.30); no screen shows them.
- Who writes `1B 13` in a real camera (the Hello Kitty ROM does, at the end of its SRAM-initialisation routine; the retail ROMs never do), and why the fast calibration sanity check needs two tolerances (27 and 19) for the `AFFC` / `AFFD` pair.

**WRAM / HRAM** (the complete lists are in §2.12)
- The meaning of the individual sound ids. (The printer checksum-retry path that advances `$DC1F:20` by `$0280` is explained by the printer's firmware, which reports a checksum error one packet late: §17.10.)

**Disassembly** (§1.2)

**Sensor and calibration** (§18.9)
- The calibration vector: one black-level reference per register set, so the five live bands join without a visible jump (§18.13, I, with real-camera evidence); the factory calibration needs darkness (a strong light changes it completely, §18.13, C). Closed 2026-11-02: three calibrations of camera `CE10245109` (dark, intense light, varying light) give the bytes; the light records are valid and used, their band references jump by 61-89 units, and the camera jitters violently in changing light (§18.13, C for the bytes and the observation, I for the mechanism).
- Why the first test capture of the gain probe uses the matrix byte `$D5`; the printing menus (no extra captures seen in BGB, the printer helper was not attached); the SRAM of the recorded unit, to compare with the vector implied by its threshold scans (§18.5).

**Other**
- TCRF items that keep an open point (`tcrf_check/TCRF_CHECKLIST.md`, none left: every row is C or I. Settled 2026-11-02: B02 and B03 (heard by the owner in recordings of the two songs), C17 (closed by the owner: the hot-spot editor works on a forced Album B picture, the exit menu of TCRF is not identified), B08 (the unused main-menu tiles are 15:48C0 and the empty box that fills 11:5300-57FF and 15:5200-55FF of the international and Gold ROMs; the Japanese-only tile is the circled X, 15:4480), C04 (STAFF ROLL = the Japanese label of the 4th USER planet), C18 (the third face = picture 2, unchanged), B15 and B17 (closed by the owner); B14, B18, C06, C12 and C16 earlier (§16.29).
- The open points of the BGB comparison (§16.10, §16.11 "what this walk does not prove", §17).

---
