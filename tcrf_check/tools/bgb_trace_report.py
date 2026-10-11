#!/usr/bin/env python3
"""Aggregate the BGB re-trace (phase 2 results) against my core's union coverage (merged_v8/cov.npz): per-category counts of block heads and instructions, per-bank table, the
heads BGB did not reproduce, contradictions (a head my core never executed that BGB executed) and the SGB-only blocks.
usage: bgb_trace_report.py [OUT.json]     (reads bgbtrace/bgb_*.jsonl, bgbtrace/plan/plan_summary.json, bgbtrace/never_probe_*.json*)"""
import sys, os, json, glob, collections
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE); sys.path.insert(0, HERE)
import numpy as np, blocks as B
heads, members, code = B.blocks()
ex = np.load(os.path.join(ROOT, 'merged_v8', 'cov.npz'))['ex']
key = lambda h: '%02X:%04X' % h
core_heads = {key(h) for h in heads if ex[B.flat(*h)]}; never_heads = {key(h) for h in heads if not ex[B.flat(*h)]}
v8_never = set(never_heads)
for f in glob.glob(os.path.join(ROOT, 'bgbtrace', 'core_dj_corpus.json')):          # heads that the D.J. corpus (dj_corpus.py) adds to my core's union
    added = {h for e in json.load(open(f))['entries'].values() for h in e['new']} & never_heads
    core_heads |= added; never_heads -= added
ninstr = {key(h): len(members[h]) for h in heads}
plan = json.load(open(os.path.join(ROOT, 'bgbtrace', 'plan', 'plan_summary.json')))
assigned = set(); confirmed = set(); missing = set(); unexpected = collections.Counter(); runs = 0
PLAN = {}
for f in glob.glob(os.path.join(ROOT, 'bgbtrace', 'plan', 'plan_*.json')):
    if f.endswith('plan_summary.json'): continue
    PLAN[os.path.basename(f)[len('plan_'):-len('.json')]] = json.load(open(f))['entries']
for f in sorted(glob.glob(os.path.join(ROOT, 'bgbtrace', 'bgb_*.jsonl'))):
    stem = os.path.basename(f)[len('bgb_'):].split('.w')[0]
    stem = stem[len('plan_'):] if stem.startswith('plan_') else stem.replace('_dmg', '')
    for l in open(f):
        if not l.strip(): continue
        r = json.loads(l); runs += 1
        heads_here = set(PLAN[stem][str(r['id'])]['new']); miss = set(r['missing'])
        assigned |= heads_here; missing |= miss; confirmed |= heads_here - miss
        for u in r['unexpected']: unexpected[u] += 1
missing -= confirmed
printer_only = set(plan['printer_only']) - assigned          # no joypad-only witness at all (a head that has one, confirmed or not, is not printer-only)
rest = core_heads - assigned - printer_only
def instr(s): return sum(ninstr[h] for h in s if h in ninstr)
cat = collections.OrderedDict([
    ('core union (executed by my core)', core_heads), ('witness assigned (replayable, joypad-only lineage)', assigned & core_heads),
    ('  confirmed in BGB (head hit)', confirmed & core_heads), ('  not reproduced in BGB', missing & core_heads),
    ('printer-only witnesses (not in this run)', printer_only & core_heads), ('other witnesses (forced / link / long runs, not replayable here)', rest)])
res = dict(core_union_from_v8_never_added_by_dj_corpus=len(v8_never) - len(never_heads), runs=runs, categories={k: dict(heads=len(v), instructions=instr(v)) for k, v in cat.items()}, contradictions=dict(unexpected), never_heads=len(never_heads),
           never_heads_instr=instr(never_heads))
per = collections.OrderedDict()
for b in range(0, 0x40):
    row = {}
    for name, s in (('all', set(key(h) for h in heads if h[0] == b)), ('core', core_heads), ('confirmed', confirmed), ('missing', missing), ('printer', printer_only), ('rest', rest), ('never', never_heads)):
        hs = [h for h in s if int(h.split(':')[0], 16) == b and h in ninstr]
        row[name] = (len(hs), instr(hs))
    if row['all'][0]: per['%02X' % b] = row
res['per_bank'] = per
sgb = set()
for f in glob.glob(os.path.join(ROOT, 'bgbtrace', 'never_probe_sgb*.jsonl')):
    for l in open(f):
        if l.strip(): sgb |= set(json.loads(l)['hits'])
d = json.load(open(os.path.join(ROOT, 'bgbtrace', 'never_probe_e0_sys2.json'))); sgb |= set(d['hits'])
res['sgb_only_heads'] = dict(count=len(sgb), instructions=instr(sgb), heads=sorted(sgb))
res['missing_heads'] = sorted(missing)
json.dump(sorted(confirmed), open(os.path.join(ROOT, 'bgbtrace', 'confirmed_heads.json'), 'w'))
# printer runs (bgb_print_run.py --heads / bgb_dj_print.py --br, directories bgbtrace/ph_*): which heads of the report's categories do they hit?
ph = set()
for f in glob.glob(os.path.join(ROOT, 'bgbtrace', 'ph_*', 'heads_hit.json')): ph |= set(json.load(open(f))['hits'])
ph &= core_heads
res['printer_runs'] = dict(runs=len(glob.glob(os.path.join(ROOT, 'bgbtrace', 'ph_*', 'heads_hit.json'))), hit_printer_only=(len(ph & printer_only), instr(ph & printer_only)), not_hit_printer_only=(len(printer_only - ph), instr(printer_only - ph)),
                           not_hit_printer_only_by_bank=dict(collections.Counter(h[:2] for h in printer_only - ph)), confirmed_plus_printer=(len(confirmed | ph), instr(confirmed | ph)), hit_but_not_reproduced=(len(ph & missing), instr(ph & missing)))
json.dump(dict(current_printer_only=len(printer_only), hit=sorted(ph & printer_only), not_hit=sorted(printer_only - ph)), open(os.path.join(ROOT, 'bgbtrace', 'printer_only_result.json'), 'w'))
out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'bgbtrace', 'trace_report.json')
json.dump(res, open(out, 'w'), indent=1)
print('result records', runs)
for k, v in res['categories'].items(): print('%-72s heads %6d  instructions %6d' % (k, v['heads'], v['instructions']))
print('never-executed heads (core)', len(never_heads), 'instr', instr(never_heads), '| contradictions (BGB executed a never-head in DMG mode):', dict(unexpected))
print('printer runs:', res['printer_runs'])
print('SGB-only heads (never-heads that BGB hit in SGB mode):', len(sgb), 'instr', instr(sgb))
print('bank  all(h,i)   core   confirmed  missing  printer  rest  never')
for b, r in per.items(): print(b, *['%d/%d' % r[n] for n in ('all', 'core', 'confirmed', 'missing', 'printer', 'rest', 'never')])
