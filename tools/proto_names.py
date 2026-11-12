#!/usr/bin/env python3
"""L3 names of the early prototype: merge the name layers into roms/prototype_debagame/disasm/sym_names_proto.csv (the input of sym_build).

  tools/proto_names.py [--min-port 16] [--auto AUTO.csv] [--match MATCH.csv] [--symtab SYMTAB.csv] [--trace TRACE.json] [--out OUT.csv] [--doubts OUT.md] [--texts TEXTS.csv]

Layers, lowest first (a later layer replaces the name at the same address; a name `-` deletes):
  1. auto   disasm/layers/sym_names_proto_auto.csv (tools/proto_types.py --names): Gfx_ / Map_ / Data_ / JumpTable_ BB_AAAA, tag C
     (a run of bytes that no layer names and that the L2 runs never read nor execute becomes Leftover_BB_AAAA, tag I: owner rule 2026-11-11)
  2. assets the banked labels of the two leftover symbol tables (disasm/leftover_symtab_proto.csv, kind label, value $4000-$7FFF,
            byte2 = the bank): all 31 have the same bank and address in both tables. Named as the Japanese ROM names its assets, the
            developers' name as suffix (owner, 2026-11-09): Gfx_BB_AAAA_NAME / Map_BB_AAAA_NAME, tag C, when this build copies a typed
            block that starts there (layer 1 holds Gfx_ / Map_ at that address); Data_BB_AAAA_NAME, tag I, otherwise (an asset of the
            old builds that this build neither copies nor reads in the L2 runs: kind not settled).
  5. gaps   after the layers: Data_BB_AAAA, tag C, at the start of every run of bytes that no type row, traced instruction or inline
            table covers and that is not padding (16+ equal $00 / $FF), when no name stands there: the Japanese convention for a block
            whose kind is not settled, so that the label before it does not claim it (tcrf_check/tools/rom_layout_map.py: Data_ = UNCERTAIN);
            only where the label before it in the bank is not already such a gap label (padding between two gaps needs no new label).
  6. parts  <routine>_Part<AAAA>, tag C, at the first traced instruction after a non-code label (a gap label on a never-traced byte
            inside a routine): the code keeps its routine's name and colour.
  3. port   disasm/match_old_proto.csv (tools/proto_match_old.py): the developers' name of an old-build routine whose code is found
            at exactly one place of this build (operands masked). A name found at several addresses (one per table) keeps the
            address with the longer pattern; an address given several names keeps the name both tables give, else the one with the
            longest pattern, and is tagged ? when two names tie. Tag C at --min-port bytes or more, I below. The note gives the table,
            the old address, the length and the match kind.
  4. hand   disasm/layers/sym_names_proto_hand.csv (every row with its reason)
  4b. copies  an exact copy (in bytes nothing identifies) of an identified block of 32+ bytes: Leftover_BB_AAAA_<block name>, tag I,
            with the block's type row (a copy of a routine is typed data). Padding-like runs inside a copy do not stop it.
  4c. text   every text type row: Leftover_BB_AAAA_AsmSource (assembler source in clear) or _SrcListing (file.dmg(line) : text lines), tag I.
  5b. PC RAM a leftover gap run that holds strings of the development PC's memory (Windows paths, the DOS environment):
            Leftover_BB_AAAA_PcRam, tag I. --texts writes every text in clear (the text rows and the PC strings) to
            assets/text_sections_proto.csv.
Checks: one name per address and one address per name (a clash aborts), valid rgbasm labels, every routine entry of the trace
(call targets, jump-table entries, vectors, the entry) named. --doubts writes the doubts list: every name not tagged C but the leftovers, with its note (OUT.md, and the same rows as OUT.csv
beside it); the leftovers, whose I tag is final, go to sym_settled_unused_proto.csv beside it.
Prints `proto_names: N names, tags {...}; routine entries R, unnamed U`.
"""
import csv, json, os, re, sys, argparse, collections
D = 'roms/prototype_debagame/'
ap = argparse.ArgumentParser(); ap.add_argument('--min-port', type=int, default=16)
ap.add_argument('--auto', default=D + 'disasm/layers/sym_names_proto_auto.csv'); ap.add_argument('--match', default=D + 'disasm/match_old_proto.csv')
ap.add_argument('--symtab', default=D + 'disasm/leftover_symtab_proto.csv'); ap.add_argument('--symtab-mem', default=D + 'disasm/leftover_symtab_mem_proto.csv'); ap.add_argument('--printer-lib', default=D + 'disasm/printer_lib_proto.csv'); ap.add_argument('--oldbuilds', default=D + 'disasm/oldbuilds_proto.csv'); ap.add_argument('--trace', default=D + 'trace/trace_proto.json')
ap.add_argument('--hand', default=D + 'disasm/layers/sym_names_proto_hand.csv'); ap.add_argument('--rom', default='/root/work/roms/pocketcamera_proto.gb')
ap.add_argument('--types', default=D + 'disasm/sym_types_proto.csv'); ap.add_argument('--texts', default=D + 'assets/text_sections_proto.csv')
ap.add_argument('--out', default=D + 'disasm/sym_names_proto.csv'); ap.add_argument('--doubts', default=D + 'disasm/sym_unconclusive_proto.md')
a = ap.parse_args()
names = {}
def put(b, ad, nm, conf, note, src):
    b = 0 if ad < 0x4000 else b
    if nm == '-': names.pop((b, ad), None)
    else: names[(b, ad)] = [nm, conf, note, src]
