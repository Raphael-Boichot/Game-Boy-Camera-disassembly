#!/usr/bin/env python3
"""Who uses the OAM meta-sprite lists of the table 01:4000?  `Oam_AddMeta_B01_4000` (00:24AF) takes the list id in A; the 249 two-byte pointers at 01:4000 lead to lists of `[Y, X, tile, attr]` sprites + one terminator byte.
For every list id asked (default `$A6-$BB`, the ids that no organic run asks for) this prints the list (address, sprites, tiles), whether its pointer entry and its bytes were READ in any run / in an organic run
(coverage file cov.npz: `dr` / `odr`), the instruction that read them first (`rdr`), and how many of the `call $24AF` sites of the ROM (bytes CD AF 24) have a `ld a, id` (3E id) in the 12 bytes before them.
That last test is a literal-id test: it finds an id written next to the call, not an id taken from a table or a RAM byte (`id sources` = calls that have no literal id).
usage: oam_list_use.py ROM COV.npz [ID[-ID] ...]   e.g. oam_list_use.py pocketcamera_jp.gb coverage/v8/merged_v8/cov.npz BA   (README 16.24: the hand flipping a newspaper, list $BA)"""
import sys
import numpy as np
CALL = bytes([0xCD, 0xAF, 0x24]); NLIST = 249

def lists(rom):
    ptr = [rom[0x4000 + 2 * i] | rom[0x4001 + 2 * i] << 8 for i in range(NLIST)]
    srt = sorted({p for p in ptr if 0x4000 <= p < 0x8000})
    out = []
    for i, p in enumerate(ptr):
        nxt = srt[srt.index(p) + 1] if p in srt and srt.index(p) + 1 < len(srt) else p + 1
        out.append((p, rom[p:nxt]))          # bank 1 starts at ROM offset 0x4000, so a pointer is the file offset
    return ptr, out

def call_sites(rom):
    s = []; i = rom.find(CALL)
    while i >= 0: s.append(i); i = rom.find(CALL, i + 1)
    return s

def literal_sites(rom, sites, ident, window=12):
    return [p for p in sites if bytes([0x3E, ident]) in rom[max(0, p - window):p]]

def read_stats(cov, lo, hi):
    return int(cov['dr'][lo:hi].sum()), int(cov['odr'][lo:hi].sum()), hi - lo

def summary(rom, ids):
    """(calls, ids of `ids` with a literal `ld a, id` near a call, ids with a literal site over the whole table, their sites, calls with no literal id at all)"""
    sites = call_sites(rom); lit = [i for i in range(NLIST) if literal_sites(rom, sites, i)]
    nolit = [p for p in sites if not any(rom[k] == 0x3E and rom[k + 1] < NLIST for k in range(max(0, p - 12), p - 1))]
    return dict(calls=len(sites), asked=[i for i in ids if i in lit], control_ids=len(lit), control_sites=sum(len(literal_sites(rom, sites, i)) for i in lit), nolit=len(nolit))

def organic(cov, rom, ids):
    """(lists whose bytes no organic run read, organic reads of the pointer entries and the bytes of the lists `ids`)"""
    ptr, ls = lists(rom)
    unread = sum(1 for i in range(NLIST) if read_stats(cov, ptr[i], ptr[i] + len(ls[i][1]))[1] == 0)
    return unread, sum(read_stats(cov, 0x4000 + 2 * i, 0x4002 + 2 * i)[1] + read_stats(cov, ptr[i], ptr[i] + len(ls[i][1]))[1] for i in ids)

def first_reader(cov, off):
    r = int(cov['rdr'][off])
    return '%02X:%04X' % ((r >> 16) & 0xFF, r & 0xFFFF) if r & 0x80000000 else '-'

if __name__ == '__main__':
    a = sys.argv[1:]; rom = open(a[0], 'rb').read(); cov = np.load(a[1])
    ids = []
    for t in (a[2:] or ['A6-BB']):
        lo, _, hi = t.partition('-'); ids += range(int(lo, 16), int(hi or lo, 16) + 1)
    ptr, ls = lists(rom); sites = call_sites(rom)
    print('%d calls of 00:24AF (CD AF 24) in the ROM' % len(sites))
    org_unread = [i for i in range(NLIST) if read_stats(cov, ptr[i], ptr[i] + len(ls[i][1]))[1] == 0]
    print('lists whose bytes no organic run read: %d of %d' % (len(org_unread), NLIST))
    print('id   list    sprites tiles       entry read (any/org)  list bytes read (any/org)  first reader  calls with ld a,id nearby')
    for i in ids:
        p, b = ls[i]; n = (len(b) - 1) // 4; spr = [b[4 * k + 2] for k in range(n)]
        e = read_stats(cov, 0x4000 + 2 * i, 0x4002 + 2 * i); l = read_stats(cov, p, p + len(b))
        print('%02X  01:%04X  %3d     %s  %d/%d  %3d/%3d  %3d/%3d  %s  %d' % (i, p, n, ('%02X-%02X' % (min(spr), max(spr))) if spr else '-', e[0], e[1], l[0], l[2], l[1], l[2], first_reader(cov, p), len(literal_sites(rom, sites, i))))
    print('ids asked that no call has as a literal: %s' % ' '.join('%02X' % i for i in ids if not literal_sites(rom, sites, i)))
    s = summary(rom, ids)                                                                   # control: the same test on every id
    print('control: %d of %d ids have a literal call site (%d sites); %d of the %d calls have no literal id at all (the id comes from a table or a RAM byte)' % (s['control_ids'], NLIST, s['control_sites'], s['nolit'], s['calls']))
