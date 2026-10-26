[README](../README.md) · [Section index](index.md)

## 4. Asset catalog

Cross-referenced against both uploaded TCRF pages. A machine-generated catalog of **every** banked
tile/tilemap copy in the ROM is in `roms/jp_rev_a/assets/catalog_jp.csv` (385 copy-call sites, 270 unique
source blocks) — built by pattern-matching every call to the two banked-copy helpers
(`Call_000_0450` → VRAM tiles/tilemap, `Call_000_0586` → smaller copies) and reading back the
`a`/`hl`/`de`/`bc` values loaded immediately before each call. All unique tile sources are
pre-rendered to PNG in `roms/jp_rev_a/assets/atlas/` with an `INDEX.txt` cross-reference (bank, ROM address,
length, VRAM destination, caller).

Confirmed against the owner's documentation (PDFs) and rendered directly from the JP ROM:

- **Album B (30 pictures)**: `$0DA000` + i×`$1000`, matches TCRF's B01–B30 list exactly (rendered — see `roms/jp_rev_a/assets/albumB_jp.png`). Per-picture metadata footer confirmed at offset `$F00-$FFF` of each slot (magic bytes, user-ID echo, border index, hot-spot flags, checksum) matching the Inject-pictures documentation's field layout. B01-B21 carry a name (`F04-F0C`) and a comment (`F15-F2F`) in the game's character set, decoded in §16.27 (B22-B30 and all 30 slots of the international ROM have none).
- **Wild frames (8)**: `$0C4000` + i×`$1800` (rendered — `roms/jp_rev_a/assets/wildframes_jp.png`); only wild-frame index 4 (the 5th) is byte-identical between JP and international, matching TCRF's note that frames 07/08 are CoroCoro-exclusive and everything else is region-swapped art.
- **Hidden factory-test font**: bank `$24` offset `$57E0`, 0x300 bytes = 48 tiles, a plain `0-9 A-Z + - *` charset used only by the hidden diagnostic screen (§8) — **not documented anywhere we've seen**, genuinely new.
- Main Menu / Photo Option / Magic Bank / Album Bank / Run!Run!Run! / DJ / Printer graphics banks named in the TCRF "unused graphics" page: **matched against each TCRF item** (§15, `tcrf_check/TCRF_CHECKLIST.md`): the per-item status is the table of §16.24; the D.J. tile (B14) and the RUN! star (B18) were located on 2026-10-19 (§16.29). The wild-frame sheet is 20 tiles wide and the CoroCoro stamps are at `2B:4000`.

---