for r in csv.DictReader(open(a.auto)): put(int(r['bank'], 16), int(r['addr'], 16), r['name'], r['conf'], r['note'], r['source'])
# 2. banked asset labels of the old tables
lab = collections.defaultdict(set)
for r in csv.DictReader(open(a.symtab)):
    if r['kind'] == 'label' and r['space'] == 'ROMX': lab[(r['name'], int(r['byte2']), int(r['value'], 16))].add(r['table'])
for (nm, b, v), tabs in sorted(lab.items(), key=lambda k: (k[0][1], k[0][2])):
    old = names.get((b, v))     # Japanese naming (owner, 2026-11-09): the block's kind prefix and own address, the developers' name as suffix
    if old and re.match(r'(Gfx|Map)_[0-9A-F]{2}_[0-9A-F]{4}$', old[0]):
        put(b, v, '%s_%s' % (old[0], nm), 'C', '%s in both old symbol tables (same bank and address); this build copies the block here: %s' % (nm, old[2]), 'symtab_asset')
    elif nm.startswith('BG_'):                    # every BG_ block that this build copies is a BG map (BG_BANK, BG_MOVIE, BG_CONF ...): roadmap step 5
        put(b, v, 'Map_%02X_%04X_%s' % (b, v, nm), 'I', '%s in %s old symbol table%s at this bank and address; this build neither copies nor reads it (L2 runs); a BG map by its name (every BG_ block this build copies is one) and its bytes (tile numbers, the common ones of the menu maps)' % (
            nm, 'both' if len(tabs) == 2 else 'one', 's' if len(tabs) == 2 else ''), 'symtab_asset')
    else: put(b, v, 'Data_%02X_%04X_%s' % (b, v, nm), 'I', '%s in %s old symbol table%s at this bank and address; this build neither copies nor reads it (L2 runs): kind not settled' % (
        nm, 'both' if len(tabs) == 2 else 'one', 's' if len(tabs) == 2 else ''), 'symtab_asset')
# 3. port from the old builds
rows = [r for r in csv.DictReader(open(a.match)) if r['hits'] == '1']
byname = collections.defaultdict(list)
for r in rows: byname[r['name']].append(r)
keep = []
for nm, rs in byname.items():
    best = max(int(r['bytes']) for r in rs)
    keep += [r for r in rs if r['new_addr'] == next(x['new_addr'] for x in rs if int(x['bytes']) == best)]
byaddr = collections.defaultdict(list)
for r in keep: byaddr[r['new_addr']].append(r)
for ad, rs in sorted(byaddr.items()):
    cand = collections.defaultdict(list)
    for r in rs: cand[r['name']].append(r)
    order = sorted(cand.items(), key=lambda kv: (-len({x['table'] for x in kv[1]}), -max(int(x['bytes']) for x in kv[1]), kv[0]))
    nm, rr = order[0]
    tie = len(order) > 1 and len({x['table'] for x in order[1][1]}) == len({x['table'] for x in rr}) and \
          max(int(x['bytes']) for x in order[1][1]) == max(int(x['bytes']) for x in rr)
    ln = max(int(x['bytes']) for x in rr)
    conf = '?' if tie else ('C' if ln >= a.min_port else 'I')
    what = 'the same bytes as the data label' if rr[0]['kind'] == 'data' else 'same code as'
    note = 'developers\' name: %s %s in the old build of table %s (%s bytes, %s match)' % (what, 
        nm, ' and '.join('%s at old %s' % (x['table'], x['old_addr']) for x in sorted(rr, key=lambda x: x['table'])), ln, rr[0]['kind'])
    if len(order) > 1: note += '; other names on this address: ' + ', '.join(o[0] for o in order[1:])
    put(0, int(ad, 16), nm, conf, note, 'port_old')
# 4. hand
for r in csv.DictReader(open(a.hand)): put(int(r['bank'], 16), int(r['addr'], 16), r['name'], r['conf'], r['note'], r['source'])
# 5. gaps: unidentified bytes get a Data_ label at their start
ROMB = open(a.rom, 'rb').read(); TR = json.load(open(a.trace))
COPYNOTE = 'leftover copy of '
cov_ = bytearray(len(ROMB))
for k, n in TR['code'].items():
    o = int(k[3:], 16) if k.startswith('00:') else int(k[:2], 16) * 0x4000 + int(k[3:], 16) - 0x4000
    for i in range(n): cov_[o + i] = 1
for k in TR['inline']:
    o = int(k[3:], 16) if k.startswith('00:') else int(k[:2], 16) * 0x4000 + int(k[3:], 16) - 0x4000
    cov_[o] = 1
TYPES = [r for r in csv.DictReader(open(a.types)) if not r['note'].startswith((COPYNOTE, 'older build: ', 'printer library of an older build'))]     # without the rows of an earlier run of step 4b
for r in TYPES:
    b = int(r['bank'], 16); s0, e0 = int(r['start'], 16), int(r['end'], 16)
    for ad in range(s0, e0): cov_[ad if b == 0 else b * 0x4000 + ad - 0x4000] = 1
idcov_ = bytearray(cov_)                              # identified bytes only (trace and type rows), without the padding runs
i = 0
while i < len(ROMB):                                   # padding: 16+ equal $00 / $FF
    j = i
    while j < len(ROMB) and ROMB[j] == ROMB[i] and (j - i) < 0x4000 and (j >> 14) == (i >> 14): j += 1
    if ROMB[i] in (0, 0xFF) and j - i >= 16:
        for k in range(i, j): cov_[k] = 1
    i = j
