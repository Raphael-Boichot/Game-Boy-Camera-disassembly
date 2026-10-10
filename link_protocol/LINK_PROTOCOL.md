# Game Link Cable photo exchange — protocol (standalone copy of README §14)


*Status of this section.* The byte values and state machines come from the ROM code (`00:2AE9-2E7A`, `07:4000-51B6`, `02:462F`, `07:4A17`, `07:4ADA`); every claim was then **run** on two instances of the emulator core joined by a modelled cable (§13.1, `cov/link_lib.py`) and compared with the SRAM of both units before and after. Five scenarios were logged byte by byte (`link_protocol/sniff_logs/*.csv`, one row per byte exchange); the unplug and simultaneous-press cases (14.7) were observed but not logged. A BGB-to-BGB exchange (README §16.6, both ROMs) gives the same SRAM result; BGB was not made to log the bytes and the real hardware was not tried, so the *timing* figures below are still the emulator's (marked "emulator"), and the *byte values and the order* follow from the ROM. Labels: **code** = read in the ROM, **observed** = seen in the two-core runs, **inferred** = reasoning only.

### 1 What the exchange does (summary)

* The Pocket Camera moves **one photo per session** between two cameras. The photo **leaves the sender's album** (the vector entry becomes `FF`; the pixels stay in the slot until overwritten) and **enters the receiver's album as a new photo** with the sender's own tag (owner ID, name, comments, image checksum) plus three reception counters (`F12-F14`). **observed**, five sender/receiver pairs, a receiver-initiated session, and a 3-hop chain.
* One unit is the **initiator** (the player who presses A on the link screen, mode `$0E`, state 1). Its own Left/Right choice (`$D5F5`: Left = *send*, Right = *receive*) decides the roles of **both** units. The other unit (the **responder**) just waits armed; its own Left/Right choice is ignored and overwritten (`07:418A` copies the protocol role `$DC52` into `$D5F5`). **observed**: with the responder pressing Left, nothing or Right, the result is identical.
* The initiator is also the only unit that sends **commands**; the responder only answers. The unit that **sends the photo always confirms with A** (the confirmation dialog of state 5 for an initiator-sender, state 14 for a responder-sender); B in that dialog refuses (the requester returns to its browse screen).
* On the wire every byte is exchanged **full duplex**, and the two units **alternate as clock master for each byte**. A whole photo is 4,103 exchanges (4,096 data + 7 protocol exchanges); a thumbnail page is 2,055. About 5.9 s and 2.9 s (emulator).

### 2 Physical layer and timing (code, observed)

* Standard DMG serial port. Master = `SC=$81` (internal 8,192 Hz clock, one byte = 4,096 CPU cycles = 0.98 ms); slave = `SC=$80` (external clock), armed in advance.
* **Strict alternation.** After each byte the serial IRQ (`00:2AE9`) re-arms `SC=$80` and flips `$DC43`. The unit whose `$DC43` is then 1 starts the timer (`TAC=$06`, 65,536 Hz, `TIMA=$EE`: 18 ticks = 275 µs); the timer IRQ (`00:2D50`) stops it and writes `SC=$81`, which makes this unit the master of the next byte. The other unit stays armed as slave. Hence in the logs the master column goes A, B, A, B, … (exceptions: after a half-size page, and at the start of a request, see 14.4).
* Because a shift register holds the byte just received, a byte that the IRQ does not reload is **echoed** back on the next exchange (seen in the dummy first data exchange, which carries the last SYNC bytes).
* Cost measured on the emulator: 5,981 cycles per exchange (1.43 ms, ~700 bytes/s) including IRQ latency and the 275 µs timer delay. **emulator**.
* The serial vector `$0058` jumps through the table at `$0385` indexed by `FFC6` (1 = camera link `00:2AE9`, 0 = printer driver `00:0F16`). Link set-up `00:2D5F` (called by `07:4119` on first entry of the link screen) sets `SB=$12`, `SC=$80`, clears `$DC43-$DC5E`, sets both buffer pointers to `$C000`, `TIMA=TMA=$EE`, `TAC=2` (stopped) and `IE |= $0C` (serial + timer). Link tear-down `00:2DD8` (B button on the link screen) or `00:2CEF`.

### 3 Handshake and roles (code, observed)

Exchange numbers are those of the log `flow1` (sender = initiator) and `flow2` (receiver = initiator); `M` = clock master of that byte.

