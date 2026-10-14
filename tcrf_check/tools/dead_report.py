#!/usr/bin/env python3
"""README 16.26: the result tables of the forced never-run code.  Reads the outputs of dead_jump.py (UNREFERENCED, jump), dead_flip.py (UNREACHABLE, gate flipped), the direct jumps into the pieces
whose gate the flips never executed, dead_effects.py (effect table), and the BGB result files of bgb_dead_hook.py; writes assets/force_unref_jp.csv (48 rows) and assets/force_flip_jp.csv (73 rows).
usage: dead_report.py DEAD_DIR BGB_DIR OUT_DIR [FORCED_DIR for bgb_cases_jp.csv]       (DEAD_DIR holds unref.json flip.json unreach_jump0.json unreach_jump1.json effects.json xorslots.json; BGB_DIR holds out3 out4 outF outU outE)"""
import sys, os, re, json, csv, glob, collections
HERE = os.path.dirname(os.path.abspath(__file__)); REPO = os.path.abspath(os.path.join(HERE, '..', '..'))

def sym():
    d = {}
    for l in open(os.path.join(REPO, 'pocketcamera_jp.sym')):
        m = re.match(r'^([0-9a-fA-F]{2}):([0-9a-fA-F]{4}) (\S+)', l)
        if m: d[(int(m.group(1), 16), int(m.group(2), 16))] = m.group(3)
    return d

def ba(flat): return ('%02X:%04X' % (flat >> 14, (flat & 0x3FFF) + 0x4000)) if flat >= 0x4000 else ('00:%04X' % flat)

def merge(runs):
    out = []
    for a, b, src in runs:
        if src is None: continue
        delta = src - a
        if out and out[-1][2] == delta and a - out[-1][1] <= 64: out[-1][1] = b
        else: out.append([a, b, delta])
    return out

def effects_text(groups):
    """what the code did in its most frequent outcome (and the sum over all outcomes for sound / mode)"""
    ret = [g for g in groups if g['returned']]; n_ret = sum(g['n'] for g in ret); n_all = sum(g['n'] for g in groups)
    bits = []; vr = collections.Counter(); wr = set(); hr = set(); io = set(); snd = set(); modes = 0
    for g in ret:
        d = g['direct']
        if not d: continue
        for a, b, delta in merge(d['vram']): vr[(0x8000 + a, 0x8000 + b, ba(a + delta))] += g['n']
        for a, v in d['wram']: wr.add(a)
        for a, v in d['hram']: hr.add(a)
        for a, v in d['io']: io.add(a)
        for s, v in d['mailbox']: snd.add('%s %d' % (s, v))
        if g['mode_ctl'] != g['mode_after']: modes += g['n']
    if vr:
        top = sorted(vr.items(), key=lambda kv: -kv[1])[:2]
        bits.append('VRAM ' + '; '.join('%04X-%04X<-%s' % k for k, n in top) + (' (+%d more outcomes)' % (len(vr) - 2) if len(vr) > 2 else ''))
    if wr: bits.append('WRAM ' + ','.join('%04X' % a for a in sorted(wr)[:6]) + ('..(%d)' % len(wr) if len(wr) > 6 else ''))
    if hr: bits.append('HRAM ' + ','.join('%04X' % a for a in sorted(hr)[:5]))
    if io: bits.append('IO ' + ','.join('%04X' % a for a in sorted(io)))
    if snd: bits.append('sound request ' + ','.join(sorted(snd)))
    if modes: bits.append('mode changed in %d runs' % modes)
    return n_all, n_ret, ' | '.join(bits) if bits else 'no write'

