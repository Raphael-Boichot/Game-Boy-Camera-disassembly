#!/usr/bin/env python3
"""Build the TCRF documented-content checklist for the Japanese Pocket Camera ROM.
Coverage columns are computed from the merged coverage file (organic = joypad + SRAM only, forced = snapshot/poke runs).
usage: tcrf_checklist.py COV.npz OUT.md OUT.csv
Evidence tags: C = code/data-traced or seen on a screenshot of the ROM, I = inferred (visual / structural match),
? = inconclusive or not located (never guessed).
The 'TCRF says' column paraphrases the OCR of the TCRF PDFs supplied by the user (tcrf/t1-*.txt, t2-*.txt)."""
import sys, os, csv, numpy as np
from collections import Counter
z = np.load(sys.argv[1]); ex = z['ex'] != 0; oex = z['oex'] != 0; dr = z['dr'] != 0; odr = z['odr'] != 0
def fo(bank, a): return bank * 0x4000 + (a - 0x4000) if bank else a
def R(bank, a, b): return (fo(bank, a), fo(bank, b) + 1)           # inclusive end
def Rl(bank, a, n): return (fo(bank, a), fo(bank, a) + n)
def FO(o, n): return (o, o + n)
def cov(ranges, kind):
    t = o = n = t2 = 0
    for a, b in ranges:
        seg = slice(a, b); n += b - a; t2 += (dr[seg] | ex[seg]).sum()
        if kind == 'code': t += (ex[seg]).sum(); o += (oex[seg]).sum()
        else: t += (dr[seg] | ex[seg]).sum(); o += (odr[seg] | oex[seg]).sum()
    if n == 0: return 'n/a', 0, 0, 0, 0
    pt, po = 100.0 * t / n, 100.0 * o / n
    st = 'organic' if po >= 90 else ('mostly organic' if po >= 50 else ('partly organic' if po >= 10 else ('forced-only' if pt >= 50 else ('partly touched (forced)' if pt >= 5 else 'never touched'))))
    return st, n, pt, po, 100.0 * t2 / n
def loc(ranges):
    out = []
    for a, b in ranges:
        while a < b:
            bank = a // 0x4000; lo = bank * 0x4000; hi = min(b, lo + 0x4000)
            off = 0x4000 if bank else 0
            out.append('%02X:%04X-%04X' % (bank, a - lo + off, hi - 1 - lo + off)); a = hi
    return ' '.join(out)
I = []
def add(iid, grp, item, tcrf, rng, kind, meth, ver, tag, asset=''): I.append((iid, grp, item, tcrf, rng, kind, meth, ver, tag, asset))
GA = 'A. Unlock-gated content (credits, CoroCoro, Album B, unlockable stamps and games)'
GB = 'B. TCRF "Unused" sections (music, graphics, hot-spot effects, code)'
GC = 'C. TCRF "Regional Differences": what the Japanese side shows'
# =========================================================================== A
add('A01', GA, 'Real credits sequence: gate and states $12-$18 (mode $08, bank 9)', 'JP: "STAFF ROLL" label; the sentence "Don\'t butter me up!" is on the ending picture of the (real) credits and was removed in international versions',
    [R(9, 0x4CF2, 0x5200)], 'code', 'code trace + emulator screenshots with unlocking saves',
    'EXECUTED. Gate 09:4CFC-4D0B: stored [$DAA7:$DAA6] >= $7799 (the nine-complement of the displayed Run!Run!Run! result, i.e. displayed 22:00 or lower; SRAM 10CC:10CB) -> real credits (CLIP THIS, One Love, staff roll text, ending picture); below the gate -> dancers only. The never-executed bytes are the tail of the range, not a separate feature.', 'C', 'shots/credits_real_s13_clip_this.png shots/credits_real_s14_one_love.png shots/credits_real_s15_staff_roll_text.png shots/credits_real_s16_ending_picture.png shots/credits_normal_dancer.png')
