#!/usr/bin/env python3
"""Which screens of the Japanese ROM use the STAT interrupt, and what the tile-data flip of STAT handler 1 (00:0B43) does to the picture (README 16.2, section "The STAT split").
`capture` replays, in BGB, the cheapest entry of the organic corpus for every (mode, state) signature it holds, and saves the state, the LCD picture and the interrupt registers at the end of the replay
(HRAM FFC5 = handler index, FFAF / FFB5 = split line, FFAB = LCDC shadow, FFAC bit 6 = STAT interrupt wanted, IE bit 1 = STAT interrupt enabled).
`report` classifies the end screens: the split runs only where FFAC bit 6 and IE bit 1 are set, whatever FFC5 says; for the screens with handler 1 it renders the state with gb_screen.py without and with the flip at every
scanline and prints the range of lines that reproduces the BGB picture to the pixel.  Window screens (LCDC bit 5) are listed but not tested (gb_screen has no window layer).
usage: stat_split_census.py capture ROM CORPUS OUTDIR [--worker I --workers N]    (saves: saves_unl / saves / saves_pseudo of /home/claude/gbcam_jp)
       stat_split_census.py report ROM OUTDIR OUT.csv"""
import sys, os, json, csv
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
names = lambda k: '+'.join(n for m, n in CORE if k & m) or '-'
SAVES = '/home/claude/gbcam_jp/saves_unl:/home/claude/gbcam_jp/saves:/home/claude/gbcam_jp/saves_pseudo'.split(':')

def cheapest(corpus):
    C = {}
    for l in open(corpus):
        if l.strip(): e = json.loads(l); C[e['id']] = e
    def cost(i):
        t = 0
        while i >= 0 and i in C: t += sum(a[1] + a[2] for a in C[i].get('actions', [])); i = C[i].get('parent', -1)
        return t
    best = {}
    for i, e in C.items():
        s = '%d:%d' % tuple(e['sig']); c = cost(i)
        if s not in best or c < best[s][0]: best[s] = (c, i)
    return C, best

def capture(rom, corpus, out, worker=0, workers=1):
    import bgb_run
    os.makedirs(out, exist_ok=True); C, best = cheapest(corpus)
    res = open(os.path.join(out, 'res%d.jsonl' % worker), 'a')
    for n, k in enumerate(sorted(best, key=lambda k: best[k][0])):
        if n % workers != worker: continue
        pre = os.path.join(out, 's' + k.replace(':', '_'))
        if os.path.exists(pre + '.sna'): continue
        p = []; i = best[k][1]
        while i >= 0 and i in C: p.append(i); i = C[i].get('parent', -1)
        p = p[::-1]; sp = dict(C[p[0]]['spec']); seq = [(names(a[0]), int(a[1]), int(a[2])) for j in p[1:] for a in C[j]['actions']]
        sav = next((os.path.join(d, sp['sav'] + '.sav') for d in SAVES if os.path.exists(os.path.join(d, sp['sav'] + '.sav'))), None)
        r = bgb_run.run(rom, sav, pre, seq, combo=bgb_run.mask(names(sp['combo'])) if sp['combo'] else 0, free=sp['free'] + 3, tail=0, timeout=600)
        st = r['st']; h = st['HRAM']
        res.write(json.dumps(dict(sig=k, mode=r['mode'], state=r['state'], ffc5=h[0x45], ffac=h[0x2C], ie=st['IE'][0], ffaf=h[0x2F], ffb5=h[0x35], ffab=h[0x2B])) + '\n'); res.flush()
        if os.path.exists(pre + '.dem'): os.remove(pre + '.dem')

def report(rom_path, out, csv_path):
    import bgb_run, gb_screen, menu_screen_gif as M
    mode_names = {}
    for r in csv.DictReader(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'roms', 'jp_rev_a', 'disasm', 'const_names_jp.csv'))):
        if r['group'] == 'mode' and r['value'] != 'ff': mode_names[int(r['value'], 16)] = r['name']
    rows = {}
    for f in sorted(os.listdir(out)):                                       # one row per end screen; the registers come from the saved state
        if f.startswith('res') and f.endswith('.jsonl'):
            for l in open(os.path.join(out, f)):
                if not l.strip(): continue
                sig = json.loads(l)['sig']; pre = os.path.join(out, 's' + sig.replace(':', '_'))
                if not os.path.exists(pre + '.sna'): continue
                st = bgb_run.read_state(pre + '.sna'); h = st['HRAM']; w = st['WRAM']
                rows.setdefault((w[0x15CE], w[0x15CF]), dict(sig=sig, ffc5=h[0x45], ffac=h[0x2C], ie=st['IE'][0], ffaf=h[0x2F], ffab=h[0x2B]))
    outrows = []
    for (m, s), r in sorted(rows.items()):
        pre = os.path.join(out, 's' + r['sig'].replace(':', '_'))
        irq = bool(r['ie'] & 2) and bool(r['ffac'] & 0x40)
        row = dict(screen='%02X:%02X' % (m, s), mode=mode_names.get(m, ''), handler=r['ffc5'], line=r['ffaf'], stat_irq='on' if irq else 'off', lcdc='%02X' % r['ffab'], window='yes' if r['ffab'] & 0x20 else '', exact_lines='', px_unsplit='', px_split='')
        if irq and r['ffc5'] == 1 and not r['ffab'] & 0x20:
            st = bgb_run.read_state(pre + '.sna'); ref = M.shot(pre + '.bmp'); a = (st['SCX'][0], st['SCY'][0], st['BGP'][0], st['OBP'][0], st['OBP'][1])
            top = gb_screen.render(st['VRAM'], st['OAM'], r['ffab'], *a)
            d = [int((gb_screen.render_split(st['VRAM'], st['OAM'], r['ffab'], l, *a) != ref).sum()) for l in range(145)]
            ok = [l for l in range(145) if d[l] == 0]
            row['px_unsplit'] = int((top != ref).sum()); row['px_split'] = min(d[60:130])
            if ok: row['exact_lines'] = '%d-%d' % (ok[0], ok[-1])
        outrows.append(row)
    cols = ['screen', 'mode', 'handler', 'line', 'stat_irq', 'lcdc', 'window', 'exact_lines', 'px_unsplit', 'px_split']
    with open(csv_path, 'w', newline='') as f:
        w = csv.DictWriter(f, cols, lineterminator='\n'); w.writeheader(); w.writerows(outrows)
    on = [r for r in outrows if r['stat_irq'] == 'on']; h1 = [r for r in on if r['handler'] == 1]
    tested = [r for r in h1 if r['px_split'] != '']; exact = [r for r in tested if r['px_split'] == 0]
    print('%d end screens: STAT interrupt on in %d, handler 1 in %d of those (%d tested without a window layer, %d reproduced to the pixel by the flip); FFC5 = 1 and the interrupt off in %d screens'
          % (len(outrows), len(on), len(h1), len(tested), len(exact), sum(1 for r in outrows if r['stat_irq'] == 'off' and r['handler'] == 1)))
    return outrows

if __name__ == '__main__':
    a = sys.argv[1:]
    opt = lambda k, d: type(d)(a[a.index(k) + 1]) if k in a else d
    if a and a[0] == 'capture': capture(a[1], a[2], a[3], opt('--worker', 0), opt('--workers', 1))
    elif a and a[0] == 'report': report(a[1], a[2], a[3])
    else: print(__doc__)
