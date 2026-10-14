---
name: gb-rom-disassembly
description: Use when starting a new Game Boy / GBC ROM disassembly, or when asked how far one is from complete: staged playbook, levels L0-L6, tools and pitfalls from the Pocket Camera project.
---

# Disassembling a Game Boy ROM (playbook from the Pocket Camera (Japan) Rev A project)

Full version: `HOWTO_NEW_ROM.md` in the Game-Boy-Camera-disassembly repository (README section 1.3 has the measured status of that ROM). Read the repo's `CLAUDE.md` first when working in it. The ROM is never in the repository: ask for it and for every sibling ROM (region, revision, edition).

## Say which level a claim is about

| Level | Meaning | Test |
|---|---|---|
| L0 | listing reassembles to the same md5 | `make` prints the md5 |
| L1 | every byte typed (code, data with row width, text, padding) | the `.sym` has no hole |
| L2 | code proven by a recursive-descent trace (0 unresolved indirect jumps) and observed in an emulator | trace + coverage report |
| L3 | every routine and asset named, tagged C / I / ?, doubts listed | names CSV + doubts CSV |
| L4 | RAM variables and constants applied in the source (no raw `[$D5CE]`) | grep for raw RAM operands |
| L5 | committed, buildable, editable tree: split files, assets as INCBIN, md5 check in `make` | tree in git |
| L6 | understanding: charset table, sibling ROMs, owner-validated names | owner answers file |

Pocket Camera JP on 2026-10-14: L0-L2 done, L3 mostly (5,334 names: C 3,499 / I 1,666 / ? 169), L4 not done (0 RAM labels, 5,632 raw WRAM and 2,583 raw HRAM operand lines), L5 not done, L6 partial. Do L0-L2 first, but start L4 and L5 as soon as L2 exists: they were left to the end and are still open.

## Stages, in order