add('A02', GA, 'Credits graphics: CLIP THIS, One Love, ending picture ("Don\'t butter me up! Be happy!!"), staff-roll background, dancer', 'same',
    [R(0x13, 0x7000, 0x7FFF), R(0x1C, 0x7C60, 0x7E9F), R(0x19, 0x5260, 0x645F), R(0x26, 0x72C0, 0x74FF), R(0x20, 0x4000, 0x4DFF), R(0x25, 0x4480, 0x497F), R(0x22, 0x4500, 0x496F), R(0x26, 0x5E80, 0x60BF)], 'data',
    'catalog_jp.csv callers jr_009_4d0e, Jump_009_4d86, jr_009_4e59, jr_009_4eba', 'RETRIEVED. All blocks are read by the credits loaders; the JP ending picture contains the sentence TCRF says was removed internationally (seen on the screenshot).', 'C', 'assets/screens/09_Jump_009_4d86_map9800_src1c_7c60.png assets/screens/09_jr_009_4e59_map9800_src26_72c0.png')
add('A03', GA, 'CoroCoro tag check + rewrite (save bytes $1FFD-$1FFF = 56 56 53)', 'Bytes 0x1FFD-0x1FFF = 56 56 53 unlock the CoroCoro content ("565653" ~ CoroCoro-Comi(c)); a ROM patch can write them at every boot',
    [R(8, 0x72E0, 0x731B)], 'code', 'disassembly + emulator',
    'Counts matches against the constant at 08:7319; >= 2 of 3 -> sets $D582 = 1, $D562 = $1E and REWRITES the three bytes (so a damaged tag self-repairs). Called from mode $19 state 0 (08:72B2).', 'C', '')
add('A04', GA, 'CoroCoro second copyright screen', 'A second copyright screen crediting the authors of the featured mangas is displayed after the Creatures and Game Freak copyrights',
    [R(8, 0x72B7, 0x72DF), Rl(0x21, 0x6BC0, 0x600)], 'data', 'screenshot with the tag', 'EXECUTED with the tag (08:72B7-72DF loads 21:6BC0, $600 B, then waits). Screenshot shows the two manga credits.', 'C', 'shots/boot_with_corocoro_tag.png shots/boot_normal.png')
add('A05', GA, 'CoroCoro stamps: 10 stamps + category icon', 'Ten stamps and the icon, located after the Pokémon stamps', [Rl(0x2B, 0x4000, 10 * 0x1E0)], 'data', 'stamp table 04:5337 (category 3 = 2B:4000, 10 stamps of 5x6 tiles)', 'RETRIEVED. The whole category is skipped unless $D582 = 1 (04:59AB-59D0).', 'C', 'assets/stamps_rom/sheet_cat3_corocoro.png shots/stamps_category3_corocoro.png')
add('A06', GA, 'Wild frames 07 and 08', '"Wild Frames" 07 and 08, selectable while printing a photo', [FO(0xC4000 + 6 * 0x1800, 2 * 0x1800)], 'data', 'ROM tiles (20 tiles wide) + emulator', 'RETRIEVED: 07 = CoroCoro "おっぱ…" manga frame, 08 = Bakusou Kyoudai Let\'s & Go!! MAX frame. Page count of the wild-frame screen is 6, or 8 with $D582 (08:52E0-52E7).', 'C', 'assets/wild_frames/wild_07_rom_0CD000_20x19tiles.png assets/wild_frames/wild_08_rom_0CE800_20x19tiles.png shots/wild_frames_01_08_corocoro_save.png')
add('A07', GA, 'Album B pictures B25-B30 (six CoroCoro pictures on page B4)', 'Six new photos can be accessed from Album B, after all the other B pictures on page B4',
    [FO(0xDA000 + 24 * 0x1000, 6 * 0x1000)], 'data', 'ROM (128x112 2bpp at 0xDA000 + i*0x1000) + CoroCoro-tag save', 'RETRIEVED; organic with the tag.', 'C', 'assets/albumB/albumB_all.png shots/album_pages_A1_to_B4.png')
