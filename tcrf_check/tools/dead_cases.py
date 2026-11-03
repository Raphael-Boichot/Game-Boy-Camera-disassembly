#!/usr/bin/env python3
"""Build the case list of bgb_dead_hook.py (README 16.26) from the core's base states: for every case the corpus entry that leads to the game mode, the (mode, state) it is in, and the values of
AF BC DE HL at the point where dead_jump.py jumped (the core's idle point), so that BGB calls the routine with the same registers.
usage: dead_cases.py CACHE_DIR OUT.json [--survey | --flips FLIP.json | --effects]   (environment as dead_jump.py; --survey = the map loader 04:6412 in every base mode; --flips = one case per flipped gate of dead_flip.py that ran)
A case = {name, bank, entry, mode (decimal game mode of the base state), key (joypad bit set in all the game's joypad bytes for the call, or null), note}."""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import dead_jump as J
g = J.g

CASES = [
    # name, bank, entry, base mode, key, what the core said, VRAM expectation [(vram address, bank, rom address, length)]
    ('map25_4B00_mode16', 0x04, 0x6412, 16, None, 'Unused_LoadTilemap25_4B00: map 25:4B00 to $9800', [(0x9800, 0x25, 0x4B00, 0x2C0)]),
    ('map24_7120_mode16', 0x04, 0x6403, 16, None, 'Unused_LoadTilemap24_7120: map 24:7120 to $9800', [(0x9800, 0x24, 0x7120, 0x2C0)]),
    ('tiles24_57E0_mode16', 0x07, 0x4BC3, 16, None, 'Unused_Link_ShowChecksum: font 24:57E0 (256 B) to $8EF0 and a hex number at $9A30', [(0x8EF0, 0x24, 0x57E0, 0x100)]),
    ('tiles17_4800_mode16', 0x07, 0x4A4D, 16, None, 'two-digit counter ($D5D8 + 1): glyph tiles 17:4800 + 32 x digit to $8700 / $8720', [(0x8700, 0x17, 0x4800, 0x20)]),
    ('tiles13_5800_mode16', 0x07, 0x503D, 16, None, 'alternate entry of a live tile loader: 13:5800 / 13:5830 to $8EC0 / $8ED0', [(0x8EC0, 0x13, 0x5800, 0x10), (0x8ED0, 0x13, 0x5830, 0x10)]),
    ('photostep_right_mode10', 0x04, 0x7C9D, 10, 'Right', 'Unused_Mode0A_PhotoStepWrap, Right held: sfx1 id 1', []),
    ('photostep_left_mode10', 0x04, 0x7C9D, 10, 'Left', 'Unused_Mode0A_PhotoStepWrap, Left held: sfx1 id 1', []),
]
# sound cases: the unused sfx1 starter 1F:46DD is reached through the real sound code: the init-table entry of sfx1 id 1 is made to point at it; the music is stopped (request $FF), 60 frames later id 1 is requested through the mailbox
# (the control run is the unpatched ROM: it plays the real id 1, so the pair of clips is 'ValueTick' vs the unused sound)
SOUND = [
    dict(name='sfx1_unused_46DD', mode=16, bank=0, entry=0, note='Sfx1_InitTbl[id 1] -> 1F:46DD (Unused_Sfx1_Init_46DD), request sfx1 id 1', patches=[[0x1F, 0x41FA, 'DD46']], mailbox=[(0xDD68, 0xFF)], mailbox2=[(0xDD60, 1)], stage2=60, clip_s=2, after=150, watch=[['FF10', 'NR10'], ['FF11', 'NR11'], ['FF12', 'NR12'], ['FF13', 'NR13'], ['FF14', 'NR14']]),
]
# the eight presets of the dead UI sound-effect player 00:10AC ($D92E = 1..8 -> NR10-NR14 of channel 1): the music is stopped, 60 frames later $D92E is set and the routine called
for _n in range(1, 9):
    SOUND.append(dict(name='uieffect_%d' % _n, mode=16, bank=0, entry=0x10AC, note='Snd_UiEffect_Dead with $D92E = %d' % _n, pre=[(0xD92E, _n)], call_stage2=True, mailbox=[(0xDD68, 0xFF)], stage2=60, clip_s=1,
                      after=150, nocontrol=True, watch=[['FF10', 'NR10'], ['FF11', 'NR11'], ['FF12', 'NR12'], ['FF13', 'NR13'], ['FF14', 'NR14']]))

# the camera-effect handlers (README 16.26): Cam_DispatchEffect (0A:5406) takes the handler number in A; seven WRAM bytes of the destination are poked with $5A first
# ($C000 row 0, $C0FF, $C3FF row 3, $C400 row 4, $C9FF row 9, $CA00 row 10, $CDFF row 13), so that a handler that copies only some of the rows leaves the marker in the others
EFFECT_MARK = [(0xC000, 0x5A), (0xC0FF, 0x5A), (0xC3FF, 0x5A), (0xC400, 0x5A), (0xC9FF, 0x5A), (0xCA00, 0x5A), (0xCDFF, 0x5A)]
EFFECT_IDX = (0x00, 0x13, 0x15, 0x20, 0x33, 0x35, 0x40, 0x53, 0x04, 0x19)
XOR_SLOTS = ((0x73EF, 'slot00'), (0x7457, 'slot13'), (0x7467, 'slot15'))

