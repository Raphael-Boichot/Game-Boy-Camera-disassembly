#!/usr/bin/env python3
"""International L6 (2026-11-22): do the Japanese leftover blocks of the international ROM reach the screen?

  tools/intl_display_check.py US.npz JP.npz [--out roms/us_eu/assets/display_check_us.csv]

US.npz / JP.npz: tools/jp/display_replay.py run on the same corpus in the display-tracking core, once on each ROM:
  GBCOV_LIB=.../libgbcov_display.so GBCAM_ROM=gbcam_us.gb GBCAM_TRACE=roms/us_eu/trace/trace_us.json GBCAM_SAV_ALL=synthetic.sav \\
      python3 tools/jp/display_replay.py coverage/v8/unlock_fuzz/f1_organic/corpus.jsonl US.npz
  GBCOV_LIB=... GBCAM_ROM=pocketcamera_jp.gb GBCAM_SAV_ALL=synthetic.sav python3 tools/jp/display_replay.py (same corpus) JP.npz
(synthetic.sav: tools/jp/make_synthetic_unlocked_save.py; the owner's unlocked saves of the corpus are not kept). For every block of
roms/us_eu/assets/never_reached_us.csv found in the international ROM (same address or moved), the bytes on screen in 15 organic frames or
more (the rule of docs §16.24) in each ROM. The Japanese run is the control: the same key paths on the ROM the corpus was made on.
"""
import argparse, csv, os
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument('us'); ap.add_argument('jp')
ap.add_argument('--out', default=os.path.join(REPO, 'roms', 'us_eu', 'assets', 'display_check_us.csv')); a = ap.parse_args()
U, J = np.load(a.us), np.load(a.jp)
def fl(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
rows = []; tot = on = 0
for r in csv.DictReader(open(os.path.join(REPO, 'roms', 'us_eu', 'assets', 'never_reached_us.csv'), encoding='utf-8')):
    if r['us_status'] not in ('same address', 'moved'): continue
    ub, ua = r['us_addr'].split(':'); o = fl(int(ub, 16), int(ua, 16)); n = int(r['bytes']); jo = fl(int(r['jp_bank'], 16), int(r['jp_addr'], 16))
    uf, jf = U['fro'][o:o + n], J['fro'][jo:jo + n]
    rows.append([r['jp_name'], r['us_addr'], n, r['us_status'], int((uf >= 15).sum()), int(uf.max()), int((jf >= 15).sum()), int(jf.max())])
    tot += n; on += rows[-1][4]
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n')
    w.writerow(['jp_name', 'us_addr', 'bytes', 'us_status', 'us_bytes_on_screen', 'us_max_frames', 'jp_bytes_on_screen', 'jp_max_frames']); w.writerows(rows)
print('intl_display_check: %d blocks, %d bytes; on screen in the international replay: %d bytes in %d blocks (Japanese control: %d bytes); %d / %d mode-state signatures'
      % (len(rows), tot, on, sum(1 for r in rows if r[4]), sum(r[6] for r in rows), len(U['sigs']), len(J['sigs'])))
