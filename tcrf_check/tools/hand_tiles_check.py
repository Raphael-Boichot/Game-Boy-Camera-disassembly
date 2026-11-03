#!/usr/bin/env python3
"""Are the six tiles at 13:5CA0-5CF0 (the TCRF "unused album hand gestures", label Unused_TCRF_AlbumHandGestures_Gfx) ever DRAWN?  README 16.24 / checklist B06, B13.

The album loaders (PhotoPicker_Init 04:400A, Mode0F_State01_ReInit, LinkPick_Substate0_Init, ...) copy the whole sheet 13:5800-67FF to VRAM $8000, so the six tiles sit in the VRAM slots
$4A-$4F whenever one of those screens is up (loading is C).  Loading does not say whether anything draws them, so this script replays the cheapest organic corpus entry of a list of
(mode, state) screens in the real BGB (tcrf_check/tools/bgbgrab.py), at three instants after the entry (+0, +15 and +45 frames of no key), reads BGB's state file and reports, per sample:
  - the VRAM slots that hold the 16 bytes of one of the six ROM tiles ("loaded");
  - the OBJ entries of OAM and the BG / window map cells that use one of those slots ("drawn"; an 8 x 8 or 8 x 16 OBJ is split, the BG tile base follows LCDC bit 4);
  - for every OBJ entry, the ROM address inside the sheet 13:5800-67FF of the tile it shows (so one sees which tiles the hand sprite really uses).
usage: hand_tiles_check.py OUT.csv [BGB_DIR] [MODE,STATE ...]      (GBCAM_ROOT = the working root of README 16.15, GBCAM_ROM; BGB_DIR is copied if it does not exist)
default screens: the five (mode, state) that load the sheet in the organic corpus (15,2) (15,3) (15,12) (15,13) (16,1)."""
import sys, os, csv, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
out = sys.argv[1]; bgbdir = sys.argv[2] if len(sys.argv) > 2 else '/home/claude/bgbq5'
sigs = [tuple(int(x) for x in s.split(',')) for s in sys.argv[3:]] or [(15, 2), (15, 3), (15, 12), (15, 13), (16, 1)]
import bgbgrab as B, bgb_run
rom = open(os.environ.get('GBCAM_ROM', B.ROOT + '/pocketcamera_jp.gb'), 'rb').read()
def tile(b, a): o = b * 0x4000 + (a - 0x4000); return rom[o:o + 16]
SIX = [tile(0x13, 0x5CA0 + 16 * k) for k in range(6)]
SHEET = {}
for a in range(0x5800, 0x6800, 16): SHEET.setdefault(tile(0x13, a), []).append(a)
rows = []
for sig in sigs:
    i, sp, seq, sav = B.entry(sig)
    for extra in (0, 15, 45):
        r = B.grab(os.path.splitext(out)[0] + '_%d_%d_%d' % (sig + (extra,)), sp, sav, seq + ([('-', 1, extra)] if extra else []), bgbdir=bgbdir)
        st = bgb_run.read_state(r['state_file']); V = st['VRAM']; O = st['OAM']; L = st['LCDC'][0]; big = bool(L & 4)
        slots = [s for s in range(384) if V[s * 16:s * 16 + 16] in SIX]
        obj = []; shown = []
        for n in range(40):
            y, x, t, a = O[4 * n:4 * n + 4]
            if y == 0 or y >= 160 or x == 0 or x >= 168: continue
            for k, tt in enumerate([t & 0xFE, t | 1] if big else [t]):
                v = bytes(V[tt * 16:tt * 16 + 16])
                shown.append((tt, ['13:%04X' % z for z in SHEET.get(v, [])]))
                if tt in slots: obj.append((n, x - 8, y - 16 + 8 * k, tt))
        bg = []
        for base in (0x1800, 0x1C00):
            for c in range(1024):
                idx = V[base + c]; slot = idx if (L & 0x10) else (256 + idx if idx < 128 else idx)
                if slot in slots: bg.append((base, c % 32, c // 32))
        sheet_in_use = sorted(set(z for _, zs in shown for z in zs))
        row = dict(mode=sig[0], state=sig[1], extra=extra, got='%d/%d' % (st['WRAM'][0x15CE], st['WRAM'][0x15CF]), lcdc='%02X' % L,
                   six_slots_loaded=' '.join('%X' % s for s in slots), obj_using_them=len(obj), bg_cells_using_them=len(bg), obj_entries=len(shown),
                   sheet_tiles_shown=' '.join(sheet_in_use))
        print(json.dumps(row), flush=True); rows.append(row)
with open(out, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0]), lineterminator='\n'); w.writeheader(); w.writerows(rows)
print('->', out)
