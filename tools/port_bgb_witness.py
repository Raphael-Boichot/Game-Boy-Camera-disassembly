#!/usr/bin/env python3
"""Targeted BGB scenarios for the international and Gold ROMs (L2 "observed"): every block head of the traced code that the merged coverage never executed
gets a *logging* breakpoint (BGB writes the head to debugmsg.txt and goes on), a scenario is replayed (joypad demo file), and the heads hit are recorded.
A scenario may attach the Game Boy Printer helper (tcrf_check/tools/bgb_printer.py, optional status injection PRN_ERR) or a second BGB instance on the
link cable (-listen / -connect, both instances logged).  This is the international counterpart of the Japanese witness runs (tcrf_check/tools/witness_map.py).

usage: port_bgb_witness.py - SCENARIOS.json OUTDIR [--only NAME,NAME] [--worker K/N]
       port_bgb_witness.py TREE --merge OUTDIR OUT.npz          the members of every head hit (tools: tcrf_check/tools/blocks.py) as an 'ex' array, for port_never_run.py
TREE = us_eu | gold (for --merge; a scenario's instances each get the never-run heads of their own ROM).   Results: OUTDIR/results.jsonl (one line per scenario and instance, resumable), OUTDIR/<name>/ (demo, state, screenshot, printer pages).
Scenario (one JSON object): name, rom (intl | gold | a path), sav (path), seq ('KEY:hold:wait,...', KEY may be A+B or '-'), combo (keys held at boot, default '-'),
  free (frames after the boot hold, default 403), tail (default 600), printer (bool), prn_err (PRN_ERR string, bgb_printer.py), env (dict),
  heads (intl | gold: whose never-run heads to log, needed when rom is a path, e.g. a patched copy),
  partner: {rom, sav, seq, combo, heads} = a second instance on the link (this instance listens, the partner connects).
"""
import sys, os, json, shutil, subprocess, time, collections
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE); TT = os.path.join(ROOT, 'tcrf_check', 'tools')
sys.path.insert(0, TT)
import blocks as B, bgb_run
ROMS = dict(intl=os.environ.get('ROM_US', '/root/work/roms/gbcam_usa_eu.gb'), gold=os.environ.get('ROM_GOLD', '/root/work/roms/gbcam_gold.gb'))
TREES = dict(us_eu=('roms/us_eu/port/trace_us.json', 'roms/us_eu/port/cov_us_runs.npz', 'intl'), gold=('roms/gold/port/trace_gold.json', 'roms/gold/port/cov_gold_runs.npz', 'gold'))

RK = dict(intl='us_eu', gold='gold'); _NEVER = {}
def never_br(rk):
    if rk not in _NEVER: _NEVER[rk] = ','.join(['00:0150///CONTROL'] + ['%s///%s' % (h, h) for h in heads_of(RK[rk])[0]])     # CONTROL: the entry point, hit once at power-on
    return _NEVER[rk]
def heads_of(tree):
    tr, cv, rk = TREES[tree]
    rom = open(ROMS[rk], 'rb').read(); h, m, _ = B.blocks(rom, json.load(open(os.path.join(ROOT, tr))))
    ex = np.load(os.path.join(ROOT, cv))['ex']
    never = ['%02X:%04X' % x for x in h if x in m and not ex[B.flat(*x)]]
    return never, m

def cm(c): return c if isinstance(c, int) else (0 if c == '-' else bgb_run.mask(c))
def parse(s): return [] if not s else bgb_run.parse_seq(s)

def bgbdir(k):
    d = '/home/claude/bgbwit%d' % k
    if not os.path.isdir(d): shutil.copytree('/home/claude/bgbx', d)
    return d

def cmd_for(d, rom, sav, prefix, seq, combo, free, tail, br, extra):
    open(prefix + '.dem', 'wb').write(bgb_run.make_demo(seq, combo, free, tail=tail))
    if sav: shutil.copy(sav, prefix + '.sav')
    for f in (prefix + '.sna', prefix + '.bmp'):
        if os.path.exists(f): os.remove(f)
    c = ['xvfb-run', '-a', 'wine', os.path.join(d, 'bgb.exe'), '-hf', '-nowarn', '-nowriteini', '-nobattsave', '-ini', os.path.join(d, 'bgb.ini'), '-rom', os.path.abspath(rom),
         '-demoplay', prefix + '.dem', '-stateonexit', prefix + '.sna', '-screenonexit', prefix + '.bmp', '-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=0', '-br', br]
    if sav: c += ['-loadbatt', prefix + '.sav']
    return c + list(extra)

def hits(d):
    log = os.path.join(d, 'debugmsg.txt')     # BGB writes it next to bgb.exe
    return dict(collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip())) if os.path.exists(log) else {}

def endstate(prefix):
    if not os.path.exists(prefix + '.sna'): return None
    w = bgb_run.read_state(prefix + '.sna').get('WRAM', b'')
    return '%02X:%02X' % (w[0x15CE], w[0x15CF]) if w else None

