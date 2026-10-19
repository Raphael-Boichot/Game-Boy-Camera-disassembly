#!/usr/bin/env python3
"""Second pass of the WRAM probe (README 2.13): the same read / write watchpoints as wram_probe.py in the scenarios that a single replay cannot reach, because they need a partner on the link cable.

Every scenario runs one of the existing BGB drivers with env BGB_WP = the watchpoint list (bgb_run.run adds `-wp` and `DebugMsgFile=1`), then counts the lines of the debug-message file of every BGB instance:
  link_exchange       two real BGB instances joined with -listen / -connect, photo exchange of mode $0E (bgb_link_wp.py, README 14); sender and receiver are logged
  print_single_1C     one photo, mode $1C -> $1D, Game Boy Printer helper on the link (bgb_print_run.py, README 17.3)
  print_card_1C       the same with the comment card (Start option, README 17.4)
  print_batch_1E      three photos marked in the multi-print screen, mode $1E (README 17.5); the route is the first 10 key actions of corpus entry 289 (main menu of the unlocked save, which has photos), Select, Up, A (LINK menu), A (print menu), Right, A; the all-zero root of the entries that reach mode $1E in the core has an empty album, and its path drifts in BGB
  print_wild_0 / _7   one photo with wild frame 01 / 08 (bgb_print_wild.py)
  show_hotspot / show_slideshow / show_animation   VIEW menu (entry 207) -> Right, A -> SHOW menu (mode $0B) -> HOT-SPOT $0C / SLIDE SHOW $0D / ANIMATION $13, no printer (the replays of the organic corpus end in the album instead)
  dj_print            TRIPY-H score print, mode $1F (bgb_dj_print.py, README 17.6); dj_print_noise = the NOISE page; dj_editor / dj_editor_sound2 = the editor without the print (SOUND I / SOUND II page)
  run_race_fast / _slow / _result   RUN! RUN! RUN! (mode $21) races of README 16.17 (bgb_run_race.py): race 1 with A every 2nd frame, race 4 with A every 16th frame, race 1 and A on the result screen
  show_animation_music   the same ANIMATION route, then Select x3 in state $01 of mode $13 (music number, `wPlayerMusic`)
  dj_perf_start / dj_perf_start_noise   the editor (SOUND I / NOISE page), then Start taps and one 50-frame Start hold (play / stop, hold counter of the performer)
  err_card_inq80 / err_dj_dataFF   the printer answers an error status byte (PRN_ERR, README 16.16)
usage: wram_probe_scen.py OUT.csv WATCH.csv [--only LABEL,LABEL] [--workers 2]
Output columns as wram_probe.py (entry = the scenario label, `.sender` / `.receiver` for the link).  Environment: GBCAM_ROOT (default /home/claude/gbcam_jp); the drivers are run from
GBCAM_ROOT/tools_repo (a symlink to tcrf_check/tools, so that their ROOT is the working root); BGB_HF=-headless (a linked BGB hangs at the handshake with -hf)."""
import sys, os, csv, re, subprocess, collections, threading, queue, shutil
args = sys.argv[1:]
def opt(n, d=None):
    if n in args:
        i = args.index(n); v = args[i + 1]; del args[i:i + 2]; return v
    return d
only = opt('--only'); workers = int(opt('--workers', '2')); out, watch = args[:2]
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp'); T = ROOT + '/tools_repo'; ROM = ROOT + '/pocketcamera_jp.gb'
CORPUS = 'unlock_runs/f1_organic/corpus.jsonl'
W = list(csv.DictReader(open(watch, encoding='utf-8')))
def wps(rows):
    s = []
    for r in rows:
        lo = int(r['addr'], 16); hi = lo + int(r['size']) - 1
        rng = '%04X' % lo if hi == lo else '%04X-%04X' % (lo, hi)
        m = '%04X_%%pc%%_%%(d5ce)%%_%%(d5cf)%%_%%rombank%%' % lo
        v = '%%(%04x)%%' % lo if hi == lo else 'xx'
        s += ['%s//r/R%s_%s_xx' % (rng, m, v), '%s//w/W%s_%s_%%a%%' % (rng, m, v)]
    return ','.join(s)
