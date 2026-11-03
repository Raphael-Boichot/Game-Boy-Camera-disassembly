#!/usr/bin/env python3
"""Relocation test of the source tree roms/jp_rev_a/src/: move every byte of a bank and check that the game still behaves the same.

usage: python3 tools/relocation_test.py --rom pocketcamera_jp.gb --core DIR [--banks 03,04,...] [--shift 16] [--corpus FILE] [--saves DIR[,DIR]] [--limit N] [--out CSV]

For each bank B: a copy of the tree gets `ds SHIFT, $00` right after the SECTION line of bank_BB.asm (every routine, table and asset of the bank
moves up by SHIFT bytes) and SHIFT bytes less of the padding that ends the bank; it must build (rgbds, as tools/make_source.py does). Then the
core of coverage/src (DIR holds gbcov.py and the built library: `cc -O2 -shared -fPIC -o libgbcov.so gbcov.c`) replays the entries of an organic
corpus (tcrf_check / coverage runs: unlock_runs/f1_organic/corpus.jsonl) on the original build and on the moved one, and compares at the end of
every entry what the player sees and where the game is: VRAM $8000-$9FFF, OAM $FE00-$FE9F, the LCD registers $FF40-$FF4B, wMode / wState. WRAM is
not compared (it holds ROM pointers, which move). An entry whose root save is missing is skipped. A bank passes when no entry differs; the CSV
gives per bank the entries replayed, the entries that differ (first ids), and how many bytes of the bank the moved build executed or read."""
import argparse, csv, hashlib, json, os, re, shutil, sys, tempfile

HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import make_source

ap = argparse.ArgumentParser()
ap.add_argument('--rom', required=True); ap.add_argument('--core', required=True)
ap.add_argument('--banks', default='03,04,06,07,08,09,27'); ap.add_argument('--shift', type=int, default=16)
ap.add_argument('--corpus', default='/home/claude/gbcam_jp/unlock_runs/f1_organic/corpus.jsonl')
ap.add_argument('--saves', default='/home/claude/gbcam_jp/saves_unl,/home/claude/gbcam_jp/saves')
ap.add_argument('--limit', type=int, default=0); ap.add_argument('--entries', default='', help='only these corpus entries (comma separated)'); ap.add_argument('--no-md5', action='store_true', help='the tree is a modified one (an experiment): do not require the original md5'); ap.add_argument('--rgbds', default=os.environ.get('RGBDS'))
ap.add_argument('--src', default=os.path.join(REPO, 'roms', 'jp_rev_a', 'src')); ap.add_argument('--out')
ap.add_argument('--worker', nargs=3, metavar=('ROM', 'OUT', 'BANK'), help=argparse.SUPPRESS)   # one replay per process: the core keeps state between ROMs
a = ap.parse_args()

SAVES = {'_zero': bytes(0x20000), '_ff': b'\xff' * 0x20000}
for d in a.saves.split(','):
    if os.path.isdir(d):
        for f in os.listdir(d):
            if f.endswith('.sav'): SAVES.setdefault(f[:-4], open(os.path.join(d, f), 'rb').read())
E = [json.loads(l) for l in open(a.corpus)]
root = {}
for e in E: root[e['id']] = e['spec']['sav'] if 'spec' in e else root[e['parent']]
ids = [e['id'] for e in E if root[e['id']] in SAVES]
if a.limit: ids = ids[:a.limit]
if a.entries: ids = [i for i in ids if str(i) in a.entries.split(',')]
need = set()
for i in ids:
    j = i
    while j != -1 and j not in need: need.add(j); j = E[j]['parent'] if 'actions' in E[j] else -1
children = {}
for i in need:
    if 'actions' in E[i]: children[E[i]['parent']] = children.get(E[i]['parent'], 0) + 1


def act(x):
    if x[0] == 'P':
        _, pf, wait, pairs = x
        for _ in range(pf):
            for ad, v in pairs: g.poke(ad, v)
            g.run(1)
        g.run(wait)
    else:
        k, hold, wait = x; g.keys(k); g.run(hold); g.keys(0); g.run(wait)


def fingerprint():
    h = hashlib.md5()
    for lo, hi in ((0x8000, 0xA000), (0xFE00, 0xFEA0), (0xFF40, 0xFF4C)):
        h.update(bytes(g.peek(x) for x in range(lo, hi)))
    return h.hexdigest(), (g.peek(0xD5CE), g.peek(0xD5CF))


def replay(rom):
    import gbcov as g
    globals()['g'] = g
    g.load_rom(rom); g.set_organic(0); snaps = {}; left = dict(children); out = {}
    for i in sorted(need):
        e = E[i]
        if 'spec' in e:
            sp = e['spec']; g.reset(SAVES[sp['sav']]); g.L.gb_attach_printer(1 if sp['printer'] else 0)
            g.keys(sp['combo']); g.run(250); g.keys(0); g.run(sp['free'])
        else:
            g.restore(snaps[e['parent']])
            for x in e['actions']: act(x)
            left[e['parent']] -= 1
            if not left[e['parent']]: snaps.pop(e['parent'])
        if left.get(i): snaps[i] = g.snapshot()
        out[i] = fingerprint()
    return out


if a.worker:
    sys.path.insert(0, a.core)
    rom, out, wb = a.worker
    got = replay(rom); o = int(wb, 16) * 0x4000
    seen = int(((g.cov_exec()[o:o + 0x4000] > 0) | (g.cov_dread()[o:o + 0x4000] > 0)).sum()) if int(wb, 16) else 0
    json.dump({'fp': {str(k): v for k, v in got.items()}, 'seen': seen}, open(out, 'w'))
    sys.exit(0)


