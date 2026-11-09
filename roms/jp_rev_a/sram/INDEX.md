# sram/ - cartridge RAM of Pocket Camera (Japan) (Rev A)

The 128 KB cartridge RAM (RAM banks $00-$0F at `$A000-$BFFF`; flat offset = bank x $2000 + (address - $A000)). RAM bank $10 is the sensor register window, not memory (docs §18).

| File | Content |
|---|---|
| `sram_map_jp.csv` | the map, one row per block or field (71 rows): flat range, RAM bank and CPU range, block, field, tag C / I / B / F / N / ?, the routines that write or read it, note. The hand table: transcribed from docs §3 (2026-11-09), which keeps the full text, the save evidence (docs §11) and the checksum rules; edit both together |
| `sram_access_jp.csv` | every proven instruction whose operand is an SRAM address: kind (R read, W write, P pointer load), bank, pc, routine, the RAM bank when the straight-line code before it selects a constant one, the flat offset (`tools/sram_db.py`) |

Access sites: 477 (P 208, R 20, W 249); RAM bank known statically for 78 (35 of them the sensor window; the 43 others all fall inside a row of the map). The bank of the other sites comes from a register argument or a caller (the storage manager of bank 2 selects it before the copies; docs §3.5).
