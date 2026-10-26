[README](../README.md) · [Section index](index.md)

## 11. SRAM structure: evidence from the 33 real saves

The authoritative, human-readable map is §3. This section is the **evidence** behind it: what was checked on
which of the 33 saves in `saves/` (12 from factory-fresh cameras, 21 from used ones), what the numbers are, and what
they cannot show. §11.9 adds 14 cameras dumped together with their own ROM. **Caution on provenance:** the owner's cameras went through injections of synthetic saves, battery replacements and save swaps, so the labels 'fresh' and 'used' describe the state of the SRAM, not a proven history. Everything here is reproducible with `tools/sram_analyze.py`
(`python3 -I tools/sram_analyze.py all saves`; sub-commands `validity`, `classify`, `calib`, `settings`, `f34`).

### 11.1 Protected blocks: checksums and echoes

Rule (`bank2:$432F`): `lo = Σ bytes + $4E`, `hi = XOR bytes ^ $54`, over the data including `Magic`.

| Block | Copies tested | Result |
|---|---|---|
| Settings `$1000` / echo `$10D9` | 33 saves × 2 | **66/66 valid, always byte-identical** |
| Vector `$11B2` / echo `$11D7` | 33 × 2 | **66/66 valid, always identical** |
| Camera-owner block `$2FB8` / echo `$2FD1` | 33 × 2 | 64/66 valid, identical; both bad in `2023-06-01` only |
| Photo tags `F00` / echo `F5C` | 990 slots × 2 | 957 slots: both valid and identical; **3 slots both valid but different** (`2021-05-19_6` slots 5-7: primary `1A`-filled, echo all-zero — a priority test, §3.8); 30 slots both bad (`2023-06-01`); **0 slots with exactly one bad copy** |

Consequence: the "primary wins" rule of §3.6 is *visible* in the data (the 3 slots), but **no save contains a block
with exactly one damaged copy, so the "copy the good one over the bad one" path is known from the code only**.

### 11.2 The never-written area: per-save evidence

"Never-written area" = the 2079 tail bytes of §3.4 (`FB8-FFF` of every slot minus the 81 bytes a retail ROM legitimately
writes). Result: **all 24 saves of untouched cameras (12 fresh + 12 clean used) have 2079/2079 bytes equal to `$AA`**;
the 9 atypical saves (two of them battery-loss saves, `00` fill) are listed with their deviations in §3.8.

