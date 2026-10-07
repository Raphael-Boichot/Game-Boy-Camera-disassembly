## WRAM `$DC00-$DDFF` (region `dc00`)

*Status: full pass on the v2 tables. Coverage: 137 addresses of `$DC00-$DDFF` appear in `wram/wram_summary.csv`; **all 137** have a row (C 125, I 0, U 12, ? 0). All 512 bytes of the range are covered by rows (178 bytes C, 0 I, 334 U, 0 ?). The stack `$DE00-$DFFF` belongs to another region; note however that the sound init clears `$DD00-$DEFF` (see `$DD00`).*

### 0. What this range really is

The range is **three unrelated subsystems plus unused space**. The previous README called all of `$DC00-$DC5E` "sound engine channel state" and `$DD00-$DD7D` "completely unidentified". Both statements are wrong.

| Range | What | Code that owns it | Evidence |
|---|---|---|---|
| `$DC00-$DC42` | **GB Printer protocol driver** state: packet type, section state machine, lengths, pointers, checksum, status byte, 12-byte packet body (`$DC2D`), VBlank poll counters | bank 0: serial IRQ dispatch `00:0368` -> `00:0F16` -> `00:176F`; VBlank poll `00:0F2D`; packet queueing `00:1AA8-1BA4`; packet-body builder `00:3339`; bank 5's music-score printer `05:59CE-5A4F` also drives it (writes `DC08/DC09/DC0A/DC3D/DC41`, reads `DC27`) | C |
| `$DC43-$DC5E` | **Game Link Cable exchange protocol** state (photo / thumbnail-page transfer between two cameras) | bank 0: serial IRQ `00:2AE9`, timer IRQ `00:2D50`, helpers `00:2C4B-2E41`, teardown `00:2CEF`; bank 7 mode `$0E` (`7:4000`, states 0-17) | C |
| `$DC5F-$DCFF` | unused | - | U |
| `$DD00-$DD7F` | **Sound driver state** (bank `$1F`): song header copy, 4 music track blocks, SFX channel blocks, request mailboxes | bank `$1F` `$5293-$5730` plus `$41FA-$57C6` tables; requests posted from bank 0 `$2A4B/$2A7C/$2A80/$2A84/$2A88` (421 + 81 + 10 + 10 + 10 proven call sites) | C |
| `$DD80-$DDFF` | unused (but cleared by the sound init) | - | U |

(The print-job variables of the print *menus* are in `$D800-$D814` and `$DB4D-$DB6D`: see `wram_d800.md` / the `DA00` file. The music *editor* variables are in `$D890-$D9D6`; no proven bank-0 instruction other than the mailbox helpers `00:2A4B-2A88` and `00:16F4` touches `$DD00-$DD7F`, so the bank-0 editor player `$1017-$1560` drives the APU on its own: I, see "Still inconclusive".)

### Method and evidence

* Every claim cites `bank:address` of instructions that belong to the proven-code set (`trace_jp.json` key `code`), read through a private disassembler over exactly that set (`not proven` lines are never used). Accesses made through HL/DE/BC are not in the access table; for those I read the code and cite the instruction.
* `C` = writer(s) and reader(s) read and role evident; `I` = inferred (what from is said); `U` = unused/dead (only written, only read, or only touched from unreachable code); `?` = inconclusive (facts given).
* Names are mine and describe the role; sweep labels are not used as evidence.
* The previous claims listed in the task were each re-derived; the verdicts are in "Corrections to the previous README".

### 1. `$DC00-$DC42`: GB Printer driver (bank 0)

**Entry points.** The serial interrupt vector sends to `00:0368`, which selects the driver by the HRAM byte `$FFC6`: 0 -> `00:0F16` -> `00:176F` (printer), 1 -> `00:2AE9` (link cable, section 2). The printer driver is a byte-by-byte state machine that is clocked by the serial IRQ; a second part, `00:0F2D`, runs from VBlank and is enabled by `DC41` (`prn_poll_enable`). Nothing in this block is written by or mirrored in SRAM.

**Packet layout (code-traced).** Every packet is `88 33`, command, compression flag, 2-byte length, data, 2-byte checksum, then two dummy bytes during which the printer returns its device id (`$81`, `DC28`) and the status byte (`DC27`). The driver walks the sections with `DC0F/DC10/DC11/DC12/DC25/DC26` and tracks the state in `DC0D` (0 none or error, 1 idle, 2/3/5/6 packet of that type in flight, 7 waiting for the status byte). Internal packet types in `DC2B`: 1 INIT, 2 PRINT, 3 DATA header, 5 INQUIRY, 6 end-of-data (empty DATA). **No packet of type 4 (BREAK) is ever queued**; a BREAK packet exists in the code at `00:1B87` but nothing references it.

**One print band.** The `$0280`-byte data section (`DC17` is always `$0280`: 640 bytes = 2 tile rows of 20 tiles) is sent from the pointer in `DC1B/DC1F`; the PRINT packet is built by `00:1BA4` in the 12-byte buffer `DC2D` (`02 00 04 00` copied from ROM `$1B7B`, then `DC31` = `[DC08]` sheets (always 1), `DC32` = `[DC09]` margin byte (high nibble = blank lines before, low nibble = after; computed by `00:3339` from `D801/D802` of the print menu, see `wram_d800.md`), `DC33` = `[DC0A]` palette (constant `$E4`), `DC34` = `[DAAB]` print intensity (SRAM `10D0`), `DC35:36` checksum, `DC37:38` dummy bytes).

**Dead code.** The variable-length/compressed-band path of `00:19EB` (`[DC0B]` is never non-zero, `$DBEC-$DC07` is never written), plus `DC21`, `DC2A`, `DC39-DC3A`, `DC3F`: never read or never written in proven code (rows say which).

### 2. `$DC43-$DC5E`: link-cable protocol (bank 0 `00:2AE9`, bank 7 mode `$0E`)

