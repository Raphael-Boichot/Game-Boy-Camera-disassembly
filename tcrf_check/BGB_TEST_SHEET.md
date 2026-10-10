# BGB confirmation sheet — results

AI slop, do not trust until human validation (not performed yet, work in progress).

Addresses are `bank:address` of the Japanese ROM (md5 fdcfe686cf4df461e870b6e53b2b5a8b), as in `pocketcamera_jp.sym`; the international ROM used for comparison is md5 42d2f65e2549be9d1d126a6828b5d1c1. SRAM offsets are file offsets of the 128 KB `.sav`. Checksum rule of the protected blocks: lo = sum + $4E, hi = xor ^ $54 (README section 3).

**What was done.** BGB 1.5.x (Windows build, run under Wine, headless) replayed joypad *demo* files (`-demoplay`, one byte per frame: A=1 B=2 Select=4 Start=8 Right=$10 Left=$20 Up=$40 Down=$80) and wrote a *state file* at exit (`-stateonexit`) and a screenshot (`-screenonexit`); the WRAM chunk of the state file gives the mode (`$D5CE`) and state (`$D5CF`), the SRAM chunk gives the save. BGB needs 3 more boot frames than my core for the same path. Everything is in `tcrf_check/assets/bgb/` (demos, last screens, small input saves, `results/*.txt`); the tools are `tools/bgb_*.py` (README §16.6, appendix). **What was not done:** BGB's debugger (breakpoints, watch of `$FF01/$FF02`) and its printer core.

| # | Hypothesis (README) | Run in BGB | Result | Result file |
|---|---|---|---|---|
| 1 | Replaying the 206 joypad paths of the corpus gives the same end state as my core | all 206 paths, Japanese ROM | 166 comparable (40 need the printer): **135 exact**, 13 same mode / other state, 18 different mode; without the 3-frame shift 124 / 14 / 28 | `sweep_summary.txt`, `bgb_vs_core*.csv` |
| 2 | Real credits need a stored Run!Run!Run! value `>= $7799` (displayed 22:00 or lower) (§15.2) | credits path on save CE10229233 and its unlocking twin | stored `99 99`: reaches `08:17`; stored `93 77` (22:06): stays at `08:01` | `credits_gate.txt` |
| 3 | CoroCoro tag = 2 of 3 bytes `56 56 53` at `$1FFD-$1FFF`, rewritten at boot (§15.2) | six tag values, Japanese ROM | `56 56 53`, `56 56 00`, `00 56 53` → `$D582 = 1`, `$D562 = $1E`, tag rewritten; `56 00 00`, `00 00 00`, `AA AA AA` → `$D582 = 0`, `$D562 = $18` | `corocoro_tag.txt` |
| 3b | The same on the **international** ROM (§16.5) | the same six values | all six give `$D582 = 1`, `$D562 = $1E` (flag set unconditionally), non-matching tags left untouched | `corocoro_tag_intl.txt` |
| 4 | Pokémon stamp pages `$D642 = min($DAA5,5)+4` (`04:5827`) | Ball value 0-6 and 10 in SRAM `10CA`; and 25 saves | `04 05 06 07 08 09 09 09`; rule holds on 18 saves, 7 not tested (path did not reach the stamp tool) | `pokemon_ball_values.txt`, `pokemon_gate_25_saves.txt` |
| 5 | Holding A in stamp placement mirrors the stamp, first hit 180 frames after the press, then every 100 (§15.4) | Japanese **and** international ROM, A held 0-395 frames | buffers unchanged at 150 / 175, mirrored at 185 / 230 / 275, original at 285 / 330 / 385, mirrored at 395; `$D641` = 180 then 100 | `stamp_hold_jp.txt`, `stamp_hold_intl.txt` |
| 6 | Hot-spot effects: effect k runs the state sequence `0C:03 → 0C:04 → 0C:03` (§15.5) | effects 0-15 on one photo, +30 and +90 frames after A | BGB and core are in the same state at both instants for all 16 effects (+30: `0C:04` for effects 1, 2, 3, 5, 6, 7, `0C:03` for the shorter 0, 4, 8-15; +90: `0C:03` for all); 98.7 % of the pixels equal on average | `hotspot_effects.txt` |
| 7 | Link exchange: sender entry → `FF`, receiver slot filled, `F14` +1 (§14) | two BGB instances (`-listen` / `-connect`), both ROMs | as predicted; same bytes on both ROMs; sender `10BF-10C0` `00 00` → `01 00`; receiver counters were at the cap 99; end screens あげました / もらいました + よろしい (Japanese), sent / received + GOOD (international) | `link_run1.txt`, `link_intl_run1.txt`, `link_counters.txt` |
| 8 | `$DA56` bit 0 = male, bit 1 = female (§16.7) | owner registration on an unregistered save | "?" → `00`, first symbol → `01`, second symbol → `02` | `gender_bits.txt` |

**Not run (still to do in BGB's debugger, if wanted).**

| Hypothesis | Setup | Breakpoint / watch | Expected |
|---|---|---|---|
| The two-stage hot-spot dispatch jumps to `6642 66AF 66DC 67D5 6801 6838 68A4 6901` for effects 0-7 and to `6983` for 8-15 | photo with a hot spot, pointer on it, A | `03:6543` | the jumps listed (does `6983` show a wave only for the S icon? TCRF says so; the code does not test the effect number) |
| Link byte timing: HELLO `$29` / `$12`, info byte, command `$40|n`, 4,096 data bytes | two BGB instances | `00:2AE9` (serial IRQ), watch `$FF01`, `$FF02` | the values and alternation of `link_protocol/LINK_PROTOCOL.md`; the timing is the emulator's so far |
| The F12 / F13 reception counters move by receiver gender | a receiver save whose `10C3/10C4` are not at the cap | SRAM after the exchange | `F12` +1 if the receiver's `$DA56` has bit 0, `F13` if bit 1 |
| "Don't butter me up!" ending picture is in the JP ROM | after #2 | `09:50D0` | screen 16 of the credits |
| Printer: packet driver and print-animation behaviour (§13.7) | BGB's printer emulation | `DC00-DC42` driver | not examined |

Please tell me what you see (a screenshot or the register values at a breakpoint is enough) and I will fold the result into README section 16.