# what each dead function is (from its label and its code; evidence I for the purpose, C for the run)
WHAT = {
 '00:0367': 'a lone `reti` (the tail of the dead V-Blank handler variant)',
 '00:03D4': 'IE bit 0 cleared (V-Blank interrupt off) and return', '00:03DB': 'IE bit 0 set (V-Blank interrupt on) and return',
 '00:057F': 'short busy-wait loop', '00:069F': 'ROM-bank to VRAM copy with bank switch (8-byte unit variant)', '00:06F8': 'bank-restore tail of 00:069F',
 '00:0758': 'tail of the dead VRAM-safe OR-merge helper 00:0751', '00:0762': 'VRAM-safe AND of a byte (sibling of the live OR helper)', '00:0773': 'VRAM-safe read of a byte (waits for mode 0/1)',
 '00:0781': 'deferred VRAM copy through V-Blank (107 B routine, entry)', '00:07AD': 'branch of 00:0781', '00:07BE': 'body of 00:0781 (never returns when entered alone: it waits for a flag nothing sets)',
 '00:10AC': 'UI sound-effect player: $D92E (1-8) picks NR10-NR14 of channel 1 from the table at 00:10D0',
 '00:190B': 'serial transfer stop (clears SC)', '00:190F': 'serial transfer stop 2 (clears SB, SC and the receive buffer)', '00:19A2': 'printer: clears the two status bytes $DC0D / $DC0E',
 '00:1AEB': 'printer: send a break', '00:1B07': 'continuation of 00:1AEB', '00:1C56': 'a lone `ret`',
 '00:24F1': 'OAM meta-tile adder, bank 02 data 6E4B (bank-switching prologue)', '00:2523': 'OAM meta-tile adder, bank 01 data 5D47', '00:253C': 'OAM meta-tile adder, bank 01 data 4000 (2 B)',
 '00:2E82': 'BC-count delay loop',
 '04:6403': 'tilemap loader: map 24:7120 to $9800', '04:6412': 'tilemap loader: map 25:4B00 to $9800', '04:7C9D': 'photo viewer (mode $0A) step with wrap, Right/Left: sfx1 id 1',
 '05:622D': 'D.J. editor: the 56 performer tiles to $9100 (a third VRAM placement of the live loaders at $8D80 / $9480)', '05:7F1C': 'Ball: graphics set to $9100', '05:7F33': 'Ball: graphics set to $9480',
 '06:71CC': 'SHOOT: timer stepping of $D7E4 modulo 4', '07:41C8': 'mode $0E: go to state $12', '07:4A4D': 'link screen: draw a two-digit number (glyph tiles 17:4800 + 32 x digit to $8700 / $8720)',
 '07:4BC3': 'link screen: hex font 24:57E0 to $8EF0 and the checksum number to the map', '07:4BEA': 'link: sum of the slot buffer into $DA0D / $DA0E', '07:503D': 'alternate entry of a live tile loader (13:5800 / 13:5830 to $8EC0 / $8ED0)',
 '09:6D00': 'RUN!: 16-bit subtract helper', '09:721D': 'RUN!: character graphics set to $9700 and $8800', '0A:4C53': 'a lone `inc b` (tail of the factory measure)',
 '0A:7CE6': 'far-call stub: gain probe', '0A:7CEC': 'far-call stub: factory measure 1',
 '1F:46DD': 'sfx1 starter: loads NR10-NR14 = 00 00 D1 C1 87 through Snd_Sfx_Start (an unused sfx1 id)', '1F:4A61': 'sfx1 step', '1F:4FBC': 'sound freeze flag set', '1F:524B': 'channel-2 register loader (NR21-NR24)',
 '1F:53B9': 'song pan loader', '1F:53E7': 'pan step', '1F:5743': 'vibrato tail', '1F:7FF3': 'sound stop entry',
}

# pieces that did not return in every jump run: a routine entered with registers it never gets, or a tail / body entered without its prologue (it pops a frame that was never pushed): the run goes on at whatever address the stack holds
TAILS = {'00:069F', '00:06F8', '00:0758', '00:0781', '00:07AD', '00:07BE', '0A:7CE6', '0A:7CEC', '1F:5743'}      # the pieces that did not return in every run

