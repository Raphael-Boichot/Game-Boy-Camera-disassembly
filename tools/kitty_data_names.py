#!/usr/bin/env python3
"""L3 data names of the Hello Kitty ROM (layer 3b of tools/kitty_names.py, 2026-11-12): every placeholder data label
(`Data_BB_AAAA`, `Gfx_BB_AAAA`, `Map_BB_AAAA`, `JumpTable_BB_AAAA` from tools/kitty_types.py) gets a name by kind and consumer, in the
Japanese ROM's convention:
  * Gfx_BB_AAAA_<context> / Map_BB_AAAA_<context>  tiles / a BG map (the kind from the display tracker or the copy that reads it);
  * Frame_BB_AAAA_<context>                         tiles of a print or camera frame (kind T_FRM of assets/layout_kind_overrides_kitty.csv);
  * Pal_BB_AAAA_<context>_Palettes                  colour data (kind PALT);
  * Snd_BB_AAAA_<context>                           sound data (read by the sound driver);
  * OamList_BB_AAAA_<context>                       a sprite layout (read by Obj_DrawSprite);
  * ObjScript_BB_AAAA_<context>                     an object script / record (read by the object engine);
  * Script_BB_AAAA_<context>                        a script of the script slots (ScriptSlots_*);
  * Src_BB_AAAA_<context>                           copied by a copy routine, the destination not seen (kind not settled);
  * <Consumer>_Tbl<AAAA>, <Consumer>_JumpTbl<AAAA> a table read by one routine / an inline jump table after its call;
  * the Japanese name, own address, when the block is a unique exact copy of a named Japanese block (16 bytes or more);
  * Leftover_BB_AAAA (owner rule 2026-11-11, tag I, final): never-read stretches (32 bytes or more, not padding) cut out of a block,
    and blocks nothing reads; the read bytes after such a stretch get `<name of the block>_PartAAAA`.
The context, in this order: the routine whose code names the address (`ld rr,nn` / `ld a,[nn]` / an inline argument; the bank from
the routine's own bank or a constant bank load just before), the screen the bytes are first read on (trace/read_screens_kitty.npz,
tools/kitty_read_screens.py: `ModeMM_<Mode>_StateSS`, after the fade of mode $1E), the routine that reads them.
Labels on inline arguments are dropped (the bytes belong to the call, as in the Japanese listing).
Tags: C when the bytes are read in an organic run (core, BGB, core paths) or named by the code; I when read only in forced runs.
"""
import csv, re, json, collections, bisect, os
import numpy as np
PH = re.compile(r'^(Data|Code|Gfx|Map|Src|JumpTable|Unk)_([0-9A-F]{2})_([0-9A-F]{4})$')
GENERIC = re.compile(r'^(Copy_|Vram_|Mem_|Map_Copy|Map_Write|Lcd_|JumpTable_|FarJumpTable|ModeState_|Serial_SetFarCallback|Object_|Obj_|ObjCmd_|ScriptSlots_|Snd_|Sfx|KittHost_TextStep|Rng_|Rst|OamDma)')
COPY = re.compile(r'^(Copy_|Vram_|Map_Copy|Map_Write|ObjCmd_CopyAt|Mode1D_CopyDescriptors|Lcd_SetupInline|Stamp_Blit)')
def fl(b, a): return a if a < 0x4000 else b * 0x4000 + a - 0x4000
def hx(o): return '%02X:%04X' % ((o >> 14), (o & 0x3FFF) + (0x4000 if o >= 0x4000 else 0))

