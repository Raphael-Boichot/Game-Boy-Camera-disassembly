#!/usr/bin/env python3
"""What a sound does, read from the log of its APU register writes (the `apu` lists that `sound_clips.py --apu` puts in OUTDIR/<channel>.json).

Library: `notes(apu)` rebuilds the notes of the four channels from the writes (a note starts at a write of NRx4 with bit 7; a write of NRx3 or of the high bits of NRx4 afterwards is a
pitch step of the same note; a note ends at the next trigger of its channel, at the length counter, at the envelope reaching 0, or when the channel is switched off), `describe(notes)` gives
a few lines of text, `roll(notes, path)` draws a piano roll.  Nothing here listens to anything: pitch is computed from the registers (pulse 131072 / (2048 - x) Hz, wave 65536 / (2048 - x) Hz,
noise 262144 / (r 2^s) Hz) and the notes are named by the equal-tempered scale from A4 = 440 Hz, which is a reading of numbers, not of sound.
CLI: sound_describe.py JSON [ID]    prints the description of every request (or of one id) of a sound_clips.py json."""
import sys, json, math

REG = {1: (0x10, 0x11, 0x12, 0x13, 0x14), 2: (None, 0x16, 0x17, 0x18, 0x19), 3: (0x1A, 0x1B, 0x1C, 0x1D, 0x1E), 4: (None, 0x20, 0x21, 0x22, 0x23)}
NAMES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
DUTY = ['12.5%', '25%', '50%', '75%']
KIND = {1: 'pulse 1', 2: 'pulse 2', 3: 'wave', 4: 'noise'}


def hz(ch, lo, hi):
    x = ((hi & 7) << 8) | lo
    if ch == 3: return 65536.0 / (2048 - x)
    return 131072.0 / (2048 - x)


def noise_hz(v):
    r = v & 7; s = v >> 4
    return 262144.0 / ((r if r else 0.5) * (1 << s))


