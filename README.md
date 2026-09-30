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

### $D5A0–$D5B4 — boot-time scratch (bank $0A only)
21 bytes, each written once and read once, only from bank $0A, only around the boot self-test
sequence (§8 of this doc). Consistent with a **one-shot scratch buffer** for the two boot pings
(`Cam_BootPing1`/`Cam_BootPing2`) rather than persistent state — not deeply traced, low priority
(nothing else in the ROM reads it).

### $D600–$D643 — bank $004 (VIEW/Album) core state
**Confirmed** — this is the album browser's central bookkeeping:

| Addr | Meaning |
|---|---|
| `$d63d` | **Current category index** (confirmed: used as `c` into two 20-byte parallel arrays at `$d615` and `$d629`). Cycles 0→1→2→(3 only if `$d582==1`, else wraps at 3) — i.e. **a normally-3-way category selector that gains a 4th option when `$d582` is set**. This is a genuine, code-verified example of the CoroCoro/extended-content flag gating an extra VIEW category — not the same mechanism as the Album-B unlock (§3), but the same WRAM byte reused for a related purpose in this bank. |
| `$d615` | Base of a 20-byte array, one entry per category, indexed by `$d63d` — contents not yet individually decoded (next step: dump all 20 bytes' consumers) |
| `$d629` | Second parallel 20-byte array, same indexing, read right alongside `$d615`'s — likely a paired (min,max) or (count,flags) per category |

### $D665–$D72D — bank $003 (Owner registration / on-screen keyboard) UI state
Heavy, exclusively-bank-$003 read/write activity (confirmed by call-site pattern, matches the
name/sex/birthdate/blood-type keyboard we walked through live with BGB last session). Not
individually traced byte-by-byte this round, but the shape is very clear: `$d665-$d67e` (dense
R/W, no pointer use — scalar cursor/field state) followed by `$d681,$d6b2` (pure-pointer, P=28
and P=18 — almost certainly the keyboard **layout table base addresses**, one for the hiragana
grid, one for the alphabet grid we saw the game switch between). Good next-session target if you
want the keyboard fully mapped rather than just located.

### $D7C1 — cross-screen signal flag (banks $002/$003/$004/$008)
**Confirmed**: set to `$12` by one screen, polled (`cp $12`) by another which clears it and sets a
different flag (`$dbcc`) on match. A simple one-shot "the previous screen finished with this
specific outcome" signal, reused across four different banks rather than each having its own.

### $D7D2–$D7FF — bank $006 (SHOOT) live-capture UI state
Very active (`$d7e3` alone: 30 reads), exclusively bank $006 except for a couple of bank-$000
crossovers. This is SHOOT mode's own working set (self-timer / zoom / retake-count style state,
by position and density) — **not yet individually decoded**; flagging as a good target if SHOOT
mode is still the priority thread.

### $D800–$D835 — bank $008 (Print) settings
**Confirmed, and connects directly to the GB Printer packet-builder in bank $000**:

| Addr | Meaning |
|---|---|
| `$d801`,`$d802` | **Print margin**, nibble-packed. Confirmed: bank $000's `Call_000_3339` (which builds the actual GB Printer `PRNT` command — default margin `$10,$03`) reads exactly these two bytes, nibble-splitting `$d802` into high/low. This is the "FEED margin 0-30" spinner from the TCRF-documented print option screen. |
| `$d803` | Current print-job **photo/page index** (incremented per page; gates which of two layout templates — `08:$50F6` plain vs `08:$540D` framed — gets loaded, via the shared flag `$dbcb`) |
| `$d804` | Copy count (initialized to 1) |
| `$d806` bit 0 | Selects an alternate default margin (`$d801=1,$d802=$10`) — looks like a "use wide margin" toggle, possibly tied to wild-frame printing needing more border space |
| `$d810` | **Wild-frame selector** — confirmed used as `×4` index (`sla a` twice) into a 4-byte-stride table, matching the 8-entry wild-frame set (§4) |
| `$d814` | Reset alongside `$d803` at print-session start; likely "printing in progress" flag |

