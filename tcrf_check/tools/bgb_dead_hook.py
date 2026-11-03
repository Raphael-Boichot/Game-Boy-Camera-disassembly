#!/usr/bin/env python3
"""Confirm in BGB what dead_jump.py / dead_flip.py found in the core (README 16.26): call a never-executed routine of the Japanese ROM from the main thread of the real game.

BGB cannot set the PC, so the ROM is patched (the patch is the experiment, not a hidden feature of the game): the `call Joy_ClearSticky` of Main_Loop (00:2F33, `CD 82 0A`) becomes
`call $3600` and a hook is put in the bank-0 padding at $3600.  The hook calls Joy_ClearSticky, then, once the game has been in the (mode, state) of the case for DELAY frames in a row
with no key held, it does ONCE what the core's jump does: optionally sets the joypad bytes $FFA1 $FFA2 $FFA3 $FFA7-$FFA9 to one key, saves $FF9B (the game's idea of the ROM bank), selects the
bank of the target like Far_Call, loads AF BC DE HL with the values the core run had, `call`s the entry and restores the bank.  Counter / flag: $DE00 / $DE01 (never accessed by the ROM).
The case's corpus entry is replayed as a BGB demo (joypad byte per frame, +3 boot frames).  Logged by BGB (debug message file): a marker when the entry address is executed and every write of the four
sound mailboxes $DD60 (sfx1) $DD68 (music) $DD70 (sfx3) $DD78 (sfx4) with the value and TOTALCLKS; the screen and the state at the end of the demo are kept; with --wav BGB also records its audio
(WavFileOut=1: 44.1 kHz stereo, time zero = power-on, 4,194,304 clocks per second) and the clip around the first non-zero request is cut out.
usage: bgb_dead_hook.py CASES.json OUTDIR [--rom ROM] [--wav] [--bgb DIR] [--only NAME,NAME] [--worker K/N]
  CASES.json = list of {name, bank, entry, corpus_entry, sig:[mode,state], regs:{a,f,bc,de,hl}, key:null|'Left'..., delay:30, extra_markers:[[bank:addr, name],...]}
Needs: BGB under wine (README gotchas), rgbasm / rgblink (/home/claude/tc/rgbds), ffmpeg for --wav.  Environment GBCAM_ROOT (saves, default /home/claude/gbcam_jp)."""
import sys, os, json, shutil, subprocess, tempfile, collections, glob, re
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROOT = os.environ.get('GBCAM_ROOT', '/home/claude/gbcam_jp')
CORPUS = os.path.join(ROOT, 'unlock_runs/f1_organic/corpus.jsonl')
KEYBIT = dict(A=0, B=1, Select=2, Start=3, Right=4, Left=5, Up=6, Down=7)
CORE = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
def names(k): return '+'.join(n for m, n in CORE if k & m) or '-'

def hook_asm(case, call=True):
    """the hook: after `delay` frames in (mode, state) with no key held it does its actions once: the joypad poke, case['pre'] = [(addr, value)] WRAM pokes, the call, case['mailbox'] = [(addr, value)] writes;
    with case['call_stage2'] the poke / pre / call move to `stage2` hook calls later, together with case['mailbox2'] (so that stage 1 can stop the music first)"""
    mode, state = case['sig']; r = case['regs']; bank = case['bank']; delay = case.get('delay', 30)
    def act():
        o = []
        if case.get('key'): o += ['  ld a,$%02X' % (1 << KEYBIT[case['key']])] + ['  ldh [$FF%02X],a' % x for x in (0xA1, 0xA2, 0xA3, 0xA7, 0xA8, 0xA9)]
        for ad, v in case.get('pre', []): o += ['  ld a,$%02X' % v, '  ld [$%04X],a' % ad]
        if call and case.get('entry'):
            o += ['  ldh a,[$FF9B]', '  push af']
            if bank: o += ['  ld a,$%02X' % bank, '  ldh [$FF9B],a', '  ld [$2000],a']
            o += ['  ld bc,$%04X' % ((r['a'] << 8) | (r['f'] & 0xF0)), '  push bc', '  ld bc,$%04X' % r['bc'], '  ld de,$%04X' % r['de'], '  ld hl,$%04X' % r['hl'], '  pop af',
                  '  call $%04X' % case['entry'], '  pop af', '  ldh [$FF9B],a', '  ld [$2000],a']
        return o
    a = ['SECTION "hook", ROM0[$3600]', 'Hook:', '  call $0A82', '  ld a,[$DE01]', '  cp $FF', '  jr z,.post', '  ld a,[$D5CE]', '  cp $%02X' % mode, '  jr nz,.reset', '  ld a,[$D5CF]', '  cp $%02X' % state, '  jr nz,.reset',
         '  ldh a,[$FFA1]', '  and a', '  jr nz,.reset', '  ld a,[$DE00]', '  inc a', '  ld [$DE00],a', '  cp %d' % delay, '  ret nz', '  ld a,$FF', '  ld [$DE01],a', '  xor a', '  ld [$DE02],a']
    if not case.get('call_stage2'): a += act()
    for ad, v in case.get('mailbox', []): a += ['  ld a,$%02X' % v, '  ld [$%04X],a' % ad]
    a += ['  ret', '.post:', '  ld a,[$DE02]', '  inc a', '  ld [$DE02],a']
    if case.get('mailbox2') or case.get('call_stage2'):
        a += ['  cp %d' % case.get('stage2', 60), '  ret nz']
        if case.get('call_stage2'): a += act()
        for ad, v in case.get('mailbox2', []): a += ['  ld a,$%02X' % v, '  ld [$%04X],a' % ad]
    a += ['  ret', '.reset:', '  xor a', '  ld [$DE00],a', '  ret']
    return '\n'.join(a) + '\n'

