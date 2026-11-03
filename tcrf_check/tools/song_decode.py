#!/usr/bin/env python3
"""Decode a song of the sound driver (bank $1F) into note names (README 16.20).
usage: song_decode.py ROM TABLE ID[,ID...]      TABLE = 57C6 (Japanese ROM) or 57D1 (international ROM); ID in hex, 1-based (the table has 72 words)
Format read from the driver: the song word points at an 11-byte header: transposition (signed), duration-table pointer, four playlist pointers (0 = unused track).
A playlist is a list of stream pointers; a high byte $FF is a jump (the next word is the target), a high byte $00 ends the song.
Stream bytes: $A0-$AF select the length (index into the duration table), $9D = instrument (3 operands), $9E = other duration table (2 operands), $9F = transposition (1 operand),
$9B / $9C loop markers (shown as loop9B / loop9C), $00 end of stream, $01 rest, anything else a note (index x 2 into the frequency table at 1F:4037, 11-bit GB period).
The pitch is the nearest equal-tempered note of 131072 / (2048 - period) Hz with A4 = 440 Hz, after the transposition: a name, not a measured pitch."""
import math, sys
NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
def decode(path, tab, sid, label=''):
    rom = open(path, 'rb').read(); base = 0x1F * 0x4000
    b = lambda a: rom[base + a - 0x4000]; w = lambda a: b(a) | b(a + 1) << 8
    hdr = w(tab + 2 * (sid - 1)); tr = b(hdr); tr = tr - 256 if tr > 127 else tr; dptr = w(hdr + 1)
    dur = [b(dptr + i) for i in range(16)]; pls = [w(hdr + 3 + 2 * i) for i in range(4)]
    print('%s id %02X header %04X transposition %d duration table %04X %s playlists %s' % (label, sid, hdr, tr, dptr, dur, [hex(p) for p in pls]))
    ftab = 0x4037
    for ti, pl in enumerate(pls):
        if pl == 0: continue
        i = pl; words = []
        while True:
            x = w(i)
            if (x >> 8) == 0: words.append('END'); break
            if (x >> 8) == 0xFF: words.append('JUMP->%04X' % w(i + 2)); break
            words.append(x); i += 2
        print('  track', ti + 1, 'playlist', [('%04X' % x if isinstance(x, int) else x) for x in words])
        for x in words:
            if not isinstance(x, int): continue
            j = x; L = 0; out = []; ins = None; tcur = tr
            while True:
                c = b(j)
                if c == 0: break
                if c == 0x9D: ins = (b(j + 1), b(j + 2), b(j + 3)); j += 4; continue
                if c == 0x9E: j += 3; continue
                if c == 0x9F: tcur = b(j + 1); tcur = tcur - 256 if tcur > 127 else tcur; j += 2; continue
                if c in (0x9B, 0x9C): out.append('loop%02X' % c); j += 1 if c == 0x9C else 2; continue
                if 0xA0 <= c <= 0xAF: L = c & 15; j += 1; continue
                if c == 1: out.append('rest/%d' % dur[L]); j += 1; continue
                nb = c + tcur; f = 131072.0 / (2048 - (w(ftab + nb) & 0x7FF)); m = round(69 + 12 * math.log2(f / 440.0)); out.append('%s%d/%d' % (NAMES[m % 12], m // 12 - 1, dur[L])); j += 1
            print('    stream %04X ins=%s : %s' % (x, ins, ' '.join(out)))
if __name__ == '__main__':
    rom, tab, ids = sys.argv[1], int(sys.argv[2], 16), [int(x, 16) for x in sys.argv[3].split(',')]
    for sid in ids: decode(rom, tab, sid)