def replay_in_process(rom, bank):
    import subprocess
    out = rom + '.json'
    p = subprocess.run([sys.executable, os.path.abspath(__file__), '--rom', a.rom, '--core', a.core, '--corpus', a.corpus, '--saves', a.saves, '--limit', str(a.limit), '--entries', a.entries,] + (['--no-md5'] if a.no_md5 else []) + [
                        '--worker', rom, out, '%02x' % bank], capture_output=True, text=True)
    if p.returncode: sys.exit('relocation_test: replay failed: ' + p.stderr[-500:])
    d = json.load(open(out)); return {int(k): (v[0], tuple(v[1])) for k, v in d['fp'].items()}, d['seen']


tmp = tempfile.mkdtemp(prefix='reloc_')
base = os.path.join(tmp, 'base.gb')
if make_source.build(a.src, base, a.rgbds) != make_source.MD5 and not a.no_md5: sys.exit('relocation_test: the tree does not build the ROM')
ref, _ = replay_in_process(base, 0)
rows = []
def move(w, b, shift=None):
    """Insert SHIFT bytes after the SECTION line of bank b in tree w and take them from its end padding; False when the bank has too little."""
    p = os.path.join(w, 'bank_%03x.asm' % b); L = open(p, encoding='utf-8').read().rstrip('\n').split('\n')
    if b == 0:                               # bank 0: the vectors and the header stay; everything from $0150 to the zero fill at $356C moves
        k0 = next(k for k, l in enumerate(L) if l.rstrip().endswith('; $0150'))
        while L[k0 - 1] and not L[k0 - 1][:1].isspace() and not L[k0 - 1].startswith(';'): k0 -= 1
        kz = next(k for k, l in enumerate(L) if 'INCBIN "data/bank_00/Bank00_ZeroFill.bin"' in l)
        n = int(re.search(r'(\d+) bytes', L[kz]).group(1)); sh = shift or a.shift
        L[kz] = '    ds %d, $00 ; relocation test: the zero fill gives %d bytes' % (n - sh, sh)
        L.insert(k0, '    ds %d, $00 ; relocation test: everything below moves up by %d bytes' % (sh, sh))
        open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n'); return True
    sec = next(k for k, l in enumerate(L) if l.startswith('SECTION'))
    last = max(k for k, l in enumerate(L) if l.strip())
    m = re.match(r'^(\s+ds )\$([0-9a-f]+)(, \$[0-9a-f]{2}.*)$', L[last])
    sh = shift or a.shift
    if any(l.lstrip().startswith('ASSERT LOW(') for l in L) and sh % 256: sh = 256      # page-aligned tables: move by whole pages
    if not m or int(m.group(2), 16) < sh: return False
    L[last] = '%s$%x%s' % (m.group(1), int(m.group(2), 16) - sh, m.group(3))
    L.insert(sec + 1, '    ds %d, $00 ; relocation test: everything below moves up by %d bytes' % (sh, sh))
    open(p, 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n'); return True
if a.banks == 'all':                         # every switchable bank moved at once: one replay for the whole ROM
    w = os.path.join(tmp, 'src_all'); shutil.copytree(a.src, w)
    moved_banks = [b for b in range(0, 64) if move(w, b)]
    moved = os.path.join(tmp, 'moved_all.gb')
    try: make_source.build(w, moved, a.rgbds)
    except SystemExit as ex: sys.exit('relocation_test: the moved tree does not build: %s' % str(ex)[:400])
    got, touched = replay_in_process(moved, 0)
    diff = [i for i in ids if got[i] != ref[i]]
    rows.append(('all (%d banks; not moved: %s)' % (len(moved_banks), ' '.join('%02X' % b for b in range(0, 64) if b not in moved_banks)), 'pass' if not diff else 'FAIL', len(ids), ' '.join(str(i) for i in diff), ''))
    print(rows[-1][:3] + (' '.join(str(i) for i in diff[:12]) + (' ... (%d)' % len(diff) if len(diff) > 12 else ''),), flush=True); a.banks = ''
for bs in [x for x in a.banks.split(',') if x]:
    b = int(bs, 16); w = os.path.join(tmp, 'src_%02x' % b)
    shutil.rmtree(w, ignore_errors=True); shutil.copytree(a.src, w)
    if not move(w, b): rows.append(('%02X' % b, 'no end padding of %d bytes' % a.shift, '', '', '')); print(rows[-1]); continue
    moved = os.path.join(tmp, 'moved_%02x.gb' % b)
    try: md5 = make_source.build(w, moved, a.rgbds)
    except SystemExit as ex: rows.append(('%02X' % b, 'does not build', str(ex)[:200], '', '')); print(rows[-1]); continue
    got, touched = replay_in_process(moved, b)
    diff = [i for i in ids if got[i] != ref[i]]
    rows.append(('%02X' % b, 'pass' if not diff else 'FAIL', len(ids), ' '.join(str(i) for i in diff), touched))
    print(rows[-1][:3] + (' '.join(str(i) for i in diff[:12]) + (' ... (%d)' % len(diff) if len(diff) > 12 else ''), touched), flush=True)
if a.out:
    with open(a.out, 'w', newline='') as fh:
        wr = csv.writer(fh, lineterminator='\n'); wr.writerow(('bank', 'result', 'entries', 'differing entries', 'bytes of the bank run or read'))
        wr.writerows(rows)
shutil.rmtree(tmp, ignore_errors=True)