def run_one(sc, k):
    out = os.path.join(OUTDIR, sc['name']); os.makedirs(out, exist_ok=True)
    br = never_br(sc.get('heads', sc.get('rom', 'intl')))      # 'heads': whose never-run heads, when 'rom' is a path (a patched copy)
    da = bgbdir(2 * k); env = dict(os.environ, WINEDEBUG='-all', WINEPREFIX='/root/wineprefix', **sc.get('env', {}))
    if sc.get('prn_err'): env['PRN_ERR'] = sc['prn_err']
    for d in (da,):
        if os.path.exists(os.path.join(d, 'debugmsg.txt')): os.remove(os.path.join(d, 'debugmsg.txt'))
    rom = ROMS.get(sc.get('rom', 'intl'), sc.get('rom')); seq = parse(sc.get('seq', '')); combo = cm(sc.get('combo', '-'))
    free = sc.get('free', 403); tail = sc.get('tail', 600); port = 8800 + k; srv = None; extra = []; pb = None; t0 = time.time()
    if sc.get('printer'):
        os.environ['PRN_ERR'] = sc.get('prn_err', '')
        from bgb_printer import PrinterServer
        srv = PrinterServer(port, out).start(); extra = ['-connect', '127.0.0.1:%d' % port]
    if sc.get('partner'):
        extra = ['-listen', '127.0.0.1:%d' % port]
    pa = subprocess.Popen(cmd_for(da, rom, sc.get('sav'), out + '/a', seq, combo, free, tail, br, extra), env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if sc.get('partner'):
        time.sleep(4); p = sc['partner']; db = bgbdir(2 * k + 1)
        if os.path.exists(os.path.join(db, 'debugmsg.txt')): os.remove(os.path.join(db, 'debugmsg.txt'))
        pseq = parse(p.get('seq', '')); n = sum(h + w for _, h, w in seq) + tail; m = sum(h + w for _, h, w in pseq)
        if m < n: pseq = pseq + [('-', n - m, 0)]
        pc = cm(p.get('combo', '-'))
        pb = subprocess.Popen(cmd_for(db, ROMS.get(p.get('rom', 'intl'), p.get('rom')), p.get('sav'), out + '/b', pseq, pc, free, tail, never_br(p.get('heads', p.get('rom', 'intl'))), ['-connect', '127.0.0.1:%d' % port]),
                              env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    for pr in (pa, pb):
        if pr is None: continue
        try: pr.wait(timeout=sc.get('timeout', 1200))
        except subprocess.TimeoutExpired: pr.kill()
    res = []
    r = dict(name=sc['name'], inst='a', rom=sc.get('rom', 'intl'), end=endstate(out + '/a'), control=hits(da).pop('CONTROL', 0), hits={k: v for k, v in hits(da).items() if k != 'CONTROL'}, secs=round(time.time() - t0))
    if srv:
        srv.stop(); r['printer'] = dict(bytes=srv.pr.bytes, packets=len(srv.pr.log), pages=[p.get('file', '-') for p in srv.pr.pages])
    res.append(r)
    if pb is not None:
        res.append(dict(name=sc['name'], inst='b', rom=sc['partner'].get('rom', 'intl'), end=endstate(out + '/b'), control=hits(db).pop('CONTROL', 0), hits={k: v for k, v in hits(db).items() if k != 'CONTROL'}, secs=round(time.time() - t0)))
    return res

if __name__ == '__main__':
    a = sys.argv[1:]
    def opt(n, d=None):
        if n in a: i = a.index(n); v = a[i + 1]; del a[i:i + 2]; return v
        return d
    tree = a[0]
    if a[1] == '--merge':
        OUTDIR, outnpz = a[2], a[3]; never, members = heads_of(tree); rk = TREES[tree][2]
        ex = np.zeros(0x100000, np.uint8); seen = set()
        for l in open(os.path.join(OUTDIR, 'results.jsonl')):
            r = json.loads(l)
            if r['rom'] != rk: continue
            seen |= set(r['hits'])
        for h in seen:
            b, ad = h.split(':')
            for (bb, aa, n) in members[(int(b, 16), int(ad, 16))]: ex[B.flat(bb, aa):B.flat(bb, aa) + n] = 1
        np.savez_compressed(outnpz, ex=ex); print('%d heads hit (of %d never-run), %d bytes credited -> %s' % (len(seen), len(never), int(ex.sum()), outnpz)); sys.exit()
    scen, OUTDIR = a[1], a[2]; only = opt('--only'); wk, wn = [int(x) for x in opt('--worker', '0/1').split('/')]
    S = json.load(open(scen)); S = [s for i, s in enumerate(S) if i % wn == wk and (not only or s['name'] in only.split(','))]
    os.makedirs(OUTDIR, exist_ok=True); resf = os.path.join(OUTDIR, 'results.jsonl')
    done = {json.loads(l)['name'] for l in open(resf)} if os.path.exists(resf) and not only else set()
    for sc in S:
        if sc['name'] in done: continue
        for r in run_one(sc, wk):
            with open(resf, 'a') as f: f.write(json.dumps(r) + '\n')
            print('%-28s %s end %s  control %d  %d heads hit  %ds %s' % (r['name'], r['inst'], r['end'], r['control'], len(r['hits']), r['secs'], r.get('printer', '')), flush=True)
