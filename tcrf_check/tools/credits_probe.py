import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
c = [(C.frames(i), i) for i, e in C.E.items() if tuple(e['sig']) == (8, 0x16)]
i = min(c)[1]; p = C.path(i); sp = dict(C.E[p[0]]['spec'])
def run(sav, combo, label):
    lib.boot(lib.SAV(sav), combo=combo, printer=sp['printer'], free=sp['free'])
    tr = []
    for j in p[1:]:
        for a in C.E[j]['actions']:
            lib.act(a); tr.append(lib.cur())
    seen = []
    for t in tr:
        if not seen or seen[-1] != t: seen.append(t)
    print(label, 'final', '%02X:%02X' % lib.cur(), 'reached 08:1x', sorted({'%02X:%02X' % t for t in seen if t[0] == 8 and t[1] >= 0x11}))
print('orig save', sp['sav'], 'combo', sp['combo'])
run(sp['sav'], sp['combo'], 'orig')
run(sp['sav'], 0, 'combo0')
base = sp['sav'].replace('unl_', '')
run(base, sp['combo'], 'non-unlocked save, combo')
run(base, 0, 'non-unlocked save, combo0')