def effects(B, mode=16):
    out = []; b = B[mode]; g.restore(b['snap']); r = g.regs()
    for idx in EFFECT_IDX:
        out.append(dict(name='effect_%02X_mode%d' % (idx, mode), bank=0x0A, entry=0x5406, corpus_entry=b['entry'], sig=list(b['sig']), key=None, delay=30, note='Cam_DispatchEffect with handler number $%02X' % idx, expect=[], nocontrol=False, after=45,
                        pre=[[a - 0xC000 + 0xC000, v] for a, v in EFFECT_MARK] + [[0xFF9E, idx]], regs=dict(a=idx, f=r['f'], bc=r['bc'], de=r['de'], hl=r['hl'])))
    for ent, nm in XOR_SLOTS:
        out.append(dict(name='xorslot_%s_mode%d' % (nm[4:], mode), bank=0x06, entry=ent, corpus_entry=b['entry'], sig=list(b['sig']), key=None, delay=30, note='XOR slot of 06:73AF at %04X' % ent, expect=[], after=45,
                        pre=[[a, v] for a, v in EFFECT_MARK] + [[0xDA44, 0xA5], [0xDA45, 0x3C]], regs=dict(a=0, f=r['f'], bc=r['bc'], de=r['de'], hl=r['hl'])))
    return out

def survey(B, bank, entry, tag, expect):
    """the routine called in every game mode that the core can leave (no control run): a contact sheet of what it does over each mode's tile set"""
    out = []
    for mode, b in B.items():
        g.restore(b['snap']); r = g.regs()
        out.append(dict(name='%s_m%02d' % (tag, mode), bank=bank, entry=entry, corpus_entry=b['entry'], sig=list(b['sig']), key=None, delay=30, nocontrol=True, after=45, expect=[list(e) for e in expect],
                        note='survey of %02X:%04X in mode %d' % (bank, entry, mode), regs=dict(a=r['a'], f=r['f'], bc=r['bc'], de=r['de'], hl=r['hl'])))
    return out

def flips(B, flipjson):
    """one BGB case per UNREACHABLE component that the core entered when its gate was flipped (dead_flip.py output): the same base state, the same key sequence, the gate opcode flipped in the ROM"""
    out = []; F = json.load(open(flipjson))
    for cid, v in F.items():
        if not v['ran']: continue
        r = v['ran'][0]; gate = v['gates'][0]; bank, ga = int(gate[:2], 16), int(gate[3:], 16); b = B[r['mode']]
        ks = [] if r['seq'] == 'idle' else [(r['seq'], 6 if '+' in r['seq'] else 4, 3)]
        out.append(dict(name='flip_%s_m%02d' % (cid.replace(':', '_'), r['mode']), hook=False, flips=[[bank, ga]], corpus_entry=b['entry'], sig=list(b['sig']), delay=0, after=70,
                        play=[('-', 0, 33)] + ks, note='gate %s flipped, %s pressed in mode %d: the core ran %d B of the component, mode %s -> %s' % (gate, r['seq'], r['mode'], r['comp_bytes_run'], r['mode_ctl'], r['mode_after']),
                        component=cid, regs=dict(a=0, f=0, bc=0, de=0, hl=0), bank=int(cid[:2], 16), entry=int(cid[3:], 16)))
    return out

def build(cache, out, svy=False, flipjson=None, effs=False):
    B = J.bases(cache); cases = []
    if flipjson:
        cases = flips(B, flipjson); json.dump(cases, open(out, 'w'), indent=1); return cases
    if effs:
        cases = effects(B); json.dump(cases, open(out, 'w'), indent=1); return cases
    if svy:
        cases = survey(B, 0x04, 0x6412, 'map25_4B00', [(0x9800, 0x25, 0x4B00, 0x2C0)]); json.dump(cases, open(out, 'w'), indent=1); return cases
    for name, bank, entry, mode, key, note, expect in CASES:
        b = B[mode]; g.restore(b['snap']); r = g.regs()
        cases.append(dict(name=name, bank=bank, entry=entry, corpus_entry=b['entry'], sig=list(b['sig']), key=key, delay=30, note=note, expect=[list(e) for e in expect],
                          regs=dict(a=r['a'], f=r['f'], bc=r['bc'], de=r['de'], hl=r['hl'])))
    for sc in SOUND:
        b = B[sc['mode']]; g.restore(b['snap']); r = g.regs(); c = dict(sc); c.pop('mode')
        c.update(corpus_entry=b['entry'], sig=list(b['sig']), delay=30, regs=dict(a=r['a'], f=r['f'], bc=r['bc'], de=r['de'], hl=r['hl'])); cases.append(c)
    json.dump(cases, open(out, 'w'), indent=1)
    return cases

if __name__ == '__main__':
    for c in build(sys.argv[1], sys.argv[2], '--survey' in sys.argv, sys.argv[sys.argv.index('--flips') + 1] if '--flips' in sys.argv else None, '--effects' in sys.argv): print(c['name'], c['corpus_entry'], c['sig'], c['regs'])
