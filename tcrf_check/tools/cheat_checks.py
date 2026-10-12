#!/usr/bin/env python3
"""The hidden-feature ("secret") lines of the GameFAQs cheats page tried with the keys only, in my core and in the real BGB (README 16.18):
title screen Up / Down (animation speed), VIEW menu Up / Down (speed of the face-in-face animation), D.J. screen: hold A (scratch), slide-show menu: Select reveals the BGM and shuffle options,
boot with Start + Select held (erase-the-game prompt), erase-album shortcut Select + Start + Up ("erase ALL photos?", A / B).
Every scenario starts from a corpus entry (joypad-only path from a boot, no RAM poke) or from a boot with a boot-time key combination, presses keys, and reads a few WRAM / SRAM bytes at the end.
usage: cheat_checks.py core OUTDIR | bgb OUTDIR | both OUTDIR      (run from the working root; ROM pocketcamera_jp.gb; BGB runs use private directories /home/claude/bgbc<K> copied from /home/claude/bgbx,
                                                                      3 at a time; GBCAM_CORE as for the other core tools)
Writes OUTDIR/cheat_checks.csv: scenario, core end state and readings, BGB end state and readings."""
import sys, os, json, csv, hashlib, subprocess, shutil
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); ROOT = os.path.dirname(HERE)
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'
def bits(s): return sum(m for m, n in CORE if n in s.split('+'))
BOOT_SAV = 'unl_CE10238211'
# root kinds: ('entry', id) = replay of the corpus entry then 60 idle frames; ('boot', sav, combo) = boot with the keys of `combo` held 250 frames; ('dj',) = the route to the D.J. performance screen
R = lambda addr, size=1: (addr, size)
# breakpoints logged in BGB (DebugMsgFile): the branch of each cheat. 08:744E = title, Up held (forces the animation counter D510 to $FF), 08:7459 = Down held (extra frame wait), 08:74AA = the script advances;
# 07:530D / 07:5315 = VIEW menu Up / Down (mask 3 / 15); 05:50AD = D.J. scratch kept going while A is held, 05:509F = A released, 05:50B9 = end of the scratch
TITLE_P = ['08:744E', '08:7459', '08:74AA']; VIEW_P = ['07:530D', '07:5315']; DJ_P = ['05:508C', '05:50AD', '05:509F', '05:50B9']
BGB_SLIDE = [('A', 4, 200), ('Left', 4, 60), ('A', 4, 300), ('Right', 4, 60), ('A', 4, 300), ('A', 4, 200)]       # BGB: title -> main menu -> VIEW (02:01) -> 0B:01 -> slide-show menu 0D:01 (checked in BGB)
SC = []
def add(group, name, root, steps, read, note='', probes=(), bgb_root=None): SC.append(dict(group=group, name=name, root=root, steps=steps, read=read, note=note, probes=list(probes), bgb_root=bgb_root))
for nm, k in (('no key', '-'), ('Up held 36 frames', 'Up'), ('Down held 36 frames', 'Down')):
    add('title screen (19:03)', nm, ('entry', 0), [(k, 36, 0)], dict(D500_script_index=R(0xD500), D510_frame_counter=R(0xD510)), 'page: Up = faster, Down = slower', probes=TITLE_P)
for nm, k in (('no key', '-'), ('Up held 40 frames', 'Up'), ('Down held 40 frames', 'Down')):
    add('VIEW menu (02:01)', nm, ('entry', 208), [(k, 40, 0)], dict(D679_period_mask=R(0xD679)), 'page: Up = faster, Down = slower', probes=VIEW_P)
add('D.J. screen (1F:05)', 'A held 100 frames', ('dj',), [('A', 100, 0)], dict(D897_script=R(0xD897), D8A6_timer=R(0xD8A6)), 'page: hold A = keep scratching', probes=DJ_P)
add('D.J. screen (1F:05)', 'A tapped (4 frames), 60 more', ('dj',), [('A', 4, 60)], dict(D897_script=R(0xD897), D8A6_timer=R(0xD8A6)), probes=DJ_P)
add('D.J. screen (1F:05)', 'A held 100 frames, released, 60 more', ('dj',), [('A', 100, 60)], dict(D897_script=R(0xD897), D8A6_timer=R(0xD8A6)), probes=DJ_P)
SS = dict(D7D2_bgm_option=R(0xD7D2), D7D3_order_option=R(0xD7D3), D674_bgm_choice=R(0xD674))
for nm, ks in (('Select', ['Select']), ('Select, Select', ['Select', 'Select']), ('Select, Up', ['Select', 'Up']), ('Select, Up, Left, A', ['Select', 'Up', 'Left', 'A']),
               ('Select, Up, Right, A', ['Select', 'Up', 'Right', 'A']), ('Select, Down', ['Select', 'Down']), ('Select, Down, Left, A', ['Select', 'Down', 'Left', 'A']),
               ('Select, Down, Right, A', ['Select', 'Down', 'Right', 'A']), ('Select, Up, B', ['Select', 'Up', 'B'])):
    add('slide-show menu (0D:01)', nm, ('entry', 300), [(k, 4, 40) for k in ks], SS, 'page: Select = BGM / shuffle options, Up = BGM, Down = shuffle, Select again = exit', bgb_root=(170, BGB_SLIDE))
