[README](../README.md) · [Section index](index.md)

## 3. SRAM structure (128 KB) — the consolidated, byte-level map

This section merges **Raphaël Boichot's
*Inject-pictures* map** (the starting point) with what the Pocket Camera (JP) Rev A code actually
does, and with a byte-by-byte comparison of **33 real saves** (evidence in §11).

### 3.0 Conventions and legend

- **Flat offset** = `bank × $2000 + (address − $A000)`. The CPU sees 8 KB at `$A000-$BFFF`; RAM bank
  `$00-$0F` is selected by writing `$4000`, RAM is enabled by writing `$0A` to `$0000`
  (every write routine does this and disables it again). RAM bank `$10` is the sensor register
  window, not memory.
- **Slot numbering.** Photo slot `N` (1…30) starts at flat `$02000 + (N−1)×$1000`; it lives in RAM bank
  `(N−1)/2 + 1`, at `$A000` for odd `N` and `$B000` for even `N`. Boichot's text counts 4 KB blocks
  from `$00000`, so his "image slot 5 / slot 18" (calibration) are **slots 3 / 16** here.
- **Magic + checksum.** Every protected block ends with the ASCII word `Magic` (`4D 61 67 69 63`)
  followed by two checksum bytes computed over *all preceding bytes including Magic*:
  `lo = (Σ bytes + $4E) mod 256`, `hi = (XOR of bytes) ^ $54`
  (`bank2:$432F`; every settings and vector block of all 33 saves verifies, and so do all tag and owner blocks of 32 of them — §11). Boichot's "seed 2F 15" is the same rule seen
  after the 5 Magic bytes. Protected block lengths: **tag `$5A`, settings `$D7`, vector `$23`, owner `$17`**.
- **Every protected block is stored twice** (primary, then echo) and repaired from the surviving copy
  at every boot (§3.6).

Status tags used in the tables:

| Tag | Meaning |
|---|---|
| **C** | **Code-traced**: both the writer and the reader were found in the ROM, and the values in real saves agree |
| **B** | **Boichot-only**: from the *Inject-pictures* documentation, consistent with all saves, not independently code-traced here |
| **D** | **Data-confirmed**: the behaviour predicted by the code is visible in real saves (usually combined with C) |
| **F** | **Factory-written**: present in every camera but never written by the retail ROM |
| **N** | **Never written** by any code path in the ROM (stays at the factory `$AA` fill) |
| **?** | **Inconclusive**: what is known and what is not is stated in the row |

### 3.1 Whole-chip overview

| Flat range | Size | Content | Bank / address | Status |
|---|---|---|---|---|
| `$00000-$00FFF` | 4096 | Exchange buffer: last 128×128 sensor image (256 tiles) | bank 0 `$A000-$AFFF` | C (sensor read-out; cleared at SHOOT entry, bank 6 `$5E83`) |
| `$01000-$010D8` | 217 | **Settings block**: animation list, sound preset, counters, scores, print intensity, Game Face flag, Magic, checksum | bank 0 `$B000-$B0D8` | C |
| `$010D9-$011B1` | 217 | Settings echo | bank 0 `$B0D9-$B1B1` | C |
| `$011B2-$011D6` | 37 | **State vector** (slot → photo number) + Magic + checksum | bank 0 `$B1B2-$B1D6` | C |
| `$011D7-$011FB` | 37 | State-vector echo | bank 0 `$B1D7-$B1FB` | C |
| `$011FC-$01FFB` | 3584 | **Game Face** image (128×112) | bank 0 `$B1FC-$BFFB` | C |
| `$01FFC-$01FFF` | 4 | CoroCoro tag (`.. 56 56 53`) | bank 0 `$BFFC-$BFFF` | C/? (§3.3) |
| `$02000-$1FFFF` | 30 × 4096 | **30 photo slots** | banks 1-15 | C |

Exact accounting: 4096 + 2×217 + 2×37 + 3584 + 4 + 30×4096 = 131 072 bytes.

### 3.2 Bank 0: exchange buffer, settings, vector, Game Face

#### Exchange buffer `$00000-$00FFF` (C)
The last image read from the sensor, 128×128 px = 256 tiles. Rewritten by every capture
(zeroed at SHOOT entry, then filled by the sensor read-out); the 128×112 photo kept in an album
slot is the middle part (`$0100-$0EFF`), the rest is dropped. In factory-fresh saves it holds
whatever the factory calibration last saw (mostly `$FF`/`$00`), different in every camera. It is
**not** covered by any checksum.

#### Settings block `$01000-$010D8` (C unless noted)
Written as a whole by the routines named in the last column, then re-checksummed and copied to the echo.
"Default" is what the ROM writes when the block is reset (`bank2:$4183`, byte-exact).