import bisect
# 4a. the printer library of the older builds (owner 2026-11-12; tools/proto_printer_lib.py -> disasm/printer_lib_proto.csv): every routine
#     and data block from SIOINT to STARTSTRINGTRANS in banks $2C / $37 (the bank 0 of the builds of tables $2A / $35: the address and the
#     developers' name come from the table, tag C) and their copies in banks $1D / $20 (found by their bytes, tag I):
#     Leftover_BB_AAAA_<developers' name>, code that this build never runs (typed data), with the Japanese Prn_* routine it matches.
#     Step 5 of the roadmap (2026-11-12): the same for every other bank-0 label of the two tables (tools/proto_oldbuilds.py ->
#     disasm/oldbuilds_proto.csv: code or data, C at the table address, I for the copies of the code found in banks $1D / $20)
LIBROWS = []; LIBTYPES = []      # (offset, bank, addr, developers' name, is data, tag, what, default size, tool)
def _o(x): b_, a_ = int(x[:2], 16), int(x[3:], 16); return a_ if b_ == 0 else b_ * 0x4000 + a_ - 0x4000
if os.path.exists(a.printer_lib):
    for r in csv.DictReader(open(a.printer_lib)):
        jp = ', the Japanese %s (%s, %s match, instruction ratio %s)' % (r['jp_name'], r['jp_addr'], r['jp_match'], r['jp_ratio']) if r['jp_match'] in ('exact', 'near') else (
             ', no Japanese counterpart of 0.8 or more' if r['jp_match'] == 'none' else ', too short to pair with a Japanese routine')
        for col, tg in (('b2C', 'C'), ('b37', 'C'), ('b1D', 'I'), ('b20', 'I')):
            if r[col]:
                how = 'address and name from symbol table $%s' % ('2A' if col == 'b2C' else '35') if tg == 'C' else 'found by its bytes (16-bit operands masked) in the order of bank $2C'
                LIBROWS.append((_o(r[col]), int(r[col][:2], 16), int(r[col][3:], 16), r['dev_name'], r['dev_name'].startswith(('PACKET', 'PREAMBLEDATA')), tg,
                                'of the printer library of an older build%s; %s' % (jp, how), int(r['size']), 'tools/proto_printer_lib.py'))
if os.path.exists(a.oldbuilds):                      # step 5 of the roadmap (2026-11-12): the rest of the older builds' bank 0
    for r in csv.DictReader(open(a.oldbuilds)):
        if r['kind'] == 'skipped': continue
        cols = [('addr', 'C')] + ([('copy_1D', 'I'), ('copy_20', 'I')] if r['kind'] == 'code' else [])
        for col, tg in cols:
            if r[col]:
                how = 'address and name from symbol table $%s%s' % (r['table'], ', called in its bank' if r['called'] == 'yes' else '') if col == 'addr' else 'found by its bytes (16-bit operands masked) near its place in bank $2C'
                LIBROWS.append((_o(r[col]), int(r[col][:2], 16), int(r[col][3:], 16), r['dev_name'], r['kind'] == 'data', tg,
                                'of the bank 0 of an older build (%s); %s' % ('the build of table $%s' % r['table'] if col == 'addr' else 'bank $%s' % r[col][:2], how), int(r['size']), 'tools/proto_oldbuilds.py'))
LIBROWS.sort(key=lambda x: x[0])
_seen_lib = set()
for k_, (o_, cb, ca, dn, isdata, tg, what, size, tool) in enumerate(LIBROWS):    # each piece runs to the next piece of the same bank (the last: its size)
    if o_ in _seen_lib: continue
    _seen_lib.add(o_)
    nx_ = next((x for x in LIBROWS[k_ + 1:] if x[0] > o_), None)
    nxt = nx_[0] if nx_ and nx_[1] == cb else o_ + size
    nxt = min(nxt, o_ + size) if tool == 'tools/proto_oldbuilds.py' else nxt
    put(cb, ca, 'Leftover_%02X_%04X_%s' % (cb, ca, dn), tg, 'leftover: %d bytes of %s %s %s; %s' % (
        nxt - o_, 'data' if isdata else 'code', dn, what, 'nothing in this build reads it' if isdata else 'code that this build never runs (typed data)'), 'oldlib')
    LIBTYPES.append(['%02X' % cb, '%04X' % ca, '%04X' % (ca + nxt - o_), 'data', '', 'older build: %s (%s; %s)' % (dn, 'data' if isdata else 'code never run here', tool)])
    for k in range(o_, nxt): cov_[k] = 1; idcov_[k] = 1
# 4b. leftover copies (owner rule 2026-11-11): an exact copy of an identified block (a named asset, map, table or routine whose bytes are all
#     typed or traced, 32 bytes or more, not one repeated byte) that lies in bytes nothing identifies inherits the block: it is named
#     Leftover_BB_AAAA_<name of the block>, tag I, and gets the block's type row (a copy of a routine is typed data: this build never runs it)
def _flat(b, ad): return ad if b == 0 else b * 0x4000 + ad - 0x4000
_lbl = sorted(names); _src = []
TYPESTART = {}
for r in TYPES: TYPESTART[(int(r['bank'], 16), int(r['start'], 16))] = max(TYPESTART.get((int(r['bank'], 16), int(r['start'], 16)), 0), int(r['end'], 16))
for i_, (b, ad) in enumerate(_lbl):
    nm = names[(b, ad)][0]
    if nm.startswith(('Leftover_', 'BankNumber_')) or re.match(r'(Data|Code|Gfx|Map|Src|JumpTable|Unk)_[0-9A-F]{2}_[0-9A-F]{4}$', nm): continue
    nb, na = _lbl[i_ + 1] if i_ + 1 < len(_lbl) else (b + 1, 0)
    end = na if nb == b else (0x4000 if b == 0 else 0x8000)
    t_ = TYPESTART.get((b, ad))
    if t_ is not None: end = min(end, t_)          # a block with its own type row ends with it (the bytes after it may be untyped)
    o0, o1 = _flat(b, ad), _flat(b, ad) + (end - ad)
    if o1 - o0 < 32 or len(set(ROMB[o0:o1])) == 1 or not all(cov_[o0:o1]): continue
    _src.append((o1 - o0, b, ad, o0, o1, nm))