FLIP = {0x20: 0x28, 0x28: 0x20, 0x30: 0x38, 0x38: 0x30, 0xC2: 0xCA, 0xCA: 0xC2, 0xD2: 0xDA, 0xDA: 0xD2, 0xC4: 0xCC, 0xCC: 0xC4, 0xD4: 0xDC, 0xDC: 0xD4, 0xC0: 0xC8, 0xC8: 0xC0, 0xD0: 0xD8, 0xD8: 0xD0}
def flat(bank, addr): return addr if addr < 0x4000 else (bank << 14) | (addr - 0x4000)

def patch_rom(rom_bytes, case, call=True):
    """the hook in the bank-0 padding + the Main_Loop call (case['hook'] false = none), case['flips'] = [[bank, addr]] conditional branches with the opposite condition, case['patches'] = [[bank, addr, 'hex']]"""
    rom = bytearray(rom_bytes)
    if case.get('hook', True):
        tmp = tempfile.mkdtemp(prefix='deadhook_'); env = dict(os.environ); env['PATH'] = '/home/claude/tc/rgbds:' + env['PATH']
        open(tmp + '/h.asm', 'w').write(hook_asm(case, call))
        subprocess.check_call(['rgbasm', '-o', tmp + '/h.o', tmp + '/h.asm'], env=env); subprocess.check_call(['rgblink', '-x', '-o', tmp + '/h.bin', tmp + '/h.o'], env=env)
        code = open(tmp + '/h.bin', 'rb').read()[0x3600:0x3600 + 200].rstrip(b'\0')
        assert all(v == 0 for v in rom[0x3600:0x3600 + len(code)]), 'bank-0 padding at $3600 is not free'
        rom[0x3600:0x3600 + len(code)] = code
        assert rom[0x2F33:0x2F36] == bytes([0xCD, 0x82, 0x0A]), 'expected call Joy_ClearSticky in Main_Loop'
        rom[0x2F33:0x2F36] = bytes([0xCD, 0x00, 0x36]); shutil.rmtree(tmp, ignore_errors=True)
    if call:
        for bank, addr in case.get('flips', []):
            o = flat(bank, addr); assert rom[o] in FLIP, 'no conditional branch at %02X:%04X' % (bank, addr); rom[o] = FLIP[rom[o]]
        for bank, addr, hx in case.get('patches', []):
            b = bytes.fromhex(hx); o = flat(bank, addr); rom[o:o + len(b)] = b
    return bytes(rom)

def load_corpus():
    C = {}
    for l in open(CORPUS):
        if l.strip(): e = json.loads(l); C[e['id']] = e
    return C