add('A08', GA, 'Album B pictures B01-B24 (stock; B17-B24 gated by the unlock counters)', 'Pre-loaded pictures (regional table in "Album B")',
    [FO(0xDA000, 24 * 0x1000)], 'data', 'ROM + unlocking save', 'RETRIEVED (30 PNG + thumbnails). B17-B24 = photo numbers $2E-$35; thresholds from the settings shadow $DA96-$DAAB (README §2 and §3.2).', 'C', 'assets/albumB/')
add('A09', GA, 'Pokémon stamps (category 2, 20 stamps)', 'First 10 stamps available from the start, last 10 unlocked by scoring 500 points in Ball',
    [Rl(0x2C, 0x6000, 20 * 0x190)], 'data', 'ROM table + code (04:5827-5832)', 'RETRIEVED (20). Unlock is gradual: page limit $D642 = min($DAA5, 5) + 4 ($DAA5 = hundreds byte of the Ball record, SRAM 10CA), so +1 page (2 stamps) per 100 points up to 500; TCRF end points (10 / 20) confirmed.', 'C', 'assets/stamps_rom/sheet_cat2_pokemon.png shots/stamps_category2_pokemon.png')
add('A10', GA, 'All 17 stamp categories (faces, kana, kanji, letters, symbols...)', 'Stamp differences (small faces, big stamps, symbols)', [R(0x2C, 0x4000, 0x7FFF), R(0x2D, 0x4000, 0x7FFF), R(0x2E, 0x4000, 0x7FFF), R(0x2F, 0x4000, 0x7FFF), R(0x30, 0x4000, 0x7FFF)], 'data', 'palette captures of every category (stamp_atlas.py)', 'RETRIEVED as screenshots (17 sheets).', 'C', 'assets/stamps/sheet_cat00.png ... sheet_cat16.png')
add('A11', GA, 'Photo frames No.01-18', 'Frames (Normal)', [R(0x34, 0x4000, 0x7FFF), R(0x35, 0x4000, 0x7FFF)], 'data', 'frame chooser (mode $09 state 9, frame_atlas.py)', 'RETRIEVED: 18 borders; the chooser has no hidden number beyond 18.', 'C', 'assets/frames/sheet_frames_all.png')
add('A12', GA, 'Wild frames 01-06', 'Tall frames that can only be selected when printing a picture', [FO(0xC4000, 6 * 0x1800)], 'data', 'ROM tiles + emulator', 'RETRIEVED: 01 Mario & Luigi, 02 Pokémon (Red on a bicycle), 03 Pocket Camera logo, 04 Yoshi, 05 Pokémon (Blastoise), 06 Pokémon (Pikachu & Clefairy).', 'C', 'assets/wild_frames/ shots/wild_frames_normal_save_only_01_06.png')
add('A13', GA, 'Space Fever II unlocks: D.J. (mode $1F)', 'Games; D.J. selectable after beating bosses', [R(5, 0x4000, 0x74CB)], 'code', 'emulator (shot target selects the game: 07:5AFA)', 'EXECUTED (mode $1F, 05:4000-74CB). Every byte of the range is executed or read (the non-executed share is tables).', 'C (selection) / I (game name)', 'work/dj_atlas/')
add('A14', GA, 'Ball (mode $20)', 'Ball = remake of the Game & Watch game', [R(5, 0x74CC, 0x7FFF)], 'code', 'emulator', 'EXECUTED organically.', 'C (code) / I (name)', '')
add('A15', GA, 'Run!Run!Run! (mode $21)', 'Unlockable button-masher: bird vs mole', [R(9, 0x5FE3, 0x7FFF)], 'code', 'emulator', 'EXECUTED (09:5FE3-7FFF); only 45 % of the bytes are executed instructions, the remainder are tables read as data (100 % executed-or-read); organic coverage of the executed part is low (31 %), so some states of this game were only reached by forced runs.', 'C (code) / I (name)', '')
add('A16', GA, 'Erase-all-saved-data screen', 'Hold Select and Start upon booting for a menu to delete all SRAM; A to confirm, B to cancel', [Rl(0x0F, 0x7B00, 0x500), Rl(0x25, 0x7A60, 0x240)], 'data', 'catalog (09:5F54) + screenshot', 'EXECUTED at boot with Select+Start; screenshot composed from the ROM blocks.', 'C', 'assets/screens/09_jr_009_5f54_map9800_src25_7a60.png')
# =========================================================================== B
add('B01', GB, 'Title-music Game Genie codes (JP ??3-B48-E6E, ??4-388-E6E)', 'Replace the title screen music with the value of "??"', [Rl(8, 0x73B4, 3), Rl(8, 0x7438, 3)], 'code', 'GG decode + ROM bytes', 'VERIFIED: the patched byte is the operand of `ld a,$01 ; call $2a88` at 08:73B4 and 08:7438 (song request 1).', 'C', '')
add('B02', GB, 'Song 0x31: two beeps in the prelude', 'The prelude has two subtle beeping noises that are never heard in normal play', [Rl(0x1F, 0x7321, 179)], 'data', 'song table 1F:57C6', 'Song data fully read (caller 07:557C). The audible beeps are not re-checked by ear.', 'C / ?', '')
add('B03', GB, 'Song 0x45: photo-deletion music lasts 0.9 s longer than heard', 'Plays endlessly with the codes', [Rl(0x1F, 0x5A96, 137)], 'data', 'song table', 'Song fully read (caller 04:5047); the 0.9 s is not measured.', 'C / ?', '')
add('B04', GB, 'Songs 0x01 and 0x1E: same title music', 'May be exactly the same song', [Rl(0x1F, 0x6874, 460)], 'data', 'song table', 'The two table entries hold the SAME pointer ($6874): identical data. Boot uses 0x01 (08:73B5, 08:7439).', 'C', '')
add('B05', GB, 'Hot-spot effect icons (8 extra) and GG 0FD-199-F76 (JP)', 'Eight additional icons, only two with unique effects; "S" icon = wave, the rest = quick page flip', [R(0x1C, 0x58A0, 0x5C9F), R(3, 0x655D, 0x69F4)], 'data', 'tiles 1C:58A0-5C9F + dispatch table 03:655D', 'GG verified: raises `ld d,$07` (03:6D18) to $0F. The table at 03:655D has 17 entries (index = effect + 1): effects 0-7 have eight distinct handlers (03:6642, 66AF, 66DC, 67D5, 6801, 6838, 68A4, 6901) and effects 8-15 ALL point to 03:6983, one raster routine that never tests the effect number, so the TCRF claim "S icon = wave, the rest = page flip" is not visible in the code (?). Re-run with an armed hot spot (WRAM poke of D643-D65C) and a real A press: effects 0-8 each executed their handler (tools/hotspot_effects.py); none of them ran in the v8 organic runs because the pointer never sat on an armed hot spot (03:6450 hit path: forced only). Icons rendered.', 'C / ?', 'assets/hotspot/')
add('B06', GB, 'Unused G letter and hand animation in the album tiles', 'Unused G letter and hand animation', [Rl(0x13, 0x5810, 0x20), R(0x13, 0x5C00, 0x5F9F)], 'data', 'tile render (rendered sheet)', 'LOCATED: letters "B G" at 13:5810, hand gestures at 13:5C00-5F9F (read as a block by the album loader; the extra frames are never displayed).', 'I', 'assets/unused/located_items.png')
add('B07', GB, 'Unused B film roll in print + unused Japanese text', 'Film roll suggesting printing B photos with margin', [Rl(0x18, 0x5990, 0x20), Rl(0x18, 0x5A50, 0x60), Rl(0x18, 0x5C70, 0xA0), Rl(0x18, 0x5F90, 0xC0)], 'data', 'tile render + catalog (08:484B)', 'LOCATED: film strip with a B at 18:5A50, digits 0-9 at 18:5C70, outlined text at 18:5F90.', 'I', 'assets/unused/located_items.png')
add('B08', GB, 'Two unused main-menu tiles; JP-only unknown tile', 'Two unused tiles in the main-menu bank; an unknown tile found only in the Japanese version', [Rl(0x15, 0x4480, 0x100)], 'data', 'tile render', 'JP-only tile = a circled X, with three identical copies at 15:4480 / 4500 / 4580 (loaded, never shown) (I). The two placeholder tiles: only candidates (?).', 'I / ?', 'assets/unused/located_items.png')
add('B09', GB, '"Cannot combine same picture" graphic', 'In both versions; the Compose option rejects combining a picture with itself', [Rl(0x0D, 0x4000, 0x40), Rl(0x0D, 0x4050, 0xE0), Rl(0x0D, 0x4140, 0x120)], 'data', 'tile render', 'LOCATED at 0D:4000-425F (white-on-black Japanese text, never displayed). The exact words are not reliably readable from my render (?).', 'I', 'assets/unused/located_items.png')
add('B10', GB, 'Four kanji 中 / 前 / 後 / 持', '"Middle", "Before", "After", "Have": the middle two reappear later with the hot-spot graphics', [Rl(0x1C, 0x54A0, 0x60), Rl(0x1C, 0x55A0, 0x60)], 'data', 'tile render', '前 and 後 located at 1C:54A0-55FF (next to an OK tile); 中 and 持 NOT located (?).', 'I / ?', 'assets/unused/located_items.png')
add('B11', GB, 'Unused icon and tile in the photo-option bank; "B CANCEL"', 'An unused icon and tile in the photo option bank', [Rl(0x0C, 0x7A20, 0x20), Rl(0x0C, 0x7A60, 0x70)], 'data', 'tile render', 'Candidates only: circled B at 0C:7A20, a short lettering strip at 0C:7A60. The unused icon and tile themselves: not identified (?).', 'I / ?', 'assets/unused/located_items.png')
add('B12', GB, 'Poorly drawn X after the Magic menu graphics', 'Only present in the international release', [], 'data', 'JP ROM', 'Not expected in the JP ROM; the circled X at 15:4480 is another thing.', '?', '')
add('B13', GB, 'Several unused hand gestures along the album bank selection hands', 'Unused hand gestures', [R(0x13, 0x5C00, 0x5F9F)], 'data', 'tile render', 'See B06.', 'I', 'assets/unused/located_items.png')
add('B14', GB, 'D.J.: unknown tile that looks like katakana め', 'Unknown tile in the DJ minigame', [], 'data', 'census', 'NOT located (?).', '?', '')
add('B15', GB, 'Printer: wave pattern that does not print with the song data', 'Wave pattern', [], 'data', 'census', 'NOT located (?).', '?', '')
add('B16', GB, 'Unused Graphic Bank 11: hand flipping through a newspaper', 'Completely unused graphic bank', [], 'data', 'bank views (2bpp and 4bpp) + coverage', 'NOT located. Bank $0B holds the Super Game Boy data (never-read tail 0B:42C6-4897 etc.); in 2bpp and 4bpp views it looks like border tile data, not a picture; bank $11 is fully read. Which bank TCRF means by "11" is unresolved (?).', '?', '')
add('B17', GB, 'Erase All Saved Data? screen', 'Text caption for deleting all saved data "and more"', [Rl(0x0F, 0x7B00, 0x500)], 'data', 'same as A16', 'The JP caption is a live screen. The "and more" is not identified (?).', 'C / ?', 'assets/screens/09_jr_009_5f54_map9800_src25_7a60.png')
add('B18', GB, 'R!R!R! star (candidate from my census)', '-', [], 'data', 'census', 'NOT located. 21:4AC0 is the circled-X tile, not a star.', '?', '')
# =========================================================================== C
add('C01', GC, 'Boot/title (name and dancing Mario changed in intl.)', 'Name and dancing Mario changed for the international releases', [R(8, 0x723E, 0x7600)], 'code', 'screenshots', 'EXECUTED (boot logo, Pocket Camera title).', 'C', 'shots/boot_normal.png')
add('C02', GC, 'Main menu: Pocket Camera logo, speech bubbles, みる / とる order', 'Logo removed, SHOOT/VIEW swapped, no bubbles in intl.', [R(7, 0x71AF, 0x7800)], 'code', 'atlas', 'EXECUTED; main-menu screenshots 00:01-00:07.', 'C', 'work/atlas_modes/sheet_00.png')
add('C03', GC, '"SPORADIC VACUUM" lettering on the View screen', 'Developer nickname removed from intl.', [R(0x12, 0x7400, 0x75FF)], 'data', 'atlas 02:xx', 'The View screen band is garbled in my core; 12:7400-75FF is a candidate only (?; possible core tile-streaming bug).', '?', 'work/atlas_modes/sheet_00.png')
add('C04', GC, 'Owner screen "OWNER NAME", user ID PC-xxxxxxxx + blood type, REPORT, SCORE', 'OWNER NAME -> USER NAME, REPORT -> RECORD, SCORE -> HI-SCORE, PC- -> GC-, JP records the blood type', [R(9, 0x4883, 0x5200)], 'code', 'atlas 08:01-08:10', 'EXECUTED; seen: OWNER NAME, PC-00912730, blood type entry, REPORT (5 counters), SCORE (S.F.HI-SCORE / BALL HI-SCORE / RUN!RUN!RUN! 99:99). The "STAFF ROLL" label was not seen in my screenshots (?).', 'C / ?', 'work/atlas_modes/sheet_01.png')
add('C05', GC, 'ACCESS menu (JP anime art; LINK in intl.)', 'Menu completely changed in intl.; ACCESS -> LINK', [], 'code', 'atlas 06:01', 'Seen: "ACCESS", castle and プリント / こうかん bubbles.', 'C', 'work/atlas_modes/sheet_01.png')
add('C06', GC, 'Printer syringe image', 'Syringe changed to a Game Boy Printer image', [], 'data', 'screens', 'Not individually identified among my composed screens (?).', '?', '')
add('C07', GC, 'Print-option text (LINE/PHOTOS, POCKET PRINTER, CANCEL, margin, TOTAL)', 'Texts edited in intl.', [], 'data', 'composed screen 08:484B', 'Composed screen retrieved; individual JP words are not transcribed (I).', 'I', 'assets/screens/08_Call_008_484b_map9800_src26_57c0.png')
add('C08', GC, 'Printing screen: big "Love" + タマノリブー', '"Love" graphic and Tamanoripu name removed in intl.', [Rl(0x1B, 0x7100, 0x800), Rl(0x1B, 0x7900, 0x650), Rl(0x26, 0x5C40, 0x240)], 'data', 'composed screen 00:3391', 'RETRIEVED. The screen only runs while printing; "forced-only" describes my runs, not reachability.', 'C', 'assets/screens/00_jr_000_3391_map9800_src26_5c40.png')
add('C09', GC, 'Transfer stand-by: inverted ukiyo-e + "アイデアがいっぱい" + first Nintendo logo', 'Intl: Peach and Wario (Mario Kart 64)', [Rl(0x15, 0x6C00, 0x800), Rl(0x15, 0x7400, 0x700), Rl(0x15, 0x7C00, 0x400), Rl(0x24, 0x5180, 0x240)], 'data', 'composed screen 07:44F4 / 07:4645', 'RETRIEVED. The "データ転送中" TV (00:305F) is a second screen of the link transfer.', 'C', 'assets/screens/07_Call_007_4645_map9800_src24_5180.png assets/screens/00_Jump_000_305f_map9800_src25_63e0.png')
add('C10', GC, 'Special menu: ピクトリップ / ごうせい with stone lantern and doll "Happy?"', 'Menu image changed to Mario in a kart; PICTRIP -> HOT-SPOT; Compose', [], 'code', 'atlas 03:01', 'Seen on the screenshot of mode 03 state 01 (lantern, doll, ごうせい).', 'C', 'work/atlas_modes/sheet_00.png')
add('C11', GC, 'Pre-loaded Album B pictures (Hanafuda art, Midsummer/Congratulations, "Please wait", girl and rabbit phone, "What the...?!", Judge, Tamanoripu, Pokémon x3)', 'Rearranged for intl.; JP exclusives listed', [FO(0xDA000, 24 * 0x1000)], 'data', 'ROM', 'All present among B01-B30: B07 おめでとう/暑中お見舞い, B08 しばらくお待ち下さい, B11 girl and rabbit, B12 なんと…, B17 Judge, B19 Tamanoripu, B22-B24 Pokémon.', 'C', 'assets/albumB/albumB_all.png')
add('C12', GC, 'D.J. screen text (JP "TRIPY-H", "FEQ.")', 'Intl: TRIPPY-H, FRQ.', [], 'data', 'atlas 05:xx', 'The D.J. screens are captured; the exact JP strings are not transcribed yet (?).', '?', 'work/dj_atlas/')
add('C13', GC, 'Pokémon frames (JP wild frames 02, 05, 06)', 'Red on a bicycle, Blastoise, Pikachu & Clefairy (intl: replaced)', [FO(0xC4000 + 0x1800, 0x1800), FO(0xC4000 + 4 * 0x1800, 2 * 0x1800)], 'data', 'ROM', 'RETRIEVED: wild frames 02, 05, 06.', 'C', 'assets/wild_frames/')
add('C14', GC, 'Stamps: JP symbols 〒 / $ / ¥ / ☎ and the particles / pointing glove / check / "look!" stamps', 'Intl removed 〒 and ¥ (added ¢ £), and replaced four stamps by faces + ©', [], 'data', 'stamp category 16 (stamp_atlas.py)', 'Seen in category 16 (zero-based cursor index): items 16-19 = 〒 $ ¥ ☎; items 45-48 = particles, pointing glove, check, look-look (visual match).', 'I', 'assets/stamps/sheet_cat16.png')
add('C15', GC, 'Hot-spot (PICTRIP) editor header', 'PICTRIP -> HOT-SPOT', [], 'data', 'composed screen 03:6A4C', 'JP header "ピクトリップ" seen.', 'C', 'assets/screens/03_jr_003_6a4c_map9800_src24_6620.png')
add('C16', GC, 'Hot-spot: B pressed during a song keeps the music playing (JP only)', 'The music keeps playing outside the hot-spot menu in JP', [], 'code', '-', 'NOT examined: needs a sound-state trace (?).', '?', '')
add('C17', GC, 'Hot-spot on Album B pictures: only the exit menu', 'GameShark 01?? D8D5 ID 1E-3B', [Rl(4, 0x408F, 0x40)], 'code', 'WRAM map', '$D5D8 is the album photo index; stock pictures are >= $1E (many `cp $1E` in bank 4); the code `D8D5` = address $D5D8 (C). The exit-only menu itself: not re-traced (?).', 'C / ?', '')
add('C18', GC, 'Error faces', 'Two of the three faces changed in intl.', [], 'data', 'atlas 09:0C', 'Two faces seen (mustache, 09:0C); the third is not identified (?).', 'C / ?', 'work/atlas_modes/sheet_02.png')
add('C19', GC, 'Credits intro animation (JP: dancer; intl: scenes from Sheriff)', 'Changed for the international versions', [], 'code', 'atlas 08:17', 'JP shows a dancer (credits_normal_dancer.png). A comparison with the international ROM is not possible here.', 'C', 'shots/credits_normal_dancer.png')
add('C20', GC, 'Super Game Boy border (Pocket Camera logo)', 'Logo changed accordingly', [R(0x0B, 0x4000, 0x7FFF)], 'data', 'screenshot', 'SGB data bank 0B; the tail never read is border tile data that my core does not request without a full SGB handshake.', 'C / I', 'shots/sgb_border_jp.png')
rows = []
for (iid, g, item, tc, rng, kind, meth, ver, tag, asset) in I:
    st, n, pt, po, pr = cov(rng, kind) if rng else ('n/a', 0, 0, 0, 0)
    asset = ' '.join(os.path.normpath(t) for t in asset.split())
    rows.append(dict(id=iid, group=g, item=item, tcrf=tc, rom=loc(rng) if rng else '-', bytes=n, coverage=st, touched_pct='%.0f' % pt if n else '', organic_pct='%.0f' % po if n else '', exec_or_read_pct='%.0f' % pr if n else '', kind=kind, method=meth, verdict=ver, tag=tag, asset=asset))
