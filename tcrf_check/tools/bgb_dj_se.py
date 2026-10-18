#!/usr/bin/env python3
"""D.J. sound effects SE 4, SE 8 and SE 9 (26 presses) replayed in BGB (README 16.18): the route of dj_se.py (keys only), the block heads of the never-run code of bank 1F logged.
usage: bgb_dj_se.py OUTDIR            (run from the working root; ROM pocketcamera_jp.gb, private BGB directories /home/claude/bgbs<K> copied from /home/claude/bgbx, the 3 runs in parallel)
Writes OUTDIR/<n>.heads_hit.json and OUTDIR/bgb_dj_se.csv (scenario, end mode:state, `$D8B7` (SE-1), `$DD08`, class-N heads hit)."""
import sys, os, json, csv, collections, shutil, subprocess
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
SCEN = [('SE 4, one press, 1500 frames', 4, 1, 1500), ('SE 8, one press, 1500 frames', 8, 1, 1500), ('SE 9, 26 presses', 9, 26, 120)]
K1 = os.environ.get('BGB_ONE')
if K1 is not None:
    mine = '/home/claude/bgbs%s' % K1
    if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
    os.environ['BGB_DIR'] = mine
import bgb_run, blocks as B, numpy as np
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
REPO = os.environ.get('REPO', os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__)))))
rom = os.path.join(ROOT, 'pocketcamera_jp.gb'); romb = open(rom, 'rb').read()
heads, members, code = B.blocks(romb, json.load(open(os.path.join(REPO, 'wram', 'trace_jp_v3.json'))))
cls = np.zeros(1 << 20, np.uint8)
for r in csv.DictReader(open(os.path.join(REPO, 'coverage', 'v8', 'report_v8', 'rom_map.csv'))):
    cls[B.flat(int(r['bank'], 16), int(r['start'], 16)):][:int(r['length'])] = ord(r['class'])
nheads = ['%02X:%04X' % h for h in sorted(heads) if h[0] == 0x1F and cls[B.flat(*h)] == ord('N')]
route = json.load(open(os.path.join(ROOT, 'unlock_runs', 'dj_route.json')))
C = {}
for l in open(os.path.join(ROOT, route['corpus'])):
    if l.strip(): e = json.loads(l); C[e['id']] = e
p = []; i = route['entry']
while i >= 0: p.append(i); i = C[i].get('parent', -1)
p = p[::-1]; sp = dict(C[p[0]]['spec'])
def one(k):
    name, se, presses, tail = SCEN[k]
    log = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    seq = []
    for j in p[1:]:
        for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
    for kk in route['shoot']: seq.append((names(kk), 1, 0))
    seq.append(('-', route['after_shoot_idle'], 0))                          # the route ends on the performance screen 1F:05 (no Select, as in dj_se.py)
    for _ in range(4): seq.append(('Right', 4, 10))
    for _ in range(se - 1): seq.append(('Up', 4, 10))
    for _ in range(presses): seq.append(('A', 4, 20))
    sav = os.path.join(out, 'in%d.sav' % k); open(sav, 'wb').write(b'\xff' * 0x20000)
    pre = '%s/run%d' % (out, k)
    r = bgb_run.run(rom, sav, pre, seq, combo=bgb_run.mask(names(sp['combo'])), free=sp['free'] + 3, br=','.join('%s///%s' % (h, h) for h in nheads),
                    extra=['-setting', 'DebugMsgFile=1'], tail=tail, timeout=1800)
    cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
    w = r['st'].get('WRAM', b'')
    res = dict(scenario=name, mode_state='%02X:%02X' % (r['mode'] or 0, r['state'] or 0), se_minus_1=w[0x18B7] if w else None, dd08=w[0x1D08] if w else None, heads=dict(sorted(cnt.items())))
    json.dump(dict(hits=res['heads']), open(pre + '.heads_hit.json', 'w'), indent=1)
    return res
if __name__ == '__main__':
    if K1 is not None: print(json.dumps(one(int(K1)))); sys.exit()
    procs = [subprocess.Popen([sys.executable, __file__, out], env=dict(os.environ, BGB_ONE=str(k)), stdout=subprocess.PIPE, text=True) for k in range(len(SCEN))]
    rows = []
    for k, pr in enumerate(procs):
        o = pr.communicate()[0].strip().splitlines(); res = json.loads(o[-1]) if o else dict(scenario=SCEN[k][0], error='no output'); rows.append(res)
        print('%-32s BGB end %s SE-1=%s DD08=%s class-N heads hit: %s' % (res['scenario'], res.get('mode_state'), res.get('se_minus_1'), res.get('dd08'), ' '.join(res.get('heads', {}))), flush=True)
    with open(out + '/bgb_dj_se.csv', 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n'); w.writerow(['scenario', 'bgb_end', 'D8B7_SE_minus_1', 'DD08', 'class_N_heads_hit'])
        for r in rows: w.writerow([r['scenario'], r.get('mode_state'), r.get('se_minus_1'), r.get('dd08'), ' '.join(r.get('heads', {}))])