CLK = 4194304.0; FRAME = 70224
def one(case, rom_bytes, outdir, bgbdir, C, tag, call, wav):
    """one BGB run (call = the forced run, not call = the control run with the same hook but no call): returns events, VRAM, screenshot, WAV"""
    import bgb_run
    bgb_run.BGB = bgbdir
    p = []; i = case['corpus_entry']
    while i >= 0: p.append(i); i = C[i].get('parent', -1)
    p = p[::-1]; sp = dict(C[p[0]]['spec']); seq = []
    for j in p[1:]:
        for a in C[j]['actions']: seq.append((names(a[0]), int(a[1]), int(a[2])))
    # a joypad sequence played after the base state (flip cases): [(keys, hold, wait)]
    for k, h, w in case.get('play', []): seq.append((k, h, w))
    sav = None
    for d in ('saves_unl', 'saves', 'intl_saves'):
        f = os.path.join(ROOT, d, sp['sav'] + '.sav')
        if os.path.exists(f): sav = f; break
    name = case['name'] + '_' + tag; os.makedirs(outdir, exist_ok=True)
    rom = os.path.join(outdir, name + '.gb'); open(rom, 'wb').write(patch_rom(rom_bytes, case, call))
    log = os.path.join(bgbdir, 'debugmsg.txt')
    if os.path.exists(log): os.remove(log)
    bank, entry = case.get('bank', 0), case.get('entry', 0)
    br = (['%02X:%04X///MK ENTRY %%TOTALCLKS%% %%ROMBANK%%' % (bank, entry)] if entry else []) + ['%s///MK %s %%TOTALCLKS%%' % (a, n) for a, n in case.get('extra_markers', [])]
    wp = ['%04X//w/SND %s %%VALUE%% %%TOTALCLKS%% %%PC%% %%ROMBANK%%' % (a, n) for a, n in ((0xDD60, 'sfx1'), (0xDD68, 'music'), (0xDD70, 'sfx3'), (0xDD78, 'sfx4'))]
    wp.append('DE01//w/FIRE %VALUE% %TOTALCLKS%')
    if wav:
        for a, n in (('FF14', 'TRIG1'), ('FF19', 'TRIG2'), ('FF1E', 'TRIG3'), ('FF23', 'TRIG4')): wp.append('%s//w/WATCH %s %%VALUE%% %%TOTALCLKS%% %%PC%% %%ROMBANK%%' % (a, n))
    for a, n in case.get('watch', []): wp.append('%s//w/WATCH %s %%VALUE%% %%TOTALCLKS%% %%PC%% %%ROMBANK%%' % (a, n))
    extra = ['-setting', 'DebugMsgFile=1', '-wp', ','.join(wp)]
    wavprefix = os.path.join(outdir, name + '_bgb')
    for f in glob.glob(wavprefix + '*.wav'): os.remove(f)
    if wav: extra += ['-setting', 'WavFileOut=1', '-setting', 'RecordPrefix=' + wavprefix]
    combo = 0 if not sp['combo'] else bgb_run.mask(names(sp['combo']))
    r = bgb_run.run(rom, sav, os.path.join(outdir, name), seq, combo=combo, free=sp['free'] + 3, br=','.join(br) if br else None, extra=extra,
                    tail=case.get('delay', 30) + case.get('after', 90), timeout=900)
    lines = open(log, errors='replace').read().splitlines() if os.path.exists(log) else []
    out = dict(tag=tag, rc=r['rc'], mode=r['mode'], state=r['state'], entry_hits=[], fire=None, sound=[], watch=[], markers=[])
    for l in lines:
        m = re.match(r'\s*MK ENTRY ([0-9A-Fa-f]+) (\w+)', l)
        if m: out['entry_hits'].append(int(m.group(1), 16)); continue
        m = re.match(r'\s*FIRE ([0-9A-Fa-f]+) ([0-9A-Fa-f]+)', l)
        if m and int(m.group(1), 16) == 0xFF and out['fire'] is None: out['fire'] = int(m.group(2), 16); continue
        m = re.match(r'\s*SND (\w+) ([0-9A-Fa-f]+) ([0-9A-Fa-f]+) (\w+) (\w+)', l)
        if m:
            if int(m.group(2), 16): out['sound'].append(dict(ch=m.group(1), value=int(m.group(2), 16), clks=int(m.group(3), 16), pc=m.group(4), bank=m.group(5)))
            continue
        m = re.match(r'\s*WATCH (\w+) ([0-9A-Fa-f]+) ([0-9A-Fa-f]+) (\w+) (\w+)', l)
        if m: out['watch'].append(dict(name=m.group(1), value=int(m.group(2), 16), clks=int(m.group(3), 16), pc=m.group(4), bank=m.group(5))); continue
        m = re.match(r'\s*MK (\w+) ([0-9A-Fa-f]+)', l)
        if m: out['markers'].append((m.group(1), int(m.group(2), 16)))
    out['shot'] = os.path.join(outdir, name + '.png')
    from PIL import Image
    if os.path.exists(r['shot']): Image.open(r['shot']).convert('RGB').save(out['shot'])
    st = r['st']; out['vram'] = st.get('VRAM', b''); out['oam'] = st.get('OAM', b''); out['wram'] = st.get('WRAM', b'')
    out['frames'] = os.path.getsize(os.path.join(outdir, name + '.dem'))
    wfs = sorted(glob.glob(wavprefix + '*.wav'))
    if wav and wfs:
        out['wav'] = wfs[-1]
        import wave
        w = wave.open(wfs[-1]); out['wav_s'] = w.getnframes() / float(w.getframerate()); w.close()
        out['wav_offset_end_s'] = out['wav_s'] - out['frames'] * FRAME / CLK       # end-aligned estimate (varies by about a second between runs: not used for the clips)
    return out