WP = wps(W)
RACE = os.environ.get('GBCAM_REPO', '/home/claude/w/clone/Game-Boy-Camera-disassembly') + '/tcrf_check/assets/run_race/race_paths.json'
RV = ['race 1, A every 2nd + Up before each hurdle', 'race 4, A every 16th frame', 'race 1, A every 2nd, then A on the result screen']
CARD_INS = '13:' + ','.join(['Right:4:40'] * 5)
# label: (argv after python3, env additions, [(log label suffix, BGB folder)], port)
BATCH_SEQ = os.environ.get('BATCH_SEQ', 'A:4:100,A:4:60,Right:4:40,A:4:60,Right:4:40,A:4:60,Down:4:60,A:4:100')
SC = collections.OrderedDict([
    ('print_single_1C', (['bgb_print_run.py', CORPUS, '289', ROM, '{OUT}', '--seq', 'A:4:100', '--tail', '4000', '--port', '{PORT}'], {}, 8801)),
    ('print_card_1C', (['bgb_print_run.py', CORPUS, '289', ROM, '{OUT}', '--ins', CARD_INS, '--seq', 'Start:4:40,A:4:100', '--tail', '4000', '--port', '{PORT}'], {}, 8802)),
    ('print_batch_1E', (['bgb_print_run.py', CORPUS, '289', ROM, '{OUT}', '--cut', '10', '--seq', 'Select:4:200,Up:4:60,A:4:300,A:4:300,Right:4:160,A:4:300,' + BATCH_SEQ, '--tail', '4000', '--port', '{PORT}'], {}, 8803)),
    ('print_wild_0', (['bgb_print_wild.py', '0', '{OUT}', '--rom', ROM, '--port', '{PORT}'], {}, 8804)),
    ('print_wild_7', (['bgb_print_wild.py', '7', '{OUT}', '--rom', ROM, '--port', '{PORT}'], {}, 8805)),
    ('dj_print', (['bgb_dj_print.py', '{OUT}', '--print', '--tail', '3000', '--port', '{PORT}'], {}, 8806)),
    ('dj_print_noise', (['bgb_dj_print.py', '{OUT}', '--print', '--select', '2', '--tail', '3000', '--port', '{PORT}'], {}, 8807)),
    ('err_card_inq80', (['bgb_print_run.py', CORPUS, '289', ROM, '{OUT}', '--ins', CARD_INS, '--seq', 'Start:4:40,A:4:100', '--tail', '4000', '--port', '{PORT}'], {'PRN_ERR': 'inq:12:80'}, 8808)),
    ('err_dj_dataFF', (['bgb_dj_print.py', '{OUT}', '--print', '--tail', '3000', '--port', '{PORT}'], {'PRN_ERR': 'data:1:FF'}, 8809)),
    ('show_hotspot', (['bgb_print_run.py', CORPUS, '207', ROM, '{OUT}', '--noprinter', '--seq', 'Right:4:60,A:4:300,Down:4:60,Down:4:60,A:4:400,Right:4:40,Left:4:40,A:4:200', '--tail', '200', '--port', '{PORT}'], {}, 8812)),
    ('show_slideshow', (['bgb_print_run.py', CORPUS, '207', ROM, '{OUT}', '--noprinter', '--seq', 'Right:4:60,A:4:300,A:4:400,A:4:300', '--tail', '200', '--port', '{PORT}'], {}, 8813)),
    ('show_animation', (['bgb_print_run.py', CORPUS, '207', ROM, '{OUT}', '--noprinter', '--seq', 'Right:4:60,A:4:300,Down:4:60,A:4:400,A:4:200,Select:4:60,Select:4:60,Up:4:60,Down:4:60', '--tail', '200', '--port', '{PORT}'], {}, 8814)),
    ('show_animation_music', (['bgb_print_run.py', CORPUS, '207', ROM, '{OUT}', '--noprinter', '--seq', 'Right:4:60,A:4:300,Down:4:60,A:4:400,Select:4:40,Select:4:40,Select:4:40,A:4:200', '--tail', '200', '--port', '{PORT}'], {}, 8815)),
    ('dj_perf_start', (['bgb_dj_print.py', '{OUT}', '--noprinter', '--seq', 'Start:4:150,Start:4:150,Start:50:150,Start:4:150,Start:4:300', '--tail', '600', '--port', '{PORT}'], {}, 8816)),
    ('dj_perf_start_noise', (['bgb_dj_print.py', '{OUT}', '--noprinter', '--select', '2', '--seq', 'Start:4:150,Start:4:150,Start:50:150,Start:4:150,Start:4:300', '--tail', '600', '--port', '{PORT}'], {}, 8817)),
    ('dj_editor', (['bgb_dj_print.py', '{OUT}', '--tail', '3000', '--port', '{PORT}'], {}, 8810)),
    ('dj_editor_sound2', (['bgb_dj_print.py', '{OUT}', '--select', '1', '--tail', '3000', '--port', '{PORT}'], {}, 8811)),
    ('run_race_fast', (['bgb_run_race.py', '{OUT}', RACE, RV[0], RV[1], RV[2]], {'BGB_ONE': '0'}, 'bgbr0')),
    ('run_race_slow', (['bgb_run_race.py', '{OUT}', RACE, RV[0], RV[1], RV[2]], {'BGB_ONE': '1'}, 'bgbr1')),
    ('run_race_result', (['bgb_run_race.py', '{OUT}', RACE, RV[0], RV[1], RV[2]], {'BGB_ONE': '2'}, 'bgbr2')),
    ('link_exchange', (None, {}, 0)),
])
pat = re.compile(r'^([RW])([0-9A-F]{4})_([0-9A-F]{4})_([0-9A-F]{2})_([0-9A-F]{2})_([0-9A-F]{2})_([0-9A-Fx]{2})_([0-9A-Fx]{2})$')
rows = []; lock = threading.Lock()
def count(folder):
    lf = os.path.join(folder, 'debugmsg.txt')
    return collections.Counter(l.strip() for l in open(lf, errors='replace') if l.strip()) if os.path.exists(lf) else collections.Counter()