TYPEAT = {}
for r in TYPES: TYPEAT[(int(r['bank'], 16), int(r['start'], 16))] = r
copy_types = []; ncopy = 0; COPYSH = {}                 # COPYSH: flat offset of a copied byte -> (shift to its source, block, bank, addr)
for ln, b, ad, o0, o1, nm in sorted(_src, reverse=True):
    blob = ROMB[o0:o1]; i_ = ROMB.find(blob)
    while i_ >= 0:
        if i_ != o0 and (i_ >> 14) == ((i_ + ln - 1) >> 14) and not any(idcov_[i_:i_ + ln]):   # padding-like runs inside a copy (white rows of a picture) do not stop it
            cb = i_ >> 14; ca = i_ if cb == 0 else 0x4000 + (i_ & 0x3FFF)
            put(cb, ca, 'Leftover_%02X_%04X_%s' % (cb, ca, nm), 'I', 'leftover: an exact copy of %s (%02X:%04X, %d bytes) that nothing in this build reads, runs or explains (never read nor run in the L2 runs)' % (nm, b, ad, ln), 'copy')
            t_ = TYPEAT.get((b, ad))
            copy_types.append(['%02X' % cb, '%04X' % ca, '%04X' % (ca + ln), t_['type'] if t_ else 'data', (t_['width'] if t_ else '') or '',
                               COPYNOTE + '%s (%02X:%04X)%s' % (nm, b, ad, '' if t_ else ': a copy of code, typed data (this build never runs it)')])
            for k in range(i_, i_ + ln): cov_[k] = 1; idcov_[k] = 1; COPYSH[k] = (o0 - i_, nm, b, ad)
            ncopy += 1
        i_ = ROMB.find(blob, i_ + 1)
# 4b-2. partial and misaligned copies, then variants (owner 2026-11-12: "pattern analysis from known assets", only this ROM's assets).
#     Partial: any run of 32+ bytes of bytes nothing identifies that equals a run of an identified block (any offset in either, so a copy
#     cut at another address or shifted by some bytes is found): Leftover_BB_AAAA_<block>_PartAAAA (AAAA: the address in the block where
#     the copied run starts), tag I, the block's type. Variant: a run of 128+ such bytes whose bytes equal those of one identified block at
#     one fixed shift for 60 % or more (an older or edited version: seeds of 8 equal bytes vote for the shift):
#     Leftover_BB_AAAA_<block>_Variant[PartAAAA], tag I, the block's type, the share of equal bytes in the note.
import numpy as _np
SRCB = {}                                          # flat offset -> index of the identified block that holds it
for k_, (ln, b, ad, o0, o1, nm) in enumerate(_src):
    for o in range(o0, o1): SRCB.setdefault(o, k_)
def _addr(o): return (o >> 14, o if o < 0x4000 else 0x4000 + (o & 0x3FFF))
def _copyrow(cb, ca, ln, k_, nm2, note2, src, sh=None):
    ln_, b, ad, o0, o1, nm = _src[k_]; t_ = TYPEAT.get((b, ad))
    put(cb, ca, nm2, 'I', note2, src)
    copy_types.append(['%02X' % cb, '%04X' % ca, '%04X' % (ca + ln), t_['type'] if t_ else 'data', (t_['width'] if t_ else '') or '',
                       COPYNOTE + '%s (%02X:%04X)%s' % (nm, b, ad, '' if t_ else ': a copy of code, typed data (this build never runs it)')])
    f0 = _flat(cb, ca)
    for k in range(f0, f0 + ln):
        cov_[k] = 1; idcov_[k] = 1
        if sh is not None: COPYSH[k] = (sh, nm, b, ad)
W16 = {}
for o in sorted(SRCB):
    w = ROMB[o:o + 16]
    if SRCB.get(o + 15) == SRCB[o] and len(set(w)) >= 3:
        l_ = W16.setdefault(w, [])
        if len(l_) < 4: l_.append(o)
