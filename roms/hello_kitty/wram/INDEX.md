# wram/ - WRAM and HRAM of Pocket Camera Hello Kitty (Japan)

| File | Content |
|---|---|
| `wram_access_kitty.csv` | every proven access site to `$C000-$DFFF`, `$FF00-$FF7F`, `$FF80-$FFFE` (5687 rows; `tools/wram_db.py` on `trace/trace_kitty.json`; kinds R 2057, W 2865, P 765) |
| `wram_summary_kitty.csv` | one row per address (704 addresses, 666 of them WRAM / HRAM): reads, writes, pointer loads, banks, routines, written constants |

Written by `tools/kitty_l4.py` (roadmap step 11, 2026-11-15), with the names, the SRAM files and the constants; never edit these files by hand.

**Names** (`disasm/ram_names_kitty.csv`, 477 rows: WRAM 396, HRAM 81; tag C 147, I 330; `tools/kitty_ram_names.py`):

* 60 by hand (`disasm/layers/ram_names_kitty_hand.csv`, each with its evidence): the mode and state, the keys (named as the Japanese ROM names its own: `wKeysHeld`, `wKeysNew`, `wKeysNewRepeat`, `wKeyRepeatDelay` ...), the LCD shadows the VBlank handler copies (`wLcdcShadow` ... `wLycShadow`), the fade (`wPaletteTarget`, `wFadeLevel`), the OAM shadow and the VRAM queue, the 15 puzzle, the counters block that mirrors SRAM `$B000-$B011` (`wCountTaken` ... `wKitts`, `wPuzzleDrawingsDone`, `wNameCardMade`), the ID card, the name card photos and the photo tag (`wSlotTag*`, the offsets of the Japanese tag);
* 130 from the Japanese ROM: an access site of this ROM pairs with a Japanese site of the same kind (`disasm/match_jp_kitty.csv`: same code; `disasm/similar_jp_kitty.csv`: an aligned copy) and the Japanese name of that address is taken, at the start most paired sites give; tag C when the code is the same, no other name shares the bytes and every paired site agrees (the sound engine, the printer and link drivers, the camera registers, the RNG);
* 287 named after the routine that touches the address most, `w` / `h` + routine + address (`wMode14_State01_D8ED`), tag I: to be named when their routines are read.

Derived: `disasm/ram_kitty.inc` (`DEF ... EQU`) and `pocketcamera_kitty_ram.sym` (`tools/ram_names.py`). The constants of the values these variables hold (modes, states, keys, palettes, sound ids) are in `disasm/const_*_kitty.csv` and `disasm/const_kitty.inc`.