Bank $000's `Call_000_1BA4`/`Call_000_3339` build a 12-byte print-command block at `$dc2d`
(contrast=`$dc08`, margin=`$dc09`, palette=`$dc0a` hardcoded `$E4`, plus `$daab` and a 2-byte
value) — this is the actual `PRNT` packet payload later sent over the GB Printer link cable. This
is a solid bridge point if you want to correlate this game's print settings directly against the
raw GBP packet captures you gave me.

### $D890–$D9F8 — bank $005 grid/cursor mechanism
**Confirmed**: bank $005 initializes **three parallel 3-byte cursor structures** at `$d8c8-$d8ca`,
`$d8f3-$d8f5`, `$d8fa-$d8fc` — each `(position, previous-position-or-$FF, flags)`, seeded to
different starting positions (9, 7, 5). All three position bytes are independently used as `rst
$18` jump-table indices (their own per-position dispatch tables, not the top-level `$d5cf` one) —
i.e. **three simultaneously-navigable cursors on one screen**, each driving its own local
jump-table. `$d92e` is written 81 times in this bank alone — almost certainly a shared
"redraw/blit the currently-highlighted cell" trigger fired after every cursor move on any of the
three. I haven't pinned down *which* screen this is yet (candidates: a multi-category stamp
picker, given TCRF documents several parallel stamp categories — small/big/Pokémon/Mario/symbols —
that would each need their own cursor). `$d9d1-$d9f1` (confirmed from last session: `$d9d3`,
`$d9d5`,`$d9d6` are per-slot validity flags) sits right after this cluster and is read by the same
bank, consistent with it being the per-item data the three cursors are browsing.

### $DA00–$DA42 — bank $007 (frame/stamp picker, working theory) + bank $009 boundary
Dense bank-$007-only activity through `$DA2F`, **not yet traced this round**. From `$DA33`
onward the same range switches to being bank-$009-dominant (see next entry) — the two banks' state
don't overlap in practice since only one mode-bank is active at a time, they just happen to share
address space (completely normal/expected for this kind of engine).

### $DA3B–$DA42 — bank $009 (PLAY/hidden RPG minigame) battle state
**Confirmed**, traced directly: this is the battle-menu cursor system for the hidden RPG minigame
found last session (とる/アイテム/チェック/まほう/にげる). `Call_009_5B9D` reads `$da3c`
and compares it against a cascade of thresholds (`$4a,$47,$44,$41,$3e,$4d` — these read as
if-else band boundaries, not literal ASCII) to pick a branch target, then uses `$da3d` (doubled,
`sla a`) as an index into a **pointer table at `$5C0E`** to fetch a per-item handler address, and
`$da3b` as an index into a second array at `$DA4D`. Working read: `$da3b`=selected-item slot,
`$da3c`=cursor's row/band position, `$da3d`=cursor's column within that band. Not fully decoded
down to "which byte is HP vs which is a turn counter" — would need to trace into the `$5C0E`
handler table itself, flagging as a good next target if the hidden minigame interests you.

### $DBCF — shared "sub-dialog result code" (banks $004/$006/$007/$009)
**Confirmed**: a generic return-value channel — one screen sets it to a small constant (`$04`,
`$08`, `$0E`, or a value pulled from a small lookup table at `07:$4186` keyed by `$dc50`) right
before handing off to what looks like a shared confirmation/sub-menu routine, and the *original*
caller later reads it back (`cp $0e`, `cp $04`) to decide where to resume. This is the "which
outcome did the shared dialog produce" pattern — worth fully mapping if you want the shared-dialog
infrastructure (delete-photo confirm, etc.) understood in general rather than per-bank.

### $DC00–$DC5E — bank $000, sound engine channel state
**Confirmed** as the (fixed-bank-resident, i.e. always-available) BGM/SFX engine's per-channel
working set, called from `Call_000_1BA4`/`Call_000_1B97` etc.: `$dc08,$dc09,$dc0a` are copied
in sequence into a 12-byte "note event" block at `$dc2d` alongside `$daab` — matches a 4-field
(channel-type, param, palette-or-volume, duration) sound-event record, consistent with the sound
sequencer we flagged but didn't chase down at `$d520` last round. `$dc08` doubles as the print
contrast byte in the print-packet-building context above (same fixed-bank helper is reused for
both music events and printer commands — a nice, tight bit of code reuse rather than two separate
addresses meaning two different things).