def run(names, D, rom, jp, T, put):
    R = open(rom, 'rb').read(); N = len(R)
    JR = open(jp, 'rb').read() if jp and os.path.exists(jp) else None
    tr = D.replace('disasm/', 'trace/'); asd = D.replace('disasm/', 'assets/')
    def load(f):
        z = np.load(tr + f); return z['exec'] > 0, z['dread'] > 0, (z['reader'] if 'reader' in z.files else np.zeros(N, np.uint32))
    org = np.zeros(N, bool); frc = np.zeros(N, bool); rdr = np.zeros(N, np.uint32)
    for f in ('cov_kitty_runs.npz', 'cov_kitty_paths.npz', 'cov_kitty_bgb.npz'):
        if os.path.exists(tr + f):
            ex, dr, rd = load(f); org |= dr | ex; m = (rdr == 0) & (rd > 0); rdr[m] = rd[m]
    for f in ('forced_kitty.npz', 'forced_gates_kitty.npz', 'forced_effects_kitty.npz'):
        if os.path.exists(tr + f):
            ex, dr, rd = load(f); frc |= dr | ex; m = (rdr == 0) & (rd > 0); rdr[m] = rd[m]
    read = org | frc
    disp = np.load(tr + 'display_kitty.npz'); dt, dm = disp['tiles'] > 0, disp['map'] > 0
    rs = np.load(tr + 'read_screens_kitty.npz') if os.path.exists(tr + 'read_screens_kitty.npz') else None
    import kitty_layout_kinds                       # the kind evidence of every byte (display tracker, loaders, copy sites, readers)
    KIND, EVK, _c = kitty_layout_kinds.evidence(rom, tr + 'display_kitty.npz', os.path.dirname(os.path.dirname(D)))
    ovk = np.array(['', 'T_UI', 'MAP', 'SOUND', 'OAM', 'T_FRM', 'PALT', 'TBL'])[KIND]
    rolectx = np.zeros(N, '<U24')                  # the loader of the role evidence (tools/kitty_layout_kinds.py rule 0)
    t0 = fl(1, 0x687D)
    for i in range(6):
        lo_, hi_, bk = R[t0 + 3 * i:t0 + 3 * i + 3]; rolectx[fl(bk, hi_ << 8 | lo_):fl(bk, hi_ << 8 | lo_) + 0x1500] = 'PrintFrame_LoadTiles'
    rolectx[(EVK == 5) & (KIND == 5) & (rolectx == '')] = 'FrameCorner_Draw'
    rolectx[fl(8, 0x40D0):fl(8, 0x6A86)] = np.where(EVK[fl(8, 0x40D0):fl(8, 0x6A86)] == 5, 'Sgb_VramTransferInline', '')
    expl = np.isin(EVK, (2, 5))                    # named by a loader table (frames, SGB transfers) or a constant copy: explained, not leftover
    code = {}
    for k, l in T['code'].items(): code[fl(int(k[:2], 16), int(k[3:], 16))] = l
    isc = np.zeros(N, bool)
    for o, l in code.items(): isc[o:o + l] = True
    argrow = set()
    for r in csv.DictReader(open(D + 'sym_types_kitty.csv')):
        if r['note'].startswith('inline arguments'): argrow.add(fl(int(r['bank'], 16), int(r['start'], 16)))
    modes = {}
    for (b, ad), v in names.items():
        m = re.match(r'Mode([0-9A-F]{2})_([A-Za-z0-9]+)$', v[0])
        if m and v[3] == 'modes' and not m.group(2).startswith(('State', 'StateTable')): modes[int(m.group(1), 16)] = v[0]
    def labels():
        L = sorted((fl(b, ad), v[0]) for (b, ad), v in names.items()); return L, [o for o, _ in L]
    L, O = labels()
    def owner(o):                          # the code label that holds byte o (not a placeholder), in the same bank
        i = bisect.bisect_right(O, o) - 1
        while i >= 0 and (PH.match(L[i][1]) or not isc[L[i][0]]): i -= 1
        if i < 0: return None
        lo = L[i][0]
        return L[i][1] if (lo < 0x4000 and o < 0x4000) or (lo >> 14) == (o >> 14) else None
    ph = {o: n for o, n in L if PH.match(n) and names[(0 if o < 0x4000 else o >> 14, o if o < 0x4000 else (o & 0x3FFF) + 0x4000)][3] == 'kitty_types'}
    def key(o): return (0 if o < 0x4000 else o >> 14, o if o < 0x4000 else (o & 0x3FFF) + 0x4000)
    st = collections.Counter()
    # A. labels on inline arguments: dropped
    for o in list(ph):
        if o in argrow and not isc[o]:
            put(*key(o), '-', '', '', 'data'); ph.pop(o); st['args'] += 1
    L, O = labels()
    def extent(o):
        i = bisect.bisect_right(O, o); e = O[i] if i < len(O) else N
        bank_end = 0x4000 if o < 0x4000 else (o | 0x3FFF) + 1
        return min(e, bank_end)
    # static references to each block start (code operands and inline arguments)
    byaddr = collections.defaultdict(list)
    for o in ph: byaddr[o if o < 0x4000 else 0x4000 + (o & 0x3FFF)].append(o)
    refs = collections.defaultdict(list)
    def bankhint(o):
        return {R[k + 1] for k in range(max(0, o - 16), o) if code.get(k) == 2 and R[k] in (0x3E, 0x06, 0x0E, 0x16, 0x1E)}
    for o, l in code.items():
        if l == 3 and R[o] in (0x01, 0x11, 0x21, 0x31, 0xFA, 0xEA):
            v = R[o + 1] | R[o + 2] << 8; c = byaddr.get(v)
            if not c or v < 0x0100: continue                       # a value under $0100 is a count, not an address
            t = c if v < 0x4000 else ([x for x in c if x >> 14 == o >> 14] if o >= 0x4000 else []) or [x for x in c if x >> 14 in bankhint(o)]
            if len(t) == 1: refs[t[0]].append(o)
    for k, l in T['args'].items():
        o = fl(int(k[:2], 16), int(k[3:], 16)); bs = R[o:o + 3 + l]
        for i in range(3, 3 + l - 1):
            v = bs[i] | bs[i + 1] << 8; c = byaddr.get(v)
            if not c or v < 0x0100: continue
            t = [x for x in c if v < 0x4000 or x >> 14 == o >> 14 or (x >> 14) in set(bs[3:])]
            if len(t) == 1: refs[t[0]].append(o)
    # B. never-read stretches: Leftover_BB_AAAA, and a resume label for the read bytes after them
    Ra = np.frombuffer(R, np.uint8); padrun = np.zeros(N, bool); i = 0
    while i < N:                                   # runs of 16+ x $00 / $FF (padding inside or after a block)
        j = i
        while j < N and Ra[j] == Ra[i]: j += 1
        if j - i >= 16 and Ra[i] in (0, 0xFF): padrun[i:j] = True
        i = j
    def padlike(s, e):                             # fewer than 32 bytes outside the padding runs
        return int((~padrun[s:e]).sum()) < 32
    blocks = []                            # (start, origin placeholder start)
    for o in sorted(ph):
        e = extent(o); i = o; starts = [o]; lefts = []
        while i < e:
            if read[i] or isc[i] or expl[i]: i += 1; continue
            j = i
            while j < e and not read[j] and not isc[j] and not expl[j]: j += 1
            s0, e0 = i, j
            while s0 + 1 < e0 and R[s0] in (0, 0xFF) and R[s0 + 1] == R[s0]: s0 += 1     # leading fill bytes stay with the block
            if e0 - s0 >= 32 and not padlike(s0, e0) and not (s0 == o and refs.get(o)):     # a stretch the code names is not a leftover
                lefts.append((s0, e0))
            i = j
        for s0, e0 in lefts:
            put(*key(s0), 'Leftover_%02X_%04X' % key(s0), 'I', 'leftover: %d bytes (%s-%04X) that no run reads or executes and that no code names (owner rule 2026-11-11)' % (
                e0 - s0, hx(s0), ((e0 - 1) & 0x3FFF) | (0x4000 if s0 >= 0x4000 else 0)), 'data_left'); st['leftover'] += 1
            k0 = e0
            while k0 < e and not (read[k0] or expl[k0]): k0 += 1
            if k0 < e: blocks.append((k0, o))
        if not (lefts and lefts[0][0] == o): blocks.append((o, o))
    # B2. a block whose bytes hold two kinds (tiles then a map ...) is cut where the kind changes (runs of 32+ bytes; bytes without
    #     evidence go with the run before them): each part is named with its own kind, as the Japanese blocks are
    more = []
    for o, orig in blocks:
        e = extent(o); k = KIND[o:e]; cur = 0; runst = o; cuts = []
        for i in range(o, e):
            v = KIND[i]
            if v and v != cur:
                if cur and i - runst >= 32 and (KIND[i:min(e, i + 32)] == v).sum() >= 32 and (read[i] or expl[i]): cuts.append(i); runst = i; cur = v
                elif not cur: cur = v; runst = i
        more += [(c, orig) for c in cuts]
    blocks = sorted(set(blocks + more)); st['kind_cuts'] += len(set(more))
    L, O = labels()
    BS = sorted(o for o, _ in blocks); CTX = {}
    used = {v[0] for v in names.values()}
    def uniq(nm):
        n2, k = nm, 2
        while n2 in used: n2 = '%s_%d' % (nm, k); k += 1
        used.add(n2); return n2
    def rname(x):
        b = (x >> 16) & 0xFF; pc = x & 0xFFFF; return owner(fl(b if pc >= 0x4000 else 0, pc))
    JN = None
    if JR:
        JN = {}
        for r in csv.DictReader(open(D.replace('hello_kitty', 'jp_rev_a') + 'sym_names_jp.csv')):
            JN[fl(int(r['bank'], 16), int(r['addr'], 16))] = r['name']
    for o, orig in sorted(blocks):
        e = extent(o); j_ = bisect.bisect_right(BS, o); e = min(e, BS[j_]) if j_ < len(BS) else e   # the next part starts a new block
        pn = ph.get(orig, ''); kind0 = PH.match(pn).group(1) if pn and PH.match(pn) else 'Data'
        part = o != orig
        rd = collections.Counter(rname(int(x)) for x in rdr[o:e] if x)
        rd.pop(None, None)
        spec = [n for n, _ in rd.most_common() if not GENERIC.match(n) and not PH.match(n)]
        gen = [n for n, _ in rd.most_common() if GENERIC.match(n)]
        ow = collections.Counter(owner(s) for s in refs.get(o, [])); ow.pop(None, None)
        ref = [n for n, _ in ow.most_common() if not GENERIC.match(n)]
        tag = 'C' if org[o:e].any() else 'I'
        scr = None
        if rs is not None:
            v = rs['next'][o:e]; v = v[v != 0xFFFF]
            if len(v):
                ms = collections.Counter(v.tolist()).most_common(1)[0][0]; m, s_ = ms >> 8, ms & 0xFF
                scr = '%s_State%02X' % (modes.get(m, 'Mode%02X' % m), s_)
        ev = []
        if ref: ev.append('named by the code of %s (%s)' % (', '.join(ref[:3]), ' '.join(hx(x) for x in refs[o][:3])))
        if rd: ev.append('read in the runs by %s' % ', '.join(n for n, _ in rd.most_common(3)))
        if scr: ev.append('first read on the screen %s (trace/read_screens_kitty.npz)' % scr)
        jn = None
        if JN is not None and e - o >= 16:
            j = JR.find(R[o:e])
            if j >= 0 and JR.find(R[o:e], j + 1) < 0 and j in JN and not PH.match(JN[j]) and not JN[j].startswith(('Leftover', 'Unused')):
                jn = re.sub(r'_[0-9A-F]{2}_[0-9A-F]{4}(_|$)', lambda m_: '_%02X_%04X%s' % (key(o) + (m_.group(1),)), JN[j], count=1)
                ja = '%04X' % ((j & 0x3FFF) + (0x4000 if j >= 0x4000 else 0))       # an own address in the Japanese name becomes the Kitty one
                jn = re.sub(r'(?<![0-9A-F])%s(?![0-9A-F])' % ja, '%04X' % key(o)[1], jn)
                ev.insert(0, 'the same %d bytes as the Japanese %s (%s)' % (e - o, JN[j], hx(j)))
        if jn and jn not in used: nm = jn; tag = 'C'
        else:
            if kind0 == 'JumpTable':
                pfx = None; ctx = owner(o - 1) or (ref[0] if ref else 'Unk')
                nm = '%s_JumpTbl%04X' % (ctx, key(o)[1])
            else:
                fam = gen[0] if gen else ''
                k = collections.Counter(ovk[o:e][ovk[o:e] != ''].tolist()).most_common(1)     # the display tracker's kind of the block
                k = k[0][0] if k else ''
                OV = {'T_UI': 'Gfx', 'T_FRM': 'Frame', 'MAP': 'Map', 'SOUND': 'Snd', 'PALT': 'Pal', 'OAM': 'OamList' if fam == 'Obj_DrawSprite' else 'ObjScript'}
                if k in OV: pfx = OV[k]; ev.append('kind %s from the evidence of tools/kitty_layout_kinds.py' % k)
                elif kind0 in ('Gfx', 'Map'): pfx = kind0
                elif fam.startswith(('Snd_', 'Sfx')) or (spec and spec[0].startswith(('Snd_', 'Sfx', 'Song'))): pfx = 'Snd'
                elif fam == 'Obj_DrawSprite': pfx = 'OamList'
                elif fam.startswith(('Object_', 'Obj_', 'ObjCmd_')) and not COPY.match(fam): pfx = 'ObjScript'
                elif fam.startswith('ScriptSlots_'): pfx = 'Script'
                elif fam and COPY.match(fam) or (not spec and fam.startswith('Copy')):
                    pfx = 'Gfx' if dt[o:e].any() and not (dm[o:e].any() and not dt[o:e].any()) else ('Map' if dm[o:e].any() else 'Src')
                elif spec or ref: pfx = None
                elif fam: pfx = None; spec = [fam]
                else: pfx = 'Src'
                ctx = ref[0] if ref else scr or (spec[0] if spec else (gen[0] if gen else (rolectx[o] or CTX.get(orig, 'NeverRead'))))   # else the loader of its role, else its block's context
                m_ = re.match(r'Mode([0-9A-F]{2})_State([0-9A-F]{2})$', ctx)          # a generic state handler: the screen form
                if m_: ctx = '%s_State%s' % (modes.get(int(m_.group(1), 16), 'Mode' + m_.group(1)), m_.group(2))
                if pfx == 'Pal': nm = 'Pal_%02X_%04X_%s_Palettes' % (key(o) + (ctx,))          # colour data (the Japanese ..._Palettes)
                elif pfx: nm = '%s_%02X_%04X_%s' % (pfx, key(o)[0], key(o)[1], ctx)
                else: nm = '%s_Tbl%04X' % (ref[0] if ref else (spec[0] if spec else ctx), key(o)[1])
            if part and pn:
                ev.append('the rest of %s after a leftover stretch' % pn)
            nm = uniq(nm)
        if not ev: ev.append('statically named or read only by the block before it')
        if o == orig and kind0 != 'JumpTable' and not (jn and nm == jn): CTX[o] = ctx
        put(*key(o), nm, tag, '; '.join(ev), 'data'); st['named_' + tag] += 1
    # C. a leftover that a named table of the same bank points to (a little-endian word in a table, a script, sound data) is explained
    #    by that table: <table>_Entry<AAAA> for a routine's table, <Pfx>_BB_AAAA_EntryOf<table address> for a prefixed block; tag I
    L, O = labels()
    TAB = re.compile(r'^(ObjScript|Snd|Script|Sfx|Song)_|_Tbl[0-9A-F]{4}|_JumpTbl|StateTable')     # pointer tables (not the 4-byte sprite records)
    for o, nm in list(L):
        if not re.match(r'Leftover_[0-9A-F]{2}_[0-9A-F]{4}$', nm) or o < 0x4000: continue
        w = bytes([key(o)[1] & 0xFF, key(o)[1] >> 8]); base = o & ~0x3FFF; hit = None; i = R.find(w, base, base + 0x4000)
        while i >= 0 and not hit:
            t = L[bisect.bisect_right(O, i) - 1][1]
            if TAB.search(t) and not t.startswith('Leftover'): hit = (i, t)
            i = R.find(w, i + 1, base + 0x4000)
        if not hit: continue
        i, t = hit; ta = re.search(r'_([0-9A-F]{2})_([0-9A-F]{4})', t)
        m = re.match(r'(ObjScript|Snd|Script)_', t)
        if m: n2 = '%s_%02X_%04X_EntryOf%s' % ((m.group(1),) + key(o) + (ta.group(2) if ta else t,))
        elif t.startswith(('Sfx', 'Song')): n2 = 'Snd_%02X_%04X_EntryOf_%s' % (key(o) + (t,))
        else: n2 = '%s_Entry%04X' % (t, key(o)[1])
        note = names[key(o)][2]
        put(*key(o), uniq(n2), 'I', 'never read in the runs, but %s points to it (the word at %s): %s' % (t, hx(i), note.split(': ', 1)[1] if ': ' in note else note), 'data_entry')
        st['leftover'] -= 1; st['entry'] += 1
    return st