| # | Phase | M | Bytes (initiator → responder, responder → initiator) | Meaning |
|---:|---|---|---|---|
| 0 | HELLO | initiator | `$29` , `$12` | The initiator (A pressed, `07:414D` → `00:2DED`) sets `DC54 := own count \| $40 if own album full`, sends `$29` with `SC=$81`. The idle responder always has `SB=$12`, `SC=$80`. On `$12` the initiator sets `DC45=1`, `DC51=1`; on `$29` the responder accepts if `DC45 = 0`. Any other byte (`$FF`: nobody listening) makes a unit re-arm as responder (`SB=$12`, `DC45=0`): **no error, no time-out**, the link screen simply stays at state 1, press A again. `$55` is accepted like `$12` (sets `DC5D`) but no code sends it. |
| 1 | INFO | responder | `DC54` of each side | **Info byte**: bit 7 = "I want to receive" (set on the initiator only: `07:4146` ORs `D5F5≠0` into `DC55` when A is pressed), bit 6 = own album full (`D561 ≥ 30`), bits 0-5 = number of photos (`D561`). Observed: `$1B` (27 photos) and `$00`; `$80` (receive, 0 photos). |
| (idle) | | | *no traffic* | After INFO both units are *connected* (`DC44=1`) and stay silent until the initiator's player chooses something. No time-out while the players choose (observed waiting 32 s). Initiator screen: state 3 (pick a photo to send / browse the peer's thumbnails); responder: state 10 then 11 (wait for a command). |
| 2 | PRELUDE | initiator | `$00 , $00` (ignored) | Started by `00:2E0E` / `00:2E41` (they write `SC=$81` at once, no timer). Also repeated at the start of **every** later request. |
| 3 | COMMAND | responder | initiator's `DC56` , responder's `DC56` (`$00`) | **Command byte**, see 14.5. The responder stores it in `DC59`; both set the byte count (`DC47 = $10` for a photo, `$08` for a thumbnail page) and the argument `DC5A = byte & $3F`. `$EF` = cancel (14.7). |
| 4… | SYNC | alternating | `DC5B` of each side (`$00` not ready, `$01` ready, `$EF` cancel) | Ready loop: each unit keeps sending its `DC5B` until it has seen a non-zero byte from the peer (or has itself sent a non-zero one: latch `DC5C`). The unit that must prepare something (the sender: load the photo, show the dialog and wait for A) keeps `DC5B=0` meanwhile; with a responder-sender this loop ran for 1,100+ exchanges while the player looked at the confirmation (observed). |
| next | DATA (dummy) | | echoes | First exchange of the bulk phase: the index is `$FFFF`, so **nothing is stored**, and the buffer byte 0 is loaded into `SB`. |
| then | DATA | alternating | `[$C000+k]` of each side | **4,096 exchanges** (photo) or **2,048** (thumbnail page). In exchange *k* each unit stores the received byte at its own `$C000+k` and loads `$C000+k+1` (`00:2C88-2CAB`; `DC4C:DC4D` = k, big-endian). Both buffers travel; **only the sender's is meaningful**, the receiver's buffer content (leftover graphics) goes back to the sender and is discarded. |
| end | | | | When `DC4C` reaches `DC47`: photo (`$10`) → tear-down `00:2CEF` (`DC44=DC45=…=0`, `SB=SC=0`, `IE` serial/timer off, `DC4E=1` "ended"); thumbnail page (`$08`) → `00:2CC7`: back to the PRELUDE stage (`DC51=1`, `DC4F=1` "half done") so that the initiator can issue the next command on the same connection. |

**Role decision** (code `00:2B3A-2BA4`, observed, all eight combinations of Left/Right × album states were run). `rx` is the peer's info byte.

| Unit | Rule |
|---|---|
| initiator | receiver if its own `DC55` bit 7 is set (it pressed Right), otherwise sender |
| responder | **receiver if the peer's info byte has bit 7 clear, sender if set** (own choice ignored) |

Refusals right after INFO (both units run the test, so each shows a message): receiver with `album full` (`DC54` bit 6) → `DC50=1`; sender whose peer has `album full` → `DC50=2`; receiver whose peer has **no photo** (`count=0`) → `DC50=3`; sender with an **empty album** → `DC50=4`. Bank 7 maps `DC50` through the table `07:4186` = `09 09 0A 0B` into the message index `$DBCF` and goes to state 18/19 (error screen). Observed pairs: (sender, full receiver) → sender `2`, receiver `1`; (empty sender, receiver) → sender `4`, receiver `3`. Only **two** exchanges (HELLO, INFO) cross the cable in these cases.

### 4 Mode `$0E` (bank 7 `7:4000`), states seen on each side (observed)

