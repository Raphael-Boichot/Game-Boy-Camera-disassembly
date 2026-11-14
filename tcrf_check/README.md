# tcrf_check: what TCRF documents, checked against the ROMs

AI slop, do not trust until human validation.

Only TCRF material is kept here (owner, 2026-11-14): the checklist of what the TCRF pages document, the pictures that answer each of
its rows, and the tools that compare a ROM with a TCRF picture. Everything else that used to sit here moved on 2026-11-14:
the Japanese-ROM experiments to [`roms/jp_rev_a/experiments/`](../roms/jp_rev_a/experiments/), their scripts to
[`tools/jp/`](../tools/jp/), the two map tools (`rom_layout_map.py`, `rom_reach_map.py`, `rom_reach_classes.py`) to [`tools/`](../tools/),
and the sensor material (the real calibration saves, the BGB sensor recordings) to [`sensor/`](../sensor/).

**No TCRF content is kept here** (owner, 2026-11-12): the TCRF pages and their revisions are linked in [`TCRF_SOURCES.md`](TCRF_SOURCES.md).

* `TCRF_CHECKLIST.md` / `.csv`: the TCRF items (A unlock-gated content, B TCRF "unused" sections, C the Japanese side of "Regional
  Differences", D the prototype page), each with ROM location, coverage, finding, evidence tag (C, I, ?) and the files that answer it.
  Generator: `tools/tcrf_checklist.py`. The reasoning is in docs §15 and §20.
* `tcrf_documented.csv`: which unused blocks of each ROM a TCRF page shows (with its section), read by `tools/unused_table.py`.
* `assets/`: only the files a checklist row cites (Album B, wild frames, frames and stamp sheets, hot-spot icons, the composed screens and
  located unused graphics of the B and C rows, the two hidden pictures of docs §20). A row that cites a file elsewhere names its path.
* `shots/`: emulator screenshots of the checklist rows (credits, CoroCoro screens, wild frames, album, SGB border, stamps).
* `tools/`: `tcrf_checklist.py`, and the three tools that compare a ROM with a picture saved from a TCRF page
  (`tcrf_exact_match.py`, `tcrf_cell_rebuild.py`, `run_star_pair.py`).
