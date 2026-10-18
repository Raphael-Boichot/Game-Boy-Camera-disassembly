#!/usr/bin/env python3
"""BGB: the SHOOT live view with each of the three dither variants D59C = 0 / 1 / 2 (README 18.12).
usage: bgb_dither_variants.py OUTDIR      (env GBCAM_ROM = the Japanese ROM, GBCAM_SAV = a valid save; BGB directory /home/claude/bgbq0 copied from /home/claude/bgbx)
The Japanese ROM has the three variants as: D59C = D7EA = 1 when mode $14 starts (06:5E3E), 2 for the trick lenses $0A / $0B and the Game Face ($15).  To see all three on the plain shot
(D7E3 = 0) the immediate of `ld a,$01` at 06:5E3F (flat 0x19E3F) is patched to 0, 1 (the original) and 2 in three copies of the ROM (the other bytes are untouched); the picture is BGB's fake sensor (README 18.9),
so this shows how the ROM's matrix is applied by BGB, not what a real scene looks like.  Writes OUTDIR/{flat,bayer,blocks}.png (160x144 BGB screenshots), OUTDIR/montage.png, OUTDIR/patched_rom_bytes.txt."""
import sys, os, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROM = os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
SAV = os.environ.get('GBCAM_SAV', '/home/claude/gbcam_jp/saves_unl/GAMEBOYCAMERA_all_unlocked.sav')
out = os.path.abspath(sys.argv[1]); os.makedirs(out, exist_ok=True)
D0 = '/home/claude/bgbq0'
if not os.path.isdir(D0): shutil.copytree('/home/claude/bgbx', D0)
os.environ['BGB_DIR'] = D0
import bgb_run; bgb_run.BGB = D0
import bgb_us_jp_job as J
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 200)
rom = bytearray(open(ROM, 'rb').read())
pat = bytes.fromhex('fe1528043e0118023e02eaead7ea9cd5'); i = bytes(rom).find(pat); assert i >= 0 and bytes(rom).count(pat) == 1
at = i + 5; assert rom[at] == 1
seq = [('A', 4, 200), K('A'), K('A'), ('-', 1, 600)]               # title, SHOOT (main menu), plain shot -> live view, wait
jobs = []; names = {0: 'flat', 1: 'bayer', 2: 'blocks'}
os.makedirs(out + '/bmp', exist_ok=True)
for v, nm in names.items():
    r = bytearray(rom); r[at] = v; p = '%s/rom_%s.gb' % (out, nm); open(p, 'wb').write(r)
    jobs.append((nm, p, SAV, seq, out + '/bmp', 2, 400, 2))
res = J.run_jobs(jobs, 2)
for nm in names.values(): print(nm, res.get(nm))
from PIL import Image
ims = []
for nm in names.values():
    im = Image.open('%s/bmp/%s.bmp' % (out, nm)).convert('RGB'); im.save('%s/%s.png' % (out, nm)); ims.append(im)
W, H = ims[0].size; M = Image.new('RGB', (3 * W * 3 + 16, H * 3), 'white')
for k, im in enumerate(ims): M.paste(im.resize((W * 3, H * 3), Image.NEAREST), (k * (W * 3 + 8), 0))
M.save(out + '/montage.png')
open(out + '/patched_rom_bytes.txt', 'w').write('flat 0x%X = 00 / bayer = 01 (original) / blocks = 02 (the byte after `3e` of `ld a,$01` in Mode14_State00_Init)\n' % at)
for nm in names.values(): os.remove('%s/rom_%s.gb' % (out, nm))
