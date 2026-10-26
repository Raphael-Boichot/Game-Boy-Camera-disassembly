#!/usr/bin/env python3
"""BGB watchpoint pass over the mode-state handlers of roms/jp_rev_a/disasm/sym_unconclusive_jp.csv (group "mode state"; README 1.1.1, 2026-10-25).

Every handler gets a logging watchpoint (execution for code, read for the three tables) whose message carries the game's mode and state
(`%(d5ce)%`, `%(d5cf)%`), plus a control watchpoint on every write of the state byte $D5CF; one replay then says in which screens each handler ran.

usage:
  mode_state_wp.py corpus  WORKER NWORKERS OUTDIR   the cheapest entry of coverage/results/corpus/*.jsonl.gz that ends in each (mode, state) of the
                                                    handlers' modes, replayed from its root save (coverage/saves, saves_unl, saves_pseudo of GBCAM_ROOT)
  mode_state_wp.py guide   WORKER NWORKERS OUTDIR   key paths from the main menu (guide_nodes.py tokens, plus keys inside the screens) on unl_CE10238211
  mode_state_wp.py partner OUTDIR [LABEL ...]       screens that need a partner on the link: print_photo / print_card (printer helper bgb_printer.py),
                                                    dj_editor / dj_perf_* (bgb_dj_print.py), link (two BGB instances, bgb_link_wp.py)
  mode_state_wp.py report  OUT.csv OUTDIR [...]     per handler: the screens where it ran, hits, runs, verdict against the mode / state of its name
Environment: GBCAM_ROOT (default /home/claude/gbcam_jp: pocketcamera_jp.gb, saves/, saves_unl/ (tools/make_unlocked_saves.py), saves_pseudo/,
tools_repo -> tcrf_check/tools, unlock_runs/f1_organic -> coverage/v8/unlock_fuzz/f1_organic, unlock_runs/dj_route.json from tcrf_check/assets/bgb_retrace);
BGB_SRC (default /home/claude/bgbx, a folder with bgb.exe and bgb.ini; the workers copy it).  A run whose path was recorded in the core can end on another
screen in BGB (timing): the hits stay valid because each carries its own mode and state, and the `end` field says where the run ended."""
import sys, os, json, gzip, glob, csv, shutil, subprocess, collections, re
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(os.path.dirname(HERE)); sys.path.insert(0, HERE)
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp'); SRC = os.environ.get('BGB_SRC', '/home/claude/bgbx')
ROM = ROOT + '/pocketcamera_jp.gb'; UNL = ROOT + '/saves_unl/unl_CE10238211.sav'
SAVES = [ROOT + '/saves', ROOT + '/saves_unl', ROOT + '/saves_pseudo']
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
H = [r for r in csv.DictReader(open(REPO + '/roms/jp_rev_a/disasm/sym_unconclusive_jp.csv', encoding='utf-8')) if r['group'] == 'mode state']    # what the runs watch: the handlers still open
PASS_CSV = REPO + '/tcrf_check/assets/mode_state_wp/mode_state_wp_jp.csv'      # the 70 handlers of the pass of 2026-10-25: the report keeps all of them as the doubtful list shrinks

def watchlist(rows):
    w = []
    for r in rows:
        if r['name'].endswith('Tbl'):       # data: a read watchpoint over the table
            a = int(r['addr'], 16); w.append('%s:%04X-%s:%04X//r/T %s %%(d5ce)%% %%(d5cf)%%' % (r['bank'], a, r['bank'], a + int(r['size']) - 1, r['name']))
        else: w.append('%s:%s//x/H %s %%(d5ce)%% %%(d5cf)%%' % (r['bank'], r['addr'], r['name']))
    w.append('D5CF//w/CTL %(d5ce)% %(d5cf)% %a%')      # control: every write of the state byte (mode, value before, value written)
    return ','.join(w)
WP = watchlist(H)

