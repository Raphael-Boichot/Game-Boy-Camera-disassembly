#!/usr/bin/env python3
"""RUN! RUN! RUN! races of run_race.py replayed in the real BGB (README 16.17): the key bytes of a variant (race_paths.json, run-length coded, core key bits) are appended to the joypad-only path
that reaches the race loop of race 1 (corpus entry 649); BGB logs the block heads of the never-run code (class N of the v8 map) of banks 9 and 1F that it executes, and the end state
(mode:state, places $D00D $D016 $D01F, race counter $D04F) is read from the BGB state file written on exit.
usage: bgb_run_race.py OUTDIR RACE_PATHS.json [VARIANT ...]     (run from the working root; ROM pocketcamera_jp.gb; default variants = the ones listed in DEFAULT)
Writes OUTDIR/<n>.heads_hit.json, <n>.bmp (screen at the end) and OUTDIR/bgb_race_runs.csv.  Private BGB directory /home/claude/bgbr<K> (copy of /home/claude/bgbx) per variant, run in parallel."""
import sys, os, json, csv, shutil, collections, subprocess
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
out, paths_json = sys.argv[1], sys.argv[2]; want = sys.argv[3:]
DEFAULT = ['race 1, A every 2nd + Up before each hurdle', 'race 1, A every 8th frame', 'race 1, A every 16th frame',
           'race 4, A every 2nd + Up before each hurdle', 'race 4, A every 6th frame', 'race 4, A every 16th frame',
           'race 1, A every 2nd, then one A tap on the result screen', 'race 1, A every 2nd, then A on the result screen']
K1 = os.environ.get('BGB_ONE')
if K1 is not None:
    mine = '/home/claude/bgbr%s' % K1
    if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
    os.environ['BGB_DIR'] = mine
import bgb_run, blocks as B, numpy as np
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
REPO = os.environ.get('REPO', '/home/claude/w/clone/Game-Boy-Camera-disassembly')
rom = os.path.join(ROOT, 'pocketcamera_jp.gb'); romb = open(rom, 'rb').read()
heads, members, code = B.blocks(romb, json.load(open(os.path.join(REPO, 'roms', 'jp_rev_a', 'wram', 'trace_jp_v3.json'))))
N = 1 << 20; cls = np.zeros(N, np.uint8)
for r in csv.DictReader(open(os.path.join(REPO, 'coverage', 'v8', 'report_v8', 'rom_map.csv'))):
    cls[B.flat(int(r['bank'], 16), int(r['start'], 16)):][:int(r['length'])] = ord(r['class'])
nheads = ['%02X:%04X' % h for h in sorted(heads) if h[0] in (9, 0x1F) and cls[B.flat(*h)] == ord('N')]            # bank 9 = the mode, bank 1F = the sound engine (the handler of request $11, 1F:4EBC)
# corpus path to entry 649
E = {}
for l in open(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')):
    if l.strip(): e = json.loads(l); E[e['id']] = e
p = []; i = 649
while i >= 0: p.append(i); i = E[i].get('parent', -1)
p = p[::-1]; sp = dict(E[p[0]]['spec']); seq0 = []
for j in p[1:]:
    for a in E[j]['actions']: seq0.append((names(a[0]), int(a[1]), int(a[2])))
sav = os.path.join(ROOT, 'saves_unl', sp['sav'] + '.sav')
PATHS = json.load(open(paths_json)); os.makedirs(out, exist_ok=True)
def one(k, name):
    log = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    seq = list(seq0) + [(names(kb), n, 0) for kb, n in PATHS[name]]
    pre = '%s/run%d' % (out, k)
    r = bgb_run.run(rom, sav, pre, seq, combo=0, free=sp['free'] + 3, br=','.join('%s///%s' % (h, h) for h in nheads),
                    extra=['-setting', 'DebugMsgFile=1'], tail=60, timeout=1800)
    cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
    w = r['st'].get('WRAM', b'')
    res = dict(variant=name, mode_state='%02X:%02X' % (r['mode'] or 0, r['state'] or 0), r0=w[0x1000 + 0xD] if w else None, r1=w[0x1016] if w else None,
               r2=w[0x101F] if w else None, race_counter=w[0x104F] if w else None, heads=dict(sorted(cnt.items())))
    json.dump(dict(hits=res['heads']), open(pre + '.heads_hit.json', 'w'), indent=1)
    return res
if __name__ == '__main__':
    import concurrent.futures as cf
    names_ = want or DEFAULT; rows = []
    # BGB under wine is run one process per variant; subprocess-free fork keeps it simple: run sequentially in worker processes
    jobs = list(enumerate(names_))
    if len(sys.argv) > 3 and os.environ.get('BGB_ONE'):
        k, n = jobs[int(os.environ['BGB_ONE'])]; print(json.dumps(one(k, n))); sys.exit()
    procs = []
    for k, n in jobs:
        env = dict(os.environ, BGB_ONE=str(k))
        procs.append(subprocess.Popen([sys.executable, __file__, out, paths_json] + names_, env=env, stdout=subprocess.PIPE, text=True))
    for (k, n), pr in zip(jobs, procs):
        o = pr.communicate()[0].strip().splitlines()
        res = json.loads(o[-1]) if o else dict(variant=n, error='no output'); rows.append(res)
        print('%-62s BGB end %s places(r0,r1,r2)=%s race#%s  N heads hit: %s' % (n, res.get('mode_state'), (res.get('r0'), res.get('r1'), res.get('r2')), res.get('race_counter'), ' '.join(res.get('heads', {}))), flush=True)
    with open(out + '/bgb_race_runs.csv', 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n'); w.writerow(['variant', 'bgb_end', 'place_runner0', 'place_runner1', 'place_runner2', 'race_counter', 'class_N_heads_hit'])
        for r in rows: w.writerow([r['variant'], r.get('mode_state'), r.get('r0'), r.get('r1'), r.get('r2'), r.get('race_counter'), ' '.join(r.get('heads', {}))])
