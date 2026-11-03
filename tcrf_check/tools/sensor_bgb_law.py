#!/usr/bin/env python3
"""Replay, on the events logged in BGB by sensor_bgb_log.py, the three steps of the live-view exposure loop of Cam_MainDispatch (bank $0A, README section 18.6):
   Level   (0A:402D)  level L = FF8A, with the setpoint divisor D59A, the contrast D59B and the active gain index D587 as they are then,
   ShiftLoaded (0A:403A)  the shift s = FF8B read from the table at 0A:7B00, with the current 16-bit exposure D596:D597,
   ExposureNew (0A:4076)  the new exposure HL = e + (e >> s) (L >= 36) or e - (e >> s) (L < 36), saturating at $FFFF.
It checks that s == table[L] and that law(e, L) == HL for every dispatch, and prints the range of L, of D59A and D59B and the bands seen.
usage: sensor_bgb_law.py ROM.gb EVENTS.csv [EVENTS.csv ...]      (the NAME_events.csv files of assets/sensor/bgb/; a scenario directory holding NAME_events.csv also works)"""
import sys, os, csv, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import sensor_exposure_check as X


def kv(s):
    return dict(p.split('=') for p in s.split() if '=' in p)


def run(d, SH):
    if d.endswith('.csv'): name, fn = os.path.basename(d)[:-len('_events.csv')], d
    else: name = os.path.basename(d.rstrip('/')); fn = os.path.join(d, name + '_events.csv')
    ev = list(csv.DictReader(open(fn)))
    cyc, cur, sm = [], None, None
    for e in ev:
        if e['kind'] != 'M': continue
        if e['what'] == 'Sum': sm = int(kv(e['extra'])['bc'], 16)                      # BC after Cam_PopcountSampleLoop (0A:4011), when logged
        elif e['what'] == 'Level':
            x = kv(e['extra']); cur = dict(level=int(x['level'], 16), d59a=int(x['d59a'], 16) if 'd59a' in x else None, d59b=int(x['d59b'], 16) if 'd59b' in x else None, band=int(x['band'], 16) if 'band' in x else None, sum=sm)
            sm = None
        elif e['what'] == 'ShiftLoaded' and cur is not None:
            x = kv(e['extra']); cur['shift'] = int(x['shift'], 16); cur['exp'] = int(x['exp'], 16)
        elif e['what'] == 'ExposureNew' and cur is not None:
            cur['new'] = int(kv(e['extra'])['exp'], 16); cyc.append(cur); cur = None
    ok = sum(1 for c in cyc if X.law(c['exp'], c['level'], SH) == c['new'])
    sh = sum(1 for c in cyc if c['shift'] == SH[c['level']])
    ls = [c for c in cyc if c['sum'] is not None and c['d59a']]
    if ls: print('%-12s level == min(159, floor(sum / D59A)) on %d of %d dispatches with a logged sum' % (name, sum(1 for c in ls if c['level'] == min(159, c['sum'] // c['d59a'])), len(ls)))
    for c in cyc:
        if X.law(c['exp'], c['level'], SH) != c['new']: print('   mismatch', name, c)
    if not cyc: print('%-12s no dispatch logged' % name); return
    rng = lambda k: ('%s..%s' % (min(c[k] for c in cyc if c[k] is not None), max(c[k] for c in cyc if c[k] is not None))) if any(c[k] is not None for c in cyc) else '-'
    print('%-12s %4d dispatches: shift == table[L] %d, law(e, L) == ROM result %d, mismatches %d | L %s, D59A %s, D59B %s, D587 (gain index G of the active band) %s' % (
        name, len(cyc), sh, ok, len(cyc) - ok, rng('level'), rng('d59a'), rng('d59b'), sorted(set(c['band'] for c in cyc if c['band'] is not None))))


if __name__ == '__main__':
    rom = open(sys.argv[1], 'rb').read(); SH = X.shift_table(rom)
    for d in sys.argv[2:]: run(d, SH)
