#!/usr/bin/env python3
"""Sound clips of the sound-effect ids, recorded in BGB (README 16.24, owner page of the L3 pass of 2026-10-14).

BGB cannot post a sound request, so the ROM is patched (the patch is the experiment, not a hidden feature of the game): the `call Joy_ClearSticky` of Main_Loop (00:2F33, `CD 82 0A`)
becomes `call $3600` and a hook in the bank-0 padding at $3600 calls it, counts frames and, every PERIOD frames, writes the next id of a table (at $3680) to ONE request mailbox
($DD60 sfx1, $DD70 sfx3, $DD78 sfx4 = what the request helpers 00:2A4B-2A88 do).  BGB records its audio (WavFileOut=1, 44.1 kHz stereo) and logs every write of the mailbox and of NRx4 (TOTALCLKS).
The first NRx4 write with bit 7 after the first request is matched with the first audible sample to line the clock and the WAV up; each clip runs from the request to the next request
(trimmed after the last audible sample, at most PERIOD frames) and is written as a mono MP3.
usage: sound_clips.py CHANNEL OUTDIR [ID ID ...] [--period PASSES] [--maxlen SECONDS] [--rom ROM] [--entry N]     (PERIOD = main-loop passes between two requests, about 1.77 frames each)
  CHANNEL sfx1 | sfx3 | sfx4     (ids in hex; default: every id found in disasm/sym_names_jp.csv handler names of that channel)
Output: OUTDIR/<channel>_<id>.mp3, OUTDIR/<channel>.json (request clocks, offset, clip lengths), the raw WAV.
Needs BGB under wine (README gotchas), rgbasm / rgblink (/home/claude/tc/rgbds), ffmpeg.  The audio is what BGB's APU produced: nobody listened to it here."""
import sys, os, re, json, glob, subprocess, tempfile, shutil, wave, csv
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import numpy as np
REPO = os.path.dirname(os.path.dirname(HERE))
MAILBOX = {'sfx1': 0xDD60, 'sfx3': 0xDD70, 'sfx4': 0xDD78}
CH = {'sfx1': '1', 'sfx3': '3', 'sfx4': '4'}
CLK = 2097152.0; FRAME = 35112; PASS_FRAMES = 1.9     # %TOTALCLKS% of BGB counts 2,097,152 per second (35,112 per frame: half of the 4.19 MHz clock), measured on the 3,600 frame-by-frame mailbox writes
args = sys.argv[1:]
def opt(name, default=None):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return default
period = int(opt('--period', '120')); maxlen = float(opt('--maxlen', '4.0')); rom_path = opt('--rom', '/home/claude/gbcam_jp/pocketcamera_jp.gb'); entry = int(opt('--entry', '0'))
assert 1 <= period <= 255, 'the pass counter of the hook is one byte'
chan, out = args[0], args[1]; ids = [int(x, 16) for x in args[2:]]
if not ids:
    s = set()
    for r in csv.DictReader(open(REPO + '/disasm/sym_names_jp.csv', encoding='utf-8')):
        m = re.match(r'Sfx%s_(?:Init|Step)_([0-9A-F]{2}(?:_[0-9A-F]{2})*)' % CH[chan], r['name'])
        if m: s.update(int(x, 16) for x in m.group(1).split('_'))
    ids = sorted(s)
os.makedirs(out, exist_ok=True)