with open(sys.argv[3], 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()), lineterminator='\n'); w.writeheader(); [w.writerow(r) for r in rows]
with open(sys.argv[2], 'w', encoding='utf-8', newline='\n') as f:
    f.write('# TCRF documented content, checked against the Japanese Pocket Camera ROM (md5 fdcfe686cf4df461e870b6e53b2b5a8b)\n\n')
    f.write('AI slop, do not trust until human validation.\n\n')
    f.write('* **TCRF says** paraphrases the OCR of the TCRF PDFs you supplied (`tcrf/t1-*.txt`, `t2-*.txt`).\n')
    f.write('* **Coverage** comes from the merged run v8 (`coverage_run/merged_v8/cov.npz`): *touched* = executed (code) or read (data) in any run, *organic* = in runs driven by the joypad and an SRAM image only. "forced-only" / "never touched" describe MY runs, not the console.\n')
    f.write('* **Tags**: C = code/data traced or seen on a screenshot of the ROM; I = inferred (visual or structural match); ? = inconclusive or not located (never guessed).\n')
    f.write('* Asset paths are relative to `tcrf_check/` (`work/` = the working directory of the census, atlas and DJ captures).\n')
    cur = None
    for r in rows:
        if r['group'] != cur:
            cur = r['group']; f.write('\n## %s\n\n| id | item (TCRF says) | ROM location | coverage touched / organic | finding | tag | assets |\n|---|---|---|---|---|---|---|\n' % cur)
        cv = ('%s (%s%% / %s%%, %d B)' % (r['coverage'], r['touched_pct'], r['organic_pct'], r['bytes'])) if r['bytes'] else r['coverage']
        if r['bytes'] and r['kind'] == 'code': cv += '<br>executed share; executed-or-read: %s%%' % r['exec_or_read_pct']
        f.write('| %s | **%s**<br>_%s_ | %s | %s | %s | %s | %s |\n' % (r['id'], r['item'].replace('|', '/'), r['tcrf'].replace('|', '/'), r['rom'], cv, r['verdict'].replace('|', '/'), r['tag'], r['asset'].replace('|', '/')))
    c = Counter()
    for r in rows:
        tg = r['tag']
        c['located / traced (C)' if tg.startswith('C') and '?' not in tg else ('inferred (I)' if tg.startswith('I') and '?' not in tg else 'with an open point (?)')] += 1
    f.write('\n## Summary\n\n' + ' · '.join('%s: %d' % kv for kv in sorted(c.items())) + ' (of %d items)\n' % len(rows))
print(len(rows), 'items', dict(c))
