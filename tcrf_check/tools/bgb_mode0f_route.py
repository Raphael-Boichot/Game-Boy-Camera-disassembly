#!/usr/bin/env python3
"""Photo count $D561 and mode $0F (README 8, 12, 16.31): who computes $D561 at boot, and by which menu route the game enters mode $0F.  Real BGB, logging watchpoints (-wp).
  boot   a cold boot (the root entry of the corpus, no key) and a soft reset (a main-menu entry, then A+B+Start+Select held):
         writes of $D561 (value, ROM bank, address of the instruction), the execution of 09:5F4B (Boot_EraseAllPrompt_Far; message carries $FF9E: 0 = cold start from 00:0202, 1 = soft reset from 00:0295),
         02:442C (Sram_ValidateAll_Far) and 02:4466 (Photo_RenumberVector), and the call into Mem_Zero at 00:0187 (the WRAM clear of the cold start, which also zeroes $D561).
  route  the corpus entries that sit in mode $0F (signatures 0F:00 ... 0F:0D of unlock_runs/f1_organic): every write of $D5CE (the mode) with the mode and state it replaces, the new value, ROM bank and address of the writing
         instruction, and every write of $D5CF (the state): the mode:state sequence of the whole replay, and the joypad lineage of the entry (keys and frames).
  guide  the three key paths from the main menu that the guide walk (guide_nodes.py) found, on the save unl_CE10238211: STUDIO > EDIT > ALBUM (`D s D A A`), VIEW > ALBUM > photo menu > DELETE
         (`V A A A A D A`), SHOOT menu > CHECK > photo > DELETE (`A R A A D A`); same logging, so the writing instruction of each route is known.
usage: bgb_mode0f_route.py CORPUS ROM OUTDIR [boot] [route] [guide]        (env BGB_DIR = a private copy of the BGB folder, default /home/claude/bgbts)
Writes OUTDIR/mode0f_boot.csv, OUTDIR/mode0f_route.csv and OUTDIR/mode0f_guide.csv and prints the tables."""
import sys, os, json, subprocess, csv, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]; corpus, rom, out = args[:3]; what = args[3:] or ['boot', 'route']
os.makedirs(out, exist_ok=True)
rows = [json.loads(l) for l in open(corpus) if l.strip()]; C = {r['id']: r for r in rows}
bd = os.environ.get('BGB_DIR', '/home/claude/bgbts'); env = dict(os.environ, BGB_DIR=bd); lg = os.path.join(bd, 'debugmsg.txt')
KEYS = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def keyname(m): return '+'.join(n for b, n in KEYS if m & b) or '-'
def lineage(i):
    p = []
    while i >= 0: p.append(i); i = C[i].get('parent', -1)
    return p[::-1]
def frames(i): return sum(a[1] + a[2] for j in lineage(i)[1:] for a in C[j].get('actions', []))
def keys(i): return ' '.join('%s/%d+%d' % (keyname(a[0]), a[1], a[2]) for j in lineage(i)[1:] for a in C[j].get('actions', []))
def probe(entry, wps, prefix):
    if os.path.exists(lg): os.remove(lg)
    subprocess.run([sys.executable, os.path.join(HERE, 'bgb_wp_probe.py'), cf, str(entry), ','.join(wps), prefix, '--rom', rom, '--tail', '0', '--system', '3'], env=env, check=True, stdout=subprocess.DEVNULL)
    shutil.copy(lg, prefix + '.dbg'); return [l.split() for l in open(prefix + '.dbg', errors='replace') if l.strip()]
