# wram/ - WRAM and HRAM of Pocket Camera Prototype (Japan) ("DEBAGAME")

| File | Content |
|---|---|
| `wram_access_proto.csv` | every proven access site to `$C000-$DFFF`, `$FF00-$FF7F`, `$FF80-$FFFE` (982 rows; `tools/wram_db.py` on `trace/trace_proto.json`; kinds R 403, W 505, P 74) |
| `wram_summary_proto.csv` | one row per address (180 addresses): reads, writes, pointer loads, banks, routines, written constants |

**The layout is this build's own**: the test program has nothing in common with the RAM map of the released camera (`roms/jp_rev_a/wram/`).
The names are in `disasm/ram_names_proto.csv` (163 addresses: WRAM 143, HRAM 20; `tools/proto_ram_names.py`), the I/O registers keep the `hardware.inc` names.
They come from the developers where the code allows a check:

* tag C (126): the name the symbol table of an older build ($2A or $35, `disasm/leftover_symtab_proto.csv`) gives to the address, and a routine of this build that touches it touches it in that older build too (banks $2C / $37, `disasm/oldbuilds_proto.csv`, `disasm/printer_lib_proto.csv`);
* tag I (37): a table name without that shared routine, the in-memory records of a fifth build (0, bank $11, `disasm/leftover_symtab_mem_proto.csv`), or, where no table names the address, `w` / `h` + the routine that touches it most + the address (28).

Derived files (`tools/ram_names.py --names disasm/ram_names_proto.csv`): `disasm/ram_proto.inc` (`DEF ... EQU`, INCLUDEd by `src/game.asm`) and `pocketcamera_proto_ram.sym` (the same names for BGB / no$gba).
The constants of the sequence variable `wGAME_SEQ` (`SEQ_*`, the 14 handlers of `MAIN_SUB` at `00:01FE`) are in `disasm/const_names_proto.csv` / `const_types_proto.csv`.
