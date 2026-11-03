import sys, os, json, time
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')   # the working root of README 16.15 (core, tools/lib.py, the ROM)
BGBX = os.environ.get('BGB_DIR', '/home/claude/bgbx')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgbgrab as B
from multiprocessing import Pool
OUT = ROOT + '/work/bgb'
def seq_wait(n): return [('-', n, 0)]
TAPS = lambda keys: [(k, 3, 6) for k in keys]
def jobs():
    J = []
    # parlor: page A menu, then RUN with different waits (the game's RNG depends on timing)
    J.append(('parlor_menuA', 342, seq_wait(120)))
    for w in range(0, 64, 5):
        J.append(('parlor_run_w%02d' % w, 342, seq_wait(30 + w) + TAPS(['Up', 'Up', 'Up', 'Left', 'Left', 'Right', 'Down']) + [('A', 4, 250)]))
    # credits: page A, page B, 13 girl frames, text pages, ending
    J.append(('credits_pageA', 2393, seq_wait(200)))
    J.append(('credits_pageB', 2393, seq_wait(700)))
    for k in range(13): J.append(('credits_girl%02d' % k, 2393, seq_wait(1010 + 12 * k)))
    for t in range(2000, 12500, 900): J.append(('credits_roll_%05d' % t, 2393, seq_wait(t)))
    J.append(('credits_end_picture', 2393, seq_wait(12800)))
    # dancing man (the short credits that B on page B reaches)
    J.append(('credits_man_a', 2422, seq_wait(60)))
    J.append(('credits_man_b', 2422, seq_wait(700)))
    J.append(('credits_man_c', 2422, seq_wait(3200)))
    return J
def work(args):
    wid, job = args
    name, ent, seq = job
    d = os.path.join(os.path.dirname(BGBX), 'bgbw%d' % wid)
    i, sp, base, sav = B.entry(ent)
    t = time.time()
    r = B.grab('%s/%s' % (OUT, name), sp, sav, base + seq, bgbdir=d, tail=2)
    w = r['st'].get('WRAM', b'')
    info = dict(name=name, rc=r['rc'], mode=r['mode'], state=r['state'], dbcf=w[0x1BCF] if w else None, song=w[0x1D69] if w else None, secs=round(time.time() - t, 1))
    print(json.dumps(info), flush=True)
    open('%s/%s.vram' % (OUT, name), 'wb').write(r['st'].get('VRAM', b''))
    open('%s/%s.oam' % (OUT, name), 'wb').write(r['st'].get('OAM', b''))
    open('%s/%s.wram' % (OUT, name), 'wb').write(w)
    return info
if __name__ == '__main__':
    J = jobs()
    only = sys.argv[1:]
    if only: J = [j for j in J if any(j[0].startswith(o) for o in only)]
    args = [(k % 2, j) for k, j in enumerate(J)]
    with Pool(2) as p: res = p.map(work, args, chunksize=1)
    json.dump(res, open(OUT + '/jobs_%s.json' % ('_'.join(only) or 'all'), 'w'))