for nm, ks in (('no key', []), ('B (cancel)', [('B', 4, 400)]), ('A (erase)', [('A', 4, 400)])):
    add('boot with Start+Select', nm, ('boot', BOOT_SAV, bits('Start+Select')), ks, dict(SRAM_md5=R(-1, 0), photo_slot_0_first_8_bytes=R(-2, 8)), 'page: A confirms, B cancels')
add('boot, no key (control)', 'no key', ('boot', BOOT_SAV, 0), [('A', 4, 400)], dict(SRAM_md5=R(-1, 0), photo_slot_0_first_8_bytes=R(-2, 8)))
ERASE = dict(D561_photo_count=R(0xD561), DBCD_erase_all_variant=R(0xDBCD))
add('erase album (0F:03)', 'Select+Start+Up held 12 frames', ('entry', 656), [('-', 120, 0), ('Select+Start+Up', 12, 60)], ERASE, 'page: Select+Start+Up, A confirms, B cancels')
add('erase album (0F:03)', '... then B', ('entry', 656), [('-', 120, 0), ('Select+Start+Up', 12, 60), ('B', 4, 200)], ERASE)
add('erase album (0F:03)', '... then A', ('entry', 656), [('-', 120, 0), ('Select+Start+Up', 12, 60), ('A', 4, 1500)], ERASE)
add('erase album (0F:03)', '... then B, then the chord again (state 0F:02)', ('entry', 656), [('-', 120, 0), ('Select+Start+Up', 12, 60), ('B', 4, 200), ('Select+Start+Up', 12, 60)], ERASE, 'the second copy of the shortcut, 04:4859-4876 (README 8)')
add('erase album (0F:03)', '... then B, the chord again, then A', ('entry', 656), [('-', 120, 0), ('Select+Start+Up', 12, 60), ('B', 4, 200), ('Select+Start+Up', 12, 60), ('A', 4, 1500)], ERASE)
add('erase album (0F:03), control', 'Select+Start held, no Up', ('entry', 656), [('-', 120, 0), ('Select+Start', 12, 60)], ERASE)
def path_actions(C, entry):
    p = C.path(entry); acts = []
    for j in p[1:]: acts += [(int(a[0]), int(a[1]), int(a[2])) for a in C.E[j]['actions']]
    return C.E[p[0]]['spec'], acts
def route_actions():
    r = json.load(open(os.path.join(ROOT, 'unlock_runs', 'dj_route.json'))); import lib
    C = lib.Corpus(os.path.join(ROOT, r['corpus'])); spec, acts = path_actions(C, r['entry'])
    return r, spec, [(a[0], a[1], a[2]) for a in acts] + [(k, 1, 0) for k in r['shoot']] + [(0, r['after_shoot_idle'], 0)]
def read_core(g, sc):
    out = {}
    for lab, (a, n) in sc['read'].items():
        if a == -1: out[lab] = hashlib.md5(bytes(g.sram()[:0x20000])).hexdigest()[:8]
        elif a == -2: out[lab] = bytes(g.sram()[0x2000:0x2008]).hex()
        else: out[lab] = g.peek(a)
    return out