def bgb_unref(bgb):
    """BGB confirmation text per UNREFERENCED component"""
    out = {}
    def J(d, n):
        p = os.path.join(bgb, d, n + '.json'); return json.load(open(p)) if os.path.exists(p) else None
    for n, cid in (('map25_4B00_mode16', '04:6412'), ('map24_7120_mode16', '04:6403'), ('tiles24_57E0_mode16', '07:4BC3'), ('tiles17_4800_mode16', '07:4A4D'), ('tiles13_5800_mode16', '07:503D')):
        d = J('out3', n)
        if d: out[cid] = 'BGB: entry hit %d; ' % d['entry_hits'] + '; '.join('VRAM %s = ROM %s: %d / %d bytes (control %d)' % (e['vram'], e['rom'], e['match_forced'], e['n'], e['match_control']) for e in d['expect']) + ('; the rest was refused by the LCD (mode 3)' if cid == '07:4BC3' else '')
    d = J('out3', 'photostep_right_mode10'); e = J('out3', 'photostep_left_mode10')
    if d and e: out['04:7C9D'] = 'BGB: entry hit; Right and Left both request sfx1 id 1 (%s)' % d['sound_new']
    d = J('out4', 'sfx1_unused_46DD')
    if d:
        w = {x[0]: x[1] for x in d['watch_forced'] if x[3] == '525F/1F'}      # the register loader Snd_Sfx_LoadRegs (1F:525F)
        out['1F:46DD'] = 'BGB: real sound code with Sfx1_InitTbl[1] -> 1F:46DD: NR10-NR14 = %s; clip peak %.0f Hz, %.2f s (the real id 1: %.0f Hz, %.2f s)' % (' '.join('%02X' % w[n] for n in ('NR10', 'NR11', 'NR12', 'NR13', 'NR14')), d['peak_hz_forced'], d['len_s_forced'], d['peak_hz_control'], d['len_s_control'])
    ui = []
    for n in range(1, 9):
        d = J('outU', 'uieffect_%d' % n)
        if d: ui.append((n, [x[1] for x in d['watch_forced'] if x[0] in ('NR10', 'NR11', 'NR12', 'NR13', 'NR14')][-5:], d['peak_hz_forced'], d['len_s_forced']))
    if ui: out['00:10AC'] = 'BGB: 8 presets: ' + '; '.join('%d: %s %.0f Hz %.0f ms' % (n, ' '.join('%02X' % v for v in r), p, l * 1000) for n, r, p, l in ui)
    return out