def folder(name):
    d = '/home/claude/' + name
    if not os.path.isdir(d): shutil.copytree(SRC, d)
    return d
def read_log(d):
    f = os.path.join(d, 'debugmsg.txt')
    L = [l.strip() for l in open(f, errors='replace')] if os.path.exists(f) else []
    return collections.Counter(l for l in L if l[:2] in ('H ', 'T ')), sum(1 for l in L if l.startswith('CTL '))
def clear_log(d):
    f = os.path.join(d, 'debugmsg.txt')
    if os.path.exists(f): os.remove(f)
def record(res, out, label, end, d, extra=None):
    hits, ctl = read_log(d)
    if os.path.exists(os.path.join(d, 'debugmsg.txt')): shutil.copy(os.path.join(d, 'debugmsg.txt'), os.path.join(out, label + '.debugmsg.txt'))
    rec = dict(target=label, end=end, ctl=ctl, hits=dict(hits)); rec.update(extra or {})
    res.write(json.dumps(rec) + '\n'); res.flush()
    print(label, 'end', end, 'ctl', ctl, 'handlers', len({k.split()[1] for k in hits}), flush=True)
def guide_seq(path):
    import guide_nodes as G
    return [('A', 4, 200)] + [('-', 1, int(t[1:])) if t.startswith('w') else (NAME[t], 4, 60 if t in 'LRUD' else 200) for t in G.tokens(path, 'L')]

def best_entries(modes):
    best = {}
    for f in sorted(glob.glob(REPO + '/coverage/results/corpus/*.jsonl.gz')):
        C = {}
        for l in gzip.open(f, 'rt'):
            if l.strip():
                e = json.loads(l)
                if 'id' in e: C[e['id']] = e
        for e in C.values():
            m, s = e['sig']
            if '%02X' % m not in modes or e.get('tainted'): continue
            fr = 0; i = e['id']; root = None; ok = True
            while i >= 0:
                x = C.get(i)
                if x is None or x.get('tainted'): ok = False; break
                if x.get('parent', -1) < 0: root = x['spec']; fr += x['spec']['free'] + 250
                else: fr += sum(a[1] + a[2] for a in x['actions'])
                i = x.get('parent', -1)
            if not ok or 'actions' in root: continue
            v = (fr, os.path.basename(f), e['id'], root['printer'], root['sav'])
            if (m, s) not in best or v < best[(m, s)]: best[(m, s)] = v
    return C, best

def cmd_corpus(w, nw, out):
    os.environ['BGB_DIR'] = folder('bgbw%d' % w); import bgb_run
    modes = {r['name'][4:6].upper() for r in H}
    _, best = best_entries(modes)
    cache = {}
    res = open(os.path.join(out, 'results_w%d.jsonl' % w), 'a')
    for n, ((m, s), (frames, f, eid, printer, sav)) in enumerate(sorted(best.items())):
        if n % nw != w: continue
        if f not in cache:
            cache[f] = {e['id']: e for e in (json.loads(l) for l in gzip.open(REPO + '/coverage/results/corpus/' + f, 'rt') if l.strip()) if 'id' in e}
        C = cache[f]; p = []; i = eid
        while i >= 0: p.append(i); i = C[i].get('parent', -1)
        p = p[::-1]; sp = C[p[0]]['spec']
        seq = [(names(a[0]), int(a[1]), int(a[2])) for j in p[1:] for a in C[j]['actions']]
        sv = next((os.path.join(d, sp['sav'] + '.sav') for d in SAVES if os.path.exists(os.path.join(d, sp['sav'] + '.sav'))), None)
        d = os.environ['BGB_DIR']; clear_log(d); key = '%02X:%02X' % (m, s)
        r = bgb_run.run(ROM, sv, os.path.join(out, 'run_%02X_%02X' % (m, s)), seq, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3,
                        extra=['-wp', WP, '-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=0'], tail=60, timeout=600)
        record(res, out, 'corpus_%02X_%02X' % (m, s), '%02X:%02X' % (r['mode'] or 0, r['state'] or 0), d, dict(corpus=f, entry=eid, printer=printer, save=sp['sav'], frames=frames))

