#!/usr/bin/env python3
"""Cam_ThresholdConverge (0A:4E44) cost check, README section 18.6.

The routine fills the 48-byte matrix with one flat threshold t, starting at $80, takes a capture and tests the 12 sampled pixels, then moves t by one per capture
until the 'count >= 9' test (then the 'count >= 8' test) changes its answer.  It returns about the mean of the two crossing thresholds, which is stored as one byte
of the calibration vector.  When the result is below $80 the number of captures N is therefore close to $81 - result.
In BGB (fake sensor) this is exact to +-1 on every run; on the real bus the matrix is not visible but the number of identical register rows of each run is N, so the
vector the recorded camera produced can be estimated:  byte ~ $81 - N  (+-1).
usage: sensor_tc_check.py --bgb NAME_events.csv      (pairs N / result in BGB)
       sensor_tc_check.py --real CALIB.xlsx           (run lengths of the recording and the vector they imply)"""
import sys, os, csv
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)


def bgb(fn):
    ev = list(csv.DictReader(open(fn)))
    runs, cur = [], None
    for e in ev:
        if e['kind'] != 'M': continue
        if e['what'] == 'ThresholdConverge':
            if cur is not None: cur['result'] = int(e['extra'].split('=')[1], 16); runs.append(cur)       # ff8e at the next entry = result of the previous run
            cur = dict(n=0)
        elif e['what'] == 'CommitVector' and cur is not None: runs.append(cur); cur = None
        elif e['what'] == 'PixelTest' and cur is not None: cur['n'] += 1
    ok = tot = 0
    for i, r in enumerate(runs):
        res = r.get('result')
        if res is None: print('run %2d  N=%3d  result: (stored in the vector, not logged)' % (i + 1, r['n'])); continue
        pred = 0x81 - r['n']; tot += 1; ok += abs(pred - res) <= 1
        print('run %2d  N=%3d  result $%02X   $81 - N = $%02X   %s' % (i + 1, r['n'], res, pred, 'ok' if abs(pred - res) <= 1 else 'differs'))
    print('%d / %d runs have |$81 - N - result| <= 1' % (ok, tot))


def real(fn):
    import sensor_decode as D
    rows = D.rows_of(fn)
    runs = [n for i, n, d in D.runs(rows) if n >= 1]
    # the first 96 rows are the 12 SAR groups of Cam_FactoryMeasure1 (8 captures each); the rest are the 12 runs of Cam_FactoryMeasure2
    tc = D.runs(rows[96:])
    ns = [n for i, n, d in tc]
    print('FactoryMeasure2 runs (captures with identical registers):', ns)
    print('implied vector bytes ($81 - N, +-1):', ' '.join('%02X' % (0x81 - n) for n in ns))
    return ns


if __name__ == '__main__':
    if sys.argv[1] == '--bgb': bgb(sys.argv[2])
    else: real(sys.argv[2])