def build_rom():
    rom = bytearray(open(rom_path, 'rb').read())
    tbl = [0, 0] + ids + [0xFF]
    asm = '\n'.join(['SECTION "hook", ROM0[$3600]', 'Hook:', '  call $0A82', '  ld a,[$DE00]', '  inc a', '  ld [$DE00],a', '  cp %d' % period, '  ret c', '  xor a', '  ld [$DE00],a',
                     '  ld a,[$DE01]', '  and a', '  jr nz,.n', '  ld a,$FF', '  ld [$DD68],a', '  xor a', '.n:', '  ld e,a', '  inc a', '  ld [$DE01],a', '  ld d,0',     # first pass: request $FF in the music mailbox $DD68 (reset, README section 2.9) so that the menu music stops and nothing else sounds
                     '  ld hl,$3680', '  add hl,de', '  ld a,[hl]', '  cp $FF', '  ret z', '  and a', '  ret z',
                     '  ld [$%04X],a' % MAILBOX[chan], '  ret', 'SECTION "tbl", ROM0[$3680]', '  db ' + ','.join('$%02X' % x for x in tbl)]) + '\n'
    tmp = tempfile.mkdtemp(prefix='sndclips_'); env = dict(os.environ); env['PATH'] = '/home/claude/tc/rgbds:' + env['PATH']
    open(tmp + '/h.asm', 'w').write(asm)
    subprocess.check_call(['rgbasm', '-o', tmp + '/h.o', tmp + '/h.asm'], env=env); subprocess.check_call(['rgblink', '-x', '-o', tmp + '/h.bin', tmp + '/h.o'], env=env)
    code = open(tmp + '/h.bin', 'rb').read()
    hook = code[0x3600:0x3680].rstrip(b'\0'); table = code[0x3680:0x3680 + len(tbl)]
    assert len(tbl) <= 0x70, 'too many ids for one run'
    assert all(v == 0 for v in rom[0x3600:0x36F0]), 'bank-0 padding at $3600-$36EF is not free'
    rom[0x3600:0x3600 + len(hook)] = hook; rom[0x3680:0x3680 + len(table)] = table
    assert rom[0x2F33:0x2F36] == bytes([0xCD, 0x82, 0x0A]); rom[0x2F33:0x2F36] = bytes([0xCD, 0x00, 0x36]); shutil.rmtree(tmp, ignore_errors=True)
    return bytes(rom)

import bgb_run
bgbdir = os.environ.get('BGB_DIR', '/home/claude/bgbs')
if not os.path.isdir(bgbdir): shutil.copytree('/home/claude/bgbx', bgbdir)
bgb_run.BGB = bgbdir
C = {}
for l in open('/home/claude/gbcam_jp/unlock_runs/f1_organic/corpus.jsonl'):
    if l.strip(): e = json.loads(l); C[e['id']] = e
sp = C[entry]['spec']
sav = None
for d in ('saves_unl', 'saves'):
    f = os.path.join('/home/claude/gbcam_jp', d, sp['sav'] + '.sav')
    if os.path.exists(f): sav = f; break
rom = os.path.join(out, 'hook_%s.gb' % chan); open(rom, 'wb').write(build_rom())
log = os.path.join(bgbdir, 'debugmsg.txt')
if os.path.exists(log): os.remove(log)
pre = os.path.join(out, chan + '_bgb')
for f in glob.glob(pre + '*.wav'): os.remove(f)
wps = ['%04X//w/REQ %%VALUE%% %%TOTALCLKS%%' % MAILBOX[chan]] + ['%s//w/TRIG %s %%VALUE%% %%TOTALCLKS%%' % (a, n) for a, n in (('FF14', 1), ('FF19', 2), ('FF1E', 3), ('FF23', 4))]
extra = ['-setting', 'DebugMsgFile=1', '-wp', ','.join(wps), '-setting', 'WavFileOut=1', '-setting', 'RecordPrefix=' + pre]
frames = int((len(ids) + 3) * period * PASS_FRAMES) + 240     # the main loop of the main menu takes about 1.77 frames per pass (measured: 150 passes = 266 frames)
r = bgb_run.run(rom, sav, os.path.join(out, chan + '_run'), [], combo=0, free=sp['free'] + 3, extra=extra, tail=frames, timeout=1500)
reqs = []; trig = []
for l in open(log, errors='replace'):
    m = re.match(r'\s*REQ ([0-9A-Fa-f]+) ([0-9A-Fa-f]+)', l)
    if m and int(m.group(1), 16): reqs.append((int(m.group(1), 16), int(m.group(2), 16)))
    m = re.match(r'\s*TRIG (\d) ([0-9A-Fa-f]+) ([0-9A-Fa-f]+)', l)
    if m and int(m.group(2), 16) & 0x80: trig.append((int(m.group(1)), int(m.group(3), 16)))
wfs = sorted(glob.glob(pre + '*.wav')); assert wfs, 'no WAV recorded (rc %s)' % r['rc']
w = wave.open(wfs[-1]); sr = w.getframerate(); d = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').reshape(-1, w.getnchannels()).astype(float).mean(1); w.close()
print('requests', len(reqs), 'trigger writes', len(trig), 'wav %.1f s' % (len(d) / sr), 'mode:state %s:%s' % (r['mode'], r['state']))
# ---- clock <-> WAV alignment by content: the NRx4 triggers (clock) are matched with the loud parts of the WAV over a grid of offsets (BGB's WAV time is not exactly the emulated clock, README 16.26)
dt = 0.01; nb = int(len(d) / sr / dt) + 1
rms = np.array([np.sqrt(np.mean(d[int(k * dt * sr):int((k + 1) * dt * sr)] ** 2)) if int((k + 1) * dt * sr) <= len(d) else 0.0 for k in range(nb)])
thr = max(150.0, rms.max() * 0.02); loud = rms > thr
T = np.zeros(nb + 2000)
for ch, c in trig:
    k = int(round(c / CLK / dt)) + 1000
    if 0 <= k < len(T): T[k:k + 8] += 1                      # a trigger sounds from 0 to 80 ms later