GUIDE = {   # label -> key path from the title (guide_nodes tokens; wN = N idle frames)
 'H22_selftimer': 'A D A A', 'H22b_timer_set': 'A D A A R R A w300', 'H23_timelapse': 'A D A D A', 'H23b_interval_set': 'A D A D A R R A R A w300',
 'H31_tricklens': 'A D D A A', 'H31b_tricklens_values': 'A D D A A R R R R L A w300', 'H32_montage': 'A D D A D A', 'H32b_montage_values': 'A D D A D A R R R A w300',
 'H33_panorama': 'A D D A D D A', 'H33b_panorama_toggles': 'A D D A D D A R D R A w400', 'H34_gameface': 'A D D A D D D A', 'H34b_gameface_down': 'A D D A D D D A D A w400',
 'V61_delete_confirm': 'V A A A A D A', 'V61b_delete_do': 'V A A A A D A A w600', 'V71_print_preview': 'V A A A A U A', 'V72_print_options': 'V A A A A U A s',
 'V73_opt_up': 'V A A A A U A s U', 'V74_opt_down': 'V A A A A U A s D', 'V74b_opt_toggle': 'V A A A A U A s D R L A w300', 'V76_print_go': 'V A A A A U A A w900',
 'T22_link_print': 'D s U A A A', 'T23_link_print_preview': 'D s U A A A A', 'T24_link_print_go': 'D s U A A A A A w900', 'T26_link_transfer': 'D s U A D A',
 'T31_hotspot': 'D s R A A', 'T33_hotspot_slot': 'D s R A A A A', 'T33b_slot_B': 'D s R A A A A B w200', 'T33c_slot_B_B': 'D s R A A A A B w200 B w200',
 'T36_hotspot_jump': 'D s R A A A A A A A', 'T37_hotspot_place': 'D s R A A A A A A A A w200 A w200', 'T38_hotspot_exit': 'D s R A A A A B B w200 B w300',
 'T39_hotspot_delete': 'D s R A A A A s w200 A w200', 'T51_album': 'D s D A A', 'T52_album_second': 'D s D A A A', 'T53_album_copy': 'D s D A A A A w600',
 'P18_panorama_print': 'A D D A D D A A w300', 'P18b_pick': 'A D D A D D A A w300 R A w200 R A w200',
}
def cmd_guide(w, nw, out):
    os.environ['BGB_DIR'] = folder('bgbg%d' % w); import bgb_run
    res = open(os.path.join(out, 'results_w%d.jsonl' % w), 'a')
    for n, (key, path) in enumerate(sorted(GUIDE.items())):
        if n % nw != w: continue
        d = os.environ['BGB_DIR']; clear_log(d)
        r = bgb_run.run(ROM, UNL, os.path.join(out, 'run_' + key), guide_seq(path), free=400, extra=['-wp', WP, '-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=0'], tail=120, timeout=600)
        record(res, out, 'guide_' + key, '%02X:%02X' % (r['mode'] or 0, r['state'] or 0), d, dict(path=path, save='unl_CE10238211'))

