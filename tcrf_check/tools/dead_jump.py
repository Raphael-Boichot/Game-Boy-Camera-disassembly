#!/usr/bin/env python3
"""Force the never-executed code of the ROM in the display-tracking core (README 16.26).

Two kinds of forcing, both on a state taken from a normal run (the cheapest corpus entry of every game mode, run on to the idle point of the main loop):
  * JUMP   (UNREFERENCED components = routines that nothing calls): the PC is set to the entry of the component, a return address (the idle PC of the main loop) is pushed,
           the core runs until the code returns there (or N frames pass), then on for AFTER more frames so that the VBlank handler / VRAM copies take effect;
  * FLIP   (UNREACHABLE components = a branch that no value selects): the conditional branch that leads into the component is made to decide the other way
           (gb_force_flip: any `jr cc / jp cc / call cc / ret cc` at that ROM offset), the game runs on from the saved state with the keys given, and the report says
           whether the component ran.
What is recorded per run: the bytes of the component that ran, whether the code came back to the idle PC, the VRAM bytes that changed with the ROM span each came from
(the display core taints every VRAM byte with the ROM offset it was copied from), OAM / LCD register changes, the sound requests (mailboxes $DD60 / $DD68 / $DD70 / $DD78),
WRAM bytes that changed, and (mode, state) before and after.  Nothing is learned about what the code was FOR: a fragment run in the wrong state does what the state makes it do.

Build the core:   cc -O2 -shared -fPIC -o libgbcov_display.so gbcov_display.c      Environment: GBCOV_LIB (that .so), GBCAM_ROOT (default /home/claude/gbcam_jp: saves, corpus).
usage: dead_jump.py CACHE_DIR OUT.json [COMPONENT ...]     (no component = every UNREFERENCED one; names as in assets/reach_components_jp.csv, e.g. 04:7C9D)
"""
import sys, os, csv, json, pickle, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import numpy as np
import display_core as D
g = D.g
REPO = os.path.abspath(os.path.join(HERE, '..', '..'))
CORPUS = os.path.join(os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp'), 'unlock_runs/f1_organic/corpus.jsonl')

def components():
    """{id: dict(bank, verdict, runs=[(start, end)], entry)} from assets/reach_ranges_jp.csv"""
    out = collections.OrderedDict()
    for r in csv.DictReader(open(os.path.join(REPO, 'assets/reach_ranges_jp.csv'))):
        c = out.setdefault(r['component'], dict(bank=int(r['bank'], 16), verdict=r['verdict'], runs=[]))
        c['runs'].append((int(r['start'], 16), int(r['end'], 16)))
    for c in out.values(): c['entry'] = min(s for s, e in c['runs']); c['size'] = sum(e - s + 1 for s, e in c['runs'])
    return out

def bases(cache_dir):
    """one snapshot per game mode: the cheapest organic corpus entry of the mode, run 30 frames on, then on to the main thread's wait for V-Blank (`halt` loop of Rst10_WaitFlagSet, 00:0013, nothing
    interrupted, shallow stack): the one place from which arbitrary code can be called safely.  Modes that never wait there (camera views $08 / $14 / $17 loop on capture code) are left out.  Cached as pickle"""
    f = os.path.join(cache_dir, 'bases2.pkl')
    if os.path.exists(f): return pickle.load(open(f, 'rb'))
    C = D.Corpus(CORPUS); best = {}
    for i, e in C.E.items():
        if C.tainted(i): continue
        k = e['sig'][0]; fr = C.frames(i)
        if k not in best or fr < best[k][0]: best[k] = (fr, i, tuple(e['sig']))
    out = {}
    for k in sorted(best):
        fr, i, sig = best[k]; g.set_organic(1); C.replay(i); g.run(30); g.set_stop(IDLE_PC); n = 0
        while not g.stop_hit() and n < 6: g.run(1); n += 1
        ok = g.stop_hit(); g.set_stop(None)
        if ok: out[k] = dict(entry=i, sig=sig, snap=g.snapshot())
    os.makedirs(cache_dir, exist_ok=True); pickle.dump(out, open(f, 'wb')); return out

def vram_runs(s0, s1):
    """changed VRAM bytes grouped into runs with the same ROM source: [(vram_start, vram_end, rom_flat_start or None)]"""
    v0 = np.frombuffer(s0.vram, np.uint8); v1 = np.frombuffer(s1.vram, np.uint8); t1 = np.frombuffer(s1.t_vram, np.uint32)
    ch = np.flatnonzero(v0 != v1); runs = []
    for i in ch:
        src = int(t1[i]) - 1 if t1[i] else None
        if runs and runs[-1][1] == i - 1 and ((src is None and runs[-1][2] is None) or (src is not None and runs[-1][2] is not None and src - (i - runs[-1][0]) == runs[-1][2])):
            runs[-1][1] = int(i)
        else: runs.append([int(i), int(i), src])
    return runs

def snd_requests():
    s = g.snd(); return [(int(ch), int(i)) for ch in range(8) for i in np.flatnonzero(s[ch])]

REGS = ('LCDC', 0x40), ('STAT', 0x41), ('SCY', 0x42), ('SCX', 0x43), ('BGP', 0x47), ('OBP0', 0x48), ('OBP1', 0x49), ('WY', 0x4A), ('WX', 0x4B)
IDLE_PC = 0x0013           # `halt` loop of Rst10_WaitFlagSet: the main thread waiting for V-Blank
TOTAL = 96                 # frames after the base state, the same for the control and the forced run (so that the two end states can be compared byte by byte)
_ctl = {}

def _end(base, setup, keys=0, key_frames=0):
    """restore `base`, apply setup (None = control), run until frame0 + TOTAL; returns (state at the end, info).  With a jump, info['ret'] holds the state and the write log at the moment the code returned"""
    g.restore(base['snap']); g.L.gb_cov_clear(); g.snd_clear(); g.set_organic(1)
    r0 = g.regs(); idle = r0['pc']; f0 = g.L.gb_frame(); returned = False; first = None; ret = None
    if setup: setup(r0, idle)
    if keys: g.keys(keys)
    while g.L.gb_frame() < f0 + TOTAL:
        g.run(1)
        if keys and g.L.gb_frame() >= f0 + key_frames: g.keys(0); keys = 0
        if setup and not returned:
            if g.stop_hit(): returned = True; first = g.L.gb_frame() - f0; ret = dict(state=g.state(), wlog=g.wlog(), sp0=r0['sp'], snd=set(snd_requests())); g.set_stop(None)
            elif g.L.gb_frame() >= f0 + 60: ret = dict(state=g.state(), wlog=g.wlog(), sp0=r0['sp'], snd=set(snd_requests())); first = None; g.set_stop(None); returned = None
    g.keys(0); g.set_stop(None)
    ex = np.flatnonzero(g.cov_exec())
    return g.state(), dict(returned=bool(returned), gave_up=returned is None and setup is not None, frames_to_return=first, exec_flat=set(int(x) for x in ex), snd=set(snd_requests()), mode=(g.peek(0xD5CE), g.peek(0xD5CF)), ret=ret)

def control(base_key, base):
    if base_key not in _ctl: _ctl[base_key] = _end(base, None)
    return _ctl[base_key]

MAILBOX = {0xDD60: 'sfx1', 0xDD68: 'music', 0xDD70: 'sfx3', 0xDD78: 'sfx4'}
def direct_effects(ret):
    """what the code wrote while it ran (between the jump and the return), from the write log; stack pushes below the jump SP are dropped"""
    if not ret: return None
    st = ret['state']; sp0 = ret['sp0']; t = np.frombuffer(st.t_vram, np.uint32)
    last = {}                                         # final value per address, in order of first write
    for a, v in ret['wlog']: last[a] = v
    out = dict(n_writes=len(ret['wlog']), wram=[], hram=[], io=[], sram=0, vram=[], oam=0, mailbox=[])
    vr = sorted(a - 0x8000 for a in last if 0x8000 <= a < 0xA000)
    runs = []
    for i in vr:
        src = int(t[i]) - 1 if t[i] else None
        if runs and runs[-1][1] == i - 1 and ((src is None and runs[-1][2] is None) or (src is not None and runs[-1][2] is not None and src - (i - runs[-1][0]) == runs[-1][2])): runs[-1][1] = i
        else: runs.append([i, i, src])
    out['vram'] = runs
    for a, v in ret['wlog']:
        if a in MAILBOX: out['mailbox'].append((MAILBOX[a], v))
    for a, v in last.items():
        if 0xC000 <= a < 0xE000 and not (sp0 - 0x80 <= a <= sp0 + 2): out['wram'].append((a, v))
        elif 0xFF80 <= a < 0xFFFF: out['hram'].append((a, v))
        elif 0xFF00 <= a < 0xFF80: out['io'].append((a, v))
        elif 0xA000 <= a < 0xC000: out['sram'] += 1
        elif 0xFE00 <= a < 0xFEA0: out['oam'] += 1
    for k in ('wram', 'hram', 'io'): out[k].sort()
    return out

def observe(base_key, base, setup, keys=0, key_frames=0):
    """report of one forced run: direct effects (write log until the return) and the differences of the end state from the control run of the same base state"""
    s0, i0 = control(base_key, base); s1, i1 = _end(base, setup, keys, key_frames)
    v0 = np.frombuffer(s0.vram, np.uint8); v1 = np.frombuffer(s1.vram, np.uint8)
    w0 = np.frombuffer(s0.wram, np.uint8); w1 = np.frombuffer(s1.wram, np.uint8); wd = np.flatnonzero(w0 != w1)
    return dict(returned=i1['returned'], gave_up=i1['gave_up'], frames_to_return=i1['frames_to_return'], exec_flat=i1['exec_flat'] - i0['exec_flat'], mode_ctl=i0['mode'], mode_after=i1['mode'],
                direct=direct_effects(i1['ret']), later=dict(
                vram=vram_runs(s0, s1), oam_changed=int(sum(1 for i in range(0xA0) if s0.oam[i] != s1.oam[i])),
                lcd={n: (s0.io[a], s1.io[a]) for n, a in REGS if s0.io[a] != s1.io[a]}, snd=sorted(i1['snd'] - i0['snd']), wram_changed=int(len(wd)),
                wram_first=[(0xC000 + int(i), int(w0[i]), int(w1[i])) for i in wd[:24]], sram_changed=int(np.count_nonzero(np.frombuffer(s0.sram, np.uint8) != np.frombuffer(s1.sram, np.uint8)))))

KEYNAMES = ('A', 'B', 'Select', 'Start', 'Right', 'Left', 'Up', 'Down')     # bit k of the game's joypad bytes $FFA1 (held) $FFA2 (new) $FFA3 (repeat) $FFA7-$FFA9 (sticky copies)
PRESETS = ('idle', 'zero') + tuple('key' + n for n in KEYNAMES)

def jump_setup(comp, preset):
    """preset: 'idle' = registers as they are at the interrupted instruction, 'zero' = AF BC DE HL = 0, 'keyX' = one joypad bit set in all the game's joypad bytes (registers as 'idle')"""
    def setup(r, idle):
        if preset == 'zero': g.set_regs(0, 0, 0, 0, 0, r['sp'])
        if preset.startswith('key'):
            for a in (0xFFA1, 0xFFA2, 0xFFA3, 0xFFA7, 0xFFA8, 0xFFA9): g.poke(a, 1 << KEYNAMES.index(preset[3:]))
        g.jump(comp['entry'], comp['bank'] if comp['entry'] >= 0x4000 else 0, idle); g.set_stop(idle)
    return setup

def comp_exec(rep, comp):
    """bytes of the component that ran, from the executed flat offsets of the report"""
    ex = rep['exec_flat']; n = 0
    for s, e in comp['runs']:
        for a in range(s, e + 1):
            if g.flat(comp['bank'], a) in ex: n += 1
    return n

def run_jump(cid, comp, B, presets=PRESETS):
    res = []
    for mode, base in B.items():
        for p in presets:
            rep = observe(mode, base, jump_setup(comp, p))
            rep.update(mode=mode, preset=p, comp_bytes_run=comp_exec(rep, comp)); rep.pop('exec_flat'); res.append(rep)
    return res

def signature(rep):
    d = rep['direct']
    if d is None: return ('no-return', rep['gave_up'])
    return (tuple(d['wram']), tuple(d['hram']), tuple(d['io']), d['sram'], d['oam'], tuple(map(tuple, d['vram'])), tuple(d['mailbox']), rep['returned'])

def summarize(runs):
    """group the runs of one component by what the code did; keep one example run per group"""
    groups = collections.OrderedDict()
    for r in runs:
        k = signature(r); gr = groups.setdefault(k, dict(n=0, modes=set(), presets=set(), example=r)); gr['n'] += 1; gr['modes'].add(r['mode']); gr['presets'].add(r['preset'])
    out = []
    for k, gr in groups.items():
        e = gr['example']; out.append(dict(n=gr['n'], modes=sorted(gr['modes']), presets=sorted(gr['presets']), returned=e['returned'], gave_up=e['gave_up'], frames_to_return=e['frames_to_return'],
                                           bytes_run=e['comp_bytes_run'], direct=e['direct'], later=e['later'], mode_ctl=e['mode_ctl'], mode_after=e['mode_after']))
    return out

if __name__ == '__main__':
    cache, outf = sys.argv[1], sys.argv[2]; want = sys.argv[3:]
    C = components(); B = bases(cache)
    todo = [k for k in C if (k in want if want else C[k]['verdict'] == 'UNREFERENCED')]
    out = {}
    for k in todo:
        runs = run_jump(k, C[k], B); out[k] = dict(comp=C[k], total_runs=len(runs), groups=summarize(runs)); print(k, len(runs), 'runs', len(out[k]['groups']), 'distinct outcomes', flush=True)
        json.dump(out, open(outf, 'w'))
