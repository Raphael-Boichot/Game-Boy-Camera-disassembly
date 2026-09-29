# Pocket Camera (Japan) — Disassembly Findings

Primary target: **Pocket Camera (Japan) (Rev A)**, MD5 `fdcfe686cf4df461e870b6e53b2b5a8b`.
International and Zelda-edition ROMs are treated as derivatives (confirmed: bank $0A, the
sensor driver, differs from the international ROM by only **61 bytes** out of 16384 — the
exposure/dithering algorithm itself is effectively region-independent; menu logic in banks
$003–$009 is likewise byte-for-byte structurally identical, same state counts ±1).

Everything below is graded by confidence:
- **Confirmed** — read directly from disassembled code and/or verified against raw ROM bytes.
- **Strong hypothesis** — code traced and consistent with the idea, but not independently cross-checked.
- **Open** — genuinely unresolved; flagged for your input.

---

## 1. Toolchain & reassembly procedure

```
rgbds v1.0.4  (rgbasm/rgblink/rgbfix)  — installed, matches what mgbdis's Makefile expects
mgbdis v3.0   — github.com/mattcurrie/mgbdis, used for the static disassembly pass
```

Procedure (byte-exact, verified working):

```bash
python3 mgbdis.py --output-dir disasm_labeled --sym pocketcamera_jp.sym pocketcamera_jp.gb
cd disasm_labeled
make            # runs rgbasm -> rgblink -> rgbfix -> md5sum
# md5sum must print fdcfe686cf4df461e870b6e53b2b5a8b
```

`pocketcamera_jp.sym` (included) currently annotates:
- All 7 menu-bank state-dispatch tables (banks $003–$009) as `.data`, with every state entry labeled — this alone fixed most of the code/data misalignment in those banks.
- ~28 hand-traced entry points inside bank $0A (sensor/calibration/factory-test) and its 5 lookup tables, also marked `.data` so mgbdis stops misreading them as instructions.

This is a **living file** — every further routine we label goes here and the disassembly regenerates clean. This is the recommended workflow for the rest of the project: never hand-edit the generated `.asm`, only ever add to the `.sym` file and regenerate.

Remaining known-dirty regions (still raw/misaligned in the disassembly, not yet symbol-annotated): most of banks $00B–$3F (graphics/data banks, not yet touched), and a few small tables still inside bank $0A (see §6).

---

## 2. WRAM map

Built from a full census (every `ld/ldh/inc/dec/cp/bit/...` referencing `$C000–$DFFF` or `$FF80–$FFFE`
across all 64 banks — 1400+ distinct addresses touched; script included as `tools/ram_census.py`,
raw table as `assets/ram_census_jp.csv`). Below are the clusters with enough evidence to name.

### $D520–$D530ish — sound/sequencer area
Touched from bank $000's VBlank handler subroutine (`Call_000_0b4e`) and mostly by "$00"-prefixed
banks that hold BGM data. Not deeply investigated yet — **flagged for follow-up if you need it.**

### $D580–$D5E5 — camera/exposure/dithering state (bank $0A's working set)
**Confirmed**, all traced directly against code this session:

| Addr | Reads/Writes | Meaning (confirmed from code) |
|---|---|---|
| `$d583` | R7 (bank0A only) | Dither-ramp param 0 ("black point" / base value) |
| `$d584` | R7 | Dither-ramp param 1 ("white point"; `swap(($d584-$d583))` gives the per-level step) |
| `$d585`,`$d586` | R2/R7 | Ramp params 2–3 (used by the *flat-fill* dithering mode, see §7) |
| `$d587` | R12 W11 | **Active gain/band selector.** Takes 0,1,2 during the coarse 3-way gain search; forced to `$08` for the "N-bit" capture path. This is the `B` register input to the dither-table selector. |
| `$d588` | R6 W1 | Committed copy of `$d587` once gain search succeeds |
| `$d589` | R6 W4 | Secondary selector; set to `$04` specifically when gain-candidate 0 (brightest-sensitivity) wins. Selects the alternate dither table (see §7). |
| `$d594` | R11 W5 | Shadow copy merged into `A000` (bits 1-2, the P/M/X edge-mode selection bits) before every trigger |
| `$d595` | W38(!) | REG1/`A001` shadow (gain + edge mode byte, OR'd with `$E0`/`$20` per exposure band) |
| `$d596`,`$d597` | W17/W18 | REG2/REG3 (`A002`/`A003`) shadow — the 16-bit exposure time |
| `$d598` | R19 W40 | REG4/`A004` shadow (Vref/edge-enhance), loaded per-band from `$d5c1-d5c9` |
| `$d599` | R19 W27 | REG5/`A005` shadow (always OR'd with bit 7 set, per hardware doc) |
| `$d59a` | shared bank006/00a | Exposure-band index used during live SHOOT-mode capture (seen set to `$54`) |
| `$d59b` | shared 006/00a | **Dither-table row index (`C` register)** — 0–15, selects which of the 16 rows in `$7C20`/`$7C60` |
| `$d59c` | shared 006/00a | **Dithering *mode* selector** (see §7): `0`=flat/uniform fill, `1`=linear ramp variant A, else=ramp variant B (the one used for normal photos) |
| `$d5a0-$d5b4` | R1 W1 each, bank00a only | 21 single-use bytes, one write/one read each — looks like a per-boot scratch table, not yet meaningfully named |
| `$d5b5-$d5c0` | **the 12-byte calibration vector**, see §5 | |
| `$d5c1-$d5c9` | 8-9 single/double-use bytes | Per-band REG4/REG5 lookup values (fed into `$d598`/`$d599`) |
| `$d5cb-$d5cd` | W4 each | Copy of calibration-vector elements 0,4,8 (`$d5b5,$d5b9,$d5bd`) — the three reference targets picked once gain=0 wins |
| `$d5ce` | W91(!), 4 banks | **Cross-bank flag**, heavily written from banks $003/$004/$006/$007 — likely a "screen transition in progress" or similar shared UI flag |
| `$d5cf` | **W427, P213(!)** across banks 3/4/6/7/8/9 | **Confirmed: the per-bank menu state-machine index** — this is what `rst $18` reads to dispatch (§ menu map, previous session) |
| `$d5d0-$d5db` | heavy in banks 004/006/007 | Not yet individually resolved — UI-transition scratch, shared across VIEW/SHOOT/PRINT-adjacent banks |
| `$d5d8` | **R66**, bank004-dominant | Frequently-read counter/index in bank $004 (our "VIEW/Album" theory bank) |
| `$d5df` | R46 W72, banks 3/4/7/8 | **Confirmed from earlier session: shared "last input" shadow**, read by several menu banks' input handlers |

### $D6xx–$D9xx
Not yet systematically walked this session — census data exists (`assets/ram_census_jp.csv`) but
needs the same kind of call-site tracing as §above. **Flagging as next-session work** unless you
want me to prioritize a specific sub-range.

### HRAM ($FF80–$FFFE)
| Addr | Meaning |
|---|---|
| `$ff8a` | Scratch flag inside the popcount sampling loop (toggled 0/nonzero) |
| `$ff8b`,`$ff8c` | Primary calibration checksum bytes (sum+13, xor+35) — **confirmed**, §5 |
| `$ff8d`,`$ff8e` | Echo calibration checksum bytes — **confirmed**, §5 |
| `$ff8f`–`$ff91` | Further diagnostic bytes shown on the hidden factory-test screen (§8); `$ff91==0` is the pass/fail flag |
| `$ffa1`–`$ffa6` | Joypad state bytes (confirmed last session): held / newly-pressed / newly-pressed-or-repeat / released / previous / repeat-counter |
| `$ffab`,`$ffad`,`$ffae` | Generic screen-palette-setup values written at the top of nearly every screen handler (boilerplate, not camera-specific) |
| `$ff9b`,`$ff9d`,`$ff9e` | ROM-bank shadow registers used by the `Call_000_08c1`/`Jump_000_08d0` far-call helper pair |

---

## 3. SRAM map

Flat addressing (bank×`$2000`+offset, i.e. the same convention the *Inject-pictures* README and
your question use — confirmed by cross-checking against it):

| Flat range | Contents | Confidence |
|---|---|---|
| `$00000-$09FFF` (banks 0-4) | Photo album slots (30× 4096-byte 128×128 raster + metadata footer per slot, per Inject-pictures doc) | Confirmed (doc) |
| `$04FF2-$04FFD` | **12-byte camera calibration vector** (gain/exposure reference targets) | **Confirmed this session**, §5 |
| `$04FFE-$04FFF` | Checksum of the above (sum+13 / xor+35 of the 12 bytes) | **Confirmed this session** |
| `$11FF2-$11FFD` | **Echo copy** of the calibration vector | **Confirmed this session** |
| `$11FFE-$11FFF` | Checksum of the echo copy | **Confirmed this session** |
| `$1FFD-$1FFF` | CoroCoro unlock signature (`56 56 53`) | Confirmed (your info + byte-verified against ROM bank $08 reference table at `08:$7347`/`08:$731C` in JP) |

Note the calibration vector's flat address (`$04FF2`) is **not** a WRAM address — it only *looks*
like one because it's small; it's SRAM bank 2 offset `$FF2`. I initially wasn't sure which of WRAM
or SRAM you meant by the first range in your question; the code makes it unambiguous: both ranges
are SRAM, addressed via `ld [$4000],a` (bank select) then `$A000`-window pointers `$AFF2`/`$BFF2`.

---

## 4. Asset catalog

Cross-referenced against both uploaded TCRF pages. A machine-generated catalog of **every** banked
tile/tilemap copy in the ROM is in `assets/catalog_jp.csv` (385 copy-call sites, 270 unique
source blocks) — built by pattern-matching every call to the two banked-copy helpers
(`Call_000_0450` → VRAM tiles/tilemap, `Call_000_0586` → smaller copies) and reading back the
`a`/`hl`/`de`/`bc` values loaded immediately before each call. All unique tile sources are
pre-rendered to PNG in `assets/atlas/` with an `INDEX.txt` cross-reference (bank, ROM address,
length, VRAM destination, caller).

Confirmed against your PDFs and rendered directly from the JP ROM:

- **Album B (30 pictures)**: `$0DA000` + i×`$1000`, matches TCRF's B01–B30 list exactly (rendered — see `assets/albumB_jp.png`). Per-picture metadata footer confirmed at offset `$F00-$FFF` of each slot (magic bytes, user-ID echo, border index, hot-spot flags, checksum) matching the Inject-pictures documentation's field layout.
- **Wild frames (8)**: `$0C4000` + i×`$1800` (rendered — `assets/wildframes_jp.png`); only wild-frame index 4 (the 5th) is byte-identical between JP and international, matching TCRF's note that frames 07/08 are CoroCoro-exclusive and everything else is region-swapped art.
- **Hidden factory-test font**: bank `$24` offset `$57E0`, 0x300 bytes = 48 tiles, a plain `0-9 A-Z + - *` charset used only by the hidden diagnostic screen (§8) — **not documented anywhere we've seen**, genuinely new.
- Main Menu / Photo Option / Magic Bank / Album Bank / Run!Run!Run! / DJ / Printer graphics banks named in the TCRF "unused graphics" page: identified candidate source blocks in the catalog by cross-referencing caller bank against our menu-bank map (Bank 3≈registration/owner-name, 4≈View/Album, 6≈Shoot, 8≈Print — established last session) but **not yet individually matched tile-for-tile against each TCRF screenshot**. This is mechanical, straightforward follow-up work — say the word and I'll produce a labeled contact sheet per TCRF section.

---

## 5. The lookup table at ROM `$02B300–$02B3FF` (international) / bank $0A `$7300` (JP, byte-identical)

**Confirmed exactly**: `table[i] == popcount(i)` (Hamming weight / number of set bits), verified
by direct comparison for all 256 input values — not a fit, an exact match.

How it's used: the auto-exposure metering routine (`Cam_PopcountSampleLoop`, bank $0A `$4FBD`)
walks the *thresholded* 1-bit sensor output in the `$A000` capture window 8 pixels (1 byte) at a
time and looks each byte up in this table to get "how many of these 8 pixels are above/below the
comparator threshold" in one memory read instead of a bit-counting loop. The running total feeds
the coarse-then-fine auto-exposure adjustment (the `CNTR2/CNTR3`-style stepping you'd recognise
from the leaked prototype source). By emulating the sample-address sequence directly (script
below), the routine's row coverage is **y = 24 to 103** of the 128-row buffer — it deliberately
stays well clear of the bottom of the frame (see §9 on masked lines).

```python
# see full interpreter in session tool log; summary:
# entry Call_00a_4000, DE=$A320 initial -> 168 samples, x:16-112, y:24-103
```

So: it's not a brightness/contrast curve, it's a **fast bit-population counter** — "brightness" in
the sense you meant is the *result* of summing these counts across the sampled window, not
anything encoded in the table itself.

---

## 6. Calibration procedure (the `$04FF2`/`$11FF2` question)

Fully traced, bank $0A, JP addresses (labels are in the shipped `.sym`):

**`Cam_Calib_ValidityCheck` → `Call_00a_460f`** computes a checksum over the 12-byte vector at
SRAM flat `$04FF2-$04FFD`:
```
b = sum(bytes) ; c = xor(bytes)      (12 bytes)
b += $0D ; c += $23                   (fixed seed constants)
valid = (b == byte[12]) and (c == byte[13])     ; i.e. bytes $04FFE/$04FFF
```
Result flag → `$ff8a`. Then **`Cam_Calib_EchoCompare`** does the *identical* computation on the
echo copy at `$11FF2-$11FFD` (checksum at `$11FFE/$11FFF`), result → `$ff8d`.

Decision logic:
- Both invalid → `Cam_Calib_RepairPaths` (full regeneration — see below)
- Primary valid, echo invalid (or vice versa) → repair the bad one from the good one
- Both individually valid but their **checksums disagree** with each other → still treated as
  corrupt (repair triggered) — a genuine primary-vs-echo consistency check, not just "is at least
  one copy intact"
- Both valid and mutually consistent → accepted as-is, no rewrite

If **completely** invalid (`Cam_Calib_ValidityCheck`'s first branch), the code doesn't try to
recover anything — it writes a **fixed factory-default vector**: `7E 7F 7F 7F 7E 7D 7E 7E 7D 7E 7D 6A`
directly into `$d5b5-$d5c0` (WRAM working copy) before calling the loader. This is a hard-coded
fallback, not computed from anything — worth knowing if you're hand-crafting save files: these
exact 12 bytes are what a "pretend nothing was ever calibrated" SRAM produces.

I have **not yet** traced exactly what `Cam_Calib_RepairPaths` and `Call_00a_46cf` (the
commit-back-to-SRAM routine used once both copies agree) do byte-for-byte — the read/compare side
is fully nailed down; the write-back side is the natural next step if useful.

**What the 12 bytes mean physically**: displayed on the hidden factory-test screen (§8) as two
labeled hex pairs, "GAIN8" = bytes 0,1 (`$04FF2`,`$04FF3`) and "GAINA" = bytes 10,11
(`$04FFC`,`$04FFD`). Bytes 0,4,8 of the vector (`$d5b5`,`$d5b9`,`$d5bd`) get pulled out
specifically as "the three reference targets" when the brightest gain candidate is chosen — so
the vector is very likely **one target-brightness byte per gain/exposure band** (up to 12 bands),
not a single global calibration constant. This matches your "O register" instinct: it isn't a
single register value, it's a per-band table of target readings that the auto-exposure search
compares its live popcount against.

---

## 7. Dithering pattern selection (high/low)

Traced fully to source. **Correction to what I told you last session**: `Cam_BuildDitherMatrix`
(bank $0A `$42BA`) is a *dispatcher*, not itself the ramp builder — it branches three ways on
`$d59c`:

- **`$d59c == 0`** → `Jump_00a_440c`: writes the **same** 3-byte pattern (`$d583,$d584,$d585`) into
  all 16 register groups uniformly. A **flat/uniform threshold matrix** — effectively no spatial
  dithering, every 2×2 (or however the hardware groups them) cell gets an identical comparator
  value. Used for the gain-search test captures (which fill the matrix with constant `$D5` then
  `$80` purely to get a clean above/below-threshold popcount, not a real picture).
- **`$d59c == 1`** → `Jump_00a_4427`: a computed **linear 16-level ramp** from `$d583` in steps of
  `swap($d584-$d583)`, written across the matrix in the interleaved group order I found last
  session (not simple ascending order — matches the hardware's expected scan order for the 4×4
  comparator block).
- **else (≥2, the normal-photo path)** → the fall-through ramp code: same idea as `$d59c==1` but a
  visibly different write order/grouping (`$a006→$a024→$a01e→$a00c→$a015→$a033...` vs the other
  variant's `$a006,$a012,$a009,$a015` grouping) — **not yet fully diffed against variant 1**, but
  clearly a second, distinct interleaving. This is the one used for ordinary SHOOT-mode captures.

**Table selection** (which 16-row, 4-bytes/row source table feeds `$d583-$d586`), from
`Cam_BuildDitherMatrix`'s own entry logic — confirmed, all 6 call sites in bank $0A checked:

```
B = $d587 (active gain)      C = $d59b (exposure-band index, 0-15, row selector)
if B == $d588 (committed/normal gain):        table = $7C20
elif B == $d589 (set to $04 only when the
                 brightest gain candidate won):  table = $7C60
elif B == $08 (fixed N-bit/dark capture gain):   table = $7C20
else:                                             table = $7C20   (default)
```

So **`$7C20` is the default table used for the overwhelming majority of captures** (normal gain,
and the special dark/"N-bit" gain both route here), and **`$7C60` is a distinct alternate table
that only activates specifically when the auto-gain search's most-sensitive/brightest candidate
wins** — i.e. it looks like a bright-scene-specific dithering profile, separate from the general
one. Both tables' raw 16×4 bytes are dumped in the session log; happy to render them as an actual
visual gradient comparison if useful.

There is also a **third, completely unreferenced table** at bank $0A `$7CA0` (same shape, 16×4
bytes) — confirmed zero references anywhere in the ROM. Genuine unused/leftover data, flagging as
an oddity per your request.

---

## 8. Boot procedure & hidden factory test mode

**Confirmed, fully traced.** During normal boot, bank $0A's `Cam_BootSelfTest_Entry` (`$6A52`) is
called unconditionally (far-call from bank $000's init sequence) with interrupts briefly disabled.
It:

1. Reads the **held** buttons (`$ffa1`, not newly-pressed — this has to be held *through* power-on).
2. If held buttons `== $FD` (everything **except B**) → jumps into the hidden diagnostic screen (below).
3. Else if held buttons `== $FF` (literally everything) → jumps to `Cam_BootAllButtons_or_SensorFail`.
4. Else (normal boot): pings the sensor twice (`Cam_BootPing1`/`Cam_BootPing2`, two tiny bank-$0A
   stubs at `$7D04`/`$7D10` — not yet individually decoded, low information density, likely just a
   presence/ack check) — **and if the first ping returns nonzero (error), it's funneled into the
   same path as holding all 8 buttons.** So `Cam_BootAllButtons_or_SensorFail` is reached two ways:
   deliberately (hold everything) or organically (sensor not responding) — a debug shortcut to
   reach the same failure-handling code without needing to break your cartridge.

### The hidden combo, decoded completely — this is the "undocumented oddity" you asked for

Hold **A+Select+Start+Right+Left+Up+Down** (everything except B) while powering on. This enters
`Cam_FactoryDiag_AllButtonsExceptB`, a genuine factory self-test screen never shown in normal play:

**Screen 1** (font from bank `$24` `$57E0`, layout from bank `$25` `$5840`, decoded via the
discovered charset):
```
*******CHECK**####**############
####PLEASE#WAIT#################
#GAIN8##########################
#GAINA##########################
```
It then pokes four live SRAM reads onto this screen as hex digit pairs:
- `$04FF0`,`$04FF1` → next to "GAIN8"
- `$04FFC`,`$04FFD` → next to "GAINA"

(plus further readouts from WRAM `$d5bf`/`$d5c0` and HRAM `$ff8d-$ff91` at other screen positions —
these are the calibration-checksum result bytes from §6, displayed live).

Final pass/fail: `$ff91 == 0` → loads a row reading **"OK"** (plays sound `$16`); nonzero → loads a
row reading **"NG"** (plays sound `$29`). Either way it then **spins forever** (`jr $-2`) — this is
a true production-line test screen, dead-ends by design, requires a hard reset to leave.

**Screen 2** (same font, tilemap at bank `$25` `$5AC0`) is the ordinary player-visible message,
confirmed byte-for-byte:
```
#######STORE####################
####PLEASE#WAIT#################
```
— i.e. this **is** the same "STORE... PLEASE WAIT" screen you get on completely ordinary boots
when the SRAM calibration data needs (re)writing, which is why holding all-buttons-except-B during
a normal cold boot with valid save data still shows it: the diagnostic screen is a superset of the
normal calibration-repair flow, not a separate code path.

### Second hidden combo, different bank

Also found this session, unrelated to the above: **Select+Start+Up**, checked in bank $004
(`jr_004_4859`, appears at two call sites). Requires WRAM `$d561` to be nonzero (i.e. gated —
doesn't fire from every screen), plays sound `$03`, then jumps straight to local state `$0A` in
whatever screen bank $004 is (our "VIEW/Album" theory). Looks like a developer shortcut into a
specific album sub-screen, skipping normal navigation. Haven't identified what `$d561` gates it on
yet, or fully mapped what state 10 is bank $004's tree — flagging for follow-up.

A third candidate, **Select+Right+Up** in bank $015, exists as a comparison but the surrounding
code is in one of the not-yet-symbol-annotated banks and reads as garbage in the current
disassembly — needs the same `.sym` treatment as bank $0A before I can respect it.

---

## 9. Masked pixel lines (123–128) — partial answer, need your input

What I can confirm from code: the auto-exposure metering routine never samples below **y=103** (see
§5's emulated coverage) — it stops well short of 128, and in fact short of 123 too, so at minimum
the metering itself doesn't touch that region, consistent with treating it as non-photometric.

What I *can't* confirm from this game's code alone: the claim that these rows read back a constant
saturation voltage is a sensor hardware fact (about the M64282FP silicon itself), not something the
firmware "does" — the firmware just trusts whatever the sensor returns at those addresses. AntonioND's
documentation (the copy in your archive) only says *"the actual sensor image is 128×126 or so"* and
defines a `GBCAM_SENSOR_EXTRA_LINES=8` margin for edge-filter calculation purposes in the *emulator*
sample code — that's a software margin for the edge-enhancement convolution needing neighbour pixels
past the visible 112 rows, not necessarily the same thing as physically-masked reference pixels.

What I *did* check: the raw 4096-byte (128×128) buffer format is preserved exactly through to
saved photos — the ROM-baked Album B pictures are full 128×128 dumps, and the same `$1000`-byte
copy size is used when moving the live `$A000` capture buffer around in bank $006. So nothing in
the software path specially crops or discards rows 123-127 — if the sensor is really returning a
constant there, that constant just gets stored and displayed like any other pixel data (though the
album/print UI only ever *shows* 112 of the 128 rows, so a normal player would never see it).

**Question for you**: is the "masked lines / saturation voltage" fact from the M64282FP datasheet
directly, or from your own hardware probing? If you can point me at the specific
datasheet register/section (or share it), I can go confirm whether the game does anything
conditional on that region rather than just storing it inertly — right now I don't have grounds to
say more than "the metering avoids it and nothing crops it."

---

## 10. Open questions

1. §6: want me to finish tracing `Cam_Calib_RepairPaths`/`Call_00a_46cf` (the write-back side of
   calibration), or is the read/validate side sufficient for now?
2. §7: want the two dither tables ($7C20/$7C60) rendered as a visual gradient comparison, and/or
   the third unused table ($7CA0) fully characterized (it's structurally identical in shape, just
   dead)?
3. §8: want me to chase down what `$d561` gates on the Select+Start+Up shortcut, and what bank
   $004 state `$0A` actually shows?
4. §4: want a tile-by-tile match of the asset catalog against each TCRF section (Main Menu, Photo
   Option, Magic Bank, etc.) rather than just the banks I've matched so far?
5. §9: per above — datasheet pointer would help close this one out properly.
6. Priority for next pass: continue the WRAM map into `$D6xx-$D9xx` (UI/print/view state, largely
   untouched so far), or go deeper on the camera cluster we already have good traction on?

---

## Appendix: tools produced this session

- `tools/ram_census.py` — full WRAM/HRAM access census from an mgbdis disassembly
- `tools/asset_catalog.py` — enumerates every banked graphics/tilemap copy call site
- `tools/render_tiles.py`, `tools/render_album.py` — render raw 2bpp ROM data to PNG for visual matching
- `pocketcamera_jp.sym` — the growing symbol file; regenerate the disassembly from this after any addition