**Transport.** Symmetrical byte exchange: both consoles run the same code; one side is the clock master (`SC=$81`), the other waits; after each byte the roles of `DC43` (`lnk_turn`) alternate and the timer interrupt `00:2D50` starts the next transfer. Hello phase (`00:2AF4-2B37`): the side that started the exchange (`DC45 = $81` before the first interrupt) sends `$29`; an idle receiver answers with `$12`. Receiving `$12` confirms the initiator (`DC45 := 1`, `DC43 := 1`); `$55` takes the same path and only additionally sets `DC5D`, which nothing reads; receiving `$29` while `DC45 == 0` makes this side the responder; any other byte resets `DC43/DC45` and answers `$12` with `SC := $80`. Then the info byte `DC54` (bit 7 want-receive, bit 6 album full, bits 0-5 photo count, `DC58` keeps the low 5 bits of the peer's byte) is swapped (`00:2B3A-2BA4`) and the exchange is refused with `DC50` = 1..4 (jump to teardown `00:2CEF`) if one side has nothing to send or the other has no room; otherwise `DC44 := 1`. The **initiator/responder roles** follow from the initiator's choice (`DC55` bit 7 = the user's "receive" choice `D5F5`, tested at `00:2B5C`; `DC52` records the result and bank 7 copies it back into `D5F5`, `07:418A-418D`). The initiator sends a command byte `DC56` (`$40|slot`: one photo, `$1000` bytes; `$80|page`: one page of thumbnails, `$0800` bytes (I); `$EF` = cancel); a ready-sync loop (`DC5B/DC5C`) lets both sides reach the same point; the bulk transfer runs over the `$C000` exchange buffer (the slot work buffer): `DC48:49` = RX base, `DC4A:4B` = TX base, big-endian pointers; `DC4C:4D` = big-endian running index that starts at `$FFFF` and counts to `DC47 * $100`; `DC47` = page count (`$10` = `$1000` bytes, `$08` = `$0800` bytes); teardown at `00:2CEF` sets `DC4E` and clears the state. `DC50` carries the abort reason (1 receiver album full, 2 peer album full, 3 peer has no photo, 4 own album empty) that bank 7 shows as a message.

**Verification of the earlier claim:** `$DC43-$DC5E` *is* the link state, `DC47` = page count, `DC48:49`/`DC4A:4B` = RX/TX pointer bases, `DC4C:4D` = index, `DC56` = command byte: all confirmed, with one precision: the pointers and the index are **big-endian** (high byte at the lower address), unlike the other 16-bit variables of this range.

### 3. `$DD00-$DD7F`: sound driver (bank `$1F`)

**It is the sound driver.** Bank `$1F` is a complete 4-channel music + sound-effect driver; `$DD00-$DD7F` is its entire state. Per-frame entry: `00:0333` -> `00:2A37` -> `1F:7FF0` -> `1F:537D`. One-time init: `00:01E1` -> `00:2A23` -> `1F:7FF6` -> `1F:5338` (switches the APU on, NR50 `$77`, NR51 `$FF`, clears `$DD00-$DEFF`).

**Request interface (C).** Four one-byte mailboxes are polled once per frame and cleared at the end of every call:

| Mailbox | Channel | Valid values | Written by (bank 0) |
|---|---|---|---|
| `DD60` | SFX on hardware channel 1 | 1..`$3E` (62 effects) | `00:2A7C` (421 proven call sites, 332 `call` + 89 `call nz`; 41 distinct ids; most frequent ids 1 (85 sites), 2, 3, 4 = UI beeps, I) |
| `DD68` | music | 1..`$48` (72 songs, table `$57C6`), `$FF` reset/stop (13 senders), `$FE` pause-like (1 sender: `05:43EF`, right after an `$FF` at `05:43E7`) | `00:2A88` (81 call sites, 50 distinct values) |
| `DD70` | SFX on channel 3 (wave) | 1..10 | `00:2A80` (10 call sites, ids 1,2,3,8,9) |
| `DD78` | SFX on channel 4 (noise) | 1..18 | `00:2A84` (10 call sites, ids 1,4,5,7,8,10,17,18) |

`00:2A4B` is a table-driven variant (HL = table of `(value, channel)` pairs indexed by A, channel 1-4 selects the mailbox; 10 call sites). Music has priority: a song or reset request in a frame skips all SFX services of that frame and discards the pending SFX requests; starting a song also kills all running effects (`1F:5420` calls `1F:52AC`).

**Music data format (C, from the player).** A song header has 11 bytes (table `$57C6`, 1 word per song): `[0]` transposition (-> `DD01`), `[1:2]` pointer to the 16-entry duration table (-> `DD02:DD03`, one of seven duration tables `$416B-$41B3`), `[3:10]` four playlist pointers (-> track blocks at `DD10/20/30/40`). A playlist is a list of 16-bit pointers to note streams; a playlist word whose high byte is `$00` ends the **whole song** (the first track to reach it sets `DD69 := 0` and runs the global reset, `1F:5524-554F`), a word with high byte `$FF` is a jump: the following word becomes the new playlist pointer (`1F:5528-5545`). A stream byte is: `$A0-$AF` = set note length (low nibble = index into the duration table) *and* the next byte is the note; `$9D` = instrument (3 operands), `$9E` = new duration-table pointer (2 operands), `$9F` = new transposition, `$9B` = begin loop (count), `$9C` = end loop, `$00` = end of pattern, any other byte = a note (index*2 into the frequency table at `$4037`, `1` = rest). The loop is in `1F:55B2-56FD`: `DD50` counts the tracks 1..4, each block is 16 bytes.

**Track block layout (`DD10/DD20/DD30/DD40`, stride `$10`):**

| Offset | Field | Evidence |
|---|---|---|
| +0/+1 | playlist pointer (+1 = 0: track unused) | init `1F:541A`; test `1F:55C0-55C3`; advance `1F:54D1`, `5519` |
| +2 | tick counter (starts at 1, decremented per frame, reloaded from +3 at each note start) | `1F:5470`, `55C6`, `56DA-56DE` |
| +3 | note length in frames (duration table entry) | `1F:5603-5606` |
| +4/+5 | stream pointer | `1F:540F-5418` (first playlist word), `54C5` (advance) |
| +6/+7/+8 | operands of op `$9D`. Track 3: `+6:+7` = wave-table pointer (`DD36:DD37`, reloaded after ch-3 SFX at `1F:5156-515E`) and `+8` = NR32 level (bit 7 = fade, `1F:54EB-54F9`). Tracks 1, 2: `+6` -> NRx2 envelope, `+8` -> NRx1 duty (`1F:56B3-56D1`); the role of `+7` (non-zero takes the branch `1F:56FD`) is `?`. Track 4: overwritten per note by a 5-byte noise record copied from table `$40C9` (`1F:5650-565D`) | `1F:548F-54B4`, `56B3-56D9` |
| +9/+A | current note frequency (11 bit, lo/hi), from the `$4037` table | `1F:563D-5645`, vibrato `1F:5731` |
| +B | rest flag (note byte 1) | `1F:5625-564A`; rest writes NRx2 := 8, `1F:56BD-56BF` |
| +C/+D | loop return pointer (op `$9B` saves the stream pointer, op `$9C` restores it) | `1F:558F-5593`, `55A8-55AC` |
| +E | vibrato phase, incremented once per frame for tracks 1-3 (track 4 has no such field in use) | `1F:56F0-56FB` |
| +F | bits 0-6: loop counter (`$9B` ORs the operand, `$9C` decrements), **bit 7 = SFX override** (the channel belongs to an effect; the music tick does not touch the hardware for it) | `1F:557D-5580`, `559B-559E`; set `1F:522C/5234/523C/5198`, cleared `1F:47A4/5151/4F67` |

**SFX block layout** (`DD60`, `DD70`, `DD78`; 8 bytes each): `+0` request, `+1` running id, `+2` tick, `+3` limit, `+4` step, `+5..+7` effect data. Each frame the service (`1F:52F8`/`52D8`/`5318`) runs the *init* handler of the id in `+0` (tables `$41FA`, `$42F2`, `$431A`) *or*, if `+0` is empty, the *step* handler of the id in `+1` (tables `$4276`, `$4306`, `$433E`); the init handlers end by jumping to the common start `1F:520A`, which writes id/limit/tick/step, sets the override bit of the channel and loads the first register block.

**The "photo code" jingle (C).** `00:16F4` (called from bank 6 at `06:514C/53AE/639A/63C6/6404` and from bank 7 at `07:717B`) splits the 16-bit value `[$DA8F:$DA90]` into four nibbles at `DD03-DD06` and requests SFX `$10` on channel 1. Handler `1F:4745/474D` plays one 8-frame note per nibble (nibble -> `$4735[n]` = 5*n -> register block at `$46E5`): a melody that encodes the value, not text. Whether `[DA8F:DA90]` is really the tag bytes `F34/F35` (SRAM slot layout) belongs to the `DA00` region; I only checked that the nibble splitter reads `$DA8F/$DA90`. The README guess "for the text routine `$2A7C`" is wrong: `$2A7C` is the channel-1 sound request routine.

**SRAM.** No variable of `$DC00-$DDFF` mirrors SRAM. `DC55` = copy of the photo count `D561` (bits 0-6, `07:412C`) plus the "receive" choice `D5F5` (bit 7, `07:414C`): derived, not a mirror; `DD03-DD06` are derived from `DA8F/DA90`; `DC08-DC0A` are constants or print options; the intensity byte in the PRINT body, `DAAB`, is outside this range (SRAM `10D0`).

### 4. Tables

#### 4.1 `$DC00-$DC42` printer driver

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DC00-$DC07` | 8 | `prn_band_comp_flags` | u8[] (array starts at $DBFE, 10 bytes up to $DC07) | `ld hl,$DBFE ; add hl,bc` only at 00:1A2E and 00:1A91 (inside the `[DC0B] != 0` branch of `prn_send_band` 00:19EB, with BC = [DC3E]-2) | Per-band "compressed" flags of a variable-length data-packet path (parallel table of 16-bit lengths at `$DBEC`, `ld hl,$DBEC` 00:1A3D/1AA0). Nothing in the proven code ever writes `$DBEC-$DC07` and `[DC0B]` is never non-zero, so this path is dead; `$DC00-$DC07` (and `$DBFE-$DBFF`) are never touched. NOT sound state (old README). | **U** |
| `$DC08` | 1 | `prn_sheets` | u8 (always 1) | W 00:333E (`ld a,1`, print engine state 5 `00:3339`), W 05:5A02 (`ld a,1`, music-score print `05:5A00`); R 00:1BC0 (copied to `$DC31`) | Data byte 0 of the GB-Printer PRINT command (00:1BA4): **number of sheets** (constant 1). The old README called it "contrast"; the intensity/contrast byte is `[$DAAB]` (data byte 3, 00:1BDB). | **C** |
| `$DC09` | 1 | `prn_margin` | u8: hi nibble = lines before, lo nibble = lines after | W 00:3369 (`b/c` merge), 05:5A19; R 00:1BC9 (-> `$DC32`) | PRINT data byte 1 = feed margins. Bank 0 engine: `DE=$1003` default (00:3341) or the two nibbles of `[$D802]` when `[$D801] != 0` (00:3344-3355), top nibble only if `[$DBC4]` (first page), bottom nibble only if `[$DBC5]` (last page) (00:3359-3369). Bank 5 score printer: `$30` if `[$D8C7]` bit 0, `$03` if bit 1, OR-ed (05:5A05-5A19). | **C** |
| `$DC0A` | 1 | `prn_palette` | u8 (constant $E4) | W 00:336E (`ld a,$E4`), 05:5A1E; R 00:1BD2 (-> `$DC33`) | PRINT data byte 2 = printer palette, always `$E4` (identity 3-2-1-0). | **C** |
| `$DC0B` | 1 | `prn_comp_enable` | u8 (always 0) | R 00:1A1B and 00:1A7E only; **never written** in proven code (cold boot clears it) | Would select the per-band variable-length/"compressed" data-packet path (tables `$DBEC`/`$DBFE`). Always 0, so every data packet is `bc=$0280` bytes, flag 0 (00:1A48). Dead input. | **U** |
| `$DC0C` | 1 | `prn_band_comp_flag` | u8 (always 0 in practice) | W 00:1A1E (= `[DC0B]`), 1A34, 1A81, 1A97 (= `[DBFE+n]`); R 00:1C1F | Value placed in byte 1 of the DATA packet header (`$DC2E`, 00:1C1F-1C22): the printer protocol's *compression flag*. Always 0 here (uncompressed data). Role C, value always 0. | **C** |
| `$DC0D` | 1 | `prn_state` | u8: 0 none/error, 1 idle, 2/3/5/6 packet in flight, 7 waiting for status byte | W 00:1868 (:=7), 18DE (:=0, no printer), 18F2/18F9 (:=0 or 1 from status), 1919 (:=0, reset), 197E (:=1, packet complete), 1995, 19A8 (:=0), 1C71 (:=[DC2B]); R 00:0F2D, 1776, 182E, 19B2, 19EC, 19F4, 1B1E, 1C57 | State of the printer link. `0` = no session (only an INIT packet may start, 00:1C5E-1C66) or printer lost; `1` = idle/last packet acknowledged (00:197D, 18F9); while a packet is in flight it holds the packet type (`DC2B`: 2 = PRINT, 3 = DATA, 5 = INQUIRY, 6 = end-of-data, copied at 00:1C6A-1C71); `7` = body sent, the reply of the last byte (the printer status) is still to come (00:1866-1868, handled at 00:18BD). Gates: print command needs 1 or 2 (00:19B5-19BB), band send needs 1 or 3 (00:19F4-19FD), VBlank inquiry needs 1 (00:0F30). | **C** |
| `$DC0E` | 1 | `prn_last_type` | u8 (packet type 0..6) | W 00:18C0 (:=[DC2B] when the status byte arrives), 197A/1998/1C78 (:=0); R 00:195E (==1), 19D4 (==2), 19D7 | Type of the packet whose status was just received and not yet consumed by the caller (`1` INIT, `2` PRINT). `prn_poll` (00:1954) and `prn_send_print` (00:19B2) call the completion routine 00:196F while it is 1 / 2 respectively. | **C** |
| `$DC0F` | 1 | `prn_sync_done` | u8 flag | W 00:17CE (:=1 after the second sync byte), 1932 (:=0); R 00:177E | 0 = the two sync bytes `$88 $33` (ROM `$1B71`) are being sent (00:17AD; the first is sent by 00:1C83-1C8E), 1 = packet body phase. | **C** |
| `$DC10` | 1 | `prn_hdr_done` | u8 counter | inc 00:181D-1827 (via HL), W 00:1935 (:=0); R 00:178A, 3515 | Becomes non-zero when the first body section (the 4-byte DATA header, or the whole body of INIT/PRINT/INQUIRY) is finished. Also read by the print-progress animation (`00:3515`, only runs while `DC10 != 0 and DC11 == 0`). | **C** |
| `$DC11` | 1 | `prn_data_done` | u8 counter | inc 00:1824-1827 (via HL), W 00:1938; R 00:1790, 1835, 351A | Non-zero when the data section of a DATA packet is finished (then the 2 checksum bytes and 2 dummy bytes follow). | **C** |
| `$DC12` | 1 | `prn_chk_idx` | u8 0..2 | inc 00:189E (via HL), W 00:193B (:=0); R 00:1796 (`cp 2`) | Index of the checksum byte being sent after a DATA packet (0 = low byte `[DC23]`, 1 = high byte `[DC24]`, 00:188C-1893); 2 = checksum done, the two trailing dummy bytes follow (00:18A3). | **C** |
| `$DC13-$DC14` | 2 | `prn_target_len` | u16 LE | W 00:1852/1858 (from DC17/18), 1876/187C (from DC15/16), 1B5C/1B63 (packet queue); R 00:180E/1815 | Number of bytes of the current body section; the section ends when `[DC19:DC1A]` reaches it (00:180B-1819). | **C** |
| `$DC15-$DC16` | 2 | `prn_hdr_len` | u16 LE | W 00:1B5F/1B66 (packet queue); R 00:1873/1879 | Copy of the length given to the packet queue (4 / 8 / 12); restored into `DC13` after the data section (00:1873-187C). | **C** |
| `$DC17-$DC18` | 2 | `prn_data_len` | u16 LE (always $0280) | W 00:1C04/1C08 (`prn_start_data` 00:1BFB); R 00:184F/1855 | Length of the data section of a DATA packet (BC of 00:1BFB; always `$0280` = 640 bytes = 40 tiles = one 160x16 band in this ROM). | **C** |
| `$DC19-$DC1A` | 2 | `prn_tx_idx` | u16 LE | inc 00:17B1, 1806-180A; W 00:17CA, 183D/1840, 1947/194A (:=0), 1C7D (:=1); also R 00:17C3 (`cp 2` end-of-section test), 00:17D2/17D6 (BC := `DC19:DC1A`), the high byte `DC1A` follows the low byte in all of these | Byte index inside the current section (also the sync-byte index while `DC0F == 0`; it starts at 1 because the first sync byte is sent by the start routine 00:1C83). | **C** |
| `$DC1B-$DC1C` | 2 | `prn_src_ptr` | u16 LE | W 00:1846/184C (from DC1F), 1882/1888 (from DC1D), 1B4E/1B55; R 00:17DA/17DE | Address of the section being sent: header buffer (`$DC2D`/ROM packet) then the data pointer; every transmitted byte is `[DC1B:DC1C] + [DC19:DC1A]` (00:17D2-17E8). | **C** |
| `$DC1D-$DC1E` | 2 | `prn_hdr_ptr` | u16 LE | W 00:1B51/1B58 (packet queue); R 00:187F/1885 | Copy of the section pointer given to the queue (ROM packet `$1B73/$1B7F/$1B8F` or buffer `$DC2D`). | **C** |
| `$DC1F-$DC20` | 2 | `prn_data_ptr` | u16 LE | W 00:1BFC/1C00 (= HL of `prn_start_data`), 1AB5/1ABD (+= $0280); R 00:1843/1849, 1AB0, 1AC0; high byte `DC20` R 00:1AB8, 1AC4 | Address of the data section of the DATA packet being sent (the caller's band buffer: `$CF00` in the bank-0 print engine, 00:32FB; `$C200` in the bank-5 score printer, 05:59EC). | **C** |
| `$DC21-$DC22` | 2 | `prn_band_ptr_copy` | u16 LE | W 00:1A0E/1A12 only; no reader anywhere | Copy of the HL passed to `prn_send_band`; written, never read. | **U** |
| `$DC23-$DC24` | 2 | `prn_checksum` | u16 LE | add 00:17EC-17F8 (every body byte), W 00:1941/1944 (:=0), R 00:188F (sent as checksum bytes) | Running 16-bit sum of the packet bytes after the sync bytes (command, flag, length, data); sent low byte first at 00:188C. For INIT/INQUIRY the checksum is precomputed in ROM; for PRINT `prn_send_print` computes it into `DC35:DC36` (00:1BC0-1BE9). | **C** |
| `$DC25` | 1 | `prn_tx_phase` | u8 0/1/2 | W 00:186D (:=1), 18FD (:=2), 1B6A/1928/1C75 (:=0); R 00:196F, 1A51 | 0 = packet being sent, 1 = body sent / waiting for the status exchange, 2 = status received, packet complete (tested by the completion routine 00:196F-19AE, which returns `$F0` while not 2). | **C** |
| `$DC26` | 1 | `prn_trail_cnt` | u8 0..2 | inc 00:18B3 (via HL), W 00:193E (:=0) | Counts the two trailing zero bytes sent after the checksum of a DATA packet (00:18A3-18BA); at 2 the packet body is over (jumps to 00:1866). | **C** |
| `$DC27` | 1 | `prn_status` | u8 (printer status byte, `$FF` = none) | W 00:18D2 (:= `[FF01]` in state `$DC0D == 7`), 191D (:=$FF); R 00:0F33, 1981/199B (in 196F), 19DF, 1A15, 1A5E/1A71/1AA8, 1AE0, 1B3A, 00:33DF, 340F, 05:5A3A; also R 00:18C3, 19F0 | Last status byte returned by the printer (reply to the last dummy byte): `$FF` = no printer/line dead (00:1914-1920 init value, 00:18D5-18E3), bit 0 checksum error, bit 1 busy, bit 4 packet error (00:1A61-1A6D); the print engine maps bit 7 -> error class 0, bit 6 -> 3, bit 5 -> 2, otherwise 1 into `$DBCF` (00:3416-343B). | **C** |
| `$DC28` | 1 | `prn_dev_id` | u8 (expect $81) | W 00:1863 (:=[DC29]), 18A5 (:=[FF01]), 1920 (:=$FF); R 00:30B9 (`cp $81`), 342E | Device-ID byte returned by the printer in the first of the two final exchanges (`$81` = GB Printer). The print engine refuses to continue unless it equals `$81` (00:30B9-30BE). | **C** |
| `$DC29` | 1 | `prn_prev_rx` | u8 | W 00:17E5 (:=[FF01] before sending the next byte); R 00:1860 | Previous received byte; at the end of a short packet it holds the device-ID reply and is moved to `DC28` (00:1860-1863). | **C** |
| `$DC2A` | 1 | `prn_irq_seen` | u8 | W 00:0F22 (:=1 by the printer-mode serial IRQ entry `0F16`), 00:192B (:=0); no reader | Written every printer serial interrupt; never read. | **U** |
| `$DC2B` | 1 | `prn_pkt_type` | u8: 1 INIT, 2 PRINT, 3 DATA header, 5 INQUIRY, 6 end-of-data | W 00:1B46 (A of the queue routine: callers 1B97 = 1, 1BA4 = 2, 1BFB = 3, 1C3C = 5, 1C49 = 6); R 00:18BD, 1C61, 1C6A | Packet type being sent (internal numbering, not the printer command byte: the printer commands are 1 INIT, 2 PRINT, 4 DATA, 15 INQUIRY). No packet of type 4 is ever queued; the ROM also contains an unreferenced printer BREAK packet (`08 00 00 00 08 00 00 00` at `$1B87`). | **C** |
| `$DC2C` | 1 | `prn_has_data` | u8 0/1 | W 00:1B4A (D of the queue routine: 1 for DATA header and end-of-data packets), 1AD4 (:=0); R 00:1828, 1900 | Non-zero if the packet continues with a data section/checksum phase after the header section (DATA packets); 0 for INIT/PRINT/INQUIRY whose checksum and dummy bytes are inside the queued block. | **C** |
| `$DC2D-$DC38` | 12 | `prn_pkt_buf` | u8[12] packet body | W 00:1BA4 (PRINT, 1BA8-1BF0), 00:1BFB (DATA header, 1C10-1C2B); sent by 00:17D2 | Body of the packet being built (sync bytes `88 33` are sent separately). PRINT: `DC2D..30` = `02 00 04 00` (command 2, flag 0, length 4; copied from ROM `$1B7B`), `DC31` = `[DC08]` sheets, `DC32` = `[DC09]` margin, `DC33` = `[DC0A]` palette, `DC34` = `[$DAAB]` intensity (the SRAM `10D0` print intensity), `DC35:36` = checksum (start 6 + the 4 data bytes), `DC37:38` = `00 00` (dummy bytes during which the printer answers `$81` and status). DATA header (only 4 bytes used): `DC2D` = `04`, `DC2E` = `[DC0C]`, `DC2F:30` = data length. Old README: "payload of PRNT packet" - right, but it is not "sound". | **C** |
| `$DC39-$DC3A` | 2 | `prn_unused_39` | - | not referenced by any proven instruction | Padding after the packet buffer; zero after boot. | **U** |
| `$DC3B` | 1 | `prn_tx_busy` | u8 0/1 | W 00:1C80 (:=1 packet transmission started), 18DB, 1907, 192E, 1AD7 (:=0); R 00:0F39, 1954, 19CA, 1A02, 1B33; also R 00:1B30 | 1 while a packet (or its data phase) is in progress; the completion routine 00:196F must return before a new packet may be queued. | **C** |
| `$DC3C` | 1 | `prn_abort` | u8 0/1 | W 00:1ACE (:=1 on status bit 4 = packet error), 194D (:=0); R 00:176F | When set the printer-mode serial IRQ step 00:176F returns immediately (transmission halted). | **C** |
| `$DC3D` | 1 | `prn_last_chunk` | u8 0/1 | W 00:32F8 (:=[DBC6]), 05:59E9 (:=A); R 00:1ADC | Set by the caller before 00:19EB: non-zero = this data packet is the last one of the page, so an empty DATA packet (end-of-data marker, 00:1C49) is appended before the PRINT command. | **C** |
| `$DC3E` | 1 | `prn_chunk_cnt` | u8 | W 00:1A0A (:= A+1 of `prn_send_band`; both callers pass A=1, so 2), dec via HL 00:1A70; R 00:1A24, 1A5B, 1A87 | Countdown of the data packets still to send (+1). With A=1: 2 -> (data packet OK) -> 1 -> [end-of-data packet if `DC3D`] -> 0 = call finished (00:1A66-1AE8). Larger values (several 640-byte packets per call, 00:1A7B-1AC8) are supported by the code but no caller uses them. | **C** |
| `$DC3F` | 1 | `prn_unused_3f` | - | not referenced | Padding; zero after boot. | **U** |
| `$DC40` | 1 | `prn_poll_cnt` | u8 0..6 | inc via HL 00:0F3E-0F41; W 00:0F47 (:=0 at 6), 1977 (:=0), 33CB (:=4); R 00:3392 | VBlank counter (00:0F2D, called from the VBlank handler when `DC41 != 0`): when the printer is idle (`DC0D == 1`, status != $FF, no transmission) every 6th frame it clears `DC42` and queues an INQUIRY packet (00:1B1E -> 1C3C) to poll the printer status. The print error screen (00:3388) waits until it equals 1. | **C** |
| `$DC41` | 1 | `prn_poll_enable` | u8 0/1 | W 00:01C7 (boot, :=0), 00:3051 (print engine state 0, :=1), 00:3466/3499 (:=0, engine exit), 05:59CE (:=1), 05:5A4F (:=0); R 00:032C | Enables the VBlank printer poll (00:032C-0330: `call nz,$0F2D`). 1 only while a print job runs (bank-0 print engine `$1D`, and the bank-5 score print). | **C** |
| `$DC42` | 1 | `prn_busy_seen` | u8 0/1 | W 00:18EB (:=1 when status bit 1 = busy), 1950 (:=0), 0F48 (:=0); R 00:19C4 | Printer reported busy: `prn_send_print` returns `$F0` (try again) while set (00:19C4-19C8); cleared when the next INQUIRY is queued (00:0F46-0F4B). | **C** |

#### 4.2 `$DC43-$DC5E` link-cable protocol

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DC43` | 1 | `lnk_turn` | u8 0/1 (toggles per byte) | W 00:2B0F (:=0), 2B2A (:=1), 2BC0 (xor 1), 2CEA (:=[DC45]), 2CF6 (:=0), 2D3E (xor 1), 2D6D (:=0); R 00:2D41, 2E18; also R 00:2BBB (xor 1 on the connect path) | Master/slave alternation. After every byte exchange the serial IRQ toggles it (00:2D39-2D3E); if it is now non-zero the IRQ arms the timer (`TAC:=6`, 00:2D45-2D49) and the timer IRQ `00:2D50` starts the next byte with the internal clock (`SC:=$81`); if zero the unit leaves `SC=$80` (external clock) and waits. So the two cameras take turns driving every byte. `00:2E0E` only starts a command when it is 1 (00:2E18). | **C** |
| `$DC44` | 1 | `lnk_connected` | u8 0/1 | W 00:2BA6 (:=1 handshake done), 2CF3 (:=0), 2D70; W 07:40FA, 07:4161 (:=0 on leaving); R 00:2AED (IRQ branch: 0 = handshake stage, !=0 = command/data stages), 2E7D (returned in Z by `00:2E68`, polled at 07:4130) | Link established flag. `0` = handshake/info stage (`$12/$29/$55`, info bytes), `1` = connected (command stage, then bulk transfer). `00:2E68` (called every frame by bank 7 State01) merges the status bits into `DC54` and returns Z if not connected. | **C** |
| `$DC45` | 1 | `lnk_initiator` | u8: 0 responder, 1 initiator (confirmed), $81 initiator (before first IRQ) | W 00:2B12 (:=0), 2B27 (:=1), 2CF9, 2D73 (:=0), 2E0A (:=$81, side effect of `ld a,$81` in `00:2DED`); R 00:2B08, 2B49, 2C3E, 2CE7, 2E0E, 2E41; R 07:41B5 | Set on the unit that sent the hello byte `$29` (`00:2DED`: `FF01:=$29`, `FF02:=$81`) and then received `$12` or `$55` (00:2AFC-2B27). A unit that hears `$29` while it is itself an initiator resets both flags and re-arms as responder (00:2B04-2B1D: collision). Selects the `SC` start and the command-byte source (00:2C3E-2C85); bank 7 State01 goes to state 2 if it is 1 and to state `$0A` otherwise (07:41B5-41C7). | **C** |
| `$DC46` | 1 | `lnk_cmd_armed` | u8 0/non-zero | W 00:2E3D, 2E64 (:=$81 by `00:2E0E` / `00:2E41`), 2CC8, 2D08, 2D76 (:=0); R 00:2E13, 2E46 | Latch "a command/transfer has been started by the initiator": `00:2E0E/2E41` do nothing while it is non-zero; cleared at the end of a transfer (00:2CC8) and at teardown (00:2D08). | **C** |
| `$DC47` | 1 | `lnk_pages` | u8: 0, $08 or $10 | W 00:2D61 (:=$10), 2C4D/2C75 (:=8), 2C5D/2C7C (:=$10), 2CCB, 2DE2 (:=0); R 00:2CB9, 2CC0 | Number of 256-byte pages of the bulk transfer: `$10` = `$1000` bytes (whole slot, a photo), `$08` = `$0800` bytes (**I**: a page of 8 thumbnails of `$100` bytes, see `DC59`). Chosen at stage 3 from bit 7 of a command byte: the own `DC56` if this unit is the initiator, the received `DC59` otherwise, i.e. always the initiator's command (00:2C44-2C85). The transfer ends when the index high byte `DC4C` equals it (00:2CB5-2CBD). | **C** |
| `$DC48-$DC49` | 2 | `lnk_rx_base` | u16 BIG-endian pointer (DC48 = high) | W 00:2DB2-2DB9 (:=$C000), 2CFC/2CFF (:=0); R 00:2C88-2C8F | RX buffer base: the IRQ stores each received byte at `[DC48:DC49] + index` unless the index high byte is `$FF` (00:2C98-2C9F). Always `$C000` (the photo/slot work buffer). | **C** |
| `$DC4A-$DC4B` | 2 | `lnk_tx_base` | u16 BIG-endian pointer (DC4A = high) | W 00:2DBC-2DC4, 2E1D-2E25, 2E4B-2E53 (:=$C000), 2D02/2D05 (:=0); R 00:2CA1-2CA8 | TX buffer base: the next byte sent is `[DC4A:DC4B] + index + 1` (00:2CA1-2CAB). Also `$C000`; re-pointed at every command start. | **C** |
| `$DC4C-$DC4D` | 2 | `lnk_index` | u16 BIG-endian (DC4C = high, DC4D = low), $FFFF = before first byte | W 00:2BB1/2BB4 (:=$FFFF at connect), 2CAD/2CB1 (each byte), 2CD5/2CD8, 2D22/2D25 (:=$FFFF); R 00:2C90-2C97, 2CB5; R 07:45C4 (`DC4D`); high/low byte stores W 00:2CAE/2CB2 (each byte), 2D79/2D7C (:=$FFFF at teardown) | Byte index of the bulk transfer (`inc de` per byte, 00:2CA0). It starts at `$FFFF` so that the first exchanged byte is not stored (00:2C98). Bank 7 State07 reads the low byte as a progress test (waits for `4 <= DC4D < $80`, 07:45C4-45CF). | **C** |
| `$DC4E` | 1 | `lnk_ended` | u8 0/1 | W 00:2BAA (:=0 at connect), 2D30 (:=1 at teardown), 2D7F; R 07:45F3 (State08), 07:4897 (State16) | 1 once the link has been torn down (00:2CEF-2D33, reached after a completed full-size transfer, a cancel (`$EF`) or an abort); bank 7 waits for it before leaving the transfer states. It does not say success or failure (see `DC50`). | **C** |
| `$DC4F` | 1 | `lnk_half_done` | u8 0/1 | W 00:2BE6 (:=0 when the command byte is sent), 2CDD (:=1 after a half-size transfer), 2D82; W 07:46EA (:=0); R 07:45A4 (State07), 07:474F (State12), 07:51A5 (`07:5169`) | Set when a `$0800`-byte (thumbnail-page) transfer has finished and the IRQ is back in the command stage (00:2CC7-2CED); bank 7 polls it before continuing with the next command. | **C** |
| `$DC50` | 1 | `lnk_abort_reason` | u8: 0 none, 1 receiver album full, 2 peer album full, 3 peer has no photo, 4 own album empty | W 00:2B74 (1), 2B96 (2), 2B7C (3), 2B9E (4), 2D85 (:=0 at init); R 07:416F | Reason for refusing the exchange right after the info bytes (00:2B63-2B9E). Bank 7 State01 maps it through the 4-byte table `07:4186` = `09 09 0A 0B` into the dialog code `[$DBCF]` and goes to state `$12` (07:416F-4185). | **C** |
| `$DC51` | 1 | `lnk_stage` | u8 0..4 | W 00:2B2F (:=1), 2BCE (inc), 2BED (:=3), 2C01 (:=0), 2CE0 (:=1), 2D1A, 2D88 (:=0); R 00:2AF4, 2BC6, 2DDB, 2DED | Stage counter of the serial IRQ: 0 (while `DC44 == 0`) = waiting for the hello byte, (while `DC44 != 0`) = bulk data transfer (00:2BC9-2BCA -> 2C88); 1 = info byte exchanged / command stage next; 2 = command byte `DC56` sent; 3 = peer command `DC59` received (sizes `DC47`, slot `DC5A`, 00:2C21-2C85); 4 = ready-sync loop (bytes `DC5B` exchanged until both sides send non-zero, 00:2BEC-2C1E). `00:2DD8` refuses to close the link while it is non-zero. | **C** |
| `$DC52` | 1 | `lnk_role_rx` | u8 0/1 | W 00:2B46 (:=1), 2B57, 2B83 (:=0), 2D8B; R 07:418A, 07:4CE6 | Role decided by the handshake: 1 = this camera **receives** a photo (checks that the peer has photos and its own album is not full, 00:2B63-2B7F), 0 = it **sends** (own count != 0, peer not full, 00:2B82-2BA1). Bank 7 copies it into `$D5F5` (07:418A-418D). The role follows the *initiator's* wish: `DC55` bit 7 for the initiator (00:2B4F-2B5C), the inverse for the responder (00:2B4F: tests the received byte). | **C** |
| `$DC53` | 1 | `lnk_album_full` | u8 0/1 | W 07:4126 (:= `[D561] >= $1E`), 00:2D8E (:=0); R 00:2DF2, 2E6C | Own album full (30 photos = `$1E`, 07:411C-4126). Becomes bit 6 (`$40`) of the info byte `DC54` (00:2DF2-2DFF, 2E68-2E7A). | **C** |
| `$DC54` | 1 | `lnk_info_tx` | u8: bit 7 want-receive, bit 6 album full, bits 0-5 photo count | W 00:2DFF (`00:2DED`), 2E7A (`00:2E68`), 2D91; R 00:2B32 (sent as the second byte), 2B6A (`& $40`) | Info byte sent in the exchange following the hello byte (00:2B32-2B35). `00:2E68` ORs the current `DC55`/`DC53` bits into it every frame. | **C** |
| `$DC55` | 1 | `lnk_own_count` | u8: bit 7 = user chose "receive", bits 0-6 = number of photos | W 07:412C (:= `[$D561]`), 07:414C (bit 7 := `[$D5F5] != 0`, Left/Right choice), 00:2D0E, 2D94 (:=0); R 00:2B5C, 2B86, 2DFB, 2E75, 07:4CEC | Own photo count (`$D561`) plus the "receive" choice made with Right on the link screen (`$D5F5` is set by `07:4272`: Left -> 0, Right -> 1). Used for the role test and as the browse limit when sending (`07:4CE6` -> `$DA09`). | **C** |
| `$DC56` | 1 | `lnk_cmd_tx` | u8: `$40`+slot, `$80`+page, `$EF` = cancel | W 00:2E36 (= `DC5A \| $40`), 2E5D (= `DC5A \| $80`), 07:4D27 (:=$EF), 00:2CCE/2D0B/2D97 (:=0); R 00:2BD9, 2C44, 2E28 | Command byte sent after the info exchange (00:2BD9-2BE3). Bit 6 (`00:2E0E`): transfer photo slot `DC5A` (`$1000` bytes); bit 7 (`00:2E41`, from `07:5169`): `$0800`-byte transfer (**I**: a page of 8 thumbnails, evidence under `DC59`); `$EF`: cancel. | **C** |
| `$DC57` | 1 | `lnk_info_rx` | u8 | W 00:2B3C (:=[FF01]), 2D9A; R 00:2B4F, 2B8D | Peer's info byte (raw). | **C** |
| `$DC58` | 1 | `lnk_peer_count` | u8 0..31 | W 00:2B41 (:= `DC57 & $1F`), 2D11, 2D9D; R 00:2B63, 07:4CF5 | Peer's photo count; 0 means "peer has nothing to give" (abort reason 3). Used as the browse limit when receiving (`07:4CF5` -> `$DA09`). | **C** |
| `$DC59` | 1 | `lnk_cmd_rx` | u8 | W 00:2C23 (:=[FF01]), 2C33, 2CD1, 2CF0, 2DA0; R 00:2C50, 2C60, 2C6B; R 07:46C7, 07:4D02 | Peer's command byte (bit 7: thumbnail page request, bit 6: photo request, `$EF`: cancel). Bank 7 State11 decodes it: page = `(DC59 & 3)*8` into `[$FF9E]` for the bank-2 thumbnail copy `02:50CD` (8 x `$100` bytes into `$C000`), or slot `DC59 & $1F` into `$D5D8` (07:46C7-4701); `$EF` aborts (07:46CE). Thumbnail reading of the bit-7 command is **I**: `02:50CD-510D` copies 8 blocks of `$100` bytes from SRAM `$AE00+` (`ld hl,$AE00 ; add hl,de`, 02:50F2) into `$C000-$C7FF` = exactly `DC47 = 8` pages, and `07:5160-5167` addresses thumbnail n at `$C000 + (n&7)*$100`. | **C** |
| `$DC5A` | 1 | `lnk_slot` | u8 (6 bits) | W 07:4579, 458D, 5183 (own request), 00:2C55/2C65/2C82 (:= `DC59 & $3F` at stage 3), 2DA3; R 00:2E2F, 2E56 | Slot (or thumbnail page) argument of the current command: bank 7 stores the requested photo number / page (= photo>>3) before `00:2E0E/2E41` builds `DC56` from it; the IRQ later overwrites it with the low 6 bits of the command it received. | **C** |
| `$DC5B` | 1 | `lnk_ready_tx` | u8: 0 not ready, 1 ready, `$EF` cancel | W 07:457E, 46E6, 4872 (:=1), 07:4864 (:=$EF), 00:2C07 (:=0), 2DA6; R 00:2C10, 2C19-2C1C | Byte sent during the ready-sync loop (stage 4): bank 7 sets it to 1 when its side has prepared its buffer, to `$EF` to cancel. | **C** |
| `$DC5C` | 1 | `lnk_ready_sent` | u8 | W 00:2C04 (:=0), 2C16 (:= `DC5B`), 2DA9; R 00:2BF0 | Latch: once the unit has sent a non-zero `DC5B`, the next sync round counts as completed regardless of the received byte (00:2BF0-2BFD) and the IRQ switches to the bulk stage (`DC51 := 0`, 00:2C01). | **C** |
| `$DC5D` | 1 | `lnk_flag_55` | u8 | W 00:2B22 (:=1 when the received hello byte is `$55`), 2D14, 2DAC (:=0); no reader | Written only; no code in the ROM ever sends `$55` either. | **U** |
| `$DC5E` | 1 | `lnk_cancel_sent` | u8 0/$EF | W 00:2BE0 (:=$EF when the own command byte is `$EF`), 2D17, 2DAF; R 00:2C2D | Remembers that this unit sent the cancel command, so that it ends the transfer at stage 3 whatever the peer answered (00:2C2D-2C38). | **C** |

#### 4.3 `$DC5F-$DCFF` unused

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DC5F-$DCFF` | 161 | `unused_dc5f_dcff` | - | no proven instruction touches any byte of `$DC5F-$DCFF` (none is in `wram_summary.csv`) | 161 bytes, zero after the boot/soft-reset clear (`00:0181`). Not part of the printer, link or sound state. | **U** |

#### 4.4 `$DD00-$DD7F` sound driver

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DD00` | 1 | `snd_unused_00` | - | only as start address of the clear loop `1F:5344` (`ld hl,$DD00`) | Never read or written by name. The sound init `1F:5338-5352` (NR52 := `$80`, NR50 := `$77`, NR51 := `$FF`, then clears memory from `$DD00` while `H != $DF`, i.e. **`$DD00-$DEFF`**, 512 bytes) is called once from `00:01E1` through `00:2A23` -> `1F:7FF6`. | **U** |
| `$DD01` | 1 | `snd_transpose` | s8 (added to the note byte) | init 1F:5423-5429 (song header byte 0), W 1F:556A (op `$9F`), R 1F:562B | Song transposition. Every note byte of tracks 1-3 is `index*2` (word index into the frequency table `$4037`); if `[DD01] != 0` it is sign-extended and added to the note byte before the lookup (`1F:562B-563D`; rests, note byte 1, are exempt). Song header byte 0 of the 72 songs (table `$57C6`): `$00` x48, `$FC` x4, `$FA` x6, `$F6` x2, `$02` x6, `$04`, `$06`, `$08` x2, `$10`, `$12`. Op `$9F` changes it inside a song. | **C** |
| `$DD02` | 1 | `snd_dur_tab_lo` | u16 LE pointer (DD02:DD03) | init 1F:5428 + 541A (song header bytes 1-2), W 1F:5556 (op `$9E`); R via `ld de,$DD02` 1F:55FA | Low byte of the pointer to the 16-entry **duration table** (frames per note length) of the current song: header bytes 1-2, one of seven tables at `$416B-$41B3` (`$418B` in 36 of the 72 songs: `03 06 0C 18 30 60 12 24 48 08 10 02 01 04 16 78`), indexed by the low nibble of the length ops `$A0-$AF` (`1F:55ED-5606`). Op `$9E` replaces both bytes from the stream. The high byte `DD03` is aliased (see below). | **C** |
| `$DD03` | 1 | `snd_dur_tab_hi / snd_sfx10_digit0` | u8: pointer high byte **and** nibble 0..F | W 00:16FB (high nibble of `[$DA8F]`), 1F:555F (op `$9E`, pointer high); R 1F:475F, 4769, 55FA/55FF | **Aliased**: high byte of the duration-table pointer (`1F:5600-5602`: `HL = [DD03:DD02] + C`) *and* the first of the four jingle digits of SFX `$10`. `00:16F4` overwrites it with a nibble 0..F, so afterwards the pointer is `$00xx-$0Fxx`, i.e. the lookup reads **bank-0 ROM** (the fixed bank at `$0000-$3FFF`), not the song table, until the next song start or op `$9E`. Harmless when no song with length ops is running at that moment (callers: bank 6 `06:514C/53AE/639A/63C6/6404` and bank 7 `07:717B`; whether music plays there was not checked: I). | **C** |
| `$DD04-$DD06` | 3 | `snd_sfx10_digits[1..3]` | u8 nibbles 0..F | W 00:1703 (low nibble of `[$DA8F]`), 00:170D (high nibble of `[$DA90]`), 00:1715 (low nibble of `[$DA90]`); R 1F:475F (`ld hl,$DD03 ; add hl,bc`, c = step 1..3) | Digits 1-3 of the 4-digit jingle (see `DD03`). `00:16F4` splits the 16-bit value `[$DA8F:$DA90]` (= bytes `F34/F35` of the tag-head buffer `$DA5B-$DA90`, README 3.x "F34-F35") into 4 nibbles `DD03..DD06` and then *requests sound `$10` on channel 1* (`ld a,$10 ; call $2A7C`, 00:1719-171B). Effect `$10` (ch1 SFX id 16: init `1F:4745`, step `1F:474D`) plays one note per digit: nibble -> `$4735[nibble]` -> 5-byte NR10-NR14 block at `$46E5+..` (1F:4769-477A). It is a **melody, not text**: `$2A7C` is the ch-1 sound-request routine, not a text routine. | **C** |
| `$DD07` | 1 | `snd_unused_07` | - | not referenced | Zero after boot. | **U** |
| `$DD08` | 1 | `snd_seq_idx` | u8 0..$17 | W 1F:48DB (:=0, shared tail `1F:48DA` of ch-1 handler `1F:48AE` = id `$2C`), 1F:4A43 (:=0 on wrap), 1F:52A9 (global reset); R/inc by `1F:4A44` (P 1F:4A44, 4A47, 4A4C) | Step memory of ch-1 effect id `$34` (init handler `1F:4A44`): every request plays the next one of **24** register blocks (`C = [$4A2A + idx]`, block at `$4A02 + C`, tick limit `$0D`: `1F:4A50-4A5E`), `idx` is incremented and wraps to 0 at `$18` (`1F:4A47-4A4C`, `4A42-4A43`). It is the only SFX state that survives between two requests. Reset by id `$2C` (`1F:48DB`) and by the global reset. | **C** |
| `$DD09-$DD0A` | 2 | `snd_u_09` | u8 | W 1F:52A3, 52A6 (:=0, global reset `1F:5293` only) | Only cleared by the reset routine; never read. | **U** |
| `$DD0B-$DD0C` | 2 | `snd_unused_0b` | - | not referenced | Zero after boot. | **U** |
| `$DD0D` | 1 | `snd_freeze` | u8 (always 0) | R 1F:54A4 only (op `$9D`); never written | If non-zero, op `$9D` (set instrument) would only drive the hardware (wave RAM load) and not store its three operands into the track block (1F:54A4-54B5). Constant 0 in practice. | **U** |
| `$DD0E` | 1 | `snd_u_0e` | u8 | W 1F:52A0 (:=0, reset only) | Only cleared by the reset routine; never read. | **U** |
| `$DD0F` | 1 | `snd_unused_0f` | - | not referenced | Zero after boot. | **U** |
| `$DD10-$DD1F` | 16 | `snd_track1` | struct[16] (layout in section 3) | song init 1F:5420 (P 1F:542E ptr, 5446 stream, 546D tick); per-frame loop base P 1F:55BD; vibrato phase `DD1E` W 1F:5479, P 1F:56F0; override bit `DD1F` P 1F:522C (set), 47A4 (clear), W 1F:52B6 | Music track of hardware channel 1 (square 1, NR1x): one 16-byte block per track, stride `$10`, walked by the per-frame loop `1F:55BD-56ED` (`[DD50]` = 1..4). Fields: playlist pointer, tick counter, note length, stream pointer, instrument bytes, note frequency, rest flag, repeat return pointer, vibrato phase, repeat counter + SFX-override bit (see section 3). | **C** |
| `$DD20-$DD2F` | 16 | `snd_track2` | struct[16] (layout in section 3) | song init (P 1F:5434, 544F, 546D); `DD2E` W 1F:547C, P 1F:56F4; `DD2F` only cleared (W 1F:52B9: channel 2 has no SFX of its own) | Music track of hardware channel 2 (square 2, NR2x): one 16-byte block per track, stride `$10`, walked by the per-frame loop `1F:55BD-56ED` (`[DD50]` = 1..4). Fields: playlist pointer, tick counter, note length, stream pointer, instrument bytes, note frequency, rest flag, repeat return pointer, vibrato phase, repeat counter + SFX-override bit (see section 3). | **C** |
| `$DD30-$DD3F` | 16 | `snd_track3` | struct[16] (layout in section 3) | song init (P 1F:543A, 5458, 546D); `DD36:DD37` R 1F:5156/515A (wave pointer, reloaded after a ch-3 SFX), `DD38` R 1F:54EB; `DD3E` W 1F:547F, P 1F:56F8; override bit `DD3F` P 1F:5234 (set), 5151 (clear), 5198 (set), R 1F:5678, W 1F:52BC | Music track of hardware channel 3 (wave, NR3x): one 16-byte block per track, stride `$10`, walked by the per-frame loop `1F:55BD-56ED` (`[DD50]` = 1..4). Fields: playlist pointer, tick counter, note length, stream pointer, instrument bytes, note frequency, rest flag, repeat return pointer, vibrato phase, repeat counter + SFX-override bit (see section 3). | **C** |
| `$DD40-$DD4F` | 16 | `snd_track4` | struct[16] (layout in section 3) | song init (P 1F:5440, 5461, 546D); noise record `DD46-DD4A` W 1F:5650-565D (copy from table `$40C9`); override bit `DD4F` P 1F:523C (set), 4F67 (clear), W 1F:52BF | Music track of hardware channel 4 (noise, NR4x): one 16-byte block per track, stride `$10`, walked by the per-frame loop `1F:55BD-56ED` (`[DD50]` = 1..4). Fields: playlist pointer, tick counter, note length, stream pointer, instrument bytes, note frequency, rest flag, repeat return pointer, vibrato phase, repeat counter + SFX-override bit (see section 3). | **C** |
| `$DD50` | 1 | `snd_cur_track` | u8 1..4 | W 1F:55BA (:=1), 1F:56E8 (inc, via DE); R 1F:54E4, 5613, 566B, 571A; P 1F:54B6, 56DF | Loop variable of the per-frame music tick `1F:55B2`: number of the track being processed (1..4); selects the channel code paths (NR1x/NR2x/NR3x/NR4x) at `1F:5613`, `566B`, `571A` and ends the loop after 4 (`1F:56DF-56F0`). Also read by the instrument op `$9D` (`1F:54B6-54BD`: track 3 reloads wave RAM). | **C** |
| `$DD51` | 1 | `snd_tmp` | u8 scratch | W 1F:5267 (SFX start: := requested id), 1F:5717 (:= vibrato mode nibble); R 1F:5194, 520C, 573C | Scratch byte with two uses: (a) `1F:5266-5267` parks the id of the SFX being started here; `1F:520C-520F` (ch 1/4) and `1F:5194-5197` (ch 3) copy it into the channel's "running id" byte; (b) `1F:5717` parks the vibrato mode nibble for `1F:573C`. The two uses never overlap inside one call. | **C** |
| `$DD52-$DD54` | 3 | `snd_unused_52` | - | not referenced | Zero after boot. | **U** |
| `$DD55` | 1 | `snd_u_55` | u8 | W 1F:5299, 1F:53B5 (:=1); no reader | Written when a song is (re)initialised or after a reset (`1F:53AF`); never read. | **U** |
| `$DD56-$DD5D` | 8 | `snd_unused_56` | - | not referenced | Zero after boot. | **U** |
| `$DD5E` | 1 | `snd_u_5e` | u8 | W 1F:5375 (:=0, in the `$FE` path `1F:536D`); no reader | Write-only. | **U** |
| `$DD5F` | 1 | `snd_unused_5f` | - | not referenced | Zero after boot. | **U** |
| `$DD60-$DD67` | 8 | `snd_sfx1` | struct[8]: channel-1 SFX | mailbox W 00:2A59 (table routine `2A4B`), 00:2A7C (direct); service P 1F:52F8; cleared W 1F:5371 ($FE path), 5395 (end of every call); block bytes via DE/HL in `1F:520A-5219`, `1F:5279`; `DD63` W 1F:459A; `DD64` P in each step handler (e.g. 1F:4752, 43A8-4C74), W 1F:4941, 49EE (:=0); `DD66` W 1F:446A (:=$01), 4821 (:=$40), 4846 (:=$60), 49B8 (:=$85), 4A70 (:=$B0), 4A97 (:=$60), 4C67, P 1F:447F, 4831, 4856, 49E3, 4A83, 4AAA, 4C8E, R 1F:49DD, 4C93; `DD67` W 1F:4513 ($83), 4532 ($87), 455E ($85), 4585 ($87), 4910 ($F0), 4949, 4AC9 ($87), 4AF0 ($86), 4B19, 4B3F, 4B66 ($87), R 1F:45B1, 4932, 4944, 4B8D | SFX channel 1 block (hardware NR10-NR14), 8 bytes. `+0` `DD60` **request mailbox** (valid 1..`$3E`, tested `cp $3F` at 1F:52FF; one-shot: cleared at the end of every driver call); `+1` `DD61` **running id** (0 = none; set by `1F:520F`, cleared W 1F:4797/52AD; read by `1F:4370`, the guard that makes effects 6/12/13/14 refuse to start while id `$26` runs); `+2` `DD62` tick counter and `+3` `DD63` limit (helper `1F:5279` increments +2 and clears it when it equals +3; the limit is passed by the init handler to `1F:520A`, `1F:459A` rewrites it); `+4` `DD64` step index (cleared at start, `inc` by the step handlers, e.g. 1F:4755); `+5` `DD65` cleared at start, no other access found; `+6` `DD66`, `+7` `DD67` effect-specific bytes (init handlers store constants `$01/$40/$60/$85/$B0` into `DD66` and `$83/$85/$86/$87/$F0` into `DD67`: look like frequency start values and NR14/envelope constants: I). Init handlers: table `$41FA` (62 words, ids 1..62), step handlers: table `$4276` (62 words). The start routine `1F:520A` sets bit 7 of `DD1F` (music channel 1 muted) and loads NR10-NR14 from the 5-byte block at HL. | **C** |
| `$DD68` | 1 | `snd_music_req` | u8: 0 none, 1..$48 song, $FE pause, $FF reset | mailbox W 00:2A63 (table routine `2A4B`), 00:2A88 (direct, 81 `call $2A88`); R P 1F:5381; cleared W 1F:5398 (not on the `$FE` path) | **Music request mailbox**. Dispatcher `1F:537D` (entered once per frame from `00:2A37` -> `1F:7FF0`, call site `00:0333`): value 0 -> run the three SFX services then the music tick; `$FE` -> `1F:536D`: only the ch-1 SFX service runs this frame, the music tick is skipped and the mailbox is not cleared (I: pause, until something else is written); `$FF` -> full reset `1F:5293`; `1..$48` -> `1F:5356` stores it into `DD69` (via HL, `1F:535D`), fetches the song header from table `$57C6` (index id-1, 72 songs) and initialises the four tracks (`1F:5420`, which first calls `1F:52AC` = kills every running SFX id and silences the channels); values `$49..$FD` are ignored (`1F:535A`). On a frame with a song/reset request the SFX services are skipped and the pending SFX mailboxes are discarded (`1F:53AA-53AD` jumps to `1F:5391`, mailboxes cleared at 5395-539E). | **C** |
| `$DD69` | 1 | `snd_song` | u8 0..$48 | W via HL 1F:535D (:= request), W 1F:529D (reset), 1F:554A (:=0 at end of song); P 1F:55B2 (R), R 1F:5695 | Id of the playing song (0 = none: `1F:55B2-55B7` returns at once). Cleared when a track playlist ends with a `0000` word (`1F:5524-554F`, which also calls the reset). For songs `$01` and `$1E` ch-1 notes get NR10 := `$1D` and `B := $33` (ORed into NR11) (`1F:5695-56A7`). | **C** |
| `$DD6A-$DD6F` | 6 | `snd_unused_6a` | - | not referenced | Zero after boot. | **U** |
| `$DD70-$DD77` | 8 | `snd_sfx3` | struct[8]: channel-3 SFX | mailbox W 00:2A6D (table routine), 00:2A80 (direct, 10 call sites); service P 1F:52D8; cleared W 1F:539B; id W 1F:5197 (ch-3 wave-load handlers) and 1F:520F, W 1F:514C (:=0), 52B0; step `DD74` W 1F:519E, inc by 1F:4F8C, 4FCE, 4FF8, 502F, 505C, 5093, 50C1, 50ED, 512A; `DD75/DD76` W 1F:4F78/4F80, 4FAB/4FAF, 504B, 5082, 50B0, 50DC, 5107, 511A, 51A1/51A4 | SFX channel 3 block (wave channel NR30-NR34), same layout as `DD60`: `+0` `DD70` request (valid 1..10: `cp $0b`, 1F:52DF), `+1` `DD71` running id, `+2/+3` `DD72/DD73` tick/limit, `+4` `DD74` step, `+5/+6` `DD75/DD76` effect-specific running values (the `$4F72` family keeps a 16-bit frequency lo/hi there, `1F:4F89-4FBA`; the ramp effect at `1F:5127-5147` uses `DD75` as direction flag and `DD76` as the NR33 value), `+7` `DD77` no access. Init table `$42F2` (10 words), step table `$4306`. The start sets bit 7 of `DD3F` (music wave channel muted); the end routine `1F:514B` clears the id and the bit, NR30 := 0 and reloads the music wave RAM from `[DD36:DD37]` (1F:5151-515E, 5286). | **C** |
| `$DD78-$DD7F` | 8 | `snd_sfx4` | struct[8]: channel-4 SFX (noise) | mailbox W 00:2A77 (table routine), 00:2A84 (direct, 10 call sites), also W 1F:438B (:=6), 4410 (:=3), 4559 (:=2), 4814 (:=4) (ch-1 effects chain a noise effect); service P 1F:5318; cleared W 1F:539E; id W 1F:520F, W 1F:4F5C (:=0), 52B3; step `DD7C` P 1F:4CEC-4F39; `DD7D` P 1F:4D54, 4D68 | SFX channel 4 block (noise NR41-NR44), 8 bytes: `+0` `DD78` request (valid 1..18: `cp $13`, 1F:531F; some ch-1 effects also post a noise request here), `+1` `DD79` running id, `+2/+3` `DD7A/DD7B` tick/limit, `+4` `DD7C` step, `+5` `DD7D` one-shot flag of the handler `1F:4D47` (ch-4 effect 6): it walks the NR43 table `$4D07` by `DD7C` (`cp $B0` ends the effect, `1F:4D4B`); when the table byte is 0 it sets `DD7D := 1`, loads the final NR41-44 block `$4D14` and stops updating (`1F:4D54-4D6F`); `+6/+7` `DD7E/DD7F` no access. Init table `$431A` (18 words), step table `$433E`; the end routine `1F:4F56-4F6C` clears the id, NR42 := 8, NR44 := `$80` and bit 7 of `DD4F`. | **C** |

#### 4.5 `$DD80-$DDFF` unused

| Address | Size | Name | Type/format | Used by (bank:function) | Meaning, values, init | Status |
|---|---|---|---|---|---|---|
| `$DD80-$DDFF` | 128 | `snd_unused_80` | - | not referenced by any proven instruction (only inside the clear loops: cold boot `00:0181`, sound init `1F:5344`) | Zero after boot; no variable of the sound driver lives above `$DD7D`. | **U** |

### 5. Incidental / single-use list and coverage index

Every address of `$DC00-$DDFF` that appears in `wram/wram_summary.csv` is listed below with its access counts (`R`eads, `W`rites, `P`ointer loads from the summary) and the row that explains it. All other addresses of the range have no proven access at all; they are covered by the unused rows.

```
DC08  R  1 W  2 P  0  banks 00:2 05:1              -> prn_sheets (C)
DC09  R  1 W  2 P  0  banks 00:2 05:1              -> prn_margin (C)
DC0A  R  1 W  2 P  0  banks 00:2 05:1              -> prn_palette (C)
DC0B  R  2 W  0 P  0  banks 00:2                   -> prn_comp_enable (U)
DC0C  R  1 W  4 P  0  banks 00:5                   -> prn_band_comp_flag (C)
DC0D  R  8 W  9 P  0  banks 00:17                  -> prn_state (C)
DC0E  R  2 W  4 P  0  banks 00:6                   -> prn_last_type (C)
DC0F  R  1 W  2 P  0  banks 00:3                   -> prn_sync_done (C)
DC10  R  2 W  1 P  1  banks 00:4                   -> prn_hdr_done (C)
DC11  R  2 W  1 P  2  banks 00:5                   -> prn_data_done (C)
DC12  R  1 W  1 P  1  banks 00:3                   -> prn_chk_idx (C)
DC13  R  1 W  3 P  0  banks 00:4                   -> prn_target_len (C)
DC14  R  1 W  3 P  0  banks 00:4                   -> prn_target_len (C)
DC15  R  1 W  1 P  0  banks 00:2                   -> prn_hdr_len (C)
DC16  R  1 W  1 P  0  banks 00:2                   -> prn_hdr_len (C)
DC17  R  1 W  1 P  0  banks 00:2                   -> prn_data_len (C)
DC18  R  1 W  1 P  0  banks 00:2                   -> prn_data_len (C)
DC19  R  2 W  4 P  3  banks 00:9                   -> prn_tx_idx (C)
DC1A  R  1 W  2 P  0  banks 00:3                   -> prn_tx_idx (C)
DC1B  R  1 W  3 P  0  banks 00:4                   -> prn_src_ptr (C)
DC1C  R  1 W  3 P  0  banks 00:4                   -> prn_src_ptr (C)
DC1D  R  1 W  1 P  0  banks 00:2                   -> prn_hdr_ptr (C)
DC1E  R  1 W  1 P  0  banks 00:2                   -> prn_hdr_ptr (C)
DC1F  R  3 W  2 P  0  banks 00:5                   -> prn_data_ptr (C)
DC20  R  3 W  2 P  0  banks 00:5                   -> prn_data_ptr (C)
DC21  R  0 W  1 P  0  banks 00:1                   -> prn_band_ptr_copy (U)
DC22  R  0 W  1 P  0  banks 00:1                   -> prn_band_ptr_copy (U)
DC23  R  1 W  2 P  1  banks 00:4                   -> prn_checksum (C)
DC24  R  1 W  2 P  0  banks 00:3                   -> prn_checksum (C)
DC25  R  2 W  5 P  0  banks 00:7                   -> prn_tx_phase (C)
DC26  R  0 W  1 P  1  banks 00:2                   -> prn_trail_cnt (C)
DC27  R 15 W  2 P  0  banks 00:16 05:1             -> prn_status (C)
DC28  R  2 W  3 P  0  banks 00:5                   -> prn_dev_id (C)
DC29  R  1 W  1 P  0  banks 00:2                   -> prn_prev_rx (C)
DC2A  R  0 W  2 P  0  banks 00:2                   -> prn_irq_seen (U)
DC2B  R  3 W  1 P  0  banks 00:4                   -> prn_pkt_type (C)
DC2C  R  2 W  2 P  0  banks 00:4                   -> prn_has_data (C)
DC2D  R  0 W  1 P  3  banks 00:4                   -> prn_pkt_buf (C)
DC2E  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC2F  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC30  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC31  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC32  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC33  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC34  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC35  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC36  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC37  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC38  R  0 W  1 P  0  banks 00:1                   -> prn_pkt_buf (C)
DC3B  R  5 W  5 P  0  banks 00:10                  -> prn_tx_busy (C)
DC3C  R  1 W  2 P  0  banks 00:3                   -> prn_abort (C)
DC3D  R  1 W  2 P  0  banks 00:2 05:1              -> prn_last_chunk (C)
DC3E  R  2 W  1 P  1  banks 00:4                   -> prn_chunk_cnt (C)
DC40  R  1 W  2 P  1  banks 00:4                   -> prn_poll_cnt (C)
DC41  R  1 W  6 P  0  banks 00:5 05:2              -> prn_poll_enable (C)
DC42  R  1 W  3 P  0  banks 00:4                   -> prn_busy_seen (C)
DC43  R  4 W  7 P  0  banks 00:11                  -> lnk_turn (C)
DC44  R  2 W  5 P  0  banks 00:5 07:2              -> lnk_connected (C)
DC45  R  7 W  5 P  0  banks 00:11 07:1             -> lnk_initiator (C)
DC46  R  2 W  5 P  0  banks 00:7                   -> lnk_cmd_armed (C)
DC47  R  2 W  7 P  0  banks 00:9                   -> lnk_pages (C)
DC48  R  1 W  2 P  0  banks 00:3                   -> lnk_rx_base (C)
DC49  R  1 W  2 P  0  banks 00:3                   -> lnk_rx_base (C)
DC4A  R  1 W  4 P  0  banks 00:5                   -> lnk_tx_base (C)
DC4B  R  1 W  4 P  0  banks 00:5                   -> lnk_tx_base (C)
DC4C  R  2 W  5 P  0  banks 00:7                   -> lnk_index (C)
DC4D  R  2 W  5 P  0  banks 00:6 07:1              -> lnk_index (C)
DC4E  R  2 W  3 P  0  banks 00:3 07:2              -> lnk_ended (C)
DC4F  R  3 W  4 P  0  banks 00:3 07:4              -> lnk_half_done (C)
DC50  R  1 W  5 P  0  banks 00:5 07:1              -> lnk_abort_reason (C)
DC51  R  4 W  7 P  0  banks 00:11                  -> lnk_stage (C)
DC52  R  2 W  4 P  0  banks 00:4 07:2              -> lnk_role_rx (C)
DC53  R  2 W  2 P  0  banks 00:3 07:1              -> lnk_album_full (C)
DC54  R  3 W  3 P  0  banks 00:6                   -> lnk_info_tx (C)
DC55  R  5 W  3 P  1  banks 00:6 07:3              -> lnk_own_count (C)
DC56  R  3 W  6 P  0  banks 00:8 07:1              -> lnk_cmd_tx (C)
DC57  R  2 W  2 P  0  banks 00:4                   -> lnk_info_rx (C)
DC58  R  2 W  3 P  0  banks 00:4 07:1              -> lnk_peer_count (C)
DC59  R  5 W  5 P  0  banks 00:8 07:2              -> lnk_cmd_rx (C)
DC5A  R  2 W  7 P  0  banks 00:6 07:3              -> lnk_slot (C)
DC5B  R  2 W  6 P  0  banks 00:4 07:4              -> lnk_ready_tx (C)
DC5C  R  1 W  3 P  0  banks 00:4                   -> lnk_ready_sent (C)
DC5D  R  0 W  3 P  0  banks 00:3                   -> lnk_flag_55 (U)
DC5E  R  1 W  3 P  0  banks 00:4                   -> lnk_cancel_sent (C)
DD00  R  0 W  0 P  1  banks 1f:1                   -> snd_unused_00 (U)
DD01  R  1 W  1 P  1  banks 1f:3                   -> snd_transpose (C)
DD02  R  0 W  1 P  1  banks 1f:2                   -> snd_dur_tab_lo (C)
DD03  R  0 W  2 P  2  banks 00:1 1f:3              -> snd_dur_tab_hi / snd_sfx10_digit0 (C)
DD04  R  0 W  1 P  0  banks 00:1                   -> snd_sfx10_digits[1..3] (C)
DD05  R  0 W  1 P  0  banks 00:1                   -> snd_sfx10_digits[1..3] (C)
DD06  R  0 W  1 P  0  banks 00:1                   -> snd_sfx10_digits[1..3] (C)
DD08  R  0 W  2 P  1  banks 1f:3                   -> snd_seq_idx (C)
DD09  R  0 W  1 P  0  banks 1f:1                   -> snd_u_09 (U)
DD0A  R  0 W  1 P  0  banks 1f:1                   -> snd_u_09 (U)
DD0D  R  1 W  0 P  0  banks 1f:1                   -> snd_freeze (U)
DD0E  R  0 W  1 P  0  banks 1f:1                   -> snd_u_0e (U)
DD10  R  0 W  0 P  3  banks 1f:3                   -> snd_track1 (C)
DD12  R  0 W  0 P  1  banks 1f:1                   -> snd_track1 (C)
DD14  R  0 W  0 P  1  banks 1f:1                   -> snd_track1 (C)
DD1E  R  0 W  1 P  1  banks 1f:2                   -> snd_track1 (C)
DD1F  R  0 W  1 P  2  banks 1f:3                   -> snd_track1 (C)
DD20  R  0 W  0 P  2  banks 1f:2                   -> snd_track2 (C)
DD24  R  0 W  0 P  1  banks 1f:1                   -> snd_track2 (C)
DD2E  R  0 W  1 P  1  banks 1f:2                   -> snd_track2 (C)
DD2F  R  0 W  1 P  0  banks 1f:1                   -> snd_track2 (C)
DD30  R  0 W  0 P  2  banks 1f:2                   -> snd_track3 (C)
DD34  R  0 W  0 P  1  banks 1f:1                   -> snd_track3 (C)
DD36  R  1 W  0 P  0  banks 1f:1                   -> snd_track3 (C)
DD37  R  1 W  0 P  0  banks 1f:1                   -> snd_track3 (C)
DD38  R  1 W  0 P  0  banks 1f:1                   -> snd_track3 (C)
DD3E  R  0 W  1 P  1  banks 1f:2                   -> snd_track3 (C)
DD3F  R  1 W  1 P  3  banks 1f:5                   -> snd_track3 (C)
DD40  R  0 W  0 P  2  banks 1f:2                   -> snd_track4 (C)
DD44  R  0 W  0 P  2  banks 1f:2                   -> snd_track4 (C)
DD46  R  0 W  0 P  1  banks 1f:1                   -> snd_track4 (C)
DD4F  R  0 W  1 P  2  banks 1f:3                   -> snd_track4 (C)
DD50  R  4 W  1 P  2  banks 1f:7                   -> snd_cur_track (C)
DD51  R  3 W  2 P  0  banks 1f:5                   -> snd_tmp (C)
DD55  R  0 W  2 P  0  banks 1f:2                   -> snd_u_55 (U)
DD5E  R  0 W  1 P  0  banks 1f:1                   -> snd_u_5e (U)
DD60  R  0 W  4 P  1  banks 00:2 1f:3              -> snd_sfx1 (C)
DD61  R  1 W  2 P  0  banks 1f:3                   -> snd_sfx1 (C)
DD63  R  0 W  1 P  0  banks 1f:1                   -> snd_sfx1 (C)
DD64  R  0 W  2 P 24  banks 1f:26                  -> snd_sfx1 (C)
DD66  R  2 W  7 P  7  banks 1f:16                  -> snd_sfx1 (C)
DD67  R  4 W 11 P  0  banks 1f:15                  -> snd_sfx1 (C)
DD68  R  0 W  3 P  1  banks 00:2 1f:2              -> snd_music_req (C)
DD69  R  1 W  1 P  2  banks 1f:4                   -> snd_song (C)
DD70  R  0 W  3 P  1  banks 00:2 1f:2              -> snd_sfx3 (C)
DD71  R  0 W  2 P  1  banks 1f:3                   -> snd_sfx3 (C)
DD74  R  0 W  1 P  9  banks 1f:10                  -> snd_sfx3 (C)
DD75  R  1 W  8 P  0  banks 1f:9                   -> snd_sfx3 (C)
DD76  R  1 W  4 P  0  banks 1f:5                   -> snd_sfx3 (C)
DD78  R  0 W  7 P  1  banks 00:2 1f:6              -> snd_sfx4 (C)
DD79  R  0 W  2 P  0  banks 1f:2                   -> snd_sfx4 (C)
DD7C  R  0 W  0 P 10  banks 1f:10                  -> snd_sfx4 (C)
DD7D  R  0 W  0 P  2  banks 1f:2                   -> snd_sfx4 (C)
```

### Corrections to the previous README

1. **"`$DC00-$DC5E` = bank 0 sound engine channel state"** (README section on `$DC00`): wrong. `$DC00-$DC42` is the **GB Printer protocol driver**, `$DC43-$DC5E` the **link-cable protocol**. There is no sound code in bank 0 that touches `$DC00-$DC5E`.
2. **"`$dc08,$dc09,$dc0a` copied into a 12-byte note event block at `$dc2d`, 4 fields (channel-type, param, palette-or-volume, duration)"**: wrong. They are the sheets/margin/palette bytes of the **PRINT packet body** (`DC2D`, 12-byte packet buffer); `$dc08` is not "also a sound byte", it is only the sheet count (always 1). The README's other statement, that `3339`/`1BA4` build the print command block at `$dc2d`, is right.
3. **"`$DD00-$DD7D` completely unidentified, bank `$1F` unidentified"**: it is the sound driver and `$DD00-$DD7F` is its complete state (section 3); the `DD03-DD06` nibbles are the jingle digits of SFX `$10`.
4. **"`$16F4` splits F34-F35 into 4 nibbles for the text routine `$2A7C`"**: the nibble split is right, but `$2A7C` is the sound-request routine (channel-1 mailbox `DD60`), A=`$10` is the sound id of the 4-note jingle. Not text.
5. **"`$DBCF`: value from table `07:$4186` keyed by `$dc50`"**: confirmed, and now explained: `$DC50` is the link abort reason; bank 7 State01 maps it through the 4-byte table `07:4186` = `09 09 0A 0B` into `$DBCF` (`07:416F-4185`). `$DBCF` itself is outside this range.
6. The first-round link statement (`DC47` page count, `DC48:49` RX base, `DC4A:4B` TX base, `DC4C:4D` index, `DC56` command) is correct, with the added precision that the 16-bit values are big-endian.

### Still inconclusive

* `DC5D` (`lnk_flag_55`) and the `$55` hello byte: `$55` is accepted when received (it sets `DC5D`, which nothing reads) but no proven code sends it (immediate scan).
* The variable-length/compressed print path (`DBFE...DC0C`, `DC21`, `DC2A`): present but dead in the proven code; whether a data-driven callback could reach it was not checked.
* A checksum-error retry (status bit 0) advances `DC1F:DC20` by `$0280` instead of re-sending the same band (`00:1AA8-1ABD`): looks like a bug in the retry path; not tested on hardware.
* Thumbnail-page interpretation of the `$80|page` / `DC47 = 8` link variant is I (consistent with the sizes), not confirmed on screen.
* Effect-specific bytes `+5..+7` of the SFX blocks, the role of track byte `+7`, the `DD0D` freeze flag (read-only, constant 0), the exact semantics of the `$FE` request (I: only the channel-1 effect service runs).
* Which sound id means what (the 41 + 5 + 8 effect ids and 72 song ids are not named); the interplay with the bank-0 music editor player (`$1017-$1560`) that writes the APU directly.
* Whether music can be playing when `00:16F4` overwrites `DD03` (it would redirect the duration table to bank-0 ROM bytes until the next song start).
