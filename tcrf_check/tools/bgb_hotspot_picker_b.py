#!/usr/bin/env python3
"""TCRF "Regional Differences" (checklist C16): in the Japanese version, if you press B while a song is playing in the hot-spot editor, the music goes on outside
the sound picker; the international versions stop it.  Real BGB (wine, headless), both ROMs, same key path from the same corpus entry:
  corpus entry 1042 of unlock_runs/f1_organic (mode $1A state 05 = Mode1A_State05_PickSound, 03:6C96), then Down 12 frames (twice; the picker steps through
  the sound list at 03:7615 and requests songs $2B, $3F, $42, $40), then B (run B) or nothing for 400 frames (control).
Logging watchpoints: writes of the music mailbox $DD68 and the sfx-1 mailbox $DD60 (message: value, ROM bank, PC), the execution of the Snd_Music stub (00:2A88 JP,
00:2B8A intl) and one line per VBlank (00:0040).  The playing-song variable $DD69 is read from the final snapshot (400 frames after the key press).
usage: bgb_hotspot_picker_b.py CORPUS JP.gb INTL.gb OUTDIR      (env BGB_DIR = a private copy of the BGB folder, default /home/claude/bgbts)
Writes OUTDIR/c16_hotspot_picker_b.csv: rom, run, frame (VBlank count since the start of the replay), message  (only the lines after the picker's first song request)
and prints the summary table."""
import sys, os, json, subprocess, csv, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import bgb_run
corpus, jp, intl, out = sys.argv[1:5]
os.makedirs(out, exist_ok=True)
rows = [json.loads(l) for l in open(corpus) if l.strip()]
runs = {'B': [[8, 12, 40], [8, 12, 190], [32, 3, 400]], 'control': [[8, 12, 40], [8, 12, 190], [0, 1, 400]]}   # masks: 8 = Down, 32 = B (bgb_wp_probe CORE table)
ids = {}
for k, (name, acts) in enumerate(runs.items()):
    i = 99990 + k; ids[name] = i
    rows.append({"id": i, "parent": 1042, "gain": 0, "sig": [26, 5], "t": 0, "tainted": False, "actions": acts})
cf = os.path.join(out, 'corpus_c16.jsonl'); open(cf, 'w').write('\n'.join(json.dumps(r) for r in rows) + '\n')
bd = os.environ.get('BGB_DIR', '/home/claude/bgbts'); env = dict(os.environ, BGB_DIR=bd)
W = 'DD68//w/SND68 %VALUE% %ROMBANK% %PC%,DD60//w/SND60 %VALUE% %ROMBANK% %PC%,00:0040//x/VBL'
res = []; table = []
for rom, path, stub in (('JP', jp, '00:2A88'), ('INTL', intl, '00:2B8A')):
    for name, i in ids.items():
        pre = os.path.join(out, '%s_%s' % (rom.lower(), name))
        lg = os.path.join(bd, 'debugmsg.txt')
        if os.path.exists(lg): os.remove(lg)
        subprocess.run([sys.executable, os.path.join(HERE, 'bgb_wp_probe.py'), cf, str(i), W + ',%s//x/MUSCALL' % stub, pre, '--rom', path, '--tail', '0', '--system', '3'], env=env, check=True, stdout=subprocess.DEVNULL)
        shutil.copy(lg, pre + '.dbg')
        frame = 0; seen = False; ev = []
        for l in open(pre + '.dbg', errors='replace'):
            l = l.strip()
            if l == 'VBL': frame += 1; continue
            if ' 03 2A63' in l or ' 03 2B65' in l: seen = True          # Snd_PlayFromList of bank 3: the picker requests a song
            if seen and ' 1F ' not in l: ev.append((frame, l))
        st = bgb_run.read_state(pre + '.sna'); song = st['WRAM'][0x1D69]
        for f, l in ev: res.append([rom, name, f, l])
        table.append((rom, name, song, [l for f, l in ev if l.startswith('SND68 FF')]))
with open(os.path.join(out, 'c16_hotspot_picker_b.csv'), 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['rom', 'run', 'frame', 'message']); w.writerows(res)
for rom, name, song, ff in table:
    print('%-4s %-8s $DD69 (playing song) = $%02X   $FF requests after the first song request of the picker: %s' % (rom, name, song, ff or 'none'))