def add(label, end, cnt):
    with lock:
        for k in sorted(cnt):
            m = pat.match(k)
            if m: rows.append([label, '', end] + list(m.groups()) + [cnt[k]])
def run(label):
    argv, env, port = SC[label]; o = '/tmp/wram_probe_scen/' + label; shutil.rmtree(o, ignore_errors=True); os.makedirs(o)
    e = dict(os.environ, BGB_WP=WP, BGB_HF='-headless', **env)
    if label == 'link_exchange':
        e['WPS_SENDER'] = WP
        sv = ROOT + '/link_protocol/saves/'
        if not os.path.exists(sv): sv = os.environ.get('GBCAM_REPO', '/home/claude/w/clone/Game-Boy-Camera-disassembly') + '/link_protocol/saves/'
        for d in ('sender', 'receiver'):
            if os.path.exists('/home/claude/bgbl_%s/debugmsg.txt' % d): os.remove('/home/claude/bgbl_%s/debugmsg.txt' % d)
        p = subprocess.run([sys.executable, T + '/bgb_link_wp.py', ROM, sv + 'flow1_A_sender_before.sav', sv + 'flow1_B_receiver_before.sav', o + '/x', WP], cwd=ROOT, env=e, capture_output=True, text=True, timeout=1500)
        end = ' | '.join(l for l in p.stdout.splitlines() if 'mode:state' in l)[:200]
        add('link_exchange.sender', end, count('/home/claude/bgbl_sender')); add('link_exchange.receiver', end, count('/home/claude/bgbl_receiver'))
    else:
        a = [x.replace('{OUT}', o).replace('{PORT}', str(port)) for x in argv]
        p = subprocess.run([sys.executable, T + '/' + a[0]] + a[1:], cwd=ROOT, env=e, capture_output=True, text=True, timeout=1500)
        end = ' | '.join(l.strip() for l in p.stdout.splitlines() if 'BGB end' in l or 'pages' in l)[:240]
        if label.startswith('run_race'): end = ' | '.join(l.strip()[:200] for l in p.stdout.splitlines() if l.startswith('{"variant"'))[:240]
        add(label, end, count('/home/claude/' + port if isinstance(port, str) else '/home/claude/bgbpr%d' % (port % 100)))
    open(o + '/stdout.txt', 'w').write(p.stdout + '\n--- stderr\n' + p.stderr[-2000:])
    print(label, '|', end, flush=True)
Q = queue.Queue()
for k in SC:
    if not only or k in only.split(','): Q.put(k)
def slot():
    while True:
        try: k = Q.get_nowait()
        except queue.Empty: return
        try: run(k)
        except Exception as ex: print(k, 'FAILED', type(ex).__name__, ex, flush=True)
th = [threading.Thread(target=slot) for _ in range(workers)]
for t in th: t.start()
for t in th: t.join()
with open(out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['entry', 'sig', 'end', 'kind', 'addr', 'pc', 'mode', 'state', 'rombank', 'value', 'a', 'hits']); w.writerows(rows)
print('->', out, len(rows), 'rows')