best = None
for kk in range(-600, 601):                                   # offsets from -6 s to +6 s, 10 ms steps
    a = np.roll(T, kk)[1000:1000 + nb]
    sc = float((a * loud).sum()) - 0.5 * float((a * (~loud)).sum())
    if best is None or sc > best[0]: best = (sc, kk)
off = best[1] * dt
print('offset %.2f s (score %.0f of %.0f trigger bins)' % (off, best[0], T.sum()))
def onset_after(t, tmax):
    i0 = int(max(t, 0) / dt); i1 = int(min(tmax, nb * dt) / dt); idx = np.flatnonzero(loud[i0:i1])
    return (i0 + idx[0]) * dt if len(idx) else None
info = dict(channel=chan, period_passes=period, ids=ids, requests=[], offset_s=off, wav=wfs[-1], wav_s=len(d) / sr)
trig_t = [c / CLK for ch, c in trig]
for k, (val, clks) in enumerate(reqs):
    rt = clks / CLK + off                                    # request time in WAV seconds
    nxt = (reqs[k + 1][1] / CLK + off) if k + 1 < len(reqs) else rt + maxlen + 0.5
    tr = [t + off for t in trig_t if t + off >= rt - 0.02]; tr = tr[0] if tr else None   # first NRx4 trigger after the request
    on = onset_after(rt - 0.05, nxt - 0.05)
    row = dict(id='%02X' % val, req_s=rt, trigger_s=tr, audible=on is not None)
    if on is not None:
        seg = loud[int(on / dt):int((nxt - 0.05) / dt)]; idx = np.flatnonzero(seg)
        end = on + (idx[-1] + 1) * dt; cut = end >= nxt - 0.12
        st = tr if (tr is not None and 0 <= tr - rt < 0.5) else on       # the clip starts 10 ms before the first NRx4 trigger of the request (not at an earlier tail of the previous effect)
        a = max(0.0, st - 0.01); b = min(end + 0.15, nxt - 0.05, a + maxlen)
        row.update(onset_s=on, onset_delay_s=on - rt, trigger_gap_s=(on - tr) if tr is not None else None, clip_s=b - a, peak=float(np.abs(d[int(a * sr):int(b * sr)]).max()), cut=bool(cut or b - a >= maxlen - 1e-6))
        tmp = os.path.join(out, 'tmp_%02X.wav' % val); ww = wave.open(tmp, 'wb'); ww.setnchannels(1); ww.setsampwidth(2); ww.setframerate(sr)
        ww.writeframes(np.clip(d[int(a * sr):int(b * sr)], -32768, 32767).astype('<i2').tobytes()); ww.close()
        mp3 = os.path.join(out, '%s_%02X.mp3' % (chan, val))
        subprocess.run(['ffmpeg', '-y', '-loglevel', 'error', '-i', tmp, '-ac', '1', '-ar', '22050', '-af', 'afade=t=out:st=%.3f:d=0.08' % max(0.0, b - a - 0.08), '-c:a', 'libmp3lame', '-b:a', '32k', mp3], check=True); os.remove(tmp)
        row.update(mp3=mp3, bytes=os.path.getsize(mp3))
    info['requests'].append(row)
json.dump(info, open(os.path.join(out, chan + '.json'), 'w'), indent=1)
for q in info['requests']:
    print(q['id'], 'req %.2f' % q['req_s'], 'trig %s' % ('%.2f' % q['trigger_s'] if q['trigger_s'] is not None else '-'), 'onset %s' % ('%.2f' % q['onset_s'] if q['audible'] else 'SILENT'),
          'len %.2f' % q.get('clip_s', 0), 'CUT' if q.get('cut') else '', 'gap-to-trigger %s' % ('%+.3f' % q['trigger_gap_s'] if q.get('trigger_gap_s') is not None else '-'), q.get('bytes', 0))
print('clips', sum(1 for q in info['requests'] if q['audible']), 'silent', [q['id'] for q in info['requests'] if not q['audible']], 'requests', len(reqs), 'of', len(ids))