def cmd_partner(out, only):
    want = lambda l: not only or l in only
    res = open(os.path.join(out, 'results_w0.jsonl'), 'a')
    env = dict(os.environ, BGB_WP=WP, BGB_HF='-headless', BGB_DIR=SRC)
    for label, path in (('print_photo', 'V A A A A U A A'), ('print_card', 'V A A A A U A S A')):
        if not want(label): continue
        d = folder('bgbp_' + label); os.environ.update(BGB_DIR=d, BGB_WP=WP, BGB_HF='-headless')
        import bgb_run; bgb_run.BGB = d
        from bgb_printer import PrinterServer
        po = os.path.join(out, label); os.makedirs(po, exist_ok=True); clear_log(d)
        srv = PrinterServer(8793, po).start()
        try: r = bgb_run.run(ROM, UNL, po + '/run', guide_seq(path), tail=4000, timeout=900, extra=['-connect', '127.0.0.1:8793'])
        finally: srv.stop()
        record(res, out, label, '%02X:%02X' % (r['mode'] or 0, r['state'] or 0), d, dict(path=path, pages=len([f for f in os.listdir(po) if f.startswith('page_')])))
    for label, f, eid, keys in (('print_pano1', '01_fuzz_a.jsonl.gz', 899, [('A', 4, 300)]),                    # corpus entry ending in 18:03 (first pick, a row); its pick ended with B, so state 03 cancels (the cancel case)
                                ('print_pano2', '01_fuzz_b.jsonl.gz', 1646, [('A', 4, 120)] * 6 + [('A', 4, 300)]),   # (state 03 prints only when the pick ended with A: wAbResult)
                                ('print_pano1b', '01_fuzz_b.jsonl.gz', 1619, [('A', 4, 120)] * 6 + [('A', 4, 300)])):  # entry ending in 18:01 (first pick), then A presses   # entry ending in 18:02 (second pick, a column), then A presses
        if not want(label): continue                  # the 4-photo job of mode $18 prints with layout 2 or 3 ($DB6D = ($D5EA xor 1) + 2, README 17.8): layout 3 sets flag bit 4 (Mode1D_InterleaveTileRows)
        d = folder('bgbp_' + label); os.environ.update(BGB_DIR=d, BGB_WP=WP, BGB_HF='-headless')
        import bgb_run; bgb_run.BGB = d
        from bgb_printer import PrinterServer
        C = {e['id']: e for e in (json.loads(l) for l in gzip.open(REPO + '/coverage/results/corpus/' + f, 'rt') if l.strip()) if 'id' in e}
        pth = []; i = eid
        while i >= 0: pth.append(i); i = C[i].get('parent', -1)
        pth = pth[::-1]; sp = C[pth[0]]['spec']
        seq = [(names(a[0]), int(a[1]), int(a[2])) for j in pth[1:] for a in C[j]['actions']] + keys
        sv = next((os.path.join(dd, sp['sav'] + '.sav') for dd in SAVES if os.path.exists(os.path.join(dd, sp['sav'] + '.sav'))), None)
        po = os.path.join(out, label); os.makedirs(po, exist_ok=True); clear_log(d)
        srv = PrinterServer(8794, po).start()
        try: r = bgb_run.run(ROM, sv, po + '/run', seq, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3, tail=6000, timeout=900, extra=['-connect', '127.0.0.1:8794'])
        finally: srv.stop()
        record(res, out, label, '%02X:%02X' % (r['mode'] or 0, r['state'] or 0), d, dict(corpus=f, entry=eid, save=sp['sav'], pages=len([x for x in os.listdir(po) if x.startswith('page_')])))
    for label, extra in (('dj_editor', []), ('dj_perf_start', ['--seq', 'Start:4:300,A:4:300']), ('dj_perf_b', ['--seq', 'B:4:300,A:4:300']), ('dj_perf_b_b', ['--seq', 'B:4:300,B:4:300']),
                         ('dj_save_quit', ['--seq', 'B:4:400,B:4:500,A:4:400,B:4:500,B:4:400,A:4:400'])):   # edit pages (dirty) -> B back to the performance -> B = performer script 8 -> save panel (state 06) -> quit panel (07)
        if not want(label): continue
        o = os.path.join(out, label); os.makedirs(o, exist_ok=True); d = '/home/claude/bgbpr10'; clear_log(d)    # bgb_dj_print.py's folder for --port 8810
        p = subprocess.run([sys.executable, ROOT + '/tools_repo/bgb_dj_print.py', o, '--tail', '1500', '--port', '8810'] + extra, cwd=ROOT, env=env, capture_output=True, text=True, timeout=1500)
        record(res, out, label, ((p.stdout.strip().splitlines() or [''])[-1])[:60], d, dict(rc=p.returncode))
    for label, flow, sa, sb in (('link', 'flow1', 'A_sender', 'B_receiver'), ('link2', 'flow2', 'B_sender', 'A_receiver')):   # the two recorded exchanges of link_protocol/saves
        if not want(label): continue
        o = os.path.join(out, label); os.makedirs(o, exist_ok=True); sv = REPO + '/link_protocol/saves/'
        for role in ('sender', 'receiver'): clear_log('/home/claude/bgbl_' + role)
        p = subprocess.run([sys.executable, ROOT + '/tools_repo/bgb_link_wp.py', ROM, sv + '%s_%s_before.sav' % (flow, sa), sv + '%s_%s_before.sav' % (flow, sb), o + '/x', WP],
                           cwd=ROOT, env=dict(env, WPS_SENDER=WP), capture_output=True, text=True, timeout=1500)
        for role in ('sender', 'receiver'): record(res, out, '%s_%s' % (label, role), 'rc %d' % p.returncode, '/home/claude/bgbl_' + role, dict(rc=p.returncode, saves=flow))