| Offset | Bytes | Field | ROM default | Writer / reader | Notes |
|---|---|---|---|---|---|
| `1000-102E` | 47 | Animation (slide-show) list: photo number per entry, MSB = album B | `FE` (= empty) | write `$49A8`/`$4A07`, read `$4EAE`/`$4EE8` | stored through the number-conversion helpers `bank0:$15ED/$1600` |
| `102F` | 1 | Animation loop flag | `00` | idem | seen `00` (31 saves), `FF` (2) |
| `1030-105E` | 47 | Animation loop / timing bytes (`$80+t` start, `t` between, `$40+t` end, t = 2…50) | `00` | idem | B for the bit meaning |
| `105F` | 1 | Animation speed | `09` | idem | seen `$03…$40` |
| `1060` | 1 | Animation border | `00` | idem | seen `00/01/05` |
| `1061-1064` | 4 | SOUND I: duty/gate, envelope, modulation ×2 | `09 8F 00 00` | write `$4A6B`, read `$4F2B` | bits 7-6 of `1061` are **never written** (see below) |
| `1065-1074` | 16 | SOUND I notes (`01…25`) | `0D 00…` | idem | |
| `1075-1078` | 4 | SOUND I stereo, 2 bits per note | `55 55 55 55` | idem | `55` = all centred |
| `1079-1088` | 16 | SOUND II wave (32 nibbles) | `00×4 FF×4 00×4 FF×4` | idem | |
| `1089-108B` | 3 | SOUND II: gain/pattern, modulation ×2 | `09 00 00` | idem | bits 7-6 of `1089` never written |
| `108C-109B` | 16 | SOUND II notes | `0D 00…` | idem | |
| `109C-109F` | 4 | SOUND II stereo | `55 55 55 55` | idem | |
| `10A0` | 1 | Loop count (SOUND I hi nibble, SOUND II lo nibble) | `FF` | idem | stored as count−1 |
| `10A1` | 1 | NOISE envelope: U/D (bit 7), **bits 6-4**, gain (3-0) | `8F` | idem (pack `$4B2B` with `$D9AC-$D9AE`) | bits 6-4 come from RAM `$D9AD & 7` (for SOUND I the same three bits are the envelope *time*, Boichot). They are **0 in 32/33 saves**; the single exception is `2021-05-19_6` (`D6` = U/D 1, bits 6-4 = 5, gain 6, valid checksum), so the field *can* hold a value. The same field for SOUND I (`1062`) takes 0, 2, 3, 5, 6, 7 in real saves. Which NOISE-editor control feeds `$D9AD`: **?** |
| `10A2` | 1 | NOISE gate (hi) / loop count−1 (lo) | `5F` | idem | |
| `10A3-10B2` | 16 | NOISE notes | `19 00…` | idem | |
| `10B3-10B6` | 4 | NOISE stereo | `55 55 55 55` | idem | |
| **`10B7-10B8`** | 2 | **NOISE per-step flag bitmap** (16 bits, MSB = step 1) | `00 00` | pack `bank2:$4B9E`, unpack `$5028` | **Boichot: "unknown, seems unused" — it is used.** Each bit is bit 4 of the in-RAM per-step array `$D9C1…$D9D0`. The sound engine (`bank0:$131F-$1344`) shifts that bit to bit 3 and ORs it into `$D917`, the copy of **NR43 (`$FF22`, written at `$1099`)**: the flag is the **LFSR-width bit of that step (set = 7-bit "metallic" noise, clear = 15-bit)**; the low nibble of the same entry selects the NR51 panning (table `$1350`: `80` left, `88` centre, `08` right). 5 distinct values over the 33 saves (`0000` 21×, `2B4B` 7×, `A800` 2×, `44A8` 2×, `0040` 1×). What the NOISE editor calls this toggle: **?** |
| `10B9` | 1 | Tempo | `78` | `$4A6B` writes `$D9D1` here | seen `$32…$F0` |
| `10BA` | 1 | "Sound preset saved" flag | `00` | `$4A6B` always writes `01` | read by bank 5 (`$D9D2`) |
| `10BB-10BC` | 2 | Counter: photos **taken** (BCD, low byte first) | `00 00` | from RAM shadow `$DA96`; write `$4BB2`, read `$503F` | the whole `10BB-10D0` run is one 22-byte copy |
| `10BD-10BE` | 2 | Counter: photos **erased** | | | |
| `10BF-10C0` | 2 | Counter: photos **transferred** | | | |
| `10C1-10C2` | 2 | Counter: photos **printed** | | | |
| `10C3` / `10C4` | 1 + 1 | Counters: pictures **received from a male-owner sender** / **from a female-owner sender** (BCD, cap 99). *(two-core link run, §14.6)* | | `bank7:$4A17` (+1 on `10C3` if bit 0, on `10C4` if bit 1 of `$CFFF`; `$CFFF` is the last byte of the 4,096-byte exchange buffer and holds the **sender's** `$DA56`, written by `07:4409` / `07:477D` before sending) | called by the link-exchange "transfer finished" states on the receiving unit, right before `$462F` stores the picture (§3.3, `F12-F14`, §14) |
| `10C5-10C8` | **4** | **Space Fever II** score (8 BCD digits, low byte first) | | | **Boichot lists `10C5-10C6` only: it is 4 bytes** (the unlock test reads `10C6…10C8`) |
| `10C9-10CA` | 2 | Ball-game score | | | |
| `10CB-10CC` | 2 | Run!Run!Run! score (99 − value on screen) | | | |
| `10CD-10CF` | 3 | **Dead bytes** | `00 00 00` | copied to/from the shadow as part of the 22-byte run, never changed | `000000` in 33/33 saves; **settled** |
| `10D0` | 1 | Print intensity | `40` | same run | seen `$0E…$7F` |
| `10D1` | 1 | **Game Face present** flag | `00` | set to `01` (both copies) by `bank2:$4C37`; read by `$506A` | *Boichot: "unknown"* — **settled** |
| `10D2-10D6` | 5 | `Magic` | | | |
| `10D7-10D8` | 2 | Checksum (length `$D7`) | | `$432F` | |

*Album-B unlock test (`bank2:$4D05`).* The album-B stock pictures `$2E…$35` are shown only if the
counters pass fixed thresholds (BCD): taken ≥ 60, printed ≥ 30, transferred ≥ 15, ball score ≥ `$0700`
and ≥ `$1000`, Space Fever II ≥ `3000` and ≥ `5000`, Run!Run!Run! high byte ≥ `$82` — one picture per
condition. This is why forcing the scores *with a valid checksum* unlocks album B (Boichot).

Echo: `$010D9-$011B1` is a byte-for-byte copy of `$01000-$010D8`.

**Bits never written by the ROM inside the settings block:** bits 7-6 of `1061` and `1089`
(the pack routine masks the field to 4+2 bits; 0 in 33/33 saves).

#### State vector `$011B2-$011D6` (C)
30 bytes, one per slot (byte *i* ↔ slot *i+1*): the **photo number − 1** shown on the camera
(`$00…$1D`), or **`$FF` = slot unused/erased**; then `Magic` (`11D0-11D4`), checksum (`11D5-11D6`, length
`$23`); echo at `$011D7-$011FB`. Deleting a photo only writes `$FF` here (`bank2:$44FB`) — the image
stays in the slot until overwritten. A new photo takes the first `$FF` entry (`$444D` with A=`$FF`).
RAM keeps a renumbered copy at `$D563` (`$4466`); `$43F9` writes it back (both copies).

#### Game Face `$011FC-$01FFB` (C)
128×112 px (3584 B) image used by the minigames. Written **only** by `bank2:$4C37` (called from bank 6 `$643C`
and the bank-7 editor `$6A5C`), which also sets `10D1` = 1 in both settings copies. Read back by `$506A`
into `$C000` when the flag is set. **Not touched by "erase all"** (neither by Start+Select at boot nor by
Select+Start+Up). In the 12 factory-fresh saves it is `$AA` (never written); in all 12 clean used saves it holds an image.

#### CoroCoro tag `$01FFC-$01FFF` (C/?)
The signature the ROM looks for is `56 56 53` at `01FFD-01FFF`. The only save that carries a full tag (`00 56 56 53`, `2021-05-19_2`) is a **battery-loss** save (§3.8: `00` fill, battery replaced). Its first byte `00` is simply what a blank chip holds and no ROM code reads it. How `56 56 53` got there is **inconclusive**: nothing in the four ROMs can create it from a blank area (the literal `56 56 53` exists once per ROM, as the comparison constant of the routine below; Hello Kitty has no such routine). The only code that touches the range is
`bank 8:$72E0`: it compares `$01FFD-$01FFF` with `56 56 53` and, if **at least 2 of the 3 bytes match**, **rewrites
the exact signature** (self-repair of one flipped byte) and returns "valid"; otherwise it returns "not CoroCoro" and writes nothing.
So the tag is never *created* by the ROM, and **`$01FFC` is never read or written** (the `00` of the CoroCoro save was therefore not put there by this code).
Values seen in other saves: `AAAAAAAA` (all fresh and most used), `00390039` (two saves of one camera),
`FFFF0000` (the 2005 camera), `80442A40`, and decay patterns in the damaged saves — **origin not established** (§3.8).

### 3.3 The 30 photo slots (4096 bytes each)

| Slot offset | Bytes | Field | Status | Writer / reader |
|---|---|---|---|---|
| `000-DFF` | 3584 | **Photo**, 128×112 px, 2bpp, 224 tiles | C | write `$46F0` (new shot, bank 6 ×6 sites), `$45A1` (album copy, bank 4), `$462F`, `$47C4` (editor save-back, bank 7); read `$4C80`; zeroed by `$411E` |
| `E00-EFF` | 256 | **Thumbnail**, 32×32 px, 16 tiles; copies get a badge | C | built by `bank0:$2583/$296F` from the photo; badge `$29F9` |
| `F00-F03` | 4 | Photo owner **ID**: 8 decimal digits, each stored as *digit+1* in a nibble (`12 54 77 56` = `01436645`) | C | copied from the camera's owner block when the photo is shot |
| `F04-F0C` | 9 | Owner name (tile codes `$56`=A … ; `00` = blank); in the Japanese ROM `$56` = ア, `$61` = シ, `$73` = ホ, `$78` = モ (printed on the comment card, §17.4) | C | idem |
| `F0D` | 1 | Gender (0 none, 1 male, 2 female) + blood type (+4 A, +8 B, +$C O, +$10 AB; JP only) | B; **C** for gender (♂ / ♀ / ?) and for blood type A and "?" (printed on the comment card, §17.4) | idem |
| `F0E-F11` | 4 | Birthdate: **eight digits, one per nibble, nibble = digit + 1** (a zero nibble in a non-empty field prints 0; all four bytes `00` print "????/????"); printed as two rows of four: `2A 99 29 17` → 1988 / 1806, `20 30 40 50` → 1020 / 3040 (§17.4). A "digit pair + 11" reading does not reproduce these digits; which of the two rows is month and day is not established (**I**) | **C** (printed form) | idem |
| **`F12-F14`** | 3 | **Per-photo "reception" counters** (binary, cap 99): `F12` +1 if the **owner of the *receiving* camera is male** (its own owner gender byte `$DA56`, bit 0), `F13` +1 if **female** (bit 1), `F14` +1 always (= number of cable transfers the photo has been through; the counters travel with the tag and keep accumulating, §14.6) | C + D | only writer: `bank2:$462F` = *store the picture held in the WRAM buffer as a new photo* (bank 7 states 9 and 17, branch `$D5F5` ≠ 0; the other branch of the same two states deletes photo `$D5D8` with `$452A`+`$44FB`). The same branch then bumps the camera-level counters `10C3/10C4` (`bank7:$4A17`). `$462F` also clears the hotspot fields `F36-F53` and rewrites `Magic` and both tag checksums. **Observed** in 4 slots (5-8) of `2021-05-19_6`, whose owner byte is `02` (female): `1A 1A 1A → 1A 1B 1B` (three slots) and `00 00 00 → 00 01 01` (one slot), i.e. exactly +0/+1/+1; zero in all other saves. Boichot: "3 unknown bytes". In those slots the primary tag was `1A`-filled and the echo all-zero (both with valid checksums: a hand-made primary-vs-echo test), and `$462F` bumped each copy separately. **Settled by the two-core link run (§14):** states 9/17 are the "transfer finished" states of the link-cable exchange screen (mode `$0E`, reached from the main menu with Down, Right, A from the default cursor); the F12/F13 test uses the *receiving* camera's own `$DA56` (a female receiver bumps `F13`: consistent with the four real slots above, owner byte `02`). Every photo received by cable carries `F14 ≥ 1`. |
| `F15-F2F` | 27 | **Comments** (same tile charset as the name); printed as **3 lines of 9 cells** on the comment card (§17.4) | B; **C** for the printed layout and the codes `$56-$70` = ア … ヒ; the whole table is `roms/jp_rev_a/disasm/charset_jp.csv` (glyph rule **C** in BGB, §16.27) | WRAM tag-head buffer `$DA5B…$DA90` ↔ `F00-F35`; `$494B` writes it to both tag copies, `$4E5F` reads it |
| `F30-F32` | 3 | `00` | B | cleared when a photo is created; non-zero (`1A 1A 1A`) only in the three `1A`-filled slots of `2021-05-19_6` |
| **`F33`** | 1 | **Copy flag**: `01` = created by the album *Copy* function | C | `$45A1` sets it in both tag copies and draws the thumbnail badge; seen `01` in 6 slots of one save |
| **`F34-F35`** | 2 | **Image checksum** = (8-bit **sum**, 8-bit **XOR**) of the 3584 photo bytes, no seed | C | computed once, at shooting time, by `$4005` (stored by `$46F0`; WRAM tag-head buffer `$DA5B+$34/$35` = `$DA8F/$DA90`); **not updated when the photo is edited later** (`$47C4` rewrites image+thumbnail only). Matches in 285 of the 369 used slots checked (77 %); the rest is discussed in §11. Boichot: copies share the value |
| `F36-F3A` | 5 | Hotspot enabled flags | B | write `$4832`/`$488F`, read `$4D88`/`$4DD7`; zero for a new photo |
| `F3B-F3F` | 5 | Hotspot X (0-14) | B | idem |
| `F40-F44` | 5 | Hotspot Y (0-12) | B | idem |
| `F45-F49` | 5 | Hotspot sound/music (0-63, FF off) | B | idem |
| `F4A-F4E` | 5 | Hotspot visual effect (0-6, FF off) | B | idem |
| `F4F-F53` | 5 | Hotspot "jump to photo" (0-29, FF off) | B | stored through the conversion helpers `$15ED/$1600` |
| `F54` | 1 | Border number | C | write `$48F7`, read `$4E31` (≥ 30 → border `$12`) |
| `F55-F59` | 5 | `Magic` | C | |
| `F5A-F5B` | 2 | Checksum (length `$5A`) | C | `$432F` |
| `F5C-FB7` | 92 | **Echo** of `F00-F5B` | C | primary wins if both valid but different |
| `FB8-FD0` | 25 | **Camera-owner block (slot 1 only)**: ID 4, name 9, gender/blood 1, birth 4, `Magic`, checksum (length `$17`) | C | WRAM buffer `$DA49-$DA5A` (gender/blood = `$DA56`); write `$4BF4` (from the registration screens, bank 9 `$4BD2`), read `$5054`, default `$4283` (all zero + Magic); **slots 2-30: never written** |
| `FD1-FE9` | 25 | Owner echo (slot 1 only) | C | idem |
| `FEA-FFF` | 22 | **Tail**: `$AA` factory fill, except the three cases below | N | never written by any retail-ROM path |

**The only non-`AA` bytes of the tail zone (`FB8-FFF`) in the 24 saves of untouched cameras (12 fresh + 12 clean used) are exactly these 81 bytes** (everything else, 2079 of 2160, is `$AA` in all 24):

| Where | Bytes | Content | Written by |
|---|---|---|---|
| slot 1 `FFF` (= flat `$02FFF`) | 1 | **Boot counter / RNG seed.** At every boot `bank0:$091A` reads it, reduces it modulo `[$D528]` (= `$FF`), builds the 55-byte subtractive-generator table at `$D52A` from it, warms it up (`$09AD` ×3), draws one value and writes it back to `$AFFF` (`$096D`). No timer or button is involved, so the stored value walks a fixed **8-step cycle `AA → 95 → 6B → 17 → 6E → 1D → 7A → 35 → AA`** (re-implemented in `tools/sram_analyze.py`, `seed_orbit`): it counts power-ons modulo 8. A fresh camera shows `95` (12/12 = one boot); 29 of the 33 saves hold a value of the cycle, the other four are `FE` (`2021-05-19_4`), two damaged files (`26`, `3E`) and the battery-loss save `2023-06-01` (`00`, the blank-chip value: `seed_next(00)` = `95`, so a battery-replaced camera re-enters the same cycle at its 2nd value, as `2021-05-19_2` shows with `6B` after two boots). The two warm-up loops (`$09B9`, `$09CA`) never advance their pointers, so only table entries 0 and 24 change — which is why the cycle is so short | C |
| slot 3 `FF0-FFF` (= `$04FF0-$04FFF`) | 16 | **calibration record**: `1B 13` + 12-byte vector + 2 checksum bytes | `1B 13`: **F** (read by the factory test, below); vector+checksum: C (`Cam_CommitVectorToSRAM` `0a:$4F58`: 12 bytes from WRAM `$D5B5` + checksum to `$AFF2` in RAM bank 2, then the same to `$BFF2` in RAM bank 8) |
| slot 16 `FF2-FFF` (= `$11FF2-$11FFF`) | 14 | **echo** of the 12-byte vector + checksum (`FF0-FF1` stay `AA`) | C |
| slot 1 `FB8-FE9` | 50 | the owner block above | C |

- The **calibration vector** checksum is a *different* rule from the Magic checksum: `(Σ + $0D, XOR + $23)`
  (additions), valid in the 26 saves whose record is intact (§11.3) and in the shifted copy of the 2005 camera — §6.
- **`1B 13`** (flat `$04FF0-$04FF1`) is identical in all 26 intact saves of the first 33 (the 14 cameras of §11.9 add: present in 5, shifted in 1, and *absent* — `AA AA` with a valid vector — in 6 units of the newest batch) and is **never written by the retail camera ROMs** (JP, USA/EU, Gold: `Cam_CommitVectorToSRAM` starts at `$AFF2`, and no instruction with operand `$AFF0` or `$AFF1` is a write). The **Hello Kitty ROM does write it**: `3E 1B EA F0 AF 3E 13 EA F1 AF` at bank 1 `$49A4`, the end of a whole-SRAM zero-fill routine (§3.8, "Two ways to a `00` area"), so `1B 13` is an initialisation constant stamped by the tool/ROM that prepares a cartridge, not by the retail camera. It is **read** by the hidden factory test (`bank 10:$455A-$45C8`, §8): the test re-measures two values (`$D5BF`, `$D5C0`) and compares each with the stored reference bytes `$AFFC` / `$AFFD` (the last two vector bytes, printed next to "GAINA" on the factory screen); `$AFF0` = `$1B` (27) and `$AFF1` = `$13` (19), printed next to "GAIN8", are the **tolerances** for the two absolute differences (`$FF8D`/`$FF8F` receive tile `$24` or `$25` depending on the sign, presumably a +/- glyph). Both within tolerance → `$FF91` = 0 → "OK", otherwise "NG". The values are therefore factory-programmed test limits (`bank 10:$6AB9` prints them). In the 2005 layout (§3.8) the record sits 6 bytes lower, so `$AFF0/$AFF1` hold other bytes (`7C 7B`) there.

### 3.4 What the ROM never reaches (guaranteed `$AA` on a camera that never lost its battery)

| Area | Bytes | Why it stays `AA` |
|---|---|---|
| Slots 2-30, `FB8-FE9` | 29 × 50 = 1450 | owner block exists only in slot 1 |
| Slot 1, `FEA-FFE` | 21 | tail |
| Slots other than 1, 3, 16: `FEA-FFF` | 27 × 22 = 594 | tail |
| Slot 3 `FEA-FEF` (6), slot 16 `FEA-FF1` (8; `FF0-FF1` are not part of the echo) | 14 | tail before the calibration record |
| Game Face `011FC-01FFB` | 3584 | only until a Game Face is saved (all clean used cameras have one) |
| `$01FFC` | 1 | never read or written |
| `$01FFD-$01FFF` | 3 | only rewritten (never created) by the CoroCoro self-repair |

Everything else is written by some path: photos/thumbnails/tags by the slot routines, the exchange buffer by the
sensor. Formatting a slot (`$411E`) zeroes `000-FB7` only, so **tail and owner-area bytes are never cleared by any
operation, including "erase all"** — they are the cleanest long-term record of the factory fill and of battery loss.

### 3.5 Where each block is touched (storage manager = bank 2 `$4005-$5130`)

| Entry | Function |
|---|---|
| `$442C` | **Boot integrity pass**: enable SRAM → owner (`$43D0`), vector (`$43A8`), 30 slots (`$433B`), settings (`$4380`) |
| `$444D` | photo number → slot index (carry set if none); `$4466` loads the vector into `$D563`, renumbers, counts photos into `$D561` |
| `$44B5` | **Erase all**: owner default (`$4283`) → vector default (`$424D`) → each slot formatted (`$411E`) and marked `FF` (`$4159`) → settings default (`$4183`). Leaves exchange buffer, Game Face, tails and calibration alone |
| `$44FB` / `$452A` | delete a photo / delete + clean hotspot-jump and animation references to it |
| `$45A1` | store a copy (sets `F33`, badge), `$462F` store a picture held in WRAM as a new photo, bumping its `F12-F14` counters (§3.3), `$46F0` **store a new shot** (copies the camera owner into `F00-F11`, zeroes `F12-F54`, writes `F34-F35`) |
| `$47C4` | rewrite photo+thumbnail (`$F00` bytes) of an edited photo, tag untouched |
| `$4832`, `$488F`, `$48F7`, `$494B` | write hotspots, hotspots with jump conversion, border, tag head `F00-F35` (both tag copies re-checksummed) |
| `$49A8`/`$4A07`, `$4A6B`, `$4BB2`, `$4BF4`, `$4C37` | write animation list, sound preset, counters/scores, camera owner, Game Face |
| `$4C80`, `$4D88`/`$4DD7`, `$4E31`, `$4E5F`, `$4EAE`/`$4EE8`, `$4F2B`, `$503F`, `$5054`, `$506A` | the matching readers (image, hotspots, border, tag head, animation, sound, counters, owner, Game Face) |
| `$51D0` | generate the owner ID if its 4 bytes are zero (random digits, each = (random & 15 + previous digit) mod 10), then `$4BF4` (called from the mode-0 entry, bank 7 `$71AF`, call site `$71E2`) |

Callers (the only far-call sites in the ROM): boot = bank 9, `Boot_EraseAllPrompt_Far` (`09:5F4B`, called at `00:0202` and `00:0295`): `$44B5` at `09:5FAC` (Start+Select held at power-on, then A), `$442C` at `09:5FB6` / `09:5FD0` (every boot), `$4466` after each. The `ld hl,$442C` at `1F:444C` is a sound-data pointer (`jp Snd_Sfx_LoadNR1x` follows), not a call.

### 3.6 Self-repair rules (answers "what does the camera do with a bad block?")

For each block the ROM checks `Magic` (primary or echo), then the checksums of both copies:

| Situation | Action |
|---|---|
| both copies good, equal | nothing |
| both good but different | **primary wins**, echo overwritten (Boichot's "first occurrence has priority") |
| one good, one bad | the good copy is copied over the bad one |
| both bad (or no Magic) | **that block only** is reset: slot → formatted and marked erased; settings → defaults; vector → all `FF` (all photos disappear, data stay); owner → all zero |

So the "suicide code" is **per block**, not a whole-save wipe (a wrong settings checksum resets scores and sound only;
a wrong vector hides all photos but leaves them in place, which is what makes Boichot's un-erase trick work).

**What a battery loss (SRAM all `00`) triggers at boot, and the 66 `Magic` strings it writes (C: code, replayed in my core).** No key and no flag is involved. Every boot runs `Boot_EraseAllPrompt_Far` (`09:5F4B`; `Boot_ColdStart` calls it at `00:0202` with A = 0, `Boot_SoftReset` at `00:0295` with A = 1); only a cold start with Start+Select held (`$FFA1` = `$0C`) shows the prompt, every other case goes to `09:5FCC`, which far-calls `Sram_ValidateAll_Far` (`02:442C`) and then `Photo_RenumberVector` (`02:4466`). `Sram_ValidateAll_Far` validates, in this order, the owner block (`02:43D0`), the photo vector (`02:43A8`), the 30 photo tags (`Sram_ValidateTagSlot`, `02:433B`, called 30 times) and the settings (`02:4380`); a block that has no `Magic` in either copy is rewritten by `Sram_FormatOwnerBlocks` (`02:4283`), `Sram_FormatVectorBlocks` (`02:424D`), `Sram_FormatPhotoBank` (`02:411E`: zeroes `$FB8` bytes of the slot, writes `Magic`, then the checksum, for both copies; the slot is then freed in the vector) and `Sram_FormatSettingsBlocks` (`02:4183`: default settings). The string is copied by `Sram_WriteMagicAt` (`02:414A`) from `Sram_MagicString` (`02:4000`, `4D 61 67 69 63`), the checksum by `Sram_WriteChecksum` (`02:432F`). The unconditional version, `Sram_FormatAll_Far` (`02:44B5`), is reached only from the power-on prompt (Start+Select, then A). Result in the core with an SRAM of 128 KiB of `00` (or of `FF`), no key, 400 frames (the game reaches the title screen): exactly **66** `Magic` strings, none before, and a second boot changes only the seed byte `$02FFF`:

| what | `Magic` at flat offsets (RAM bank : address) | count |
|---|---|---:|
| settings (block `$D7`) | `$010D2`, `$011AB` (bank 0 : `$B0D2`, `$B1AB`) | 2 |
| photo vector (`$23`) | `$011D0`, `$011F5` (bank 0 : `$B1D0`, `$B1F5`) | 2 |
| camera owner (`$17`, slot 1 only) | `$02FCA`, `$02FE3` (bank 1 : `$AFCA`, `$AFE3`) | 2 |
| tag of photo slot k = 1..30 (block `$5A`, two copies) | slot base `$2000 + $1000 × (k - 1)` plus `$F55` and `$FB1`: `$02F55`, `$02FB1`, `$03F55`, `$03FB1` ... `$1FF55`, `$1FFB1` | 60 |

**The calibration record is not a protected block and does not follow these rules** (different checksum, no `Magic`, code in bank `$0A`, §6): primary valid + echo bad → echo rebuilt from the primary; echo valid + primary bad → primary rebuilt from the echo; both valid but different, or both bad → the fixed default vector is used from WRAM and **nothing is written to SRAM**; there is no "primary wins" step.

### 3.7 Differences from Boichot's map

| Item | Boichot | This work |
|---|---|---|
| `10B7-10B8` | unknown, unused | 16-bit mask, one bit per NOISE step = LFSR-width bit (NR43 bit 3) of that step (used) |
| `10C5-10C6` | Space Fever II score | 4 bytes `10C5-10C8` |
| `10CD-10CF` | "seems never used" | dead, confirmed (code + 33/33 saves) |
| `10D1` | unknown | Game Face flag |
| `F12-F14` | 3 unknown bytes | 3 counters capped at 99 (owner male / owner female / total), written only by `$462F`; observed non-zero only in 4 slots of `2021-05-19_6`, always +0/+1/+1 as the code predicts |
| `F33` | 0 original / 1 copy | confirmed; set by album Copy `$45A1` |
| `F34-F35` | "probably a checksum" | exactly (sum8, xor8) of the photo; set at shooting time only |
| ID bytes | "11 + digits" | each nibble = decimal digit + 1; 8 digits generated by `$51D0` |
| `$02FF0-$02FF1` | "AA, but not always" | `1B 13` in slot 3 only: the factory test's tolerances (27, 19), read by the hidden factory test, never written by the retail camera ROMs (the Hello Kitty ROM stamps it, §3.8); slot 16 keeps `AA` |
| `$02FFF` | "changes with hotspots and events" | boot counter: the seed byte walks the 8-step cycle `AA 95 6B 17 6E 1D 7A 35` at each power-on |
| `$01FFC-$01FFF` | "possible tag; untouched by erase" | `01FFD-FFF` repaired (never created) by bank 8 `$72E0`; `01FFC` unused |
| "Any discrepancy erases all" | whole save | per-block reset (§3.6) |
| Calibration "slot 5 / 18" | numbering from block 0 | slots 3 / 16 |
| Never-written bytes | "factory SRAM test remnant, other value = battery replaced" | confirmed by data: clean cameras keep `AA` in 2079/2160 tail bytes; every other value seen is explained by §3.8 |

### 3.8 Atypical saves and what is still unknown

The 33 files split into **12 factory-fresh** (10 cameras: `002`/`002_2` and `008`/`008_2` are two dumps of one camera each),
**12 clean used** (tail zone still 100 % `AA` outside the legitimate exceptions) and **9 atypical** (tail zone partly or
fully overwritten), two of which are **battery-loss** saves. Convention (the owner's): a `00` where a genuine camera keeps `AA` means that the battery was lost and replaced (a blank chip reads `00`, not the factory `AA` fill); `tools/sram_analyze.py` applies it as "≥ 75 % of the 2079 never-written bytes are `00`" (class `BATT-LOSS`). These are genuine camera saves, not synthetic ones. The atypical saves are valuable precisely because they show what the ROM leaves untouched. The per-save numbers
are produced by `python3 -I tools/sram_analyze.py classify saves` (§11.2).

| Save | Non-`AA` bytes in the never-written area (of 2079) | What is different | Reading |
|---|---|---|---|
| `2005_GAMEBOYCAMERA`, `2021-08-08` (one camera, owner name decodes to BOICHOT, ID `00912730`; **slots 3-30 are byte-identical in the two files**, slots 1-2, the settings and the exchange buffer differ: the camera was used in between, the vector lists 2 photos in the first file and 30 in the second) | 176 each | **Calibration record 6 bytes lower than normal**: `1B 13` at `FEA`, vector `FEC-FF7`, checksum `C7 35` at `FF8-FF9` (valid by the calibration rule); echo in slot 16 shifted the same way. In **every** slot `FFA-FFF` holds non-`AA` bytes (mostly `00`/`55`/`11`/`FF`, but also `A8 57`, `A1 5C`, `AF 54`, `B5 40`, `6A 15`, `2E D1` in slots 14, 23-27, 29; slot 1: `FFB-FFE` = `B9 FF 1D 00`). Slot 2's tail is the same in both files although the photo in slot 2 was rewritten in between | The 12-byte vector is **identical to the one in `2021-05-19_4`** (same physical camera, same owner name, but a different owner ID `29060580`), where the record sits at the normal place. A raw-byte scan of all four ROMs I have (JP Rev A, USA/EU v1.0, Gold/Zelda, Hello Kitty) finds **no instruction operand at `$AFEA`, `$AFEC`, `$AFF8` or `$AFFA`** (nor at the slot-16 equivalents); the only operands in `$AFE0-$AFFF` / `$BFE0-$BFFF` that are real code are `$AFFF` (boot seed), `$AFCA`/`$AFE3` (owner Magic), `$BFFD-$BFFF` (CoroCoro tag), `$AFF0/$AFF1/$AFFC/$AFFD` (factory test) and `$AFF2/$BFF2` (vector load/commit/repair). USA/EU and Gold have bank `$0A` calibration code **byte-identical to JP** (bank `$0A` differs in 61 bytes only, factory-test text and tiles `$6A67-$6BD9`, `$7CE4-$7D15`), so the shifted layout cannot come from them. The shift is present in both dumps although the camera was used in between. **Not a ROM revision**: the camera was dumped again in 2026 (`CE10550742`, §11.9): its own ROM is the standard USA/EU version 0 (md5 `42d2f65e…`, byte-identical to mine), the record is still 6 bytes lower, the 6 tail bytes of 29 of the 30 slots are unchanged since 2021 although the photo area of every slot differs, and in an emulator the retail ROM rejects the record and runs on the fixed default vector (§11.9, point 2). What wrote it remains **unresolved** |
| `2021-05-19_2` (tag `00 56 56 53`) — **battery loss** | 2079 (all `00`) | the whole never-written area, the Game Face area (3584 × `00`) **and the calibration record (all 16 bytes, both copies) are `00`** instead of `AA`; settings, vector (`00 01 … 1C FF`: 29 photos), owner block and the 30 tags are valid; seed `6B` | **Battery replaced, then used normally.** The camera re-initialised what it checks (settings, vector, owner, tags) and everything it never writes stayed `00`. The seed agrees: a blank chip reads seed `00`, `seed_next(00)` = `95` = the 2nd value of the boot cycle (§3.3), so `6B` (3rd value) means the camera was started twice (mod 8) since the battery change. The calibration record stayed `00` after those boots: with both copies invalid the ROM falls back to the fixed default vector in WRAM (§6) and does not write it back to SRAM. The origin of `56 56 53` is unresolved (§3.2). Closed |
| `2021-05-19_6` (owner BOICHOT) | 2075 | tails random-looking, calibration record invalid (`BF 00 …`), vector all `FF`, settings valid with print intensity `7F` and NOISE envelope `D6`; **slots 5-7: primary tag `1A`-filled, echo tag all-zero, both with valid checksums; slot 8: both zero** — the only slots in the 33 files with non-zero `F12-F14` (§3.3) | experimental file: a hand-made primary-vs-echo priority test (Boichot: "first occurrence has priority"), after which the camera itself ran `$462F` on the four slots. Tail bytes are random, not `AA` |
| `2022-03-05` | 57 (slot 2, `FC7-FFF`) | ASCII `SAVE` + 53 parameter bytes; `F34-F35 = 0000` in all 30 slots | **third-party software** (untoxa's gb-photo stores its settings in unused bytes; the images it saved carry no checksum) |
| `2022-08-20 Vinted` | 144 | slots 19 and 20 (= RAM bank 10): `FB8-FFF` = `00 39` × 36 each; both slots unused (vector `FF`), tags valid | `$411E` formats `000-FB7` only, so a decayed or foreign write in this bank survives. Origin unknown |
| `2023-06-01` — **battery loss** (by the `00` rule) | 2023 (1678 of them `00`) | no valid owner block, no valid tag in any slot; vector valid and lists all 30 slots (`18 19 00 01 02 03 1A 1B …`); the 16-byte row `AA 55 FF FF 00×12` recurs at the same offsets in **every** slot (`$F10-$F50` and `$FC0-$FF0`: 145 occurrences, 16-byte spacing); seed `00` | `00` fill ⇒ battery loss by the `00` rule. Seed `00` is the blank-chip value, so **the camera has not booted since the wipe** (the next boot would give `95`). The regular, slot-periodic `AA 55 FF FF 00…` rows look like a pattern written by a memory tester or flash-cart tool, not by the camera (no ROM routine I know writes it): **inconclusive**, who wrote it and why settings/vector are valid is unknown |
| `2024-06-01` | 2079 | tails hold `A5 5A` patterns (671 × `A5`, 669 × `5A`) | looks like a memory test pattern or a decayed SRAM; calibration record gone |
| `2024-08-28` | 2075 | tails look random, calibration record invalid | battery loss or overwritten; the `AA` fill is gone |

**Two ways to a `00` area, and how to tell them apart.** A blank, battery-replaced chip is not the only thing that can give `00` where `AA` is expected: the **Hello Kitty ROM** contains a whole-SRAM initialisation routine (bank 1 `$4907-$49BC`, entered from a bank-5 handler at `$4117` when bit 0 of WRAM `$D8D9` is set; the menu item that triggers it is not identified). It selects RAM bank after RAM bank and fills with `$00` (`call $023A`, DE = 0): RAM bank 0 `$B000-$BFFF` (settings, vector, Game Face, CoroCoro tag), banks 1, 3-7 and 9-15 completely, bank 2 `$A000-$AFEF` plus `$B000-$BFFF`, bank 8 `$A000-$BFEF`; then it selects bank 2 again and writes `1B` / `13` to `$AFF0` / `$AFF1`. It **spares** the exchange buffer (bank 0 `$A000-$AFFF`) and, in banks 2 and 8, the last 16 bytes of the half-banks, i.e. the **calibration record** (flat `$04FF0-$04FFF` and `$11FF0-$11FFF`). The routine therefore also confirms where that record lives (`FF0-FFF` of slots 3 and 16 are the only bytes it protects). A Hello Kitty wipe would give a `00` never-written area with an **intact** calibration record and the `1B 13` header; the two `00`-filled saves have the record zeroed too (and `2021-05-19_2` the Game Face area zeroed), so they are real battery losses, not this routine.

Three more saves have a clean tail zone but an unusual `01FFC-01FFF`: `2020-05-29` and `2021-05-19_5` (one camera: same calibration
vector) carry `00 39 00 39`, `2021-05-19_3` carries `80 44 2A 40`. These four bytes are not touched by any ROM path except
the CoroCoro repair (§3.2), so their origin is not established.

**The 2026 dumps (§11.9).** `2005_…` and `2021-08-08` are the camera `CE10550742`, and it holds the standard USA/EU ROM (version 0, md5 `42d2f65e2549be9d1d126a6828b5d1c1`, the one used throughout this README). All 11 international cameras of the owner carry that same ROM and the 3 Japanese ones the JP Rev A, so the shifted record is **not** the work of another ROM revision. The retail code reads the record only at `$AFF2` (bank 2) and `$BFF2` (bank 8) and treats a record at `$AFEC` as invalid: that camera therefore runs on the fixed default vector `7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A` (emulator-confirmed, §11.9), while the record it carries is another vector, `7E 7D 7D 7D 7C 7B 7B 7D 7B 7B 78 68`, which the retail ROM cannot read back. The write at `AFEA` and the 6 stray bytes at the end of every slot (`FFA-FFF`: `00`/`55`/`11`/`FF` and a few other values) come from something that is not this ROM; they are already in the 2005 dump, and no ROM path touches them. `2021-05-19_4` carries the same vector at the *normal* place `AFF2` (and another owner ID, `29060580`). The owner cannot say how either file was made: his cameras went through many injections of synthetic saves, battery replacements and save swaps, so the origin of the shifted record is not established.

**Still inconclusive (flagged, not guessed):**

1. Which NOISE-editor control feeds RAM `$D9AD` (→ `10A1` bits 6-4, probably the envelope time that the NOISE editor does not expose; value 5 seen once), and what the per-step LFSR-width flag of `10B7-10B8` is called on screen (its hardware effect, NR43 bit 3, is settled).
2. What wrote the shifted record and the 6 stray bytes per slot in the camera `CE10550742`, and the origin of the `00 39` and `80 44 2A 40` patterns: not established (the owner's cameras went through injections, swaps and battery changes). Patterns made of `00`/`55`/`FF` also appear in the factory-fresh exchange buffers (§11.9), in `AA 55 FF FF 00…` rows of `2023-06-01` and in the `00 FF` record of `CE10251329`.
3. `F34-F35`: 52 of the 369 used slots have a non-zero value that differs from the photo (25 of them in one save). The only code that *computes* the value is `$4005` (one caller, `$46FA`); no code that *compares* it was found. `bank0:$16F4` (`Snd_PlayTagDigits`, called right after every `$46F0` in bank 6, and at bank 7 `$717B`) splits the two bytes into 4 nibbles `$DD03-$DD06` and requests the sound `$10` with `$2A7C` (`Snd_Sfx1`, a sound request, not a text routine): **nothing displays them**, they are the four notes of the P.VOICE (§16.30).
4. Who writes `1B 13` in a camera: the retail ROMs never do; the Hello Kitty ROM stamps it at the end of its SRAM-initialisation routine (bank 1 `$49A4`). Why the factory test needs *two* tolerances of 27 and 19 for the `AFFC`/`AFFD` pair is unexplained.
5. Single-bit flips in the photo area of 14 slots of fresh cameras (not analysed further; no code involved).

---
