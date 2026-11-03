import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lib; from lib import g
C = lib.Corpus('unlock_runs/f1_organic/corpus.jsonl')
i = C.best((1, 4)) or C.best((1, 0))
p = C.path(i); sp = dict(C.E[p[0]]['spec'])
def to_parlor():
    lib.boot(lib.SAV(sp['sav']), combo=sp['combo'], printer=sp['printer'], free=sp['free'])
    for j in p[1:]:
        for a in C.E[j]['actions']: lib.act(a)
    g.run(60)
print('entry', i, 'reached', '%02X:%02X' % lib.cur())
# cursor layout: left column SHOOT, ITEMS, MAGIC ; right column CHECK, RUN
paths = {'SHOOT': [], 'ITEMS': ['D'], 'MAGIC': ['D', 'D'], 'CHECK': ['R'], 'RUN': ['R', 'D']}
for name, mv in paths.items():
    to_parlor(); s0 = '%02X:%02X' % lib.cur()
    lib.play(' '.join(mv) if mv else 'w1', hold=4, wait=20)
    lib.play('A', hold=4, wait=20); seen = []
    for _ in range(40):
        g.run(10); c = '%02X:%02X' % lib.cur()
        if not seen or seen[-1] != c: seen.append(c)
    print('%-6s from %s -> %s' % (name, s0, ' '.join(seen)))
