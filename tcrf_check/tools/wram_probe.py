#!/usr/bin/env python3
"""Runtime check of RAM names in the real BGB: logging watchpoints (read and write) on every range of a watch list, over the cheapest organic replay of each (mode, state) signature.  README 2.13.

For each corpus entry the script runs tcrf_check/tools/bgb_wp_probe.py (BGB under wine, headless: one line per watchpoint hit in debugmsg.txt, the run goes on) with a read and a write
watchpoint on every range of the watch list.  The message of a watchpoint is `R|W<ADDR>_<pc>_<mode>_<state>_<rombank>_<value>_<A>` with BGB's own expressions (`%pc%`, `%(d5ce)%`, `%(d5cf)%`, `%rombank%`),
so every hit is logged with the program counter of the accessing instruction (BGB stops before it executes), the game mode and state at that moment, the mapped ROM bank, the value of a one-byte
variable (read: the value read; write: the value it had before the write) and, for a write, register A (the value written by `ld [nn],a`).
The output has one CSV row per distinct (entry, access, range, pc, mode, state, bank, value, A) with its number of hits.  Boot code writes every WRAM byte once, so the write counts of an
entry that stops right after the boot (the first entry of the list is such a control, 0 key actions) are the baseline: a count above it is an access of the game.
usage: wram_probe.py OUT.csv WATCH.csv CORPUS [--workers 2] [--entries ID,ID,...] [--chunk 60]
  WATCH.csv   name,addr,size,... (tcrf_check/tools/wram_probe_list.py)
  CORPUS      corpus.jsonl of the replay search; without --entries the cheapest untainted entry of every (mode, state) signature is replayed (README 16.15)
Environment: GBCAM_ROOT (working root of README 16.15), GBCAM_ROM; each worker uses its own copy of the BGB folder (BGB_DIR = /home/claude/bgbp_wp_wN)."""
import sys, os, csv, json, subprocess, collections, concurrent.futures as cf, re
HERE = os.path.dirname(os.path.abspath(__file__))
args = sys.argv[1:]
def opt(n, d=None):
    if n in args:
        i = args.index(n); v = args[i + 1]; del args[i:i + 2]; return v
    return d
workers = int(opt('--workers', '2')); chunk = int(opt('--chunk', '60')); ents = opt('--entries')
out, watch, corpus = args[:3]
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp'); ROM = os.environ.get('GBCAM_ROM', ROOT + '/pocketcamera_jp.gb')
W = list(csv.DictReader(open(watch, encoding='utf-8')))
def wps(rows):
    s = []
    for r in rows:
        lo = int(r['addr'], 16); hi = lo + int(r['size']) - 1
        rng = '%04X' % lo if hi == lo else '%04X-%04X' % (lo, hi)
        m = '%04X_%%pc%%_%%(d5ce)%%_%%(d5cf)%%_%%rombank%%' % lo
        v = '%%(%04x)%%' % lo if hi == lo else 'xx'          # value of a one-byte variable (before the write for a write watchpoint)
        s += ['%s//r/R%s_%s_xx' % (rng, m, v), '%s//w/W%s_%s_%%a%%' % (rng, m, v)]
    return ','.join(s)
chunks = [W[i:i + chunk] for i in range(0, len(W), chunk)]
sys.path.insert(0, ROOT + '/tools'); os.chdir(ROOT)
import lib
C = lib.Corpus(corpus)
if ents: sel = [(tuple(C.E[int(x)]['sig']), int(x)) for x in ents.split(',')]
else:
    sigs = sorted(set(tuple(e['sig']) for e in C.E.values())); sel = []
    for s in sigs:
        i = C.best(s)
        if i is not None: sel.append((s, i))
    sel.sort(key=lambda t: C.frames(t[1]))     # the cheapest entry first: the control (no key action, boot only)
def job(t):
    w, (sig, i) = t
    res = {}; end = ''
    for k, ch in enumerate(chunks):
        env = dict(os.environ, BGB_DIR='/home/claude/bgbp_wp_w%d' % w, GBCAM_ROM=ROM)
        pre = '/tmp/wram_probe_w%d/e%d_%d' % (w, i, k); os.makedirs(os.path.dirname(pre), exist_ok=True)
        p = subprocess.run([sys.executable, HERE + '/bgb_wp_probe.py', corpus, str(i), wps(ch), pre, '--rom', ROM, '--tail', '5'], capture_output=True, text=True, env=env, timeout=3000)
        m = re.search(r'end mode:state (\d+):(\d+)', p.stdout); end = m.group(0) if m else 'no end: ' + (p.stderr or p.stdout)[-120:]
        d = re.findall(r'^\{.*\}$', p.stdout, re.M)
        if d: res.update(eval(d[-1]))
    return i, sig, end, res
rows = []
import threading, queue
Q = queue.Queue()
for t in sorted(sel, key=lambda t: -C.frames(t[1])): Q.put(t)       # the longest replay first: the two workers finish together
part = open(out + '.partial.jsonl', 'w'); lock = threading.Lock()
def slot(w):
    while True:
        try: t = Q.get_nowait()
        except queue.Empty: return
        try: i, sig, end, res = job((w, t))
        except Exception as ex: i, sig, end, res = t[1], t[0], 'error %s' % ex, {}
        with lock:
            rows.append((i, sig, end, res)); part.write(json.dumps([i, sig, end, res]) + '\n'); part.flush()
            print(i, sig, end, sum(res.values()), '%d/%d' % (len(rows), len(sel)), flush=True)
th = [threading.Thread(target=slot, args=(w,)) for w in range(1, workers + 1)]
for x in th: x.start()
for x in th: x.join()
pat = re.compile(r'^([RW])([0-9A-F]{4})_([0-9A-F]{4})_([0-9A-F]{2})_([0-9A-F]{2})_([0-9A-F]{2})_([0-9A-Fx]{2})_([0-9A-Fx]{2})$')
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['entry', 'sig', 'end', 'kind', 'addr', 'pc', 'mode', 'state', 'rombank', 'value', 'a', 'hits'])
    for i, sig, end, res in sorted(rows, key=lambda r: r[0]):
        for k in sorted(res):
            m = pat.match(k)
            if m: w.writerow([i, '' if sig is None else '%d,%d' % sig, end] + list(m.groups()) + [res[k]])
print('->', out)
