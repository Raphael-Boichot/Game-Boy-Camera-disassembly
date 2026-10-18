#!/usr/bin/env python3
"""BGB: copy the stock pictures B01-B21 into the A album with EDIT > ALBUM > COPY, then open the Comment screen of each copy in VIEW > ALBUM (README 16.27).
usage: bgb_albumb_comments.py OUTDIR      (run from anywhere; env GBCAM_ROM = the Japanese ROM, GBCAM_SAV = a save with all unlocked and 0 photos; BGB directories /home/claude/bgbq0, bgbq1 copied from /home/claude/bgbx)
Stage 1 copies B01-B08 (page 1), stage 2 B09-B21 (pages 2-3), both with the Japanese main-menu key paths of guide_nodes ('D s D A A A' = EDIT > ALBUM > the copy grid);
every A-album slot is then compared with the ROM slot Bnn (3,584 photo bytes, name F04-F0C and comment F15-F2F: equal) - stage 3 opens the Comment screen of copy n (mode 0A:0E, `$D5D8` = n-1)
and albumb_comments.py --check compares the screenshots with the bank-$2A glyphs.
Writes OUTDIR/screens/Bnn.png (160x144 BGB screenshots), OUTDIR/montage.png, OUTDIR/bgb_albumb_comments.csv (B, A slot, copy equal, BGB mode:state, D5D8, differing pixels)."""
import sys, os, csv, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROM = os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
SAV = os.environ.get('GBCAM_SAV', '/home/claude/gbcam_jp/saves_unl/GAMEBOYCAMERA_all_unlocked.sav')
out = os.path.abspath(sys.argv[1]); os.makedirs(out, exist_ok=True)
D0 = '/home/claude/bgbq0'
if not os.path.isdir(D0): shutil.copytree('/home/claude/bgbx', D0)
os.environ['BGB_DIR'] = D0
import bgb_run; bgb_run.BGB = D0
import guide_nodes as G, bgb_us_jp_job as J, albumb_comments as AC
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 150)
def seq(path): return [('A', 4, 200)] + [K(t) for t in G.tokens(path, 'L')]
rom = open(ROM, 'rb').read()
Bs = [rom[0xDA000 + i * 0x1000:0xDA000 + i * 0x1000 + 0xE00] for i in range(30)]
def slot_of(sram, slot): return sram[0x2000 + slot * 0x1000:0x2000 + (slot + 1) * 0x1000]
P1 = 'A R A D L L A R A R A D L L A R A R A'        # page of 8 cells: +0, +1, +4 (via D L), +3, ... (the order is checked by content below)
P3 = 'A R A D L L A R A R A'
# stage 1: B01-B08
os.makedirs(out + '/copy', exist_ok=True)
r1 = bgb_run.run(ROM, SAV, out + '/copy/stage1', seq('D s D A A A' + ' R' * 9 + ' ' + P1 + ' R'), combo=2, free=400, timeout=600, tail=2)
s1 = r1['st']['SRAM']; open(out + '/copy/stage1.sram', 'wb').write(s1)
print('stage 1: mode %02X:%02X, photos %d' % (r1['mode'], r1['state'], r1['st']['WRAM'][0xD561 - 0xC000]))
# stage 2: B09-B21 from the stage-1 album
r2 = bgb_run.run(ROM, out + '/copy/stage1.sram', out + '/copy/stage2', seq('D s D A A A' + ' R' * 11 + ' ' + P1 + ' R U U ' + P3), combo=2, free=400, timeout=800, tail=2)
s2 = r2['st']['SRAM']; open(out + '/copy/stage2.sram', 'wb').write(s2)
print('stage 2: mode %02X:%02X, photos %d' % (r2['mode'], r2['state'], r2['st']['WRAM'][0xD561 - 0xC000]))
rows = []; where = {}
for slot in range(21):
    sl = slot_of(s2, slot); m = [i + 1 for i, b in enumerate(Bs) if sl[:0xE00] == b]
    if m:
        n = m[0]; o = 0xDA000 + (n - 1) * 0x1000
        eq = sl[0xF04:0xF0D] == rom[o + 0xF04:o + 0xF0D] and sl[0xF15:0xF15 + 27] == rom[o + 0xF15:o + 0xF15 + 27]
        where.setdefault(n, (slot, eq))      # the first slot wins: an empty slot (slot 21) has the same photo bytes as the blank canvas B01
print('A slot of each copy:', {('B%02d' % n): v for n, v in sorted(where.items())})
assert sorted(where) == list(range(1, 22)) and all(eq for _, eq in where.values()), 'copies are not all there / not equal'
# stage 3: the Comment screen of the copy of Bn: VIEW > ALBUM, page p = n // 8 ('R' twice per page), cell c = n % 8 (VIEW grid: idx+0 is in column 2), then A A R D A
MV = ['', 'R', 'D L', 'D', 'D R', 'D D L', 'D D', 'D D R']
def vseq(slot):
    p, c = divmod(slot, 8)
    return 'V A A' + ' R' * (2 * p) + ' ' + MV[c] + ' A A R D A'
os.makedirs(out + '/screens_bmp', exist_ok=True)
jobs = [('B%02d' % n, ROM, out + '/copy/stage2.sram', seq(vseq(where[n][0])), out + '/screens_bmp', 2, 400, 2) for n in range(1, 22)]
res = J.run_jobs(jobs, 2)
rep = {n: (b, t) for n, b, t in AC.check(rom, out + '/screens_bmp')}
from PIL import Image
os.makedirs(out + '/screens', exist_ok=True)
with open(out + '/bgb_albumb_comments.csv', 'w', newline='') as fh:
    w = csv.writer(fh, lineterminator='\n'); w.writerow(['picture', 'a_album_slot', 'copy_equal', 'bgb_mode_state_d5d8', 'differing_pixels', 'compared_pixels'])
    for n in range(1, 22):
        Image.open('%s/screens_bmp/B%02d.bmp' % (out, n)).convert('RGB').save('%s/screens/B%02d.png' % (out, n))
        w.writerow(['B%02d' % n, where[n][0], where[n][1], (res.get('B%02d' % n) or '').split(' D63D')[0] + ' ' + (res.get('B%02d' % n) or '').split('D5D8=')[-1].split()[0], rep[n][0], rep[n][1]])
ims = [Image.open('%s/screens/B%02d.png' % (out, n)) for n in range(1, 22)]
W, H = ims[0].size; cols = 7
M = Image.new('RGB', (cols * (W + 4) - 4, 3 * (H + 4) - 4), 'white')
for i, im in enumerate(ims): M.paste(im, ((i % cols) * (W + 4), (i // cols) * (H + 4)))
M.save(out + '/montage.png')
print('pixel check: %s' % ('all 21 screens exact (0 differing pixels in 21 x 3,456)' if all(b == 0 for b, _ in rep.values()) else 'DIFFERENCES %r' % rep))