| Flow | Initiator | Responder |
|---|---|---|
| initiator **sends** | 1 → 3 (pick own photo) → 4 → 5 (confirm A / B) → 6 → 8 (bulk) → **9** (done) → 0 | 1 → 10 → 11 (wait for command) → 16 (bulk) → **17** (done) → 0 |
| initiator **receives** | 1 → 3 (**browse** the peer's thumbnails; stays here while paging) → 4 → 7 (wait) → 8 (bulk) → **9** → 0 | 1 → 10 → 11 ⇄ 12 (serve one thumbnail page, repeated) → 13 → 14 (confirm dialog, A/B) → 15 → 16 (bulk) → **17** → 0 |
| error | 18 → 19 (message `$DBCF`; the abort cases of 14.3 were seen ending in 19, the time-out in 18) | idem |

States 9 and 17 are the same code (`07:45FD`, `07:48A1`): `call 07:4ADA` (**transferred counter +1, both roles**), then `$D5F5 ≠ 0` (this unit received): `07:4A17` (received counters) and `02:462F` (store the photo as a new one); `$D5F5 = 0` (this unit sent): delete the sent photo (`02:452A`, `02:44FB`). This answers the open question of §3.3: **the only callers of `02:462F` are the two "transfer finished" states of the link-cable exchange**.

### 5 Command byte, thumbnails and the buffer (code, observed)

| Byte | Sent by | Meaning |
|---|---|---|
| `$40 \| n` | initiator | Transfer **photo number n** (album position `n`, 0-29) = `07:4579` (initiator-sender: own photo `D5D8`) or `07:517C` (initiator-receiver: peer photo chosen in the browse screen). Observed: `$40` (photo 0), `$4B` (photo 11). |
| `$80 \| x` | initiator-receiver | Send a **thumbnail page**: the responder uses **bits 0-1 only** as the page number (page *p* = photos 8p … 8p+7, so at most 4 pages) and loads 8 thumbnails of 256 bytes = `$0800` bytes into `$C000-$C7FF` (`02:50CD`). The argument `DC5A = A >> 3` of `07:5169` also carries bits 3-4 of the caller's value, which the responder ignores: observed `$80` (page 0 at entry), `$99` (page 1), `$9A` (page 2), `$9B` (page 3), `$92` (page 2 again when the cursor wraps backwards). The page is a **look-ahead** for the cursor's direction. Verified byte for byte: the received buffer equals the sender's thumbnails `E00-EFF` of album positions 0-7. |
| `$EF` | either | Cancel (14.7). |

**Photo buffer** (4,096 bytes, `$C000-$CFFF` on both sides): `0000-0DFF` photo (3,584 B), `0E00-0EFF` thumbnail, `0F00-0F5B` tag, `0F5C-0FB7` tag echo = **the first `$FB8` bytes of the slot, unchanged** (loaded by `02:4C80`, `07:43F2`, `07:4766`); `0FB8-0FFE` = `00`; **`0FFF` = the sender's owner byte `$DA56`** (gender + blood type, `07:4409`, `07:477D`). Verified: after a transfer the receiver's `$C000-$CFB7` equals the sender's slot `000-FB7` and `$CFFF` equals the sender's `$DA56`.

### 6 SRAM effects, and the signature of an exchanged photo (observed, code)

Compared with a run of the same scenario without cable, only these bytes differ (settings/vector checksums and echoes aside):

| Where | Sender | Receiver |
|---|---|---|
| State vector `11B2-11CF` (+ echo `11D7-11F4`) | entry of the sent album position → **`FF`** (no compaction of the other entries); Magic/checksum `11D5-11D6` recomputed | first `FF` entry → **photo number** (`00` for slot 1), checksum recomputed |
| Slots | **none** (pixels, thumbnail and tag stay in the slot; it is only no longer listed) | first free slot gets the whole `$FB8` image, thumbnail and **both tag copies** |
| Counter `10BF-10C0` (photos **transferred**, BCD) | +1 | +1 (**both roles** count: the unlock test "transferred ≥ 15" counts sent plus received) |
| Counters `10C3` / `10C4` (received from a male / female owner) | unchanged | **+1 on `10C3` if the *sender's* owner byte has bit 0, on `10C4` if bit 1** (`07:4A17` reads `$CFFF`, which the transfer overwrote with the **sender's** `$DA56`). Observed: male sender → female receiver bumps `10C3` (not `10C4`). §3.2 said "by a male-owner camera": corrected to "from a male-owner sender". Cap `$99` (a save whose counters are all `99` does not change). |
| Settings block `10D7-10D8`, echo `11B0-11B1` | recomputed (counter changed) | recomputed |

**Tag of the received photo** (`F00-F5B`, copy `F5C-FB7`), compared with the sender's tag of the same photo: **only these bytes differ**: `F12`, `F13`, `F14` and the two checksum bytes `F5A-F5B` / `FB6-FB7`. Everything else is copied: owner **ID** `F00-F03`, **name** `F04-F0C`, gender/blood `F0D`, birth date `F0E-F11`, comments `F15-F2F`, copy flag `F33`, **image checksum `F34-F35` (stays valid: it matches the pixels)**. The hot-spot block `F36-F53` is **cleared** by `02:462F` (verified only on tags that had none; the clearing is in the code, `02:468B`), and `Magic` and both checksums are rewritten.

**The signature, therefore:**