def cmd_report(outcsv, dirs):
    seen = collections.defaultdict(collections.Counter); runs = collections.defaultdict(set); nrun = 0
    for d in dirs:
        for f in sorted(glob.glob(d + '/results_w*.jsonl')):
            for l in open(f):
                r = json.loads(l); nrun += 1
                for k, v in r['hits'].items():
                    p = k.split(); seen[p[1]]['%s:%s' % (p[2], p[3])] += v; runs[p[1]].add(r['target'])
    w = csv.writer(open(outcsv, 'w', newline='', encoding='utf-8'), lineterminator='\n')
    w.writerow(['bank', 'addr', 'name', 'kind', 'name_mode', 'name_state', 'screens', 'hits', 'runs', 'verdict'])
    summ = collections.Counter()
    rows = list(csv.DictReader(open(PASS_CSV, encoding='utf-8'))) if os.path.exists(PASS_CSV) else H
    for r in rows:
        n = r['name']; m = n[4:6].upper(); st = re.match(r'Mode.._State([0-9A-F]{2})_', n); sc = seen.get(n, {})
        if not sc: v = 'not reached in these runs'
        else:
            modes = {k.split(':')[0] for k in sc}
            if modes != {m}: v = 'runs in mode %s, name says %s' % ('/'.join(sorted(modes)), m)
            elif st:
                states = {k.split(':')[1] for k in sc}
                v = 'mode and state confirmed' if states == {st.group(1)} else 'mode confirmed, states %s, name says %s' % ('/'.join(sorted(states)), st.group(1))
            else: v = 'mode confirmed'
        summ[v] += 1
        w.writerow([r['bank'], r['addr'], n, 'read' if n.endswith('Tbl') else 'execute', m, st.group(1) if st else '',
                    ' '.join('%s x%d' % kv for kv in sorted(sc.items())), sum(sc.values()), len(runs.get(n, ())), v])
    print('runs', nrun, dict(summ))

if __name__ == '__main__':
    a = sys.argv[1:]
    if not a: raise SystemExit(__doc__)
    if a[0] == 'corpus': os.makedirs(a[3], exist_ok=True); cmd_corpus(int(a[1]), int(a[2]), a[3])
    elif a[0] == 'guide': os.makedirs(a[3], exist_ok=True); cmd_guide(int(a[1]), int(a[2]), a[3])
    elif a[0] == 'partner': os.makedirs(a[1], exist_ok=True); cmd_partner(os.path.abspath(a[1]), set(a[2:]))
    elif a[0] == 'report': cmd_report(a[1], a[2:])
    else: raise SystemExit(__doc__)
    print('DONE', flush=True)
