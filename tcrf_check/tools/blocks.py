#!/usr/bin/env python3
"""Basic blocks of the statically traced code (package/wram/trace_jp_v3.json) for the BGB re-trace.
A block head is: a root / entry of the trace, a jump / call / rst target, or the instruction after any jump, call, ret, rst.
blocks() -> (heads, members): heads = sorted list of (bank, addr); members[(bank, addr)] = list of (bank, addr, length) of the instructions
that execute whenever the head executes (straight-line run up to the next head or a terminator).
usage: blocks.py [ROM]   -> prints counts and checks them against merged_v8/cov.npz (instruction executed => its block head executed)."""
import sys, os, json
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.environ.get('GBCAM_ROM', os.path.join(ROOT, 'pocketcamera_jp.gb'))
TRACE = os.path.join(ROOT, 'package', 'wram', 'trace_jp_v3.json')
COND_JP = {0xC2, 0xCA, 0xD2, 0xDA}; COND_CALL = {0xC4, 0xCC, 0xD4, 0xDC}; COND_JR = {0x20, 0x28, 0x30, 0x38}
COND_RET = {0xC0, 0xC8, 0xD0, 0xD8}; RST = {0xC7, 0xCF, 0xD7, 0xDF, 0xE7, 0xEF, 0xF7, 0xFF}
# instructions the coverage run executed without executing the head of their static block: entered by `ret` to a pushed address (retaddr_rule / pushret_rule of the tracer)
INDIRECT_ENTRIES = {(0, 0x0771), (0, 0x2500), (0, 0x2502), (0, 0x2505), (0, 0x2508), (9, 0x6BDB), (5, 0x6029), (5, 0x602C), (5, 0x602D), (0, 0x0772)}
def flat(b, a): return a if (b == 0 and a < 0x4000) else b * 0x4000 + a - 0x4000
def blocks(rom=None, trace=None):
    rom = rom or open(ROM, 'rb').read(); t = trace or json.load(open(TRACE))
    code = {}
    for k, n in t['code'].items():
        if n > 0:
            b, a = k.split(':'); code[(int(b, 16), int(a, 16))] = n
    heads = set()
    for k in t['entries']:
        b, a = k.split(':'); heads.add((int(b, 16), int(a, 16)))
    term = set()                                    # instructions after which control does not fall through
    for (b, a), n in code.items():
        op = rom[flat(b, a)]; nxt = (b, a + n)
        def tgt(addr): return (0 if addr < 0x4000 else b, addr)
        if op == 0xC3 or op in COND_JP or op == 0xCD or op in COND_CALL:
            heads.add(tgt(rom[flat(b, a) + 1] | rom[flat(b, a) + 2] << 8))
            if op == 0xC3: term.add((b, a))
            heads.add(nxt)
        elif op == 0x18 or op in COND_JR:
            r = rom[flat(b, a) + 1]; r -= 256 if r > 127 else 0
            heads.add(tgt(a + 2 + r)); heads.add(nxt)
            if op == 0x18: term.add((b, a))
        elif op in RST:
            heads.add((0, op - 0xC7)); heads.add(nxt)
        elif op in (0xC9, 0xD9) or op in COND_RET:
            heads.add(nxt)
            if op in (0xC9, 0xD9): term.add((b, a))
        elif op == 0xE9:
            heads.add(nxt); term.add((b, a))
    heads |= INDIRECT_ENTRIES                       # code entered through a pushed / computed return address (found by the coverage run, no static edge)
    heads = {h for h in heads if h in code}
    members = {}
    for h in heads:
        m = []; cur = h
        while cur in code:
            m.append((cur[0], cur[1], code[cur])); 
            if cur in term: break
            cur = (cur[0], cur[1] + code[cur])
            if cur in heads: break
        members[h] = m
    return sorted(heads), members, code
if __name__ == '__main__':
    import numpy as np
    heads, members, code = blocks()
    print('instructions', len(code), 'block heads', len(heads), 'instructions covered by blocks', sum(len(m) for m in members.values()))
    z = np.load(os.path.join(ROOT, 'merged_v8', 'cov.npz')); ex = z['ex']
    owner = {}
    for h, m in members.items():
        for b, a, n in m: owner.setdefault((b, a), []).append(h)
    miss = [k for k in code if k not in owner]
    print('instructions not in any block:', len(miss), miss[:5])
    bad = 0; hx = 0
    for h in heads:
        e = bool(ex[flat(*h)])
        hx += e
        if e:
            for b, a, n in members[h]:
                if not ex[flat(b, a)]: bad += 1
    print('heads executed (core union):', hx, 'executed heads whose block has an unexecuted instruction:', bad)
    badh = [k for k in code if ex[flat(*k)] and not any(ex[flat(*h)] for h in owner.get(k, []))]
    print('executed instructions with no executed head:', len(badh), badh[:10])
