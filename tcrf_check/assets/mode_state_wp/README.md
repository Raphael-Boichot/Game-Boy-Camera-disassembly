# BGB watchpoint pass over the mode-state handlers (2026-10-25)

The 70 rows of the group "mode state" of `disasm/sym_unconclusive_jp.csv` (as they stood on 2026-10-25), checked in the real BGB with logging watchpoints:
an execution watchpoint on every handler (a read watchpoint over the three tables), whose message carries the game's mode and state, and a control
watchpoint on every write of the state byte `$D5CF`. One replay then says in which screens each handler ran. Tool: `tcrf_check/tools/mode_state_wp.py`.

* `mode_state_wp_jp.csv`: one row per handler: the screens (`mode:state x hits`) where it ran, the number of runs that reached it, and the verdict against
  the mode (and, for `ModeNN_StateSS_*` names, the state) that its name gives.
* `runs.jsonl`: one line per run: the scenario, where it ended (`end`, mode:state in hex), the number of state writes seen (`ctl`, the control) and the hits.

Scenarios (106 runs, all on the Japanese ROM, md5 `fdcfe686cf4df461e870b6e53b2b5a8b`, BGB 1.6.6 under Wine; the corpus and guide runs pass `SystemMode=0` (DMG), the printer and
link runs use BGB's automatic system choice, the D.J. runs the setting of `bgb_dj_print.py`):
* `corpus_MM_SS`: the cheapest entry of `coverage/results/corpus/*.jsonl.gz` that ends in that (mode, state), replayed from its root save. Paths recorded in the core
  can end on another screen in BGB (timing): the `end` field says where; the hits stay valid because each one carries its own mode and state.
* `guide_*`: key paths from the main menu (tokens of `guide_nodes.py`), on the unlocking save `unl_CE10238211` (`tools/make_unlocked_saves.py`).
* `print_photo`, `print_card`: VIEW -> photo -> PRINT -> A (and the comment-card print, Start) with the Game Boy Printer helper on the link (`bgb_printer.py`).
* `print_pano1`, `print_pano2`: the corpus entries `01_fuzz_a` 899 (ends in the first panorama pick, `18:03`) and `01_fuzz_b` 1646 (second pick, `18:02`), then A presses,
  with the printer helper on the link: the 4-photo job of mode `$18`.
* `dj_*`: the D.J. editor route of `bgb_dj_print.py` with keys after the SOUND I page.
* `link_sender`, `link_receiver`, `link2_sender`, `link2_receiver`: the two BGB instances of a photo exchange (`bgb_link_wp.py`, saves `link_protocol/saves/flow1_*_before.sav`
  and `flow2_*_before.sav`); both runs play the sender-initiated keys (the initiator chooses Left = send).
* `linkrx_*`: receiver-initiated exchanges (the initiator chooses Right = receive and browses the peer's thumbnails; `bgb_link_rx.py`, flow-2 saves, `-headless`, `SystemMode=0`):
  Japanese initiator and responder, Japanese initiator with the international ROM as responder, and the international ROM as initiator with a Japanese responder.
  Each record carries the ROM, the role and `states_left` (the mode:state left at every write of `$D5CF`).

What it shows and what it does not: a hit proves that the handler ran in that screen of the real emulator (C for the placement in the screen flow); it does not
prove the role written in the rest of the name (`DrawPanoramaHint`, `PickConfirm`), which is read from the code. A handler that no scenario reached is
"not reached in these runs", not dead. The debug-message logs, demos and state files are not kept.

## Result

Every run's control watchpoint fired (13 to 100 writes of `$D5CF` per run), so a handler with no hit was not run. BGB prints the mode and state in hex.
* 69 of the 70 handlers ran, **each only in the mode its name gives**; all 25 names that carry a state ran in exactly that state and no other. No handler contradicts its name.
* `Mode0E_State0C_ExchangeWaitB` ran in the receiver-initiated exchanges (responder, with a Japanese and with an international initiator). In every such run the first
  thumbnail page (2,048 bytes) reaches the initiator after the game's 180-frame deadline (`wLnkHalfDone` = 1 at the end, message `$0C` already shown), with `-hf` and at
  real speed with `-headless`, between two Japanese ROMs and across the two ROMs; the project's core sends it in about 130 frames.
* **Forced run** (`linkrx_forced_*`, `forced: true` in `runs.jsonl`): the same exchange on a copy of the Japanese ROM whose `Link_TimeoutTick` never counts down
  (`07:4ACE` `dec [hl]` -> `nop`, file offset `$1CACE`; md5 of the copy `190b1cae5209e00d7e0a001abf07fb90`). The exchange completes (initiator `03 04 07 08 09`, responder
  `0A 0B 0C 0B 0D 0E 0F 10 11`) and `Mode0E_State07_ExchangeBarsA`, `State0D_PickSecond`, `State0E_AbortWait2` (now `State0E_ConfirmSend`: the sender's confirmation dialog,
  A sends and B refuses with `$EF`) and `State0F_Ready` run, each in its own state. The csv keeps the names the runs logged.
* Not reached (1): `Mode1D_InterleaveTileRows` (`00:3249`), whose only caller `00:31B4` runs it when bit 4 of the print-layout command byte in B is set:
  none of the print jobs of these runs (photo, card, two panoramas, D.J. score) issued such a command.
* This places each handler in the screen flow. The owner decided (2026-10-25) that this confirms the name: the 69 handlers that ran are tagged C in `disasm/sym_names_jp.csv`
  (the four of the forced run say so in their note); the role in the rest of each name is still read from the code.
