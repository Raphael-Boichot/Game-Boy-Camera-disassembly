# wram/ — WRAM / HRAM map data (Pocket Camera JP Rev A)

The condensed map is README §2. This folder holds the full per-region write-ups (every row cites `bank:addr` of proven code) and the machine-readable data behind them.

| File | Content |
|---|---|
| `wram_lowwram.md/.csv` | `$C000-$D4FF` (slot work buffer, exchange buffer, VRAM staging, overlays) and the stack `$DE00-$DFFF` |
| `wram_d500.md/.csv` | `$D500-$D5FF` (VRAM queue, RNG, mode / state, input, settings block movers) |
| `wram_d600.md/.csv` | `$D600-$D7FF` |
| `wram_d800.md/.csv` | `$D800-$D9FF` |
| `wram_da00.md/.csv` | `$DA00-$DBFF` |
| `wram_dc00.md/.csv` | `$DC00-$DDFF` (printer driver, link protocol, sound driver state) |
| `wram_hram.md/.csv` | `$FE00-$FFFF` (OAM, I/O shadows, HRAM) |
| `wram_access.csv` | every proven access: address, kind (R read, W write, P pointer load), bank, pc, function, constant written |
| `wram_summary.csv` | per address: reads, writes, pointer loads, banks, top functions, constants written (1,153 addresses) |
| `trace_jp.json` | first (baseline) trace: 56,799 instructions, 14 unresolved indirect sites |
| `trace_jp_v3.json` | trace with `tools/extra_roots.json` (134 roots, 45 of them unreferenced code): 60,449 instructions, 0 unresolved |

Notes
- The `.md` files were written against the first access tables (1,135 addresses). `wram_access.csv` / `wram_summary.csv` are the final ones (1,153 addresses, all covered by a row of the `.csv` files); the 18 extra addresses are covered by the README §2 tables and the "Update after the v3 trace" notes.
- Status tags: C code-traced, I inferred, U unused/dead, ? inconclusive.
- Regenerate the access tables with `python3 tools/wram_db.py pocketcamera_jp.gb <roots.json> pocketcamera_jp.sym <prefix>` (needs the ROM, which is not included).