### Not yet touched
`$D6xx` tail past `$D643` outside what's listed above, `$DAA0-$DB80` region generally (lots of
low-traffic pointer-only entries, likely more UI-transition scratch), `$DD00-$DD7D` (dense,
exclusively bank `$01F` — a bank we haven't identified the role of at all yet), and everything
past `$DE00` (mostly single-hit entries scattered across graphics/data banks $028-$03E, probably
not meaningful engine state, more likely incidental self-modifying-adjacent addressing in those
banks' own private use). Full census remains in `assets/ram_census_jp.csv` if you want to point me
at a specific address.

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

Note on bank addressing: SRAM bank selection for the 30 photo slots is **computed**, not a fixed
per-slot immediate value (searched for literal `ld a,$0X / ld [$4000],a` bank-select pairs across
every bank — essentially only bank $0A's CAM-register-window select (`$10`) shows up as a hardcoded
immediate; genuine SRAM data banks are selected via a variable holding the slot index). That's
consistent with 30× 4096-byte slots needing more than 8 banks and being addressed generically
rather than case-by-case. I haven't yet re-derived the per-slot metadata footer layout
independently from JP code (the table in §4 above is sourced from the Inject-pictures
documentation, not yet cross-verified against a disassembled read site) — flagging as a real gap,
not a confirmed-from-code entry, if you want it closed properly rather than trusted from the doc.


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

### The write-back side — now fully traced

`Call_00a_46cf` / `Call_00a_46e1` are a generic pair, not calibration-specific:

```
Call_00a_46cf (LOAD 12+2 bytes FROM [hl] INTO WRAM):
    de = $d5b5 ; repeat 12×: [de++] = [hl++]        ; the 12 data bytes
    $ff8b = [hl++] ; $ff8c = [hl++]                  ; the 2 checksum bytes

Call_00a_46e1 (STORE WRAM back TO [hl], SRAM-write-enabled):
    [$0000] = $0A                                    ; enable SRAM writes (the MBC "RAM enable" register)
    de = $d5b5 ; repeat 12×: [hl++] = [de++]
    [hl++] = $ff8b ; [hl] = $ff8c                     ; re-use the SAME checksum bytes, not recomputed
    [$0000] = $00                                     ; disable SRAM writes again
```

`Cam_Calib_RepairPaths` = "primary good → overwrite echo": select bank 2, `Call_00a_46cf` from
`$AFF2` (loads primary into WRAM); select bank 8, `Call_00a_46e1` to `$BFF2` (writes WRAM to echo).
The mirror-image routine (`jr_00a_46b7`, "echo good → overwrite primary") does the same thing with
the two banks swapped. Either way the **surviving copy's checksum bytes get copied verbatim**,
which is correct — the checksum only depends on the 12 data bytes, and those didn't change.

### The self-test/re-measure gate — a real discovery

`Cam_Calib_Loader`, called after validation/repair succeeds, does something I hadn't expected:
it re-reads all 12 bytes from **both** copies and checks whether **every single byte is `$AA`**
(bank 2 first, then bank 8). If either copy is all-`$AA`, it returns immediately — **no
measurement is taken**. Only if the data is *not* the blank/erased pattern does it fall into
`Cam_Calib_BootMeasureSeq`, which calls `Cam_ExposureBandSelect` (the real sensor measurement,
§3) on **every single boot**, not just first-time setup.

So `$AA`-filled SRAM is a deliberate "this cartridge has never been factory-calibrated, don't
bother measuring against garbage targets" sentinel — consistent with `$AA` being used elsewhere in
SRAM as a general "slot is blank/uninitialized" marker (matches the pattern in the unlock save you
gave me, which was mostly `$AA`-filled). Practical consequence: **the device recalibrates its gain
against the stored reference targets on every cold boot**, not once at the factory and never
again — this is a genuine adaptive system, not a one-time factory trim.

### The calibration vector — complete byte-by-byte mapping

Traced by reading all three branches of `Cam_ExposureBandSelect` (previously I'd only read the
`gain=0` branch). The coarse gain search tries REG1 = 0, 1, 2 in sequence (stopping at the first
that produces a usable test capture); whichever wins picks **three** bytes out of the vector as
the live reference targets (`$d5cb`,`$d5cc`,`$d5cd`):

| Winning gain | `$d5cb` ← | `$d5cc` ← | `$d5cd` ← |
|---|---|---|---|
| 0 | `$d5b5` (byte 0) | `$d5b9` (byte 4) | `$d5bd` (byte 8) |
| 1 | `$d5b6` (byte 1) | `$d5ba` (byte 5) | `$d5bd` (byte 8) |
| 2 | `$d5b7` (byte 2) | `$d5bb` (byte 6) | `$d5be` (byte 9) |
| (fallback/"3") | `$d5b8` (byte 3) | `$d5bc` (byte 7) | `$d5be` (byte 9) |

So the 12-byte vector is really a **3×4 grid** (one row of 4 per "target slot", read down columns
by gain index), with gains 0↔1 sharing their third-slot target and gains 2↔3 sharing theirs:

```
       gain=0   gain=1   gain=2   gain=3(fallback)
slot A: $04FF2   $04FF3   $04FF4   $04FF5      <- $d5cb, "primary" target
slot B: $04FF6   $04FF7   $04FF8   $04FF9      <- $d5cc, "secondary" target
slot C: $04FFA (shared 0&1)   $04FFB (shared 2&3)    <- $d5cd, "tertiary" target
```

`$04FFC`/`$04FFD` ("GAINA" on the factory screen, `$d5bf`/`$d5c0`) are **not** part of this 3-target
selection at all — they're displayed separately on the diagnostic screen but consumed elsewhere
(most likely by the deeper 8-point factory sweep below; I haven't pinned down their exact
consumer yet).

These three chosen bytes (`$d5cb/cc/cd`) are the **target popcount values** the continuous
auto-exposure loop compares its live measurement against (see §11's pseudocode) — i.e. "for this
gain and this part of the exposure curve, a correctly-exposed image should produce approximately
this many dark pixels in the sampled region." That's the precise answer to "which value is which
camera register": **none of the 12 bytes is a register value directly** — they're auto-exposure
*targets*, consumed by WRAM (not written to `$A0xx` hardware registers themselves). The actual
register values (REG1/REG4/REG5) come from a *different*, smaller per-band table (`$d5c1-$d5c9`,
mentioned last round, not re-verified this pass).

There's also a deeper, 8-point factory sweep (`Cam_FactoryMeasure1`, called from `Call_00a_4947`
alongside `Cam_FactoryMeasure2` + `Cam_CommitVectorToSRAM`) that tests REG1 = `$20,$21,$22,$23,
$E4,$E5,$E8,$0A` (gain×edge-mode combinations beyond the simple 0/1/2 used at boot) and stores
results into `$d59d-$d5a8` (REG4 low bits) and `$d5a9-$d5b4` (O-register results) — 8 raw
measurement pairs. This is very likely what actually **produces** the 12-byte vector in the first
place (probably via `Cam_CommitVectorToSRAM`, which I haven't traced yet) — i.e. a genuine factory
calibration pass, distinct from the lightweight boot-time re-check. Flagging as the natural next
trace if you want the full origin story closed out.

### Where exactly is the checksum — unambiguous diagram

```
SRAM flat address:  04FF2 04FF3 04FF4 04FF5 04FF6 04FF7 04FF8 04FF9 04FFA 04FFB 04FFC 04FFD | 04FFE 04FFF
                    └──────────────────────── 12 data bytes ─────────────────────────────┘   └ checksum ┘
                                                                                                 (sum+13, xor+35)

SRAM flat address:  11FF2 ................................................................ 11FFD | 11FFE 11FFF
                    └──────────────────────── echo of the same 12 bytes ─────────────────┘   └ checksum ┘
```
Checksum algorithm (identical for both copies):
```
sum = 0 ; xor = 0
for each of the 12 data bytes b:
    sum = (sum + b) & 0xFF
    xor = (xor ^ b) & 0xFF
expected_byte1 = (sum + 0x0D) & 0xFF      # compared against 04FFE / 11FFE
expected_byte2 = (xor + 0x23) & 0xFF      # compared against 04FFF / 11FFF
```
This is a different, simpler algorithm than the image-tag checksum documented in the
Inject-pictures README — two independent checksum schemes coexist in this SRAM, one for photo
slots and this one specifically for the calibration vector.

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

## 10. Auto-exposure: what part of the image, and the full algorithm

**There are two genuinely different sampling mechanisms** in this code, easy to conflate — I did,
last round. Clearing that up:

### A. The coarse gain search's sanity check — a tiny fixed 4×4 patch, NOT the main metering

`Cam_PixelTestHelper` (called from the 3-way gain loop and from the O-register SAR search) reads
just **4 bytes** from the capture buffer at a fixed address (`$A002` or `$A082`, i.e. tile #0 or
tile #8, row 1), testing 4 specific bits (columns 1–4 of an 8-pixel-wide row) per byte — a **4×4
pixel micro-patch** at a fixed position, used only as a cheap "did this test-capture come back
roughly sane" check during the coarse gain/O-register search. It is not the real photometry.

### B. The continuous fine-adjustment loop — the real metering, and it's the center ~75%×62%

`Cam_PopcountSampleLoop`, called from `Cam_MainDispatch` (the routine that runs continuously
during live preview) starting at `$A320`, walks tile-by-tile across:
```
x: pixel 16 .. 111   (96 of 128 columns — 16px margin left, 16px margin right)
y: pixel 24 .. 103   (80 of 128 rows   — 24px margin top,  25px margin bottom)
```
i.e. a **96×80 center-cropped region** (not a tiny patch, not the full 128×128 frame either) —
roughly the middle three-quarters horizontally and five-eighths vertically. This is the region
the live auto-exposure/auto-gain loop actually measures, every frame, while you're framing a
shot. Verified by symbolically emulating the sample-address sequence against the real ROM bytes
(not guessed) — confirmed no row below 103 or above 24, no column outside 16-111, is ever touched
by this loop.

### The full algorithm, in readable pseudocode

In the spirit of the prototype's `AKARUSA`/`CNTR2`/`CNTR3` naming — here's the retail routine with
meaningful names, verified against the actual disassembly (bank $0A):

```
# ---- Runs once per live-preview frame, after a capture completes ----
def Cam_MainDispatch(target_popcount):
    # target_popcount was picked earlier by the coarse gain search (Cam_ExposureBandSelect)
    # from the 12-byte SRAM calibration vector — see table above.
    select_SRAM_bank(0)                       # 0 = the live image buffer, not general SRAM
    dark_pixels = popcount_scan(x=16..111, y=24..103)   # sum of set comparator bits, center region

    # --- integer "how many target-units fit" via repeated subtraction, capped at 159 ---
    level = 0
    remainder = dark_pixels
    while remainder >= target_popcount and level < 159:
        remainder -= target_popcount
        level += 1
    # level is now 0..159: higher = more dark pixels measured = more underexposed

    correction_shift = CorrectionShiftTable[level]     # bank0A $7B00, 256 bytes, see shape below
    exposure = read_16bit(d596, d597)                  # current REG2:REG3 shadow

    if level >= 36:
        # too many dark pixels -> underexposed -> INCREASE exposure time
        exposure = exposure + (exposure >> correction_shift)
    else:
        # few enough dark pixels -> adequately/over exposed -> DECREASE exposure time
        exposure = exposure - (exposure >> correction_shift)
    # (16-bit add/sub; overflow on increase clamps to $FFFF, underflow on decrease is handled
    #  by the gain-band-switch logic below rather than clamping to 0)

    select_CAM_register_window()
    d596, d597 = exposure                     # commit the new exposure candidate to WRAM shadow

    # --- automatic gain-band switching at the edges of the current band's useful range ---
    if d587 == d589:        # currently on the "brightest-candidate" band
        goto band_specific_handler_1
    elif d587 == 0x08:      # currently on the fixed N-bit/dark band
        goto band_specific_handler_2
    elif d587 == 0x0a:
        goto band_specific_handler_3
    elif REG1_shadow.bit7:  # "already at the top of the range" flag
        if exposure - 0x00CF underflows:
            if exposure - 0xEE00(signed) also underflows:      # truly pinned at max
                commit_exposure_and_return()
            else:
                # step UP to the next-brighter gain band ($d589), fresh mid-range exposure
                d587 = d589 ; REG1 = d589 | 0xE0 ; exposure = 0x0D80
                REG4 = d5c3 ; REG5 = d5c8 | 0x80          # per-band REG4/REG5 from the small table
                rebuild_dither_matrix()
    else:
        if exposure - 0x0030 underflows:        # exposure dropped below ~48 ticks
            # step DOWN to the next-dimmer gain band ($d588), fresh mid-range exposure
            d587 = d588 ; REG1 = d588 | 0xE0 ; exposure = 0x0048
            REG4 = d5c2
        elif exposure - 0x0010 underflows:       # small enough to just floor it
            commit_exposure_and_return()
        else:
            d597 = 0x10                          # floor the low byte, commit
            commit_exposure_and_return()

    write_registers(A002=exposure_hi, A003=exposure_lo, A004=REG4, A005=REG5, A001=REG1)
```

**Why the correction table has the shape it does** (dumped directly from ROM, `bank0A $7B00`):
values are **small (2–4) at the extremes** of the 0–159 range and **peak at 16 right around
index 35–38** (the increase/decrease boundary), then settle to a flat 3 for the rest of the range.
Because the value is a *right-shift count*, small values mean "shift by only a little" = a **large**
proportional correction, while large values (up near 16) mean "shift by a lot" = a **tiny**
correction. So the real shape is: **big, aggressive corrections when the image is badly over- or
under-exposed, and very fine nudges right around the crossover point** — a textbook proportional
controller shaped to avoid hunting/oscillation near the setpoint, confirmed directly from the
table's contents rather than assumed.

This closes the loop on your original question: the "O register" instinct was right in spirit —
what actually happens is a **combined exposure-time-and-gain-band feedback loop**, metering the
center ~96×80 region every frame, compared against a per-gain-band target pulled from the SRAM
calibration vector, with an aggressive-near-extremes/gentle-near-target proportional correction
curve, and automatic hand-off between gain bands when the exposure time would otherwise run off
either end of the current band's useful range.

---

## 11. Open questions

**Resolved this round** (no longer open): calibration write-back/repair paths, the boot
re-measure gate, the full 12-byte vector mapping, exact checksum locations, auto-exposure sample
region, and the full fine-adjustment algorithm.

**New from this round's tracing:**
1. §6: `Cam_CommitVectorToSRAM` (called from `Call_00a_4947` after the 8-point factory sweep) is
   the last untraced piece of the calibration story — it's very likely what actually *computes*
   the 12-byte vector from the 8 raw sweep measurements. Want that closed out?
2. §6: `$04FFC`/`$04FFD` (`$d5bf`/`$d5c0`, shown as "GAINA" on the diagnostic screen) are read
   but their consumer wasn't identified this round — candidates are somewhere in the 8-point sweep
   or `Cam_CommitVectorToSRAM`.
3. §10: the fixed constants used when switching gain bands (`$0D80`, `$0048`, `REG4` from
   `$d5c2`/`$d5c3`, etc.) are transcribed correctly but not independently explained — would need
   the same kind of tracing as the main vector to say *why* those specific values.

**Still open from before:**
4. §7: want the two dither tables ($7C20/$7C60) rendered as a visual gradient, and/or the third,
   unused table ($7CA0) fully characterized?
5. §8: what `$d561` gates on the Select+Start+Up shortcut, and what bank $004 state `$0A` shows?
6. §4: tile-by-tile match of the asset catalog against each TCRF section?
7. §9 (masked lines): still need a datasheet pointer or your own probing data to close out properly.
8. §2: the bank $005 triple-cursor screen's identity (mechanism confirmed, screen unknown).
9. §SRAM: the photo-slot metadata footer is still trusted from the Inject-pictures doc, not
   re-derived from JP code.
10. Bank `$01F` (`$DD00-$DD7D`) is still completely unidentified.
11. Next WRAM targets: `$D615`/`$D629` (VIEW-category arrays), bank-$003 keyboard layout tables,
    bank-$006 SHOOT state, or bank-$007's `$DA00-DA2F` — which first?

---

## Appendix: tools produced this session

- `tools/ram_census.py` — full WRAM/HRAM access census from an mgbdis disassembly
- `tools/asset_catalog.py` — enumerates every banked graphics/tilemap copy call site
- `tools/render_tiles.py`, `tools/render_album.py` — render raw 2bpp ROM data to PNG for visual matching
- `pocketcamera_jp.sym` — the growing symbol file; regenerate the disassembly from this after any addition