if 'boot' in what:
    root = next(r['id'] for r in rows if r.get('parent', -1) < 0 and r['spec']['sav'] == 'unl_PC10696894' and r['spec']['combo'] == 0) if any(r.get('parent', -1) < 0 and r['spec']['sav'] == 'unl_PC10696894' and r['spec']['combo'] == 0 for r in rows) else min(r['id'] for r in rows if r.get('parent', -1) < 0)
    menu = min((r for r in rows if r['sig'] == [0, 1]), key=lambda r: frames(r['id']))['id']          # the cheapest entry in the main menu
    rows2 = rows + [{"id": 99990, "parent": menu, "gain": 0, "sig": [0, 1], "t": 0, "tainted": False, "actions": [[240, 20, 400]]}]       # A+B+Start+Select held 20 frames, then 400 frames
    cf = os.path.join(out, 'corpus_boot.jsonl'); open(cf, 'w').write('\n'.join(json.dumps(r) for r in rows2) + '\n')
    W = ['D561//w/W561 %VALUE% %ROMBANK% %PC%', '09:5F4B//x/BOOTFAR %(ff9e)%', '02:442C//x/VALIDATE', '02:4466//x/RENUMBER', '00:0187//x/MEMZERO', '00:0040//x/VBL']
    res = []
    for name, ent in (('cold boot', root), ('soft reset', 99990)):
        L = probe(ent, W, os.path.join(out, 'boot_' + name.split()[0]))
        frame = 0; ev = []
        for p in L:
            if p[0] == 'VBL': frame += 1; continue
            ev.append((frame, ' '.join(p)))
        # soft reset: only the lines from 5 frames before the soft reset's own call of 09:5F4B ($FF9E = 1); the replay starts with a cold start
        if name == 'soft reset':
            f1 = next(f for f, m in ev if m == 'BOOTFAR 01'); ev = [(f, m) for f, m in ev if f >= f1 - 5]
        for f, m in ev: res.append([name, f, m])
        print(name); [print('  frame %5d  %s' % (f, m)) for f, m in ev]
    with open(os.path.join(out, 'mode0f_boot.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['run', 'frame', 'message']); w.writerows(res)
if 'route' in what:
    ids = [656, 658, 448, 465, 2847, 2852, 684]
    cf = corpus
    W = ['D5CE//w/MW %(d5ce)% %(d5cf)% %VALUE% %ROMBANK% %PC%', 'D5CF//w/ST %(d5ce)% %VALUE%']
    res = []
    for i in ids:
        L = probe(i, W, os.path.join(out, 'route_%d' % i))
        seq = []; into = collections.Counter()
        for p in L:
            if p[0] == 'ST' and len(p) >= 3 and (not seq or seq[-1] != p[1] + ':' + p[2]): seq.append(p[1] + ':' + p[2])
            if p[0] == 'MW' and len(p) >= 6 and p[3] == '0F' and p[1] != '0F': into[(p[1] + ':' + p[2], p[4] + ':' + p[5])] += 1
        r0 = C[lineage(i)[0]]['spec']['sav']
        print('entry %d sig %s save %s: %d frames, %d actions\n  keys: %s\n  (mode:state) writes: %s\n  first entries into mode 0F (from mode:state, at bank:pc): %s' % (i, C[i]['sig'], r0, frames(i), sum(len(C[j].get('actions', [])) for j in lineage(i)[1:]), keys(i), ' '.join(seq), dict(into)))
        res.append([i, '%02X:%02X' % tuple(C[i]['sig']), r0, frames(i), keys(i), ' '.join(seq), '; '.join('%s -> 0F at %s x%d' % (k[0], k[1], v) for k, v in into.items())])
    with open(os.path.join(out, 'mode0f_route.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['entry', 'signature', 'save', 'frames', 'joypad_lineage_key/hold+wait', 'mode_state_writes', 'entries_into_mode_0F']); w.writerows(res)
if 'guide' in what:
    import bgb_run; bgb_run.BGB = bd
    import guide_nodes as G
    NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
    K = lambda t: (NAME[t], 4, 60 if t in 'LRUD' else 200)
    sav = os.environ.get('GBCAM_SAV_GUIDE', os.path.join(os.path.dirname(os.path.abspath(rom)), 'saves_unl', 'unl_CE10238211.sav'))
    W = ['D5CE//w/MW %(d5ce)% %(d5cf)% %VALUE% %ROMBANK% %PC%', 'D5CF//w/ST %(d5ce)% %VALUE%']
    res = []
    for label, path in (('STUDIO > EDIT > ALBUM', 'D s D A A'), ('VIEW > ALBUM > photo menu > DELETE', 'V A A A A D A'), ('SHOOT menu > CHECK > photo > DELETE', 'A R A A D A')):
        if os.path.exists(lg): os.remove(lg)
        r = bgb_run.run(rom, sav, os.path.join(out, 'guide_' + path.replace(' ', '')), [('A', 4, 200)] + [K(t) for t in G.tokens(path, 'L')], combo=2, free=400, timeout=800, tail=2, extra=['-wp', ','.join(W), '-setting', 'DebugMsgFile=1'])
        seq = []; into = collections.Counter()
        for l in open(lg, errors='replace'):
            p = l.split()
            if len(p) >= 3 and p[0] == 'ST' and (not seq or seq[-1] != p[1] + ':' + p[2]): seq.append(p[1] + ':' + p[2])
            if len(p) >= 6 and p[0] == 'MW' and p[3] == '0F' and p[1] != '0F': into[(p[1] + ':' + p[2], p[4] + ':' + p[5])] += 1
        print('%s  [%s]  end %02X:%02X\n  (mode:state) writes: %s\n  entries into mode 0F (from mode:state, at bank:pc): %s' % (label, path, r['mode'], r['state'], ' '.join(seq), dict(into)))
        res.append([label, path, '%02X:%02X' % (r['mode'], r['state']), ' '.join(seq), '; '.join('%s -> 0F at %s x%d' % (k[0], k[1], v) for k, v in into.items())])
    with open(os.path.join(out, 'mode0f_guide.csv'), 'w', newline='') as f:
        w = csv.writer(f, lineterminator='\n'); w.writerow(['route', 'keys_from_main_menu', 'end_mode_state', 'mode_state_writes', 'entries_into_mode_0F']); w.writerows(res)
