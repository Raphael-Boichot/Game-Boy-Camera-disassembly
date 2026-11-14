#!/usr/bin/env python3
"""Replay one entry of the replay corpus in the real BGB (Windows exe under wine, headless) with *logging watchpoints* and count the hits.

BGB writes one line to debugmsg.txt for every watchpoint hit and goes on (the message is the last field of the -wp item), so a read, a write or an execution
of a ROM byte can be proven or refuted on the real emulator: the counts below are the whole output.

usage: bgb_wp_probe.py CORPUS ENTRY WATCHPOINTS OUTPREFIX [--rom ROM] [--saves DIR[:DIR...]] (default saves_unl:saves:saves_pseudo of the working root) [--system 0] [--tail FRAMES]
  CORPUS       corpus.jsonl of the replay search (entries with id, parent, actions, spec of the root; coverage_run/merged_corpus_v3/corpus.jsonl)
  ENTRY        id of the entry to replay (the lineage of root save + joypad actions is replayed from the boot)
  WATCHPOINTS  BGB -wp list, comma separated: ADDRESS[/VALUE][/drwxj][/MESSAGE] written as  BB:AAAA-BB:AAAA//r/NAME  (range, any value, read access, message NAME)
               or BB:AAAA//x/NAME for an execution; use a CONTROL watchpoint on bytes that the replay certainly reads (a table the code indexes), so that a count
               of 0 on the real target means "not read" and not "watchpoint broken"
Environment: BGB_DIR (a private copy of the BGB folder is made at /home/claude/bgbp_wp if it does not exist: debugmsg.txt lives there).
Example (L3 pass of 2026-10-14, entry 783 = erase one photo, ends in mode 0F state 02 after Mode0F_State09_EraseOne ran twice):
  bgb_wp_probe.py merged_corpus_v3/corpus.jsonl 783 '04:4493-04:44B0//r/CTL,04:4D09-04:4D1A//r/T4D09,04:4C8D//x/S09ENTRY,04:4D08//x/S09RET' out/e783
  -> {'CTL': 12, 'S09ENTRY': 2, 'S09RET': 2}   (the 18 bytes 04:4D09-4D1A were never read)"""
import sys, os, json, shutil, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
args = sys.argv[1:]
def opt(name, default=None):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return default
rom = opt('--rom', os.path.join(os.path.dirname(os.path.dirname(HERE)), 'pocketcamera_jp.gb'))
saves = opt('--saves', '/home/claude/gbcam_jp/saves_unl:/home/claude/gbcam_jp/saves:/home/claude/gbcam_jp/saves_pseudo').split(':')      # saves_pseudo: _zero.sav / _ff.sav = 128 KB of $00 / $FF, the roots of the corpus that start from an empty SRAM
system = opt('--system', '0'); tail = int(opt('--tail', '60'))
corpus, entry, wps, out = args[0], int(args[1]), args[2], args[3]
mine = os.environ.get('BGB_DIR', '/home/claude/bgbp_wp')
if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
os.environ['BGB_DIR'] = mine
import bgb_run
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
C = {}
for l in open(corpus):
    if l.strip(): e = json.loads(l); C[e['id']] = e
p = []; i = entry
while i >= 0 and i in C: p.append(i); i = C[i].get('parent', -1)
p = p[::-1]; sp = dict(C[p[0]]['spec']); seq = []
for j in p[1:]:
    for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
sav = None
for d in saves:
    f = os.path.join(d, sp['sav'] + '.sav')
    if os.path.exists(f): sav = f; break
log = os.path.join(mine, 'debugmsg.txt')
if os.path.exists(log): os.remove(log)
os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)
r = bgb_run.run(rom, sav, out, seq, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3,
                extra=['-wp', wps, '-setting', 'DebugMsgFile=1', '-setting', 'SystemMode=%s' % system], tail=tail, timeout=1500)
cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
print('save', sav, 'actions', len(seq))
print('end mode:state %s:%s' % (r['mode'], r['state']), 'pc', r['pc'] and hex(r['pc']))
print(dict(cnt))