def run_core(sc):
    import lib; from lib import g
    C = lib.Corpus(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')); g.set_organic(1)
    kind = sc['root'][0]
    if kind == 'entry': C.replay(sc['root'][1]); g.run(60)
    elif kind == 'boot': lib.boot(lib.SAV(sc['root'][1]), combo=sc['root'][2], free=100)
    else:
        r, spec, acts = route_actions(); lib.boot(lib.SAV(spec['sav']), combo=spec['combo'], printer=spec['printer'], free=spec['free'])
        for a in acts: lib.act(a)
    ex0 = lib.exec_baseline()
    for k, hold, wait in sc['steps']: g.keys(bits(k)); g.run(hold); g.keys(0); g.run(wait)
    import numpy as np
    return '%02X:%02X' % lib.cur(), read_core(g, sc), (np.array(g.cov_exec(), copy=True) != 0) & ~ex0
def run_bgb(k, out):
    sc = SC[k]; mine = '/home/claude/bgbc%d' % k
    if not os.path.isdir(mine): shutil.copytree('/home/claude/bgbx', mine)
    os.environ['BGB_DIR'] = mine
    import bgb_run, lib
    rom = os.path.join(ROOT, 'pocketcamera_jp.gb'); kind = sc['root'][0]; seq = []
    if kind == 'entry':
        C = lib.Corpus(os.path.join(ROOT, 'unlock_runs', 'f1_organic', 'corpus.jsonl')); spec, acts = path_actions(C, sc['bgb_root'][0] if sc['bgb_root'] else sc['root'][1])
        seq = [(names(a[0]), a[1], a[2]) for a in acts] + (list(sc['bgb_root'][1]) if sc['bgb_root'] else []) + [('-', 60, 0)]; sav = os.path.join(ROOT, 'saves_unl', spec['sav'] + '.sav'); combo = bgb_run.mask(names(spec['combo'])); free = spec['free'] + 3
    elif kind == 'boot': sav = os.path.join(ROOT, 'saves_unl', sc['root'][1] + '.sav'); combo = bgb_run.mask(names(sc['root'][2])); free = 103
    else:
        r, spec, acts = route_actions(); seq = [(names(a[0]), a[1], a[2]) for a in acts]; sav = os.path.join(out, 'in_ff.sav'); open(sav, 'wb').write(b'\xff' * 0x20000); combo = bgb_run.mask(names(spec['combo'])); free = spec['free'] + 3
    seq += list(sc['steps'])
    log = os.path.join(mine, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    kw = dict(br=','.join('%s///%s' % (a, a) for a in sc['probes']), extra=['-setting', 'DebugMsgFile=1']) if sc['probes'] else {}
    res = bgb_run.run(rom, sav, '%s/run%d' % (out, k), seq, combo=combo, free=free, tail=60, timeout=1800, **kw)
    if sc['probes']:
        import collections
        cnt = collections.Counter(l.strip() for l in open(log, errors='replace') if l.strip()) if os.path.exists(log) else {}
    st = res['st']; w = st.get('WRAM', b''); sr = st.get('SRAM', b''); rd = {}
    for lab, (a, n) in sc['read'].items():
        if a == -1: rd[lab] = hashlib.md5(sr[:0x20000]).hexdigest()[:8]
        elif a == -2: rd[lab] = sr[0x2000:0x2008].hex()
        else: rd[lab] = w[a - 0xC000] if w else None
    if sc['probes']: rd['probe_hits'] = {a: cnt.get(a, 0) for a in sc['probes']}
    return '%02X:%02X' % (res['mode'] or 0, res['state'] or 0), rd
if __name__ == '__main__':
    mode, out = sys.argv[1], sys.argv[2]; os.makedirs(out, exist_ok=True)
    if mode == 'bgb1': k = int(sys.argv[3]); es, rd = run_bgb(k, out); print(json.dumps([es, rd])); sys.exit()
    rows = {sc['name'] + '|' + sc['group']: dict(group=sc['group'], scenario=sc['name'], page=sc['note']) for sc in SC}
    old = os.path.join(out, 'cheat_checks.csv')
    if mode == 'bgb' and os.path.exists(old):
        for r0 in csv.DictReader(open(old)):
            k0 = r0['scenario'] + '|' + r0['group']
            if k0 in rows: rows[k0].update({k: v for k, v in r0.items() if k in ('core_end', 'core')})
    if mode in ('core', 'both'):
        import numpy as np, lib; UNION = np.zeros(len(lib.exec_baseline()), bool)
        for sc in SC:
            es, rd, new = run_core(sc); UNION |= new; r = rows[sc['name'] + '|' + sc['group']]; r['core_end'] = es; r['core'] = json.dumps(rd)
            print('core %-26s %-36s %s %s' % (sc['group'], sc['name'], es, rd), flush=True)
    if mode in ('bgb', 'both'):
        procs = []
        for k, sc in enumerate(SC):
            while len([p for p in procs if p[1].poll() is None]) >= 3: import time; time.sleep(2)
            procs.append((k, subprocess.Popen([sys.executable, __file__, 'bgb1', out, str(k)], stdout=subprocess.PIPE, text=True)))
        for k, pr in procs:
            o = pr.communicate()[0].strip().splitlines(); sc = SC[k]; r = rows[sc['name'] + '|' + sc['group']]
            if o: es, rd = json.loads(o[-1]); r['bgb_end'] = es; r['bgb'] = json.dumps(rd)
            else: r['bgb_end'] = 'no output'
            print('bgb  %-26s %-36s %s %s' % (sc['group'], sc['name'], r.get('bgb_end'), r.get('bgb')), flush=True)
    if mode in ('core', 'both'):
        lib.g.cov_exec()[:] = UNION.astype(np.uint8); lib.dump_exec_ranges(os.path.join(out, 'exec_ranges.csv'), np.zeros(len(UNION), bool))      # bytes executed by the key presses (beyond the root of each scenario)
    with open(os.path.join(out, 'cheat_checks.csv'), 'w', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=['group', 'scenario', 'page', 'core_end', 'core', 'bgb_end', 'bgb'], lineterminator='\n'); w.writeheader(); w.writerows(rows.values())