1. **`F14 ≥ 1`**: the number of cable transfers the photo has been through (cap 99). A photo shot on this camera has `F12-F14 = 00 00 00`.
2. **`F12` = number of those hops whose *receiver's* owner was male** (`$DA56` bit 0 of the *receiving* camera, `02:4664`), **`F13`** = female receivers (bit 1). A receiver with an unset gender adds nothing to `F12/F13` but still `F14`.
3. The owner ID `F00-F03` (and name) is that of the **camera that shot the photo**, so it differs from the receiving camera's own owner block. On a camera that shot and then passed the photo on, the ID of the shooter is kept.
4. The three counters **travel with the tag** and keep accumulating on every further hop. Observed chain (male sender → camera with unset gender → female camera → male camera): `(F12,F13,F14)` = `0,0,1` → `0,1,2` → `1,1,3`.
5. The thumbnail carries **no** badge (the copy badge is only drawn for `F33 = 01`, album copy).
6. At camera level, `10BF` and `10C3/10C4` move as in the table above.

Not exchanged, therefore never in a received tag: the receiver's own owner ID, the hot-spot data (cleared).

### 7 Cancel, refusal, time-outs, unplugging (observed)

* **Receiver presses B while browsing**: the initiator sends `$EF` as command (in the log: a COMMAND exchange with `$EF`); both units tear the link down (`DC4E=1`) and return to the main menu (mode 6).
* **Sender presses B in the confirmation dialog**: it puts `$EF` in `DC5B`; the SYNC exchange carries `$EF`, `00:2BFD` jumps to the "half done" path (`00:2CC7`), no data are transferred, and the requester **returns to its browse screen** with the link still up (log `flow5`: the next command is the thumbnail request `$80` again).
* **Cable pulled during a transfer**: nothing is detected on the wire. Bank 7 counts a 16-bit frame counter `DA0B:DA0C` down once per frame (loaded with `$0200` = 512 frames when the bulk phase is set up, `$00B4` = 180 frames after a command has been issued or received) and when it reaches zero it shows the error screen with message `$0C` (state 18). **It is a deadline, not a per-byte watchdog**: it is not re-armed by progress. Observed: pulled during the bulk phase, the error came exactly when the remaining count had run out (469 frames after the unplug, the counter held `$01D5`). A photo needs about 350 frames (margin ~160); a thumbnail page needs about 175 frames against the 180-frame budget (**emulator timing**; a margin of 5 frames, so a slower real cable cycle would show this error; **inferred**, not tried on hardware).
* **Both players press A**: if one press precedes the other by 1-3 frames (tested) the first unit is the initiator and the session proceeds normally. If both are processed in the *same* frame (the harness's coincidence case) the first hello succeeds on one unit while the other has just started its own hello: the pair is left inconsistent (one unit waiting in stage 1, `DC51=1`, whose `00:2DED` and `00:2DD8` then refuse to act; observed once, not analysed further; the real probability of two hands pressing within the same 16 ms is not modelled).
* **Nobody listening**: the hello reads `$FF` (no partner or cable unplugged) and the unit re-arms as responder (`SB=$12`, `SC=$80`): no message, no time-out (observed).

### 8 SRAM of the two cameras after the first example (reproduce)

`link_protocol/saves/flow1_*` and `flow2_*`: before/after images written by the emulator for the sender-initiates and the receiver-initiates scenarios (**emulator-generated, not real cameras**; each also carries the ~3.5 KB of normal boot-time changes, so diff them against the *unlinked* run or look only at the regions of 14.6). The generator is `cov/linksniff/gen_logs.py`; the log format is described in `link_protocol/README.md`.

### 9 What is still open (kept as questions, not guessed)

* **Hardware / BGB confirmation** of the byte timing and of the alternation: a BGB-to-BGB exchange was run on both ROMs (README §16.6, row 7) and gives the same SRAM result as the emulator (sender entry set to `FF`, receiver slot filled, `F14` 0 → 1, checksums and `F70` changed). BGB was not made to log the bytes, so the byte *timing* is still the emulator's; real hardware was not tried.
* Meaning of **bits 3-4 of the thumbnail command** (`$18` vs `$10`) and of the unused count bit 5 (the maximum count is 30, so it is never set).
* Whether the **`$55`** hello variant, the `DC5D` flag and the `$0800` page for "photos 24-31" in a 27-photo album show anything on screen (the last page's unused 5 thumbnails are whatever the album loader leaves; not examined).
* ~~The Japanese names of the main-menu entry that opens mode `$0E` and of the link screen's options~~ **Answered (README §16.2):** main-menu lower page つうしん (LINK; the Japanese screen is headed ACCESS) with プリント / こうかん (PRINT / TRANSFER), then あげる / もらう (SEND / RECEIVE): Left = send, Right = receive, as the code says.
