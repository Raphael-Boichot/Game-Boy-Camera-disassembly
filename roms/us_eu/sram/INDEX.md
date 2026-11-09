# sram/ - cartridge RAM of Game Boy Camera (USA, Europe)

The 128 KB cartridge RAM (RAM banks $00-$0F at `$A000-$BFFF`; flat offset = bank x $2000 + (address - $A000)). RAM bank $10 is the sensor register window, not memory (docs §18).

| File | Content |
|---|---|
| `sram_map_us.csv` | the map of the Japanese ROM (`roms/jp_rev_a/sram/sram_map_jp.csv`, docs §3), with each routine at its address in this build; written by `tools/sram_map.py --tag us`, never edit it |
| `sram_access_us.csv` | every proven instruction whose operand is an SRAM address: kind (R read, W write, P pointer load), bank, pc, routine, the RAM bank when the straight-line code before it selects a constant one, the flat offset (`tools/sram_db.py`) |

Access sites: 477 (P 208, R 20, W 249); RAM bank known statically for 78 (35 of them the sensor window; the 43 others all fall inside a row of the map). The bank of the other sites comes from a register argument or a caller (the storage manager of bank 2 selects it before the copies; docs §3.5).

Same layout as the Japanese ROM (C, static): each of the 477 access sites of this build pairs, through `port/code_map_us.csv`, with a Japanese site of the same kind at the same SRAM address, and no site is new. What differs is content, not layout: the owner name and the comments are codes of the international character set (`disasm/charset_us.csv`), and the English owner card has no blood-type field (`Unused_OwnerCard_DrawBloodType` is dead code, docs §1.5).