| # | Save | Class | Non-`AA` in never-written area (of 2079) | `AA` bytes in Game Face area (of 3584) / flag `10D1` | `01FFC-FFF` | Seed `$02FFF` (position in cycle) | Photos listed / `F34` matches |
|---|---|---|---|---|---|---|---|
| 1 | `001` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 2 | `002` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 3 | `002_2` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 4 | `003` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 5 | `004` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 6 | `005` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 7 | `006` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 8 | `007` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 9 | `008` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 10 | `008_2` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 11 | `009` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 12 | `010` | fresh | 0 | 3584 / 0 | `aaaaaaaa` | `95` (1) | 0 / 0 |
| 13 | `2005_GAMEBOYCAMERA` | **atypical** | 176 | 39 / 1 | `ffff0000` | `95` (1) | 2 / 2 |
| 14 | `2020-05-29 GAMEBOYCAMERA` | clean used | 0 | 72 / 1 | `00390039` | `7A` (6) | 30 / 29 |
| 15 | `2021-05-19_1_POCKETCAMERA` | clean used | 0 | 18 / 1 | `aaaaaaaa` | `17` (3) | 30 / 21 |
| 16 | `2021-05-19_2_POCKETCAMERA` | **battery loss** | 2079 | 0 / 0 | `00565653` | `6B` (2) | 29 / 27 |
| 17 | `2021-05-19_3_POCKETCAMERA` | clean used | 0 | 21 / 1 | `80442a40` | `6E` (4) | 2 / 2 |
| 18 | `2021-05-19_4_POCKETCAMERA` | clean used | 0 | 41 / 1 | `aaaaaaaa` | `FE` (off cycle) | 22 / 22 |
| 19 | `2021-05-19_5_POCKETCAMERA` | clean used | 0 | 72 / 1 | `00390039` | `6E` (4) | 0 / 0 |
| 20 | `2021-05-19_6_POCKETCAMERA` | **atypical** | 2075 | 4 / 0 | `f400d500` | `6B` (2) | 0 / 0 |
| 21 | `2021-06-29 GAMEBOYCAMERA` | clean used | 0 | 11 / 1 | `aaaaaaaa` | `7A` (6) | 18 / 15 |
| 22 | `2021-08-08 GAMEBOYCAMERA` | **atypical** | 176 | 39 / 1 | `ffff0000` | `6E` (4) | 30 / 30 |
| 23 | `2022-02-02 GAMEBOYCAMERA` | clean used | 0 | 15 / 1 | `aaaaaaaa` | `35` (7) | 18 / 18 |
| 24 | `2022-03-05 GAMEBOYCAMERA` | **atypical** | 57 | 61 / 1 | `aaaaaaaa` | `95` (1) | 30 / 0 |
| 25 | `2022-05-03 GAMEBOYCAMERA-0` | clean used | 0 | 1 / 1 | `aaaaaaaa` | `1D` (5) | 27 / 23 |
| 26 | `2022-05-12 GAMEBOYCAMERA` | clean used | 0 | 61 / 1 | `aaaaaaaa` | `35` (7) | 30 / 24 |
| 27 | `2022-08-20 Vinted GAMEBOYCAMERA` | **atypical** | 144 | 138 / 1 | `aaaaaaaa` | `6E` (4) | 0 / 0 |
| 28 | `2022-08-25 Easycash GAMEBOYCAMERA` | clean used | 0 | 51 / 1 | `aaaaaaaa` | `7A` (6) | 30 / 4 |
| 29 | `2023-06-01 GAMEBOYCAMERA-0` | **battery loss** | 2023 | 148 / 1 | `ffffff00` | `00` (blank chip, no boot since) | 0 / 0 |
| 30 | `2023-08-01 Game Boy Camera (USA,EU)` | clean used | 0 | 26 / 1 | `aaaaaaaa` | `95` (1) | 30 / 29 |
| 31 | `2023-09-04 Pocket Camera (JP Rev 1)` | clean used | 0 | 12 / 1 | `aaaaaaaa` | `95` (1) | 30 / 28 |
| 32 | `2024-06-01 GAMEBOYCAMERA` | **atypical** | 2079 | 0 / 0 | `b5daa55a` | `26` (off cycle) | 1 / 1 |
| 33 | `2024-08-28 Pocket Camera (JP Rev 1)` | **atypical** | 2075 | 47 / 1 | `38cd41d7` | `3E` (off cycle) | 10 / 10 |

Reading the columns: *Game Face* — 3584 `AA` bytes = never written (all fresh cameras); 1-72 = a real picture; flag `10D1` = 1 where the
camera stored one. *Photos listed / `F34` matches* — slots the vector lists, and how many of them have `F34-F35` equal to the
(sum, xor) of their photo (§11.5).

### 11.3 Calibration record (slot 3 `FF0-FFF`, slot 16 `FF2-FFF`)

`python3 -I tools/sram_analyze.py calib saves`: **26 saves have an intact record** (`1B 13`, 12-byte vector, checksum `(Σ+$0D, XOR+$23)`
valid, echo identical) — 22 distinct vectors, the duplicates being second dumps of one camera (`002`/`002_2`, `008`/`008_2`,
`2020-05-29`/`2021-05-19_5`, `2022-03-05`/`2022-05-12`). Not intact: the two shifted copies (`2005`, `2021-08-08`: valid at `FEA`, §3.8),
the two battery-loss saves (`2021-05-19_2`, `2023-06-01`: record all `00` / not a valid record), and three damaged files (`2021-05-19_6`, `2024-06-01`, `2024-08-28`).
The vector bytes lie in `$65…$80`. `Cam_CommitVectorToSRAM` (`0a:$4F58`) writes exactly this layout (read from the disassembly:
12 bytes from `$D5B5`, then `Σ+$0D` and `XOR+$23`, first at `$AFF2` in RAM bank 2, then at `$BFF2` in RAM bank 8).

### 11.4 Settings block: which fields and bits are ever used

`python3 -I tools/sram_analyze.py settings saves`, over the 33 saves:

| Field | Values seen | Reading |
|---|---|---|
| `1061 & C0`, `1089 & C0` | `0` in 33/33 | never written (the pack code masks to 2+4 bits) |
| `10A1 & 70` (NOISE envelope bits 6-4) | `0` ×32, `$50` ×1 (`2021-05-19_6`) | field exists; normally 0 |
| `1062 & 70` (SOUND I envelope bits 6-4) | `0` ×25, `$20`, `$30`, `$50` ×3, `$60` ×2, `$70` | used |
| `10B7-10B8` | `0000` ×21, `2B4B` ×7, `A800` ×2, `44A8` ×2, `0040` ×1 | used (NR43 width flag per step, §3.2) |
| `10CD-10CF` | `000000` ×33 | dead bytes |
| `102F` | `00` ×31, `FF` ×2 | animation loop flag |
| `1060` | `00` ×30, `01` ×2, `05` ×1 | animation border |
| `10BA` | `00` ×16 (12 fresh + 4 used), `01` ×17 | "sound preset saved" |
| `10D1` | `00` ×15, `01` ×18 | Game Face present (all 12 clean used cameras: 1; all 12 fresh: 0) |
| `105F` / `10B9` / `10D0` | `$03…$40` / `$32…$F0` / `$0E…$7F` | speed / tempo / print intensity |