1. **Intake.** md5, header `$0100-$014F` (MBC type, sizes, flags), diff siblings per bank (the two Pocket Camera ROMs differ in 44 % of their bytes: traces do not transfer). Pin `rgbds` (1.0.4 wants `ldh a, [$FFxx]`) and `mgbdis` v3.0. Round trip with NO symbols first: `python3 mgbdis.py --output-dir out rom.gb && cd out && make`; fix any md5 difference before anything else.
2. **Symbol file = single source of truth.** mgbdis v3.0 has no `--sym` option: it reads `<rom basename>.sym` beside the ROM (`BB:AAAA Name`, block lines `.code:LEN`, `.data:LEN[:WIDTH]`, `.text:LEN`, `.padding:LEN`, LEN in hex). Never edit the `.sym` by hand: keep `sym_names_*.csv` (`bank,addr,name,conf,note,source`, layers assets < auto < hand < fixes, name `-` deletes) and `sym_types_*.csv` (`bank,start,end,type,width,note`), plus the trace, and a builder that aborts on duplicate names, labels inside instructions, holes, overlaps and non-uniform padding. Naming: `Module_Verb` PascalCase; assets `Gfx_BB_AAAA_...`, `Map_...`, `Src_BB_AAAA_...`. Tag every name C (code read / emulator / BGB) / I (inferred) / ? (doubt) and regenerate the doubts list after every rename.
3. **mgbdis artefact.** It prints a label for any operand equal to a label's address (`ld bc, Label` as a byte count, `ld [Label], a` as an MBC write, far pointers in the wrong bank, word tables as `db`). A post-pass (`sym_fix.py --tables`) rewrites what the instruction bytes decide; bytes and md5 do not change. Extend its rules for each ROM.
4. **Static tracer.** Recursive descent from the vectors, entry point, labels, mode/state tables, then hand roots with a reason each. Teach it the engine helpers first (banked call, one-way far jump, banked copy, `rst` jump tables with inline words, wait loops). List unresolved indirect jumps (`jp hl`, computed calls), resolve each by hand (table idiom, split immediates, cooperative task entries, RAM callbacks), repeat until 0. Cap an inline `rst` table at the lowest target seen (one table was read a word too long and swallowed a handler's first instruction). Reachable is not live: keep unreferenced roots as dead roots.
5. **Assets.** Catalogue every banked copy call with constant bank/source/destination/length. A far pointer counts only if the immediate reaches the helper unchanged (`ld hl,TABLE; add hl,bc; ld a,[hl+]` is a local table). Render 2bpp sheets 16 tiles wide and maps 32 wide; typing by picture is allowed but tagged. Outside pictures (TCRF, Spriters Resource) may be 2x enlargements; a 1-2 tile exact match is weak. Banks with no static reference are found with an emulator ROM-read log.
6. **RAM map, then wire it in.** Build the access database (every instruction touching `$C000-$DFFF`, `$FF80-$FFFE`, I/O; R / W / pointer-load kinds; read-modify-write through HL is invisible). One CSV per region with name, type, writers, readers, evidence tag. Use real cartridge saves for the SRAM layout (checksums, mirrors, magic). Then apply the names: mgbdis accepts RAM labels in the `.sym` (`00:d5ce wMode`, bank 00 applies in every bank), but the assembler needs an include that defines them (`DEF wMode EQU $D5CE`), and the false-positive class of step 3 applies.
7. **Dynamic evidence.** Own SM83 core with coverage (fast, fuzzed joypad taps, single keys and 34 chords, seeded with real saves, replayable corpus) then BGB (the judge). What remains is gated by data, not keys: direction pressed while A is held, counter wraps, filled tables, out-of-range cursors, save contents. Poke WRAM/SRAM between frames (a variable recomputed every frame cannot be forced; a value known only inside a frame needs a two-pass snapshot/restore). Table overruns run garbage: count them separately, never as designed paths. Forcing: jump to an unreferenced function at a safe idle point (the main thread's halt/wait), flip a gating branch, replay in BGB through a hook in free bank-0 bytes called from the main loop. Forced dead code stays evidence I.
8. **BGB harness.** Demo file = one joypad byte per frame (A=1 B=2 Select=4 Start=8 Right=$10 Left=$20 Up=$40 Down=$80), 250-frame boot hold, `xvfb-run wine bgb.exe -hf` (`-headless` if linked runs stall), `-stateonexit` for RAM/VRAM/OAM, `-screenonexit` (160x144 only), `-br` breakpoints, 2 workers (about 250 runs in 4 minutes), long jobs with `setsid nohup`.
9. **Text, split tree, sibling ROM.** Find the font bank early and build the charmap from the glyph sheets (not done for Pocket Camera). Commit the generated listing or per-bank sources with assets as INCBIN and a `make check` that compares the md5 (not done). For a second region, trace it separately; untested idea: match the first ROM's functions by their bytes with operands masked and port the names.

## Pitfalls (all hit once)

- BGB refuses VRAM writes in PPU mode 3 (161 of 256 bytes landed); its logs are hex; its WAV time is not a constant offset (find a sound by content); it needs 3 more boot frames than my core. Read register writes at the right pc, not the last write.
- Screenshots and asset comparisons come from BGB, never from my core (it draws some screens wrongly).
- A hex parser that expected upper case found nothing in the lower-case `.sym` and produced a false "nothing is displayed" claim: test a parser on a known label.
- Never `pkill -f PATTERN` when PATTERN is in your own command line: kill by PID. Foreground calls over 120 s are killed.
- Recompute every number before quoting it; regenerate derived tables with the tool. Corrections made in this project: a variable declared "never written" (only its reader was dead), a description of a branch flip written backwards, a count taken from the wrong column.

## Discipline

Tag claims C / I / ?; never guess, say what was not checked. Keep the owner's answers in a CSV. Update README and checklist files together. One commit per batch: `git fetch origin`, `git merge-base --is-ancestor origin/main HEAD`, `git push origin <branch>:main`.

## Answering "how far are we from a full disassembly?"

Never give one percentage. Give the level table (L0-L6), the measured counts behind each level (bytes by type, names by tag, raw RAM operand lines, auto labels left, doubtful rows with distinct bytes), and the next step with the best payoff (apply the RAM map).
