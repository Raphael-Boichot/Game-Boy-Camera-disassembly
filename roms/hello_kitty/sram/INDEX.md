# sram/ - cartridge RAM of Pocket Camera Hello Kitty (Japan)

The 128 KB cartridge RAM (RAM banks $00-$0F at `$A000-$BFFF`; flat offset = bank x $2000 + (address - $A000)). RAM bank $10 is the sensor register window, not memory (docs §18).

| File | Content |
|---|---|
| `sram_map_kitty.csv` | the map, one row per block or field (38 rows): flat range, RAM bank and CPU range, block, field, tag C / I / N, routines, note. The hand table (2026-11-15, roadmap step 11), from the code of bank $01 (`Sram_*`, `Photo_*`, `Counters_*`) and of the calibration (bank $04); the rows of photo slot 1 stand for the 30 slots. Shared with the Japanese layout: the photo slots, the photo vector, the ID card (the Japanese owner block), the RNG seed and the calibration record; its own: the counters block `$B000-$B016` (no checksum), the three name card photos `$B1FC-$B88B`, no settings block, no Game Face |
| `sram_saves_kitty.csv` | the map checked on six saves the game writes in the core (`tools/kitty_sram_saves.py`): formatted, factory-fresh ($AA), two photos, 999,999 Kitts, the erase screen answered B and A. Every byte written lies in a written row, every Magic, checksum and echo holds |
| `sram_access_kitty.csv` | every proven instruction whose operand is an SRAM address: kind (R read, W write, P pointer load), bank, pc, routine, the RAM bank when the straight-line code before it selects a constant one, the flat offset (`tools/sram_db.py`) |

Access sites: 423 (P 152, R 18, W 253); RAM bank known statically for 59 (22 of them the sensor window; the 37 others all fall inside a row of the map). The bank of the other sites comes from a register argument or a caller (`Sram_PhotoSlotAddr` for the photo slots: RAM bank (N + 1) / 2, `$A000` / `$B000`). Two P sites of bank $05 (05:4E06, 05:6048) load $B050 / $B850 as object coordinates (`Object_CreateWithParam`, BC = x / y), not SRAM.