npart = 0; i_ = 0; NR = len(ROMB)
while i_ < NR - 16:
    if idcov_[i_] or ROMB[i_:i_ + 16] not in W16: i_ += 1; continue
    best = None
    for s_ in W16[ROMB[i_:i_ + 16]]:
        k_ = SRCB[s_]; o0, o1 = _src[k_][3], _src[k_][4]
        if o0 <= i_ < o1: continue
        lo = 0
        while i_ - lo - 1 >= 0 and s_ - lo - 1 >= o0 and ROMB[i_ - lo - 1] == ROMB[s_ - lo - 1] and not idcov_[i_ - lo - 1] and ((i_ - lo - 1) >> 14) == (i_ >> 14): lo += 1
        hi = 16
        while i_ + hi < NR and s_ + hi < o1 and ROMB[i_ + hi] == ROMB[s_ + hi] and not idcov_[i_ + hi] and ((i_ + hi) >> 14) == (i_ >> 14): hi += 1
        if not best or lo + hi > best[0]: best = (lo + hi, i_ - lo, s_ - lo, k_)
    if best and best[0] >= 32:
        ln, d_, s_, k_ = best; cb, ca = _addr(d_); nm = _src[k_][5]; sb, sa = _addr(s_)
        whole = s_ == _src[k_][3] and ln == _src[k_][4] - _src[k_][3]
        nm2 = 'Leftover_%02X_%04X_%s' % (cb, ca, nm) + ('' if whole else '_Part%04X' % sa)
        _copyrow(cb, ca, ln, k_, nm2, 'leftover: an exact copy of %d bytes of %s (from %02X:%04X%s) that nothing in this build reads, runs or explains (never read nor run in the L2 runs)' % (
            ln, nm, sb, sa, '' if whole else ', a part of the block'), 'copy', sh=s_ - d_)
        npart += 1; i_ = d_ + ln
    else: i_ += 1
W8 = {}
for o in sorted(SRCB):
    w = ROMB[o:o + 8]
    if SRCB.get(o + 7) == SRCB[o] and len(set(w)) >= 3:
        l_ = W8.setdefault(w, [])
        if len(l_) < 4: l_.append(o)
nvar = 0
runs_ = []; i_ = 0
while i_ < NR:                                     # runs of bytes nothing identifies (padding runs included: a picture has white rows)
    if idcov_[i_]: i_ += 1; continue
    j_ = i_
    while j_ < NR and not idcov_[j_] and (j_ >> 14) == (i_ >> 14): j_ += 1
    if j_ - i_ >= 128: runs_.append((i_, j_))
    i_ = j_
Ra_ = _np.frombuffer(ROMB, _np.uint8)
for r0, r1 in runs_:
    todo = [(r0, r1)]
    for _it in range(4):
        nxt = []
        for t0, t1 in todo:
            if t1 - t0 < 128: continue
            votes = collections.Counter()
            for o in range(t0, t1 - 8):
                for s_ in W8.get(ROMB[o:o + 8], ()): votes[(s_ - o, SRCB[s_])] += 1
            if not votes: continue
            (dl, k_), v = votes.most_common(1)[0]
            if v < 3: continue
            o0, o1 = _src[k_][3], _src[k_][4]
            a0, a1 = max(t0, o0 - dl), min(t1, o1 - dl)
            if a1 - a0 < 128 or (a0 < o1 and a1 > o0): continue            # too short, or overlapping its own source
            ratio = float((Ra_[a0:a1] == Ra_[a0 + dl:a1 + dl]).mean())
            if ratio < 0.6 or len(set(ROMB[a0:a1])) < 3: continue
            cb, ca = _addr(a0); sb, sa = _addr(a0 + dl); nm = _src[k_][5]
            whole = a0 + dl == o0
            _copyrow(cb, ca, a1 - a0, k_, 'Leftover_%02X_%04X_%s_Variant%s' % (cb, ca, nm, '' if whole else 'Part%04X' % sa),
                     'leftover: a variant of %d bytes of %s (from %02X:%04X): %.0f %% of the bytes equal at that shift, an older or edited version; nothing in this build reads, runs or explains it (never read nor run in the L2 runs)' % (
                         a1 - a0, nm, sb, sa, 100 * ratio), 'variant', sh=dl)
            nvar += 1; nxt += [(t0, a0), (a1, t1)]
        todo = nxt
# 4b-3. seams (owner 2026-11-12: the glyphs of banks $02 / $3A that the copies left out): a run of 8 to 1,024 bytes that nothing identifies,
#     right after a copy (whole, part or variant) of a block and right before bytes that continue the same block at the same shift (a copy
#     of it at that shift give or take 8 bytes, as in bank $22 where 6-byte seams cut the copies, or bytes equal to it for 28 of 32), is
#     the same block edited there: Leftover_BB_AAAA_<block>_VariantPartAAAA, tag I, the
#     block's type, the share of equal bytes in the note (the run is where this copy differs from the block: other glyphs, another picture).
nseam = 0; i_ = 0
while i_ < NR:
    if idcov_[i_]: i_ += 1; continue
    j_ = i_
    while j_ < NR and not idcov_[j_] and (j_ >> 14) == (i_ >> 14): j_ += 1
    L = COPYSH.get(i_ - 1)
    if L and 8 <= j_ - i_ <= 1024 and ((i_ - 1) >> 14) == (i_ >> 14) and len(set(ROMB[i_:j_])) >= 3:
        sh, nm, sb0, sa0 = L; Rr = COPYSH.get(j_)
        cont = (Rr is not None and abs(Rr[0] - sh) <= 8 and Rr[1] == nm) or sum(x == y for x, y in zip(ROMB[j_:j_ + 32], ROMB[j_ + sh:j_ + sh + 32])) >= 28
        k_ = next((k for k, x in enumerate(_src) if x[5] == nm), None)
        if cont and k_ is not None and _src[k_][3] <= i_ + sh and j_ + sh <= _src[k_][4]:
            cb, ca = _addr(i_); sb, sa = _addr(i_ + sh)
            ratio = float((Ra_[i_:j_] == Ra_[i_ + sh:j_ + sh]).mean())
            _copyrow(cb, ca, j_ - i_, k_, 'Leftover_%02X_%04X_%s_VariantPart%04X' % (cb, ca, nm, sa),
                     'leftover: %d bytes between two pieces of a copy of %s at the same shift, where this copy differs from the block (%02X:%04X; %.0f %% of the bytes equal): an edited version; nothing in this build reads, runs or explains it (never read nor run in the L2 runs)' % (
                         j_ - i_, nm, sb, sa, 100 * ratio), 'variant', sh=sh)
            nseam += 1
    i_ = j_