Rebuilding the default block from the ROM (`bank2:$4183`: `FE`×47, `00`, `00`×47, `09`, `00`, the 90-byte table at `$41F3`, 21 zeros, `40`, `00`, `Magic`, checksum) gives **exactly** the settings block and echo of all 12 fresh cameras (217 bytes each).

### 11.5 Photo tags: `F12-F14`, `F30-F32`, `F33`, `F34-F35`

`python3 -I tools/sram_analyze.py f34 saves` (population: slots listed by the vector, tag valid): **369 slots in 17 saves**.

| Check | Result |
|---|---|
| `F34-F35` = (Σ, XOR) of the 3584 photo bytes | **285 / 369 match (77 %)**; 32 slots hold `0000` (30 of them = the gb-photo save `2022-03-05`); 52 hold a different non-zero value (25 of them in `2022-08-25 Easycash`) |
| `F12-F14` ≠ 0 | 4 slots, all in `2021-05-19_6` (slots 5-8), always `+0/+1/+1` — the code rule of `$462F` for a female owner (§3.3) |
| `F30-F32` ≠ 0 | 3 slots, same save (the `1A` fill) |
| `F33` = 1 (album copy) | 6 slots, all in `2022-02-02` |

(The two battery-loss saves are in these counts only through `2021-05-19_2`: 29 slots listed, 27 match.) The mismatching `F34` values fit in-camera editing (the editor's save-back `$47C4` rewrites image + thumbnail but not `F34-F35`);
this is plausible, **not proven** for those saves.

### 11.6 Boot seed byte (`$02FFF`)

Predicted by re-implementing `bank0:$091A-$09D3` (`tools/sram_analyze.py: seed_orbit`): `AA → 95 → 6B → 17 → 6E → 1D → 7A → 35 → AA`.
Observed over the 33 saves: `95` ×16 (all 12 fresh cameras + `2005`, `2022-03-05`, `2023-08-01`, `2023-09-04`), `7A` ×3, `6E` ×4, `6B` ×2, `35` ×2,
`17` ×1, `1D` ×1 — **29/33 on the cycle** — and four off it: `FE` (`2021-05-19_4`), `26` and `3E` (two damaged files), `00` (the battery-loss save `2023-06-01`: blank-chip value, the camera never booted after the wipe); the battery-loss save `2021-05-19_2` sits on the cycle (`6B` = 2 boots after the battery change: `00` → `95` → `6B`).
A fresh camera that was powered on once is exactly at `95`, as predicted from `AA`.

### 11.7 CoroCoro tag and the odd `01FFC-01FFF` values

`01FFC-01FFF` = `AAAAAAAA` in 23 saves (12 fresh + 11 used); `00565653` (CoroCoro-looking tag) in the battery-loss save `2021-05-19_2` only; `00390039` in `2020-05-29` and `2021-05-19_5` (one
camera); `80442A40` in `2021-05-19_3`; `FFFF0000` in `2005`/`2021-08-08`; `F400D500`, `FFFFFF00`, `B5DAA55A`, `38CD41D7` in four damaged files.
The only code that touches this range is the bank-8 tolerant check `$72E0` (≥ 2 of 3 bytes of `01FFD-01FFF` equal `56 56 53` ⇒ rewrite the exact
signature). It never creates the tag, so a camera without it stays `AA`.

### 11.8 What the saves cannot tell

- The repair of a block with one bad copy (no such block in the files).
- What wrote the shifted calibration layout of `2005`/`2021-08-08` (not a ROM revision, §11.9).
- Which user action reaches `bank2:$462F` in normal use (only four slots of one experimental save show its effect).
- The origin of the `00 39` and `80 44 2A 40` patterns.

### 11.9 The 14 cameras dumped with their own ROM (October 2026)

The owner supplied, for each of 14 cartridges, a ROM dump (`.sgb`) and an SRAM dump (`.sav`): 11 international units (`CE…`) and 3 Japanese units (`PC…`). Some have a dead battery. `python3 -I tools/sram_analyze.py classify|calib|validity <dir>` was run on the 14 SRAM files; the ROMs were identified by md5 and header. `tools/cameras_summary.py` produces `source/cameras/cameras_summary.csv` (one line per camera: ROM md5, class, seed, owner ID, record), `tools/emu_calib_check.py` the emulator check of point 2.

**Provenance (from the owner).** These cameras have been through many experiments: injections of synthetic saves, battery replacements, save swaps. The SRAM of a cartridge is therefore **not necessarily what its own ROM wrote**, and the owner cannot say what was done to which unit. What the ROM does (code-traced; point 2 emulator-confirmed) is unaffected. Where a pattern *comes from* (factory, injection, swap, battery) is, for every unit below, a hypothesis at best, and the rest of this section is worded accordingly.

**ROMs.** All 11 `CE…` cartridges carry the same ROM, md5 `42d2f65e2549be9d1d126a6828b5d1c1` (title `GAMEBOYCAMERA`, mask-ROM version `$014C` = 0, header checksum `$9D`), byte-identical to the USA/EU ROM used in this README. All 3 `PC…` cartridges carry the JP Rev A (md5 `fdcfe686cf4df461e870b6e53b2b5a8b`, version 1). A ROM downloaded from the internet, `Pocket Camera (J) (V1.1) [S].gb`, is byte-identical to that Rev A (V1.1 is another name for header version 1); so are the two JP ROM files uploaded earlier. Across the 14 cartridges and the 3 downloaded or uploaded copies there is **one international and one Japanese ROM**. That does not prove that no other revision exists, only that none of the 14 units has it.

| Camera | State of the SRAM | Boots since the last reset (seed) | Owner ID | Photos listed | `FF0-FF1` | Calibration record (vector, first bytes) |
|---|---|---|---|---|---|---|
| `CE10000843` | **dead battery**: all blocks invalid, 0 valid tags, 2078 of 2079 never-written bytes non-`AA`, photo area at 7.1 bit/byte (random) | `00` (no inference: the whole chip is random) | - | - | `EA EA` | invalid |
| `CE10866859` | **partly lost**: settings, vector, owner and 30 tags valid, photos with image-like entropy, but the never-written area is non-`AA` (2075 of 2079, biased towards `FF`/`00`/one-bit values) | `35` (7) | `00912730` (point 6) | 30 | `F6 08` | invalid (garbage) |
| `CE10550742` | atypical, **the 2005 camera** (§3.8): shifted record, 176 non-`AA` tail bytes | `7A` (6) | `00912730` | 0 | `7C 7B` (the record is at `FEA`) | `7E 7D 7D 7D 7C 7B 7B 7D…` at `FEC`, valid by the rule, **not read by the ROM** |
| `CE10251329` | used, clean tails | `6E` (4) | `13356735` | 4 | `1B 13` | `00 FF 00 FF…` (14 bytes, same in both copies, checksum invalid) |
| `CE10229233` | used, clean tails | `35` (7) | `33122681` | 27 | `1B 13` | `7C 7B 7E 7C…` valid |
| `CE10238211` | used, clean tails | `95` (1) | `10711523` | 30 | `1B 13` | `7D 7E 7C 7D…` valid |
| `CE10785322` | used, clean tails | `7A` (6) | `46882401` | 20 | `1B 13` | `7C 7E 7D 7E…` valid |
| `PC10696894` | used, clean tails | `1D` (5) | `01436645` | 30 | `1B 13` | `7C 7C 7E 80…` valid |
| `CE10001819` | never-written area untouched, default settings (`99 99…`) | `35` (7) | `77013356` | 9 | `AA AA` | `7D 7E 7D 7D…` valid |
| `CE10063189` | same | `6B` (2) | `77013356` | 0 | `AA AA` | `7E 7E 7E 7D…` valid |
| `CE10517662`, `CE10811537` | same | `17` (3) | `77013356` | 0 | `AA AA` | `7E 7D 7E 7E 7D 7C 7D 7D 7C 7B 78 60` valid, identical in both |
| `PC10584071` | same | `1D` (5) | `77013356` | 2 | `AA AA` | the same vector as the two above |
| `PC10201702` | same | `AA` (0, never booted) | `77013356` | 1 | `AA AA` | `71 72 72 72…` valid |

"Boots" is the position on the boot-seed cycle (§3.3) since the factory state, modulo 8. "Photos listed" counts the used entries of the state vector.

**What these cameras show**

1. **The 2005 camera is `CE10550742`.** Same 12-byte vector, same owner block (`BOICHOT`, ID `00912730`), same 6 stray bytes in the tails; the three files `2005_…`, `2021-08-08` and the 2026 dump are one camera, dumped three times. Its own ROM is the standard international ROM, so the shifted calibration record of §3.8 is not a ROM-revision effect. Given the history above, the simplest origin of the shifted record and of the stray bytes is an injection made with a file or tool that used another layout, but this cannot be verified. Between 2021 and 2026 the photo area of every slot changed and the state vector became empty (0 photos), yet the 6 tail bytes of 29 of the 30 slots and the record's position are unchanged: the retail ROM never touches them.
2. **The retail ROM ignores a shifted record (emulator check).** PyBoy, USA/EU ROM with the header patched to MBC5, the two sensor-wait loops (`jr nz,-4` at file offsets `$19F73` and `$25FE0`) replaced by `nop`s, SRAM reads enabled at the check; the 14 SRAM files are not modified. `Cam_Calib_ValidityCheck` (bank 10 `$45C9`): with `CE10229233` (normal record) it returns 0 and `$D5B5-$D5C0` = `7C 7B 7E 7C 7B 7C 7D 7C 7A 79 75 6A` (its own vector); with `CE10550742` it returns `$FF`, the validity flag `$FF8A` stays 0, and `$D5B5-$D5C0` = `7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A`, the fixed default of §6. This confirms the reading of the code (record only at `$AFF2` / `$BFF2`). Emulator limits: PyBoy has no Pocket Camera mapper (no sensor, no camera registers); the check itself reads SRAM only, so it does not depend on them. A run in BGB (real mapper) has not been done.
3. **`1B 13` is not universal.** Present in the 12 factory-fresh files of the first set and in 5 of the 14 cameras (`CE10251329`, `CE10229233`, `CE10238211`, `CE10785322`, `PC10696894`); absent (`AA AA`) in 6 units of the newest batch (never-written area untouched), which all have a valid vector, default settings (`99 99…`, never saved) and the same default owner ID `77013356`; 3 of them (`CE10517662`, `CE10811537`, `PC10584071`, two international and one Japanese) carry the **identical** vector `7E 7D 7E 7E 7D 7C 7D 7D 7C 7B 78 60`. A vector measured on each unit would not coincide across three units: either a batch value written by the factory or one synthetic save injected into three cartridges; with this history it cannot be told. The retail ROM never reads `FF0-FF1`, so these cameras work; only the hidden factory test (§8) compares against them.
4. **Dead batteries come in two kinds.** `CE10000843` lost everything: random content in every area (7.1 bit/byte in the photo area), no valid block, no valid tag. `CE10866859` is different: settings, vector, owner and the 30 tags are valid, the vector lists 30 photos and the photo area has image-like entropy (4.0 bit/byte), only the area the camera never writes is no longer `AA` (2075 of 2079 bytes, biased towards `FF`, `00` and bytes with one bit different). A total loss followed by the camera re-creating what it checks (§3.6, as in `2021-05-19_2`) would look similar, but then the vector would list no photo and the photo area would be noise; so the checked blocks were not re-created. Cause **inconclusive**; with injections and save swaps in the history, a foreign or synthetic save written into this cartridge is the simplest reading (valid blocks, non-`AA` never-written area, an owner ID identical to that of `CE10550742`), but it is not verifiable. A random, non-`00` fill is a second signature of a lost battery (inferred from `CE10000843` alone), besides the `00` fill of §3.8.
5. **`CE10251329`** holds a record `1B 13` + `00 FF` × 7 in the primary copy and `AA AA` + `00 FF` × 7 in the echo (both outside the checksum rule). Patterns of `00`/`55`/`FF` look like a memory-test pattern, as in the factory-fresh exchange buffers (`55 00 FF 00 D5 00…`) and in the `AA 55 FF FF 00…` rows of `2023-06-01`. The camera therefore uses the default vector. Origin unknown (a synthetic save is possible).
6. **Owner IDs are not unique.** `01436645` is the ID of four different cameras (`001`, `004`, the camera of `2020-05-29` / `2021-05-19_5`, and `PC10696894` / `2023-09-04`), `34724160` of two (`002`, `007`), `00912730` of two (`CE10550742`, `CE10866859`), and `77013356` is the default of the six new units (never registered by an owner). With save swaps and injections in the history this is expected (a save carries its ID with it), so **nothing can be concluded about the ID generator** (`$51D0`, §3.5) from it.
7. **Matches with the older files.** `CE10229233` = `2022-05-03` (29 of 30 slots identical), `CE10238211` = `2022-08-25 Easycash`, `PC10696894` = `2023-09-04 … (Rev 1)`; the other new cameras have no older file.

---