def note_name(f):
    if f <= 0: return '-'
    n = int(round(69 + 12 * math.log2(f / 440.0)))
    return '%s%d' % (NAMES[n % 12], n // 12 - 1)


def midi(f):
    return 69 + 12 * math.log2(f / 440.0) if f > 0 else 0


def sweep(n):
    """pulse 1 only: the hardware sweep unit changes the pitch by itself (NR10: period bits 4-6 in 1/128 s, direction bit 3 (1 = down), shift bits 0-2) every period ticks after the trigger;
    the steps are added to the note when nothing else changed its pitch, and a rising sweep that passes 2047 ends the note"""
    sw = n.get('sweep', 0)
    if n['ch'] != 1 or not sw or n['steps']: return
    P = (sw >> 4) & 7; sh = sw & 7; dec = bool(sw & 8)
    if P == 0 or sh == 0: return
    x = n['x0']; t = n['t0']; k = 0
    while k < 200:
        k += 1; t = n['t0'] + k * P / 128.0
        if t >= n['t1']: break
        d = x >> sh; x = x - d if dec else x + d
        if x > 2047: n['t1'] = t; break
        if x < 1: break
        n['steps'].append((t, hz(1, x & 255, x >> 8)))
    n['swept'] = bool(n['steps'])


def notes(apu):
    """apu: [[t, reg, value], ...] with reg a two-digit hex string or 'W'; returns a list of note dicts, in time order"""
    reg = {}; wave = []; cur = {}; out = []; wave_hist = {}
    last_t = 0.0
    def end(ch, t, why):
        n = cur.pop(ch, None)
        if n is None: return
        n['t1'] = max(n['t0'], t); n['why'] = why
        sweep(n)
        if not n.get('silent'): out.append(n)          # a trigger with volume 0 is how the engine mutes a channel: it ends the note before it and is not a note itself
    def limit(n):
        """end time of a note from its own length counter and envelope"""
        t = None
        if n['len_en']:
            L = (256 - n['len']) / 256.0 if n['ch'] == 3 else (64 - n['len']) / 256.0
            t = n['t0'] + L
        if n['ch'] != 3 and n.get('pace', 0) and not n.get('up'):
            e = n['t0'] + n['vol'] * n['pace'] / 64.0
            t = e if t is None else min(t, e)
        return t
    for t, g, v in apu:
        last_t = t
        if g == 'W':
            wave.append(v); continue
        r = int(g, 16); reg[r] = v
        for ch, rr in REG.items():
            nr0, nr1, nr2, nr3, nr4 = rr
            n = cur.get(ch)
            if n is not None and n.get('lim') is not None and t >= n['lim']:
                end(ch, n['lim'], 'length/envelope'); n = None
            if r == nr4:
                if v & 0x80:
                    end(ch, t, 'retrigger')
                    n = dict(ch=ch, t0=t, len_en=bool(v & 0x40), len=reg.get(nr1, 0) & (0xFF if ch == 3 else 0x3F), steps=[])
                    if ch == 4:
                        n['f'] = noise_hz(reg.get(nr3, 0)); n['poly'] = reg.get(nr3, 0)
                    else:
                        n['f'] = hz(ch, reg.get(nr3, 0), v); n['x0'] = ((v & 7) << 8) | reg.get(nr3, 0)
                    if ch in (1, 2): n['duty'] = reg.get(nr1, 0) >> 6
                    if ch == 1: n['sweep'] = reg.get(nr0, 0)
                    if ch == 3:
                        n['vol3'] = (reg.get(nr2, 0) >> 5) & 3; n['wave'] = tuple(wave[-16:]) if len(wave) >= 16 else None
                        n['vol'] = {0: 0, 1: 15, 2: 8, 3: 4}[n['vol3']]
                    else:
                        e = reg.get(nr2, 0); n['vol'] = e >> 4; n['up'] = bool(e & 8); n['pace'] = e & 7
                    n['silent'] = (n['vol3'] == 0) if ch == 3 else (n['vol'] == 0 and (not n['up'] or n['pace'] == 0))
                    n['f0'] = n['f']; n['lim'] = limit(n); cur[ch] = n
                elif n is not None and ch != 4:
                    f = hz(ch, reg.get(nr3, 0), v)
                    if abs(f - n['f']) > 1e-9: n['steps'].append((t, f)); n['f'] = f
            elif r == nr3 and n is not None:
                if ch == 4:
                    f = noise_hz(v)
                else:
                    f = hz(ch, v, reg.get(nr4, 0))
                if abs(f - n['f']) > 1e-9: n['steps'].append((t, f)); n['f'] = f
            elif r == nr2 and n is not None and ch != 3:
                if v == 0 or (v >> 3) == 0:
                    end(ch, t, 'channel off')
                else:
                    n['vol'] = v >> 4; n['up'] = bool(v & 8); n['pace'] = v & 7
            elif ch == 3 and r == nr0 and not (v & 0x80) and n is not None:
                end(ch, t, 'channel off')
            elif r == nr2 and n is not None and ch == 3:
                n['vol3'] = (v >> 5) & 3
    for ch in list(cur): end(ch, cur[ch]['lim'] if cur[ch].get('lim') is not None else last_t, 'end of log')
    out.sort(key=lambda n: (n['t0'], n['ch']))
    return out


def describe(ns, maxnotes=10):
    """a list of text lines"""
    lines = []
    for ch in (1, 2, 3, 4):
        cn = [n for n in ns if n['ch'] == ch]
        if not cn: continue
        t0 = cn[0]['t0']; t1 = max(n['t1'] for n in cn)
        head = '%s: %d note%s over %.2f-%.2f s' % (KIND[ch], len(cn), '' if len(cn) == 1 else 's', t0, t1)
        if ch in (1, 2):
            ds = sorted(set(n['duty'] for n in cn)); head += ', duty ' + '/'.join(DUTY[d] for d in ds)
        if ch == 3:
            vs = sorted(set(n['vol3'] for n in cn)); head += ', output level ' + '/'.join(['mute', '100%', '50%', '25%'][v] for v in vs)
            ws = set(n['wave'] for n in cn if n['wave']); head += ', %d wave table%s loaded' % (len(ws), '' if len(ws) == 1 else 's')
        if ch == 1 and any(n.get('sweep') for n in cn): head += ', hardware sweep %s' % '/'.join('$%02X' % s for s in sorted(set(n['sweep'] for n in cn if n.get('sweep'))))
        fs = [n['f0'] for n in cn] + [f for n in cn for _, f in n['steps']]
        if ch != 4: head += ', pitch %s-%s (%.0f-%.0f Hz)' % (note_name(min(fs)), note_name(max(fs)), min(fs), max(fs))
        else: head += ', noise rate %.0f-%.0f Hz' % (min(fs), max(fs))
        lines.append(head)
        if len(cn) <= maxnotes:
            parts = []
            for n in cn:
                s = '%s %.2fs' % (note_name(n['f0']) if ch != 4 else '%.0fHz' % n['f0'], n['t1'] - n['t0'])
                if n['steps']:
                    s += ' (%s%d pitch steps %s>%s)' % ('sweep, ' if n.get('swept') else '', len(n['steps']), note_name(n['f0']) if ch != 4 else '%.0f' % n['f0'], note_name(n['steps'][-1][1]) if ch != 4 else '%.0f' % n['steps'][-1][1])
                parts.append(s)
            lines.append('  ' + ', '.join(parts))
        else:
            parts = ['%s %.2fs' % (note_name(n['f0']) if ch != 4 else '%.0fHz' % n['f0'], n['t1'] - n['t0']) for n in cn[:maxnotes]]
            lines.append('  first notes: ' + ', '.join(parts) + ' ...')
        sw = [n for n in cn if n.get('swept')]
        if sw and len(cn) > maxnotes:
            n = sw[0]; lines.append('  the hardware sweep $%02X slides each note %s to %s (%d steps in %.2f s)' % (n['sweep'], note_name(n['f0']), note_name(n['steps'][-1][1]), len(n['steps']), n['steps'][-1][0] - n['t0']))
    if not lines: lines.append('no note was triggered')
    return lines


def roll(ns, path, tmax=None, title=None):
    import matplotlib; matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    col = {1: '#d1495b', 2: '#2e86ab', 3: '#3a9d5d', 4: '#777777'}
    fig, ax = plt.subplots(figsize=(7.2, 1.7), dpi=100)
    tm = tmax or max([n['t1'] for n in ns] + [0.1])
    for n in ns:
        if n['ch'] == 4:
            y = 20 + 6 * math.log2(max(n['f0'], 1) / 100.0) / 2
            ax.plot([n['t0'], n['t1']], [y, y], color=col[4], lw=2.2, alpha=.55, solid_capstyle='butt')
            for ts, f in n['steps']:
                pass
            continue
        xs = [n['t0']] + [t for t, _ in n['steps']] + [n['t1']]
        ys = [midi(n['f0'])] + [midi(f) for _, f in n['steps']]
        ys += [ys[-1]]
        ax.step(xs, ys, where='post', color=col[n['ch']], lw=2.0, alpha=.9, solid_capstyle='butt')
    ax.set_xlim(0, tm); ax.set_xlabel('s', fontsize=7); ax.set_ylabel('pitch (semitones from A4)', fontsize=7)
    ax.tick_params(labelsize=7); ax.grid(alpha=.25)
    for s in ('top', 'right'): ax.spines[s].set_visible(False)
    if title: ax.set_title(title, fontsize=8, loc='left')
    fig.tight_layout(pad=0.4); fig.savefig(path, format='png'); plt.close(fig)


if __name__ == '__main__':
    j = json.load(open(sys.argv[1])); want = sys.argv[2].upper() if len(sys.argv) > 2 else None
    for q in j['requests']:
        if want and q['id'] != want: continue
        print('id %s  clip %.2f s%s' % (q['id'], q.get('clip_s', 0), ' (cut at the window end)' if q.get('cut') else ''))
        for l in describe(notes(q.get('apu', []))): print('  ' + l)