with open(a.types, 'w', newline='') as f:     # the type table with the copies' rows (rerunning this script gives the same file)
    w_ = csv.writer(f, lineterminator='\n'); w_.writerow(['bank', 'start', 'end', 'type', 'width', 'note'])
    for r in TYPES: w_.writerow([r['bank'], r['start'], r['end'], r['type'], r['width'], r['note']])
    w_.writerows(copy_types + LIBTYPES)
# 4c. leftover text (owner 2026-11-11): the text type rows (proto_types.py: printable ASCII / Shift-JIS) are pieces of the developers' PC files
#     that the build tool left in unused ROM space. Leftover_BB_AAAA_AsmSource: assembler source in clear (instructions, DEFB / DB, comments);
#     Leftover_BB_AAAA_SrcListing: a listing of that source, one `file.dmg(line) : text` line per hit (a grep output). Tag I, final.
#     A row that starts on the bank-number byte (BB:4000, read by the self-test) is labelled from BB:4001.
ASMRE = re.compile(rb'\t(DEFB|DEFW|DB|DW|LD|LDH|CALL|JP|JR|RET|RETI|INC|DEC|PUSH|POP|AND|OR|XOR|CP|ADD|ADC|SUB|SBC|EQU|BIT|SET|RES|RLCA|RRCA|SWAP|SRL|SLA|DS)\b', re.I)
LISTRE = re.compile(rb'[A-Za-z0-9_]+\.(dmg|DMG|inc|INC|asm|ASM)\(\d+\) :')
TEXTROWS = []
for r in TYPES:
    if r['type'] != 'text': continue
    b = int(r['bank'], 16); s0, e0 = int(r['start'], 16), int(r['end'], 16)
    if s0 == 0x4000 and names.get((b, 0x4000), [''])[0].startswith('BankNumber_'): s0 = 0x4001
    t = ROMB[_flat(b, s0):_flat(b, s0) + e0 - s0]
    nl, na = len(LISTRE.findall(t)), len(ASMRE.findall(t))
    what = 'SrcListing' if nl > na else 'AsmSource'
    old = names.get((b, s0))
    if old and not re.match(r'(Text|Data)_[0-9A-F]{2}_[0-9A-F]{4}$', old[0]) and not old[0].startswith('Leftover_'): sys.exit('proto_names: text row %02X:%04X under %s' % (b, s0, old[0]))
    put(b, s0, 'Leftover_%02X_%04X_%s' % (b, s0, what), 'I', 'leftover text: %d bytes of %s (%d listing lines, %d assembler lines) that nothing in this build reads (never read nor run in the L2 runs)' % (
        e0 - s0, 'a listing of the developers\' source (file.dmg(line) : text)' if what == 'SrcListing' else 'the developers\' assembler source in clear', nl, na), 'text')
    TEXTROWS.append((b, s0, e0, what, nl, na))
ngap = 0
import numpy as _np                       # what the L2 runs read or executed (trace/cov_proto_runs.npz): a gap that is used is not a leftover
_z = _np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'roms', 'prototype_debagame', 'trace', 'cov_proto_runs.npz'))
RUNX = (_z['ex'][:len(ROMB)] > 0) | (_z['dr'][:len(ROMB)] > 0)
byb = collections.defaultdict(list)
for (b, ad) in names: byb[b].append(ad)
for b in byb: byb[b].sort()
for o in range(len(ROMB)):
    if not cov_[o] and (o == 0 or cov_[o - 1] or (o & 0x3FFF) == 0):
        b = o >> 14; ad = o if b == 0 else 0x4000 + (o & 0x3FFF)
        if (b, ad) in names: continue
        lst = byb[b]; i_ = bisect.bisect_right(lst, ad) - 1
        if i_ < 0 or names[(b, lst[i_])][3] == 'gap': continue      # nothing before it in the bank, or a gap label already owns it
        e_ = o + 1
        while e_ < len(ROMB) and not cov_[e_] and (e_ & 0x3FFF): e_ += 1
        if RUNX[o:e_].any():      # read or run in the L2 runs: something uses it, so the kind is still to settle (a placeholder)
            put(b, ad, 'Data_%02X_%04X' % (b, ad), 'C', 'start of bytes that nothing identifies yet (no type row, trace or name), read or run in the L2 runs: kind not settled', 'gap')
        else:                     # owner rule 2026-11-11: bytes that nothing reads, runs or explains are leftovers, named Leftover_BB_AAAA, tag I
            put(b, ad, 'Leftover_%02X_%04X' % (b, ad), 'I', 'leftover: %d bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no reader; never read nor run in the L2 runs)' % (e_ - o), 'gap')
        ngap += 1
        bisect.insort(lst, ad)
