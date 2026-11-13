#!/usr/bin/env python3
"""Hello Kitty Pocket Camera: a verdict on every never-run piece of trace/red_kitty.csv (roadmap step 9, 2026-11-13).

  tools/kitty_red_verdicts.py [--check]          writes roms/hello_kitty/trace/red_verdicts_kitty.csv

One row per piece (bank, start, end), with a class and the reason, by the rules below in order (first match wins; the owner
is the routine the piece lies in, the gate owner the routine of the branch it hangs on):

  UNREACHABLE  (purple on the reachability map) proven by the code, or by the runs and the code together:
               - the state handlers of the ten modes that nothing enters ($13, $15-$1D: no code stores one of them as a
                 constant outside its own state $00, README "The modes seen only by forcing"), and the routines named
                 Unused_* (settled unused, L3 doubts list);
               - the "no slot for this photo number" branches (Photos_LoadPage8, Photo_LoadEmptyThumb,
                 Photo_LoadEmptyPicture, behind a failed Photo_FindSlotA): the album keeps its numbers compact (deleting
                 photo 01 of two renumbers the other, BGB 2026-11-12), evidence I;
  LINK         needs something of the link partner the ten BGB exchanges did not do (modes $07-$09, Link_*, Exchange_*,
               the counters and card stats of a received photo, and what hangs behind them);
  SENSOR       a branch on the sensor's picture (Cam_*, the camera states of modes $02 and $11): another light level;
  PRINTER      a branch on the printer's replies or on a print frame's descriptors (Prn_*, Mode06_*, Mode1D_*, PrintGame_*);
  SGB          a Super Game Boy feature the SGB runs did not use (Sgb_*);
  SAVE         needs another save (the Kitt payments of the games with too few Kitts);
  SOUND        a track opcode or branch not met in the first 300 frames of every song and effect id;
  GAME         an outcome of a Kitt game the runs did not produce;
  ARGS         a path of a shared helper for an argument no caller passed in the runs;
  INPUT        a menu value, card field or key sequence the runs did not use;
  OPEN         not examined yet.
Only UNREACHABLE is drawn purple; the other classes stay red, with their reason.
"""
import sys, os, csv, re, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE); P = os.path.join(REPO, 'roms', 'hello_kitty', 'trace')
ap = argparse.ArgumentParser(); ap.add_argument('--check', action='store_true'); a = ap.parse_args()
NOSLOT = {'05:7060', '05:716C', '05:6C0A', '05:738C', '05:73FD', '05:6045', '06:67CA', '07:4A44'}   # pieces after the six callers' jr c (hand, 2026-11-13)
DEAD_MODES = r'Mode(13|15|16|17|18|19|1A|1B|1C)_(State|FadeOut)'
RULES = [
    ('UNREACHABLE', 'C', lambda o, g: re.match(DEAD_MODES, o) or re.match(DEAD_MODES, g),
     'a state of a mode that nothing enters ($13, $15-$1D: no code stores it as a constant outside its own state $00; README, "The modes seen only by forcing")'),
    ('UNREACHABLE', 'C', lambda o, g: o.startswith('Unused_') or g.startswith('Unused_'), 'in or behind a routine settled unused (L3 doubts list)'),
    ('UNREACHABLE', 'I', lambda o, g: KEY in NOSLOT, 'a jr c after Photo_FindSlotA (01:4D81) failed: a photo number with no slot; the album keeps its numbers compact (BGB 2026-11-12); shown only with Photo_FindSlotA patched'),
    ('UNREACHABLE', 'I', lambda o, g: o in ('Photos_LoadPage8', 'Photo_LoadEmptyThumb', 'Photo_LoadEmptyPicture') or g in ('Photos_LoadPage8', 'Album_ObjLoadSlot'),
     'the branch for a photo number with no slot (Photo_FindSlotA fails): the album keeps its numbers compact (BGB 2026-11-12: deleting photo 01 of two renumbers the other); shown only with Photo_FindSlotA patched'),
    # the Japanese verdicts of the same code (cross-check of 2026-11-13, trace/jp_crosscheck_kitty.csv)
    ('UNREACHABLE', 'I', lambda o, g: o == 'Prn_SendInquiry', 'same code as the Japanese Prn_SendInquiry (00:1B25 / 1B36), a desperate case of docs §16.21: its only caller, the idle poll at 00:0D7A, tests $DD0C = 1 and $DD3A = 0 itself before the call, which are the two conditions that lead here; only a serial interrupt between the test and the entry could'),
    ('UNREACHABLE', 'I', lambda o, g: o == 'Img_ReduceToThumbnail' and KEY == '00:25AD', 'the ROM-source branch (source below $A000), as the Japanese 00:258F (docs §16.21): the only caller, Photo_MakeThumbnail (call at 00:2A9E), passes the table 00:2AB6 whose source is $C000 (WRAM)'),
    ('PRINTER', 'I', lambda o, g: o.startswith('Mode1D_') and not o.startswith('Mode1D_State'), 'a band descriptor flag (bit 3, 4 or 5) that only the Japanese layout prints of mode $1D used (bit 4 only in Print_Layout3_FourPhotosRotated, 08:656E; BGB 2026-10-25); the Kitty mode $1D goes back to mode $01 at once, the layout scripts are not in this ROM, and none of the Kitty prints (mode $06, all six frames and the wild frames) built such a descriptor'),
    ('SOUND', 'I', lambda o, g: o == 'Snd_Sfx_Start', 'same code as the Japanese 1F:522A / 1F:5234 (the channel-3 flush of the sound set-up and its default exit), a desperate case of docs §16.21: never reached there by 504 mailbox and 1,020 port trials'),
    ('LINK', 'I', lambda o, g: GATE == '06:6ACF' or KEY == '06:6ACF', 'behind the wait of Mode09_State0B on $DD4E, which only Link_Irq_HalfDone sets: the end of an 8-page ($800-byte) transfer, asked by a command with bit 7 (Exchange_RequestPage, 06:60CB; length $08 at 00:142B / 00:1453); in BGB the request is sent (both units on receive, exchange2_both_take, 13 linked runs in all) but no partner serves it, and the waiting side leaves on its $B4-frame countdown to print error 14:01'),
    ('LINK', 'I', lambda o, g: re.match(r'(Mode0[789]_|Link_|Exchange_|Counters_AddReceived|CardStats_|KeyPrompt_LoadSoundsB|FrameRec_LoadTilesScreenOff)', o) or re.match(r'(Mode0[789]_|Link_|Exchange_)', g),
     'the exchange: a reply or a command of the partner that the ten BGB exchanges of 2026-11-13 did not send'),
    ('SENSOR', 'I', lambda o, g: re.match(r'(Cam_|Mode02_State0[CDE]|Mode11_State0E)', o) or g.startswith('Cam_'), 'a branch on the sensor picture: another light level than the runs saw; the fake-light runs of tools/kitty_forced_runs.py (a byte plane written over SRAM $A000-$AEFF every frame, 2026-11-13) move the exposure ($DA17-$DA18) but leave the gain band $DA08 at 5, so the bands $08 / $0A (Cam_MainDispatch_Band3 / 4) and their neighbours stay unrun'),
    ('PRINTER', 'I', lambda o, g: re.match(r'(Prn_|Mode06_|Mode1D_|PrintGame_|Print)', o) or re.match(r'(Prn_|Mode06_|Mode1D_)', g), 'a branch on the printer replies or on a print frame descriptor that the prints did not produce'),
    ('UNREACHABLE', 'C', lambda o, g: o == 'VramQueue_Run', 'the VRAM queue at $D700 is always empty: the three stores to its count $D881 store 0 (00:17CB, 00:1872, 00:1B4C) and no other code names $D881 or $D700'),
    ('UNREACHABLE', 'I', lambda o, g: o == 'Vec_Joypad' or g == 'Vec_Joypad', 'the joypad interrupt: never raised in the runs, its bit apparently never set in IE'),
    ('SGB', 'I', lambda o, g: o.startswith('Sgb_'), 'a Super Game Boy path the SGB runs did not take'),
    ('SOUND', 'I', lambda o, g: o.startswith(('Snd_', 'Sfx')), 'a track opcode or branch that the first 300 frames of each song and effect id (all requested, tools/kitty_forced_runs.py) did not meet'),
    ('GAME', 'I', lambda o, g: not o.startswith('KittHost_Pay') and re.match(r'(Puzzle15_|Scratch_|KittHost_|Mode0E_|Mode0F_|Mode10_|RecordBook_)', o), 'an outcome of a Kitt game the runs did not produce (a solved puzzle, a prize, a record)'),
    ('ARGS', 'I', lambda o, g: re.match(r'(Vram_|Copy_|Call_DE|Rst18_|Bcd_|Bin_ToBcd|Digits_|Delay_Frames|Object_|Objects_|Img_ReduceToThumbnail|Text_CopyBigLineVram|ScriptSlots_Add|Obj_SoundCh1|ObjCmd_SoundCh1|ScriptCmd_SoundCh1|KeyPrompt_SoundCh1|Rng_Init)', o),
     'a path of a shared helper for an argument or a table entry that no caller passed in the runs (a short length, a digit value, a sound channel command)'),
    ('INPUT', 'I', lambda o, g: re.match(r'(IdCard_|NameCardEdit_|Stamp_|Album|Photo_DrawNumber|TakePhotos_|CameraFrame_|FrameCorner_|PhotoTrain_|Mode0[0-5BD]_|Mode11_)', o),
     'a menu value, a card field or a key sequence that the runs did not use'),
    ('LINK', 'I', lambda o, g: o.startswith('Counters_AddExchanged'), 'the counter of exchanged photos: after an exchange path the BGB exchanges did not finish'),
    ('SAVE', 'I', lambda o, g: o.startswith('KittHost_Pay'), 'the Kitt payment fails (a far call to 06:5B59 with the price returns carry): a save with fewer Kitts than the price; the runs start with 999,999 or 0 Kitts and do not open this game with 0'),
]
out = []
for r in csv.DictReader(open(os.path.join(P, 'red_kitty.csv'))):
    o, g = r['owner'], r['gate_owner'] or ''; KEY = '%s:%s' % (r['bank'], r['start']); GATE = r['gate']
    if r['class'] == 'BEHIND': g = r['gate_owner'] or r['gate_insn'].replace('behind ', '')
    for cls, ev, f, why in RULES:
        if f(o, g): break
    else: cls, ev, why = 'OPEN', '', 'not examined yet'
    out.append([r['bank'], r['start'], r['end'], cls, ev, why])
OUT = os.path.join(P, 'red_verdicts_kitty.csv')
txt = 'bank,start,end,class,evidence,verdict\n' + ''.join(','.join(x[:5]) + ',"%s"\n' % x[5] for x in out)
if a.check:
    if open(OUT).read() != txt: sys.exit('kitty_red_verdicts: trace/red_verdicts_kitty.csv is not what this tool writes today')
    print('kitty_red_verdicts: fresh'); sys.exit(0)
open(OUT, 'w').write(txt)
import collections
c = collections.Counter();
for x, r in zip(out, csv.DictReader(open(os.path.join(P, 'red_kitty.csv')))): c[x[3]] += int(r['bytes'])
print('kitty_red_verdicts: %d pieces: %s' % (len(out), ', '.join('%s %d' % kv for kv in c.most_common())))
