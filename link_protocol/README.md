# link_protocol — sniffed Game Link Cable photo exchange (Pocket Camera Japan, Rev A)

* `LINK_PROTOCOL.md` — the protocol write-up (same text as README §14 of the findings README).
* `sniff_logs/*.csv` — one row per serial byte exchange between two emulated cameras (two instances of `cov/gbcov7`, cable modelled in `cov/link_lib.py`):

| column | meaning |
|---|---|
| `n`, `frame` | exchange number; frame counter of the harness (coarse: advances in the harness' action steps, not per byte) |
| `master`, `master_tx`, `master_rx` | unit (A or B) that clocked this byte, the byte it sent, the byte it received |
| `phase` | HELLO, INFO, PRELUDE, COMMAND, SYNC, DATA (classified from the units' `$DC44` / `$DC51` link state at the start of the byte) |
| `initiator_tx`, `responder_tx` | the same bytes seen per role (what the initiator sent / what the responder sent) |
| `data_index` | for DATA rows: `$DC4C:$DC4D` before the byte; the byte exchanged is stored at `$C000 + data_index` by each receiver (`first(not stored)` = the dummy first exchange) |
| `A_stage`, `B_stage`, `A_cmd`, `B_cmd_rx`, `A_ready`, `B_ready` | `$DC51`, `$DC56` of A, `$DC59` of B, `$DC5B` of each |
| `delivered` | 1 if the partner was armed and took the byte, 0 if the master read `$FF` |

| log | scenario |
|---|---|
| `flow1_sender_initiates_photo0` | A (27 photos, initiator, Left = send) sends photo 0 to B (empty album): 4,103 exchanges |
| `flow2_receiver_initiates_browse_then_photo11` | A (initiator, Right = receive) browses B's thumbnails (pages `$80`, `$99`), then requests photo 11 (`$4B`), B confirms: 9,320 exchanges |
| `flow3_abort_receiver_album_full` | sender meets a full album: 2 exchanges, abort reasons 2 / 1 |
| `flow4_cancel_while_browsing` | receiver presses B while browsing: command `$EF` |
| `flow5_sender_refuses` | sender presses B in the confirmation dialog: requester returns to browsing |

* `saves/flow1_*`, `flow2_*` — before / after SRAM images of both units (**written by the emulator, not real cameras**; they also contain the normal boot-time changes, so compare the regions listed in §14.6 or an unlinked run).
* `tools/` — the sniffer scripts. They need `cov/libgbcov7.so` + `libgbcov7b.so` (built from `cov/gbcov7.c`, `gcc -O2 -shared -fPIC`), `cov/link_lib.py`, the ROM and the saves; regenerate everything with `python3 tools/gen_logs.py OUTDIR` from the `cov/linksniff/` layout of the package.

Limits: a BGB-to-BGB exchange (two BGB instances joined with `-listen` / `-connect`, both ROMs; README §16.6, `tcrf_check/assets/bgb/results/link_run1.txt`, `link_intl_run1.txt`, `link_counters.txt`) gives the same SRAM result as the emulator; BGB was not made to log the bytes and real hardware was not tried, so the byte values and order follow from the ROM and the byte *timing* is still the emulator's. On screen the exchange is LINK > TRANSFER > SEND / RECEIVE (Japanese つうしん > こうかん > あげる / もらう), the end screens read sent / received + GOOD (あげました / もらいました + よろしい).