# 5b. leftover PC memory (owner 2026-11-11): a leftover run whose bytes hold strings of the development PC's memory (Windows paths, the
#     DOS environment, Windows module names) is a piece of that PC's RAM that the build tool wrote into unused ROM space:
#     Leftover_BB_AAAA_PcRam, tag I, final. The run is the span of the gap label (to the next label of the bank); only the strings are proven.
#     Also (owner 2026-11-12) a run with 2+ x86 function prologues (55 8B EC) or 5+ in-memory symbol records (the linker's symbol list,
#     tools/proto_symtab.py --out-mem): the memory of the PC that linked the ROM.
PCRE = re.compile(rb'[A-Z]:\\[A-Za-z]|WINDOWS VMM|[A-Z0-9]{3,8}\.(DLL|EXE|VXD|DRV)\b|COMSPEC=|winbootdir=')
X86RE = re.compile(rb'\x55\x8B\xEC')            # push bp / mov bp,sp: an x86 function prologue ($EC is no Game Boy opcode)
MEMSYM = set()                                  # the in-memory symbol records (tools/proto_symtab.py --out-mem): the linker's symbol list
_mp = a.symtab_mem
if os.path.exists(_mp):
    for r in csv.DictReader(open(_mp)): o_ = int(r['file_offset'], 16); MEMSYM.add((o_ >> 14, 0x4000 + (o_ & 0x3FFF)))
npc = 0; PCRAM = []
_all = sorted(names)
for i_, (b, ad) in enumerate(_all):
    nm, c, note, src = names[(b, ad)]
    if src != 'gap' or not nm.startswith('Leftover_'): continue
    nb, na = _all[i_ + 1] if i_ + 1 < len(_all) else (b + 1, 0)
    end = na if nb == b else 0x8000
    t = ROMB[_flat(b, ad):_flat(b, ad) + end - ad]
    hits = [m for m in PCRE.finditer(t)]
    x86 = len(X86RE.findall(t)); mem = sum(1 for (mb, mo) in MEMSYM if mb == b and ad <= mo < end)
    if not hits and x86 < 2 and mem < 5: continue
    strs = []                              # the printable string around each hit (a NUL-terminated string of the PC memory)
    for m in hits:
        i0, i1 = m.start(), m.end()
        while i0 > 0 and 0x20 <= t[i0 - 1] < 0x7F: i0 -= 1
        while i1 < len(t) and 0x20 <= t[i1] < 0x7F: i1 += 1
        if not strs or strs[-1][0] != ad + i0: strs.append((ad + i0, t[i0:i1].decode('latin1')))
    ex = [x for _, x in strs[:3]]
    allstr = []                           # every string of the run for the text listing: 6+ printable bytes ending on a NUL, half of them letters
    for m in re.finditer(rb'[\x20-\x7e]{6,}(?=\x00)', t):
        x = m.group()
        if sum(1 for ch in x if 0x41 <= ch <= 0x5A or 0x61 <= ch <= 0x7A) * 2 >= len(x): allstr.append((ad + m.start(), x.decode('latin1')))
    evs = []
    if strs: evs.append('%d strings of the development PC\'s RAM (%s ...)' % (len(strs), ' / '.join(x[:40] for x in ex)))
    if x86 >= 2: evs.append('%d x86 function prologues (55 8B EC: push bp / mov bp,sp; $EC is no Game Boy opcode)' % x86)
    if mem >= 5: evs.append('%d records of the linker\'s symbol list as held in memory (disasm/leftover_symtab_mem_proto.csv)' % mem)
    names[(b, ad)] = ['Leftover_%02X_%04X_PcRam' % (b, ad), 'I', 'leftover PC memory: %d bytes (%02X:%04X-%04X) that hold %s, and that nothing in this build reads, runs or explains; only those are proven, the rest of the run is taken as the same memory' % (
        end - ad, b, ad, end - 1, '; '.join(evs)), 'ram']
    PCRAM.append((b, ad, end, allstr)); npc += 1
# 6. code after a data label: a <routine>_Part<AAAA> label (the Japanese convention for a piece of a parent block) at the first traced
#    instruction that a non-code label would own, so that the code keeps the name and the colour of its routine
codeat = set()
for k in TR['code']: codeat.add((int(k[:2], 16) if not k.startswith('00:') else 0, int(k[3:], 16)))
npart = 0
for b in sorted(byb):
    lst = sorted(ad for (bb, ad) in names if bb == b); prevcode = None; owner = None
    for ad in sorted(set(lst) | {ad for (bb, ad) in codeat if bb == b}):
        if (b, ad) in names:
            owner = (b, ad)
            if (b, ad) in codeat: prevcode = names[(b, ad)][0]
        elif (b, ad) in codeat and owner is not None and owner not in codeat and prevcode:
            base = re.sub(r'_Part[0-9A-F]{4}$', '', prevcode)
            put(b, ad, '%s_Part%04X' % (base, ad), 'C', 'continuation of %s after a data label or a never-traced byte' % base, 'part'); owner = (b, ad); prevcode = names[(b, ad)][0]; npart += 1
# checks
LABEL = re.compile(r'^[A-Za-z_][A-Za-z0-9_]*$')
seen = {}
for k, v in names.items():
    if not LABEL.match(v[0]): sys.exit('proto_names: invalid label %s at %02X:%04X' % (v[0], *k))
    if v[0] in seen: sys.exit('proto_names: %s on %02X:%04X and %02X:%04X' % (v[0], *seen[v[0]], *k))
    seen[v[0]] = k
ROM = open(a.rom, 'rb').read(); T = json.load(open(a.trace))
code = {int(k[3:], 16) for k in T['code'] if k.startswith('00:')}
ent = {0x0040, 0x0048, 0x0050, 0x0058, 0x0100} | {t for t in T['tables'].get('00:3822', [])}
for ad in code:
    if ROM[ad] in (0xCD, 0xC4, 0xCC, 0xD4, 0xDC):
        t = ROM[ad + 1] | ROM[ad + 2] << 8
        if t < 0x4000: ent.add(t)