def wavmono(fn):
    import wave, numpy as np
    w = wave.open(fn); sr = w.getframerate(); d = np.frombuffer(w.readframes(w.getnframes()), dtype='<i2').reshape(-1, w.getnchannels()).astype(float).mean(1); w.close(); return d, sr

def savewav(fn, x, sr):
    import wave, numpy as np
    w = wave.open(fn, 'wb'); w.setnchannels(1); w.setsampwidth(2); w.setframerate(sr); w.writeframes(np.clip(x, -32768, 32767).astype('<i2').tobytes()); w.close()

def last_sound(x, sr, thr=20, gap=0.25):
    """(start, end) sample indices of the last non-silent burst of a WAV (gaps shorter than `gap` s stay inside a burst); the base level of BGB's WAV is constant"""
    import numpy as np
    nz = np.flatnonzero(np.abs(x - np.median(x)) > thr)
    if not len(nz): return None
    end = nz[-1]; i = len(nz) - 1
    while i > 0 and nz[i] - nz[i - 1] < gap * sr: i -= 1
    return int(nz[i]), int(end) + 1

def runs_of(idx):
    runs = []
    for i in idx:
        if runs and runs[-1][1] == i - 1: runs[-1][1] = int(i)
        else: runs.append([int(i), int(i)])
    return runs

