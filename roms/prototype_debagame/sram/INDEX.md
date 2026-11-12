# sram/ - cartridge RAM of Pocket Camera Prototype (Japan) ("DEBAGAME")

The 128 KB cartridge RAM (RAM banks $00-$0F at `$A000-$BFFF`; flat offset = bank x $2000 + (address - $A000)). RAM bank $10 is the sensor register window, not memory (docs §18).

| File | Content |
|---|---|
| `sram_map_proto.csv` | the map, one row per block (3 rows): flat range, RAM bank and CPU range, block, field, tag, routines, note. The hand table (2026-11-12, roadmap step 7), from the access sites and the README (the tester: AGING, PROTECT, GALLERY); the layout is this build's own, not the Japanese one |
| `sram_access_proto.csv` | every proven instruction whose operand is an SRAM address: kind (R read, W write, P pointer load), bank, pc, routine, the RAM bank when the straight-line code before it selects a constant one, the flat offset (`tools/sram_db.py`) |

Access sites: 83 (P 41, R 6, W 36); RAM bank known statically for 14 (12 of them the sensor window; the 2 others all fall inside a row of the map). The bank of the other sites comes from a register or a caller: the image-copy modes, PICT_SAVE_GO and MAKE_GALLERY (the photo number), the tests (a loop over the 16 banks).
