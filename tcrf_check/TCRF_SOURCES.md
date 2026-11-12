# TCRF: where the content is

The repository holds **no TCRF content** (owner, 2026-11-12): no copy of TCRF's pages, pictures or listings. Where a name, a note or
a document credits TCRF, the content is on the pages below. TCRF is credited only for what these pages show; what they do not show is
"unused, not documented by TCRF" (`roms/<folder>/assets/unused_<tag>.csv`, `tools/unused_table.py`; the TCRF section of each block is
in `tcrf_check/tcrf_documented.csv`).

| Page | Revision checked | Used for |
|---|---|---|
| [Game Boy Camera](https://tcrf.net/Game_Boy_Camera) | [oldid 1968673](https://tcrf.net/index.php?title=Game_Boy_Camera&oldid=1968673) | group B of `TCRF_CHECKLIST.md`; the `Unused_TCRF_*` names of the Japanese, international and Gold ROMs |
| [Game Boy Camera/Regional Differences](https://tcrf.net/Game_Boy_Camera/Regional_Differences) | [oldid 1846909](https://tcrf.net/index.php?title=Game_Boy_Camera/Regional_Differences&oldid=1846909) | group C; `docs/20_tcrf_regional_differences.md` |
| [Prerelease:Game Boy Camera](https://tcrf.net/Prerelease:Game_Boy_Camera) | - | the Rev 0 note and the cut moving-object capture (nothing located in a ROM) |
| [Proto:Game Boy Camera](https://tcrf.net/Proto:Game_Boy_Camera) | [oldid 1982808](https://tcrf.net/index.php?title=Proto:Game_Boy_Camera&oldid=1982808) (4 December 2025) | group D; the `Unused_TCRF_*` names of the prototype (fourteen pictures, editor UI, NEO logo, arrow cursor) and its source-code chunks |
| [Hello Kitty Pocket Camera](https://tcrf.net/Hello_Kitty_Pocket_Camera) | - (read 2026-11-12) | the Pompompurin picture (mode `$18`), the only unused item of that page |

The tools that compare a ROM with a TCRF picture (`tcrf_check/tools/tcrf_exact_match.py`, `tcrf_check/tools/tcrf_cell_rebuild.py`, `tcrf_check/tools/run_star_pair.py`)
take the picture as an argument: save it from the page first. Their earlier comparison pictures, which embedded TCRF images, were
removed on 2026-11-12 together with the owner's copies of the pages (`source/Unused_graphics_TCRF/`, still in the git history before
that date).