def main():
    dead, bgb, out = sys.argv[1:4]; os.makedirs(out, exist_ok=True); S = sym()
    comps = {r['first_addr']: r for r in csv.DictReader(open(os.path.join(REPO, 'assets', 'reach_components_jp.csv')))}
    U = json.load(open(os.path.join(dead, 'unref.json'))); B = bgb_unref(bgb)
    T = json.load(open(os.path.join(dead, 'targeted.json'))); T_EXTRA = {}
    T_EXTRA['00:10AC'] = 'targeted core run ($D92E = 1..8, NR10-NR14 of channel 1): ' + '; '.join('%d: %s' % (n, ' '.join('%02X' % v for k, v in T['uieffect_%d' % n]['apu'])) for n in range(1, 9))
    T_EXTRA['1F:46DD'] = 'targeted core run (DE = $DD62, as Snd_RunSfx1 leaves it): NR10-NR14 = ' + ' '.join('%02X' % v for k, v in T['sfx1_46DD']['apu'])
    rows = []
    for cid, c in U.items():
        b = int(cid[:2], 16); a = int(cid[3:], 16); n_all, n_ret, eff = effects_text(c['groups'])
        frames = max([g['frames_to_return'] or 0 for g in c['groups'] if g['returned']] or [0]); run = max(g['bytes_run'] for g in c['groups'])
        if cid in TAILS: eff = 'did not return in %d of %d runs (registers the routine never gets, or a tail / body entered without its prologue): not a designed path, the run goes on at whatever the stack holds; %d distinct outcomes' % (n_all - n_ret, n_all, len(c['groups']))
        if cid in T_EXTRA: eff += ' | ' + T_EXTRA[cid]
        rows.append([cid, c['comp']['size'], S.get((b, a)) or S.get((0, a)) or '', WHAT.get(cid, ''), 'jump (PC set at the idle point of the main loop)', n_all, n_ret, n_all - n_ret, frames, '%d / %d' % (run, c['comp']['size']), eff, B.get(cid, 'not run in BGB'), 'C (core run) / I (purpose)' if cid not in B else 'C (core and BGB) / I (purpose)'])
    with open(os.path.join(out, 'force_unref_jp.csv'), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['component', 'bytes', 'label', 'what_it_is', 'method', 'runs', 'returned', 'no_return', 'max_frames_to_return', 'bytes_run', 'effects_in_core', 'bgb', 'evidence']); w.writerows(rows)
    # UNREACHABLE
    F = json.load(open(os.path.join(dead, 'flip.json'))); J2 = {}
    for k in (0, 1):
        p = os.path.join(dead, 'unreach_jump%d.json' % k)
        if os.path.exists(p): J2.update(json.load(open(p)))
    E = json.load(open(os.path.join(dead, 'effects.json'))); X = json.load(open(os.path.join(dead, 'xorslots.json')))
    def bgb_flip(cid):
        for p in glob.glob(os.path.join(bgb, 'outF', 'flip_%s_%s_m*.json' % (cid[:2], cid[3:]))):
            d = json.load(open(p))
            if not d['entry_hits']: return 'BGB: the piece was NOT reached (entry hits 0; mode $%s, control $%s): the replay or the timing differs from the core' % (d['mode_forced'], d['mode_control'])
            return 'BGB: reached (entry hits %d); mode $%s (control $%s); VRAM diff %s B; WRAM diff %s B' % (d['entry_hits'], d['mode_forced'], d['mode_control'], d.get('vram_diff_bytes'), d.get('wram_diff_bytes'))
        return 'not run in BGB'
    rows2 = []
    for cid, v in F.items():
        comp = v['comp']; cr = comps.get(cid, {}); cls = cr.get('class', ''); why = cr.get('note') or ''
        if v['ran']:
            r = v['ran'][0]; method = 'gate %s flipped (%d of %d base / key trials executed the gate)' % ('+'.join(v['gates']), v['hit_gate'], v['tries'])
            res = 'ran %d / %d B from base mode $%02X with %s; mode $%02X:%02X -> $%02X:%02X; %d WRAM, %d VRAM runs, %d OAM bytes changed vs control%s' % (r['comp_bytes_run'], comp['size'], r['mode'], r['seq'], r['mode_ctl'][0], r['mode_ctl'][1], r['mode_after'][0], r['mode_after'][1], r['wram_changed'], r['vram_n'], r['oam_changed'], (' ; sound %s' % r['snd']) if r['snd'] else '')
            rows2.append([cid, cls, comp['size'], why, method, 'yes', res, bgb_flip(cid), 'C (core' + (' and BGB' if bgb_flip(cid).startswith('BGB: reached') else '') + ') / I (why)'])
        elif v['gates']:
            jr = J2.get(cid); method = 'gate %s never executed in %d trials; then a direct jump into the piece' % ('+'.join(v['gates']), v['tries'])
            if jr:
                n_all, n_ret, eff = effects_text(jr['groups']); run = max(g['bytes_run'] for g in jr['groups'])
                res = 'jump: %d runs (idle and zero registers x 30 modes), %d returned, %d / %d B ran; %s' % (n_all, n_ret, run, comp['size'], eff)
            else: res = 'no run'
            rows2.append([cid, cls, comp['size'], why, method, 'jump only', res, 'not run in BGB', 'C (core) / I (why)'])
        else:
            m = re.search(r'\[(\d+)\]', cr.get('entry', '')); idx = int(m.group(1)) if m else None
            if cr.get('entry', '').startswith('0A:541A') and idx is not None:
                e = E['%02X' % idx]
                if e['n']:
                    W = {a: x for a, x in e['wram']}; best = None
                    for k, ee in E.items():
                        if k == '%02X' % idx or not ee['n'] or int(k, 16) in (0x0D, 0x0F, 0x2D, 0x2F, 0x4D, 0x4F, 0x55): continue
                        eq = sum(1 for a, x in ee['wram'] if W.get(a) == x)
                        if eq == e['n'] and (best is None or ee['n'] < best[1]): best = (k, ee['n'])
                    res = 'Cam_DispatchEffect called with A=$%02X: wrote %d bytes at $%04X-$%04X (%d rows of 256 B)%s' % (idx, e['n'], e['span'][0], e['span'][1], e['n'] // 256, ('; the same bytes as the live handler $%s at the same addresses' % best[0]) if best else '')
                else: res = 'Cam_DispatchEffect called with A=$%02X: returns at once, no write (a lone `ret`)' % idx
                method = 'dispatcher called with the missing handler number (A = $%02X)' % idx
            elif cr.get('entry', '').startswith('06:73AF') and idx is not None:
                x = X['slot%02d_%s' % (idx, '7457' if idx == 19 else '7467')] if False else X['slot13_7457' if idx == 19 else 'slot15_7467']
                res = 'XOR pass over %d rows of 256 B from $C000 (key $DA44 nonzero), the same bytes as slot 0 (06:73EF, 14 rows) at the same addresses' % (x['n'] // 256)
                method = 'jump to the slot with a nonzero XOR key $DA44-45'
            else: res = 'no run'; method = ''
            bg = 'not run in BGB'
            EB = json.load(open(os.path.join(bgb, 'effects_bgb.json'))) if os.path.exists(os.path.join(bgb, 'effects_bgb.json')) else {}
            if cr.get('entry', '').startswith('0A:541A') and idx is not None:
                eb = EB.get('%02X' % idx)
                if eb: bg = 'BGB: wrote %d rows only (markers kept at %s), bytes identical to handler $%s: %d / %d' % (eb['rows'], ' '.join(eb['marker_kept']), eb['vs'], eb['equal'], eb['n'])
                elif idx == 0x19: bg = 'BGB: handler $19 called, WRAM unchanged (a lone `ret`)'
                elif idx in (0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x39, 0x3B, 0x3F, 0x59, 0x5B, 0x5C, 0x5D, 0x5E, 0x5F): bg = 'same lone `ret` as $19 (BGB: $19 called, WRAM unchanged)'
            elif cr.get('entry', '').startswith('06:73AF') and idx is not None:
                eb = EB.get('slot13' if idx == 19 else 'slot15'); bg = 'BGB: %d bytes XORed (%d rows), identical to slot 0: %d / %d' % (eb['n'], eb['n'] // 256, eb['equal'], eb['n'])
            rows2.append([cid, cls, comp['size'], why, method, 'yes' if res != 'no run' else 'no', res, bg, 'C (core) / I (why)'])
    with open(os.path.join(out, 'force_flip_jp.csv'), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['component', 'class', 'bytes', 'why_unreachable', 'method', 'ran', 'core_result', 'bgb', 'evidence']); w.writerows(rows2)
    print(len(rows), 'unreferenced rows;', len(rows2), 'unreachable rows;', collections.Counter(r[5] for r in rows2))

def bgb_cases(bgb, out):
    """one row per BGB case (the compact record of the runs; the screenshots / VRAM / WRAM dumps stay in the working directory)"""
    rows = []
    for d in ('out3', 'out4', 'outS', 'outF', 'outU', 'outE'):
        for p in sorted(glob.glob(os.path.join(bgb, d, '*.json'))):
            c = json.load(open(p))
            if 'name' not in c or 'entry_hits' not in c: continue
            ex = '; '.join('%s=%s:%d/%d' % (e['vram'], e['rom'], e['match_forced'], e['n']) for e in c.get('expect', []))
            snd = ' '.join('%s %d' % (a, b) for a, b in c.get('sound_new', []))
            rows.append([d, c['name'], c.get('note', '')[:120], c['entry_hits'], 'yes' if c['entry_hits'] or d in ('out4', 'outU') else 'no', '%s' % c['mode_forced'], '%s' % c['mode_control'], c.get('vram_diff_bytes', ''), c.get('wram_diff_bytes', ''), ex, snd, c.get('peak_hz_forced', '')])
    os.makedirs(out, exist_ok=True)
    with open(os.path.join(out, 'bgb_cases_jp.csv'), 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['batch', 'case', 'note', 'entry_hits', 'reached', 'mode_state_forced', 'mode_state_control', 'vram_diff_bytes', 'wram_diff_bytes', 'rom_span_match', 'sound_requests', 'clip_peak_hz']); w.writerows(rows)
    print(len(rows), 'BGB cases')

if __name__ == '__main__':
    main(); bgb_cases(sys.argv[2], sys.argv[4] if len(sys.argv) > 4 else os.path.join(sys.argv[3], 'forced'))
