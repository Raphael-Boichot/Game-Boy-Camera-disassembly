# tcrf_check: TCRF documented content checked against the Japanese Pocket Camera ROM

AI slop, do not trust until human validation.

* `TCRF_CHECKLIST.md` / `.csv`: 54 items (unlock-gated content, TCRF "unused" sections, Japanese side of "Regional Differences"), each with ROM location, coverage computed from `coverage/v8/merged_v8/cov.npz`, finding, evidence tag (C traced, I inferred, ? not located) and asset files. The reasoning is in README section 15.
* `assets/`: everything retrieved (Album B, wild frames, frames, stamps, 68 composed screens, hot-spot icons, located unused graphics, the two confirmation runs). Added with README section 16: `assets/bgb/` (the BGB runs: demo files, last screens, small input saves, `results/*.txt`; the 200 MB of BGB state files are not kept), `assets/atlas2/{JP,INTL,INTL2}` (screen of every reached (mode, state) on the Japanese ROM, the same inputs on the international ROM, and a native exploration of the international ROM; `result.json`), `assets/intl_compare/` (Japanese / international pairs, the mirrored-main-menu probe, Album B pages with and without the CoroCoro tag, `boot_flags.txt`, `menus_not_in_guide.png`).
* `BGB_TEST_SHEET.md`: what was run in BGB (8 checks, results) and what is still to do in its debugger.
* `shots/`: emulator screenshots (credits, CoroCoro screen, wild frames, album, SGB border, stamps).
* `work/`: atlas contact sheets (`atlas_modes/sheet_NN.png`, `MM_SS` = mode, state), D.J. captures, census data, unused-tile gallery.
* `tools/`: the scripts. They were run from a working tree whose layout was `package/coverage/src` (here `coverage/src`), `saves/`, `unlock_runs/`; `lib.py` sets the paths and `GBCAM_ROM` overrides the ROM. Rebuild the native core from `coverage/src` first (see `coverage/README.md`); `coverage/src/gbcov8.c` is the core used for v8.