unnamed = sorted(t for t in ent if (0, t) not in names)
with open(a.out, 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'note', 'source'])
    for (b, ad), (nm, c, note, src) in sorted(names.items()): w.writerow(['%02X' % b, '%04X' % ad, nm, c, note, src])
tags = collections.Counter(v[1] for v in names.values())
FINAL = ('gap', 'copy', 'variant', 'text', 'ram', 'oldlib', 'tiles')      # the leftovers: their I tag is final (owner rule 2026-11-11)
doubt = sorted((k, v) for k, v in names.items() if v[1] != 'C' and v[3] not in FINAL)
settled = sorted((k, v) for k, v in names.items() if v[1] != 'C' and v[3] in FINAL)
with open(os.path.join(os.path.dirname(a.doubts), 'sym_settled_unused_proto.csv'), 'w', newline='') as f:   # the Japanese columns
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'group', 'size', 'evidence', 'proof'])
    for (b, ad), (nm, c, note, src) in settled:
        grp = {'gap': 'leftover', 'copy': 'leftover copy', 'variant': 'leftover variant', 'oldlib': 'leftover older build', 'text': 'leftover text', 'ram': 'leftover PC memory', 'tiles': 'leftover tiles'}[src]
        w.writerow(['%02X' % b, '%04X' % ad, nm, c, grp, int(re.search(r'(\d+) bytes', note).group(1)), note,
                    'tools/proto_names.py: %s, and trace/cov_proto_runs.npz neither reads nor runs them' % {'gap': 'no type row, traced instruction or reader', 'copy': 'an exact copy of the named block (or of a part of it), in bytes no type row, traced instruction or reader covers', 'variant': 'equal to the named block at one shift for most of its bytes, in bytes no type row, traced instruction or reader covers', 'oldlib': 'a routine or block of an older build\'s bank 0 (disasm/printer_lib_proto.csv, disasm/oldbuilds_proto.csv), in bytes no type row, traced instruction or reader covers',
                     'text': 'a text type row (printable ASCII / Shift-JIS) that no traced instruction reads', 'ram': 'strings of the PC memory in bytes no type row, traced instruction or reader covers',
                     'tiles': 'a hand type row (2bpp tiles, disasm/layers/sym_types_proto_hand.csv) that no traced instruction or copy site reads'}[src]])
with open(a.texts, 'w', newline='') as f:   # every text in clear of the image
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'start', 'end', 'bytes', 'kind', 'label', 'lines', 'sample'])
    rows_ = []
    for b, s0, e0, what, nl, na in TEXTROWS:
        t = ROMB[_flat(b, s0):_flat(b, s0) + e0 - s0].decode('cp932', 'replace')
        rows_.append((b, s0, e0, {'AsmSource': 'assembler source (leftover)', 'SrcListing': 'source listing (leftover)'}[what], 'Leftover_%02X_%04X_%s' % (b, s0, what), t.count('\r\n'),
                      re.sub(r'\s+', ' ', t[:80]).strip()))
    for b, ad, end, strs in PCRAM:
        for o_, x in strs:
            rows_.append((b, o_, o_ + len(x), 'PC memory string (leftover)', 'Leftover_%02X_%04X_PcRam' % (b, ad), 1, x[:80]))
    for b, s0, e0, k, lb, nl, smp in sorted(rows_): w.writerow(['%02X' % b, '%04X' % s0, '%04X' % e0, e0 - s0, k, lb, nl, smp])
with open(a.doubts, 'w') as f:
    f.write('# Prototype: names not tagged C (doubts list)\n\nGenerated by `tools/proto_names.py` from the name layers (%d names: C %d / I %d / ? %d). '
            'Every name below is a hypothesis until the code or an emulator confirms it. Not listed: the %d leftovers (`Leftover_BB_AAAA`, with the `_<name>` of the block they copy, `_AsmSource` / `_SrcListing` for text, `_PcRam` for PC memory; tag I, final), in `sym_settled_unused_proto.csv`.\n\n| address | name | tag | source | reason |\n|---|---|---|---|---|\n' % (
                len(names), tags['C'], tags['I'], tags['?'], sum(1 for v in names.values() if v[1] != 'C' and v[3] in FINAL)))
    for (b, ad), (nm, c, note, src) in doubt: f.write('| %02X:%04X | %s | %s | %s | %s |\n' % (b, ad, nm, c, src, note.replace('|', '/')))
with open(os.path.splitext(a.doubts)[0] + '.csv', 'w', newline='') as f:      # the same list as a table (HOWTO_NEW_ROM.md section 0.1: sym_unconclusive_<tag>.csv/.md)
    w = csv.writer(f, lineterminator='\n'); w.writerow(['bank', 'addr', 'name', 'conf', 'source', 'evidence'])
    for (b, ad), (nm, c, note, src) in doubt: w.writerow(['%02X' % b, '%04X' % ad, nm, c, src, note])
print('proto_names: %d names, tags %s; routine entries %d, unnamed %d%s' % (len(names), dict(sorted(tags.items())), len(ent), len(unnamed),
      (' (' + ' '.join('%04X' % t for t in unnamed) + ')') if unnamed else ''))
src = collections.Counter(v[3] for v in names.values()); print('by source:', dict(sorted(src.items())))
