#!/usr/bin/env python3
"""BGB: Trick Lens 9 (D7E3 = $0B) shows four half-size pictures, one per quadrant (README 18.12).
usage: bgb_lens9_quadrants.py OUTDIR      (env GBCAM_ROM / GBCAM_SAV as in bgb_dither_variants.py)
The plain shot's `Mode15_State00_ReturnToShoot` (06:4000, `xor a ; ld [$D7E3],a`) is patched to `ld a,$0B ; ld [$D7E3],a` (the later `ld a,0 ; ld [$D5CF],a` becomes `xor a ; ld [$D5CF],a` to keep the length; the rest of the ROM is untouched) so that the plain SHOOT item starts the live view with D7E3 = $0B.  Then A is pressed 0-3 times: in the live view of $0B / $0F / $15 an A press below the last phase only steps `$D7E4` (06:71E4), the last one takes the shot.
Dither: the default of mode $14 for $0B is $D59C = 2 (ramp B); the copy `ramp_A` patches that default to 1, `flat` to 0.
Writes OUTDIR/lens8_rampB.png (D7E3 = $0A: Trick Lens 8, the same half-size picture in all four quadrants), OUTDIR/{phase0,phase1,phase2,phase3}_rampB.png, phase3_rampA.png, phase3_flat.png (160x144 BGB screenshots) and OUTDIR/montage.png."""
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
rom = bytearray(open(ROM, 'rb').read()); b = bytes(rom)
old = bytes.fromhex('afeae3d73e14eaced53e00eacfd5c9'); i = b.find(old); assert i >= 0 and b.count(old) == 1
new = bytes.fromhex('3e0b' 'eae3d7' '3e14' 'eaced5' 'af' 'eacfd5' 'c9'); assert len(new) == len(old)
rom[i:i + len(old)] = new
pat = bytes.fromhex('fe1528043e0118023e02eaead7ea9cd5'); j = b.find(pat); assert j >= 0 and b.count(pat) == 1; at = j + 9; assert rom[at] == 2
live = [('A', 4, 200), K('A'), K('A'), ('-', 1, 400)]       # title, then two A (the first one after the title is lost in the menu fade-in, the second enters SHOOT: 14:01 in every run)
def seqn(n): return live + [K('A'), ('-', 1, 300)] * n
jobs = []
for tag, dv, n, v in (('lens8_rampB', 2, 0, 0x0A), ('phase0_rampB', 2, 0, 0x0B), ('phase1_rampB', 2, 1, 0x0B), ('phase2_rampB', 2, 2, 0x0B), ('phase3_rampB', 2, 3, 0x0B), ('phase3_rampA', 1, 3, 0x0B), ('phase3_flat', 0, 3, 0x0B)):
    r = bytearray(rom); r[at] = dv; r[i + 1] = v; p = '%s/rom_%s.gb' % (out, tag); open(p, 'wb').write(r)
    jobs.append((tag, p, SAV, seqn(n), out + '/bmp', 2, 400, 2))
res = J.run_jobs(jobs, 2)
from PIL import Image
tags = [t[0] for t in jobs]
for t in tags: print(t, res.get(t, '')[:30]); Image.open('%s/bmp/%s.bmp' % (out, t)).convert('RGB').save('%s/%s.png' % (out, t)); os.remove('%s/rom_%s.gb' % (out, t))
ims = [Image.open('%s/%s.png' % (out, t)) for t in tags]; W, H = ims[0].size; s = 2
M = Image.new('RGB', (len(ims) * (W * s + 6) - 6, H * s), 'white')
for k, im in enumerate(ims): M.paste(im.resize((W * s, H * s), Image.NEAREST), (k * (W * s + 6), 0))
M.save(out + '/montage.png')
