#!/usr/bin/env python3
"""Who reads the doubtful ROM spans?  BGB read watchpoints on every row of disasm/sym_unconclusive_jp.csv (and an execute watchpoint on a row of one byte),
over the cheapest organic replay of each (mode, state) signature, as tcrf_check/tools/wram_probe.py does for RAM (README 2.13).

usage: bgb_span_read_probe.py OUT.csv CORPUS [--workers 2] [--entries ID,ID,...] [--rows disasm/sym_unconclusive_jp.csv]
Every watchpoint logs `<tag>_<pc>_<mode>_<state>` (BGB stops before the instruction, so pc is the reader); the control `CTL` is a read watchpoint on Mode_Table
(00:2F3F-2FA2), which the main loop reads every frame, so a span count of 0 in an entry whose CTL count is above 0 means "not read in that replay".
OUT.csv: entry, sig, end, tag, name, pc, mode, state, hits (one row per distinct watchpoint message).  Environment as wram_probe.py (GBCAM_ROOT, GBCAM_ROM).
Example (2026-10-26): the 14 rows of the doubtful list over the 206 signatures of unlock_runs/f1_organic/corpus.jsonl -> tcrf_check/assets/span_reads/span_reads.csv"""
import sys, os, csv, re, subprocess, json, threading, queue
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE))
args = sys.argv[1:]
def opt(n, d=None):
    if n in args:
        i = args.index(n); v = args[i + 1]; del args[i:i + 2]; return v
    return d
workers = int(opt('--workers', '2')); ents = opt('--entries'); rowsf = opt('--rows', os.path.join(REPO, 'disasm', 'sym_unconclusive_jp.csv'))
out, corpus = args[:2]
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp'); ROM = os.environ.get('GBCAM_ROM', ROOT + '/pocketcamera_jp.gb')
R = list(csv.DictReader(open(rowsf, encoding='utf-8')))
wp = ['00:2F3F-00:2FA2//r/CTL_%pc%_%(d5ce)%_%(d5cf)%']
TAG = {}
for k, r in enumerate(R):
    b = int(r['bank'], 16); a = int(r['addr'], 16); n = int(r['size']); t = 'S%02d' % k; TAG[t] = r['name']
    rng = '%02X:%04X' % (b, a) if n == 1 else '%02X:%04X-%02X:%04X' % (b, a, b, a + n - 1)
    wp.append('%s//r/%s_%%pc%%_%%(d5ce)%%_%%(d5cf)%%' % (rng, t))
    if n == 1: wp.append('%s//x/X%s_%%pc%%_%%(d5ce)%%_%%(d5cf)%%' % (rng, t[1:]))
WP = ','.join(wp)
os.chdir(ROOT)
class Corpus:                     # the replay-corpus reader of tcrf_check/tools/lib.py (which also needs the core library)
    def __init__(self, path):
        self.E = {}
        for l in open(path):
            if l.strip(): e = json.loads(l); self.E[e['id']] = e
    def path(self, i):
        p = []
        while i >= 0: p.append(i); i = self.E[i].get('parent', -1)
        return p[::-1]
    def frames(self, i):
        f = 0
        for j in self.path(i):
            e = self.E[j]
            if 'spec' in e: f += 250 + e['spec']['free']
            else: f += sum(int(a[1]) + int(a[2]) for a in e['actions'])
        return f
    def tainted(self, i): return any(self.E[j].get('tainted') for j in self.path(i))
    def best(self, sig):
        c = [(self.frames(i), i) for i, e in self.E.items() if tuple(e['sig']) == tuple(sig) and not self.tainted(i)]
        return min(c)[1] if c else None
C = Corpus(corpus)
if ents: sel = [(tuple(C.E[int(x)]['sig']), int(x)) for x in ents.split(',')]
else:
    sel = []
    for s in sorted(set(tuple(e['sig']) for e in C.E.values())):
        i = C.best(s)
        if i is not None: sel.append((s, i))
def job(w, sig, i):
    env = dict(os.environ, BGB_DIR='/home/claude/bgbp_wp_w%d' % w, GBCAM_ROM=ROM)
    pre = '/tmp/span_probe_w%d/e%d' % (w, i); os.makedirs(os.path.dirname(pre), exist_ok=True)
    p = subprocess.run([sys.executable, HERE + '/bgb_wp_probe.py', corpus, str(i), WP, pre, '--rom', ROM, '--tail', '5'], capture_output=True, text=True, env=env, timeout=3000)
    m = re.search(r'end mode:state (\d+):(\d+)', p.stdout); end = m.group(0) if m else 'no end: ' + (p.stderr or p.stdout)[-120:]
    d = re.findall(r'^\{.*\}$', p.stdout, re.M)
    return end, (eval(d[-1]) if d else {})
Q = queue.Queue(); rows = []; lock = threading.Lock()
for t in sorted(sel, key=lambda t: -C.frames(t[1])): Q.put(t)
part = open(out + '.partial.jsonl', 'a')
def slot(w):
    while True:
        try: sig, i = Q.get_nowait()
        except queue.Empty: return
        try: end, res = job(w, sig, i)
        except Exception as ex: end, res = 'error %s' % ex, {}
        with lock:
            rows.append((i, sig, end, res)); part.write(json.dumps([i, sig, end, res]) + '\n'); part.flush()
            print(i, sig, end, {k: v for k, v in res.items() if not k.startswith('CTL')} or '-', 'CTL', sum(v for k, v in res.items() if k.startswith('CTL')), '%d/%d' % (len(rows), len(sel)), flush=True)
th = [threading.Thread(target=slot, args=(w,)) for w in range(1, workers + 1)]
for x in th: x.start()
for x in th: x.join()
pat = re.compile(r'^(CTL|S\d\d|X\d\d)_([0-9A-F]{4})_([0-9A-F]{2})_([0-9A-F]{2})$')
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['entry', 'sig', 'end', 'tag', 'name', 'pc', 'mode', 'state', 'hits'])
    for i, sig, end, res in sorted(rows, key=lambda r: r[0]):
        agg = {}
        for k, v in res.items():
            m = pat.match(k)
            if not m: continue
            key = m.groups() if m.group(1) != 'CTL' else ('CTL', '', '', '')
            agg[key] = agg.get(key, 0) + v
        for (t, pc, mo, st), v in sorted(agg.items()):
            w.writerow([i, '' if sig is None else '%d,%d' % tuple(sig), end, t, TAG.get('S' + t[1:], 'Mode_Table (control)') if t != 'CTL' else 'Mode_Table (control)', pc, mo, st, v])
print('->', out)
