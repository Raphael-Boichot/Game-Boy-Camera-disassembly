#!/usr/bin/env python3
"""Who reads the doubtful ROM spans?  BGB read watchpoints on every row of disasm/sym_unconclusive_jp.csv (and an execute watchpoint on a row of one byte),
over the cheapest organic replay of each (mode, state) signature, as tcrf_check/tools/wram_probe.py does for RAM (README 2.13).

usage: bgb_span_read_probe.py OUT.csv CORPUS [--workers 2] [--entries ID,ID,...] [--rows disasm/sym_unconclusive_jp.csv] [--targets T.csv --chunk 400]
  --targets: any list bank, addr, size, kind (x / r), name (tcrf_check/tools/l3_targets.py); the watchpoints are split into runs of --chunk, each with its own control CTL<n>
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
targets = opt('--targets'); chunk = int(opt('--chunk', '400'))
out, corpus = args[:2]
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp'); ROM = os.environ.get('GBCAM_ROM', ROOT + '/pocketcamera_jp.gb')
CTLW = 'CTL_%pc%_%(d5ce)%_%(d5cf)%'
TAG = {}; T = []                               # (tag, bank, addr, size, kind)
if targets:                                    # --targets CSV: bank, addr, size, kind (x = execute the first byte, r = read the range), name (tcrf_check/tools/l3_targets.py)
    for k, r in enumerate(csv.DictReader(open(targets, encoding='utf-8'))):
        t = 'T%03X' % k; TAG[t] = r['name']; T.append((t, int(r['bank'], 16), int(r['addr'], 16), int(r['size']), r['kind']))
else:
    for k, r in enumerate(csv.DictReader(open(rowsf, encoding='utf-8'))):
        t = 'S%02d' % k; TAG[t] = r['name']; n = int(r['size'])
        T.append((t, int(r['bank'], 16), int(r['addr'], 16), n, 'r'))
        if n == 1: TAG['X' + t[1:]] = r['name']; T.append(('X' + t[1:], int(r['bank'], 16), int(r['addr'], 16), 1, 'x'))
def wp_of(t, b, ad, n, kd):
    rng = '%02X:%04X' % (b, ad) if n == 1 else '%02X:%04X-%02X:%04X' % (b, ad, b, ad + n - 1)
    return '%s//%s/%s_%%pc%%_%%(d5ce)%%_%%(d5cf)%%' % (rng, kd, t)
CH = [T[i:i + chunk] for i in range(0, len(T), chunk)]
WPS = [','.join(['00:2F3F-00:2FA2//r/' + CTLW] + [wp_of(*x) for x in ch]) for ch in CH]
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
    res = {}; end = ''
    for c, WP in enumerate(WPS):
        p = subprocess.run([sys.executable, HERE + '/bgb_wp_probe.py', corpus, str(i), WP, pre + '_%d' % c, '--rom', ROM, '--tail', '5'], capture_output=True, text=True, env=env, timeout=3000)
        m = re.search(r'end mode:state (\d+):(\d+)', p.stdout); end = m.group(0) if m else 'no end: ' + (p.stderr or p.stdout)[-120:]
        d = re.findall(r'^\{.*\}$', p.stdout, re.M)
        for k, v in (eval(d[-1]) if d else {}).items():
            if k.startswith('CTL'): k = 'CTL%d' % c + k[3:]
            res[k] = res.get(k, 0) + v
    return end, res
Q = queue.Queue(); rows = []; lock = threading.Lock()
done = set()                                   # resume: entries already in OUT.partial.jsonl are read back, not replayed again
if os.path.exists(out + '.partial.jsonl'):
    for l in open(out + '.partial.jsonl'):
        if l.strip():
            i, sig, end, res = json.loads(l)
            if i not in done: done.add(i); rows.append((i, sig, end, res))
for t in sorted(sel, key=lambda t: -C.frames(t[1])):
    if t[1] not in done: Q.put(t)
part = open(out + '.partial.jsonl', 'a')
def slot(w):
    while True:
        try: sig, i = Q.get_nowait()
        except queue.Empty: return
        try: end, res = job(w, sig, i)
        except Exception as ex: end, res = 'error %s' % ex, {}
        with lock:
            rows.append((i, sig, end, res)); part.write(json.dumps([i, sig, end, res]) + '\n'); part.flush()
            hit = sorted({k.split('_')[0] for k in res if not k.startswith('CTL')}); ctl = [sum(v for k, v in res.items() if k.startswith('CTL%d_' % c) or (k.startswith('CTL_') and c == 0)) for c in range(len(WPS))]
            print(i, sig, end, (hit if len(hit) <= 20 else '%d targets hit' % len(hit)) or '-', 'CTL', ctl, '%d/%d' % (len(rows), len(sel)), flush=True)
th = [threading.Thread(target=slot, args=(w,)) for w in range(1, workers + 1)]
for x in th: x.start()
for x in th: x.join()
pat = re.compile(r'^(CTL\d*|S\d\d|X\d\d|T[0-9A-F]{3})_([0-9A-F]{4})_([0-9A-F]{2})_([0-9A-F]{2})$')
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['entry', 'sig', 'end', 'tag', 'name', 'pc', 'mode', 'state', 'hits'])
    for i, sig, end, res in sorted(rows, key=lambda r: r[0]):
        agg = {}
        for k, v in res.items():
            m = pat.match(k)
            if not m: continue
            key = m.groups() if not m.group(1).startswith('CTL') else (m.group(1), '', '', '')
            agg[key] = agg.get(key, 0) + v
        for (t, pc, mo, st), v in sorted(agg.items()):
            w.writerow([i, '' if sig is None else '%d,%d' % tuple(sig), end, t, TAG.get(t, 'Mode_Table (control)'), pc, mo, st, v])
print('->', out)