def run_case(case, rom_bytes, outdir, bgbdir, wav=False, C=None):
    C = C or load_corpus(); name = case['name']
    F = one(case, rom_bytes, outdir, bgbdir, C, 'forced', True, wav)
    K = one(case, rom_bytes, outdir, bgbdir, C, 'control', False, wav) if not case.get('nocontrol') else dict(sound=[], fire=None, vram=b'', wram=b'', oam=b'', shot=None, mode=0, state=0, watch=[])
    t0 = F['fire'] if F['fire'] is not None else (F['entry_hits'][0] if F['entry_hits'] else None)
    win = case.get('after', 90) * FRAME
    def inwin(ev, t): return [e for e in ev if t is not None and t <= e['clks'] <= t + win]
    fs, ks = inwin(F['sound'], t0), inwin(K['sound'], K['fire'] if K['fire'] is not None else t0)
    kset = collections.Counter((e['ch'], e['value']) for e in ks)
    res = dict(name=name, note=case.get('note', ''), bank=case.get('bank'), entry=case.get('entry'), sig=case.get('sig'), key=case.get('key'), fire_s=None if t0 is None else round(t0 / CLK, 3),
               entry_hits=len(F['entry_hits']), entry_after_fire_clks=None if (t0 is None or not F['entry_hits']) else F['entry_hits'][0] - t0,
               mode_forced='%02X:%02X' % (F['mode'], F['state']), mode_control='%02X:%02X' % (K['mode'], K['state']),
               sound_forced=[(e['ch'], e['value'], e['clks'] - t0, e['pc'] + '/' + e['bank']) for e in fs],
               sound_control=[(e['ch'], e['value'], e['clks'] - (K['fire'] or t0), e['pc'] + '/' + e['bank']) for e in ks],
               sound_new=sorted(set((e['ch'], e['value']) for e in fs) - set(kset)),
               watch_forced=[(e['name'], e['value'], e['clks'] - t0, e['pc'] + '/' + e['bank']) for e in F['watch'] if t0 is not None and t0 <= e['clks'] <= t0 + win][:40])
    vf, vk = F['vram'], K['vram']
    if vf and vk:
        d = [i for i in range(min(len(vf), len(vk))) if vf[i] != vk[i]]
        res['vram_diff_bytes'] = len(d); res['vram_diff_runs'] = [('%04X-%04X' % (0x8000 + a, 0x8000 + b)) for a, b in runs_of(d)][:30]
        rom = rom_bytes
        ex = []
        for va, bank, ra, n in case.get('expect', []):
            o = flat(bank, ra); ref = rom[o:o + n]; seg_f = vf[va - 0x8000:va - 0x8000 + n]; seg_k = vk[va - 0x8000:va - 0x8000 + n]
            ex.append(dict(vram='%04X' % va, rom='%02X:%04X' % (bank, ra), n=n, match_forced=sum(1 for x, y in zip(ref, seg_f) if x == y), match_control=sum(1 for x, y in zip(ref, seg_k) if x == y)))
        res['expect'] = ex
        open(os.path.join(outdir, name + '_vram_forced.bin'), 'wb').write(vf); open(os.path.join(outdir, name + '_vram_control.bin'), 'wb').write(vk)
    wf, wk = F['wram'], K['wram']
    if wf: open(os.path.join(outdir, name + '_wram_forced.bin'), 'wb').write(wf)
    if wk: open(os.path.join(outdir, name + '_wram_control.bin'), 'wb').write(wk)
    if wf and wk:
        wd = [i for i in range(min(len(wf), len(wk))) if wf[i] != wk[i]]
        res['wram_diff_bytes'] = len(wd); res['wram_diff_first'] = [('%04X' % (0xC000 + i), wk[i], wf[i]) for i in wd[:12]]
    of, ok = F['oam'], K['oam']
    if of and ok: res['oam_diff_bytes'] = sum(1 for x, y in zip(of, ok) if x != y)
    res['screens'] = [F['shot'], K['shot']]
    res['frames'] = F['frames']
    if wav and F.get('wav'):
        res['wav_forced'] = F['wav']; res['wav_control'] = K.get('wav')
        import numpy as np
        a, sr = wavmono(F['wav']); b = wavmono(K['wav'])[0] if K.get('wav') else None
        res['wav_len_s'] = [round(len(a) / float(sr), 3)] + ([round(len(b) / float(sr), 3)] if b is not None else [])
        for tg, X in (('forced', a), ('control', b)):
            if X is None: continue
            seg = last_sound(X, sr)
            if seg is None: res['clip_' + tg] = None; continue
            i0, i1 = seg; L = min(i1 - i0, int(case.get('clip_s', 3) * sr)); x = X[i0:i0 + L]
            clip = os.path.join(outdir, name + '_%s_clip.wav' % tg); savewav(clip, x, sr); res['clip_' + tg] = clip
            n = min(len(x), 16384); sp = np.abs(np.fft.rfft(x[:n] * np.hanning(n))); fr = np.fft.rfftfreq(n, 1.0 / sr)
            res['peak_hz_' + tg] = round(float(fr[sp[5:].argmax() + 5]), 1); res['rms_' + tg] = round(float(np.sqrt(((x - np.median(x)) ** 2).mean())), 1); res['len_s_' + tg] = round((i1 - i0) / float(sr), 3)
            res['start_s_' + tg] = round(i0 / float(sr), 3)
    json.dump(res, open(os.path.join(outdir, name + '.json'), 'w'), indent=1)
    return res

if __name__ == '__main__':
    args = sys.argv[1:]
    def opt(n, d=None):
        if n in args: i = args.index(n); v = args[i + 1]; del args[i:i + 2]; return v
        return d
    rom = opt('--rom', os.path.join(ROOT, 'pocketcamera_jp.gb')); bgb = opt('--bgb'); wav = '--wav' in args
    if wav: args.remove('--wav')
    only = opt('--only'); wk, wn = [int(x) for x in opt('--worker', '0/1').split('/')]
    cases = json.load(open(args[0])); out = args[1]
    bgbdir = bgb or os.path.join(out, 'bgbdir%d' % wk)
    if not os.path.isdir(bgbdir): shutil.copytree(os.environ.get('BGB_SRC', '/home/claude/bgbx'), bgbdir)
    os.environ['BGB_DIR'] = bgbdir
    rb = open(rom, 'rb').read(); C = load_corpus()
    for n, c in enumerate(cases):
        if only and c['name'] not in only.split(','): continue
        if n % wn != wk: continue
        r = run_case(c, rb, out, bgbdir, wav=wav, C=C)
        print('%-28s entry %d  forced %s control %s  new sound %s  vram diff %s  expect %s' % (c['name'], r['entry_hits'], r['mode_forced'], r['mode_control'], r['sound_new'], r.get('vram_diff_bytes'),
              [(e['rom'], e['match_forced'], e['match_control'], e['n']) for e in r.get('expect', [])]), flush=True)
