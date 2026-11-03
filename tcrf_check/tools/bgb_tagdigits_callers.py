#!/usr/bin/env python3
"""F34-F35 (the photo's checksum bytes): which screens call 00:16F4 (Snd_PlayTagDigits) and who reads the four nibbles it leaves in $DD03-$DD06 (README 3, 12, 16.27, 16.30).
Real BGB, logging watchpoints (-wp; the message goes to debugmsg.txt and the game runs on):
  execution of 00:16F4 and of its six call sites 06:514C, 06:53AE, 06:639A, 06:63C6, 06:6404, 07:717B   -> 'X name mode state'   (mode $D5CE, state $D5CF at that moment)
  every READ of $DD03-$DD06                                                                              -> 'RD pc bank'          (an instruction that reads a nibble: the sound driver, or a display routine?)
  every WRITE of $DD03-$DD06                                                                             -> 'WR pc bank'
  every write of the sfx-1 mailbox $DD60                                                                 -> 'S1 value bank pc'   (the table keeps value $10 = the P.VOICE request only)
Runs (key paths of bgb_jofamo_checks.py, README 16.27):
  pvoice  slide show > Select > P.VOICE option > A (the 21-picture copy album of bgb_albumb_comments.py, stage2.sram), the slide show runs on its own
  shoot   SHOOT, live view, shutter, save, shutter, save (all-unlocked save, no photos)
  fusion  FORCED: the joypad lineage of corpus entry 610 (COMPOSE, FUSION layout, mode $17 state $0A; bgb_compose.py) on its own save (30 photos), in a copy of the ROM whose album-full test of state
          $0D is switched off (06:52C1 `cp $1e` -> `cp $ff`; with 30 photos A in state $0D leaves for the "album full" message, and every other corpus save with a COMPOSE entry has 30 photos;
          an album with fewer photos changes the album part of the lineage), then Down (state $0D, confirm), A (build), wait, A on the result (state $0F: save the picture).
          The call at 06:53AE is reached by the game's own code; only the album-full test is forced.
usage: bgb_tagdigits_callers.py OUTDIR ALBUM21.sram [pvoice] [shoot] [fusion]
env: GBCAM_CORPUS (default /home/claude/gbcam_jp/unlock_runs/f1_organic/corpus.jsonl) for the fusion lineage
env: GBCAM_ROM (Japanese ROM), GBCAM_SAV (all-unlocked save); BGB directory: BGB_DIR (default /home/claude/bgbts)
Writes OUTDIR/tagdigits_callers.csv (run, event, mode, state, rom bank, pc, count) and prints the table."""
import sys, os, csv, collections
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
D = os.environ.get('BGB_DIR', '/home/claude/bgbts'); os.environ['BGB_DIR'] = D
import bgb_run; bgb_run.BGB = D
JP = os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
SAV = os.environ.get('GBCAM_SAV', '/home/claude/gbcam_jp/saves_unl/GAMEBOYCAMERA_all_unlocked.sav')
out = os.path.abspath(sys.argv[1]); album = os.path.abspath(sys.argv[2]); what = sys.argv[3:] or ['pvoice', 'shoot', 'fusion']
os.makedirs(out, exist_ok=True)
DM = os.path.join(D, 'debugmsg.txt')
SITES = [('00:16F4', 'Snd_PlayTagDigits'), ('06:514C', 'Split_Result'), ('06:53AE', 'Fusion_Result'), ('06:639A', 'ShutterVariant0'), ('06:63C6', 'ShutterVariant1'), ('06:6404', 'ShutterVariant2'), ('07:717B', 'SlidePlay_ShowNext')]
WPS = ['%s//x/X %s %%(d5ce)%% %%(d5cf)%%' % (a, n) for a, n in SITES]
WPS += ['D5CF//w/ST %(d5ce)% %VALUE%', 'DD03-DD06//r/RD %PC% %ROMBANK%', 'DD03-DD06//w/WR %PC% %ROMBANK%', 'DD60//w/S1 %VALUE% %ROMBANK% %PC%']
KN = lambda k, h=4, w=60: (k, h, w)
RUNS = {
    'pvoice': (album, [('A', 4, 200), KN('Left'), KN('A', 4, 200), KN('Right'), KN('A', 4, 200), KN('A', 4, 200), KN('Select'), KN('Up'), KN('Right'), KN('A'), ('-', 1, 300), KN('A', 4, 300), ('-', 1, 1500)]),
    'shoot': (SAV, [('A', 4, 200), ('A', 4, 200), ('A', 4, 200), ('A', 4, 300), ('A', 4, 200), ('A', 4, 300), ('-', 1, 200)]),
}
def lineage(entry):
    import json
    C = {}
    for l in open(os.environ.get('GBCAM_CORPUS', '/home/claude/gbcam_jp/unlock_runs/f1_organic/corpus.jsonl')):
        if l.strip(): e = json.loads(l); C[e['id']] = e
    p = []; i = entry
    while i >= 0: p.append(i); i = C[i].get('parent', -1)
    p = p[::-1]; sp = dict(C[p[0]]['spec'])
    core = [(1, 'Right'), (2, 'Left'), (4, 'Up'), (8, 'Down'), (16, 'A'), (32, 'B'), (64, 'Select'), (128, 'Start')]
    nm = lambda k: '+'.join(n for m, n in core if k & m) or '-'
    return [(nm(a[0]), int(a[1]), int(a[2])) for j in p[1:] for a in C[j]['actions']], sp, bgb_run.mask(nm(sp['combo'])) if sp['combo'] else 0
rows = []
for name in what:
    kw = dict(combo=2, free=400)
    if name == 'fusion':
        seq, sp, kw['combo'] = lineage(610); kw['free'] = sp['free'] + 3
        seq = seq + [('-', 1, 120), KN('Down', 4, 120), KN('A', 4, 900), ('-', 1, 600), KN('A', 4, 300), ('-', 1, 900)]
        sav = os.path.join(os.path.dirname(SAV), sp['sav'] + '.sav'); rom_run = os.path.join(out, 'pocketcamera_jp_fulltest_off.gb'); rb = bytearray(open(JP, 'rb').read())
        assert rb[0x192C1:0x192C3] == b'\xFE\x1E', rb[0x192C1:0x192C3].hex(); rb[0x192C2] = 0xFF; open(rom_run, 'wb').write(rb)       # 06:52C1
    else:
        sav, seq = RUNS[name]; rom_run = JP
    if os.path.exists(DM): os.remove(DM)
    r = bgb_run.run(rom_run, sav, os.path.join(out, name), seq, timeout=800, tail=2, extra=['-wp', ','.join(WPS), '-setting', 'DebugMsgFile=1'], **kw)
    cnt = collections.Counter()
    for l in open(DM, errors='replace'):
        p = l.split()
        if not p: continue
        if p[0] == 'X' and len(p) >= 4: cnt[('call', p[1], '%s' % p[2], p[3], '', '')] += 1
        elif p[0] in ('RD', 'WR') and len(p) >= 3: cnt[(p[0], '', '', '', p[2], p[1])] += 1
        elif p[0] == 'S1' and len(p) >= 4 and p[1] == '10': cnt[('S1 10', '', '', '', p[2], p[3])] += 1        # only the P.VOICE request (sfx1 $10); the other values are other sounds
    tr = []                                                  # the (mode, state) written to $D5CF, consecutive duplicates dropped
    for l in open(DM, errors='replace'):
        p = l.split()
        if len(p) >= 3 and p[0] == 'ST' and (not tr or tr[-1] != p[1] + ':' + p[2]): tr.append(p[1] + ':' + p[2])
    print('%s: end %02X:%02X; last 40 (mode:state) writes: %s' % (name, r['mode'], r['state'], ' '.join(tr[-40:])))
    for k, v in sorted(cnt.items()):
        rows.append([name, k[0], k[1], k[2] and '$' + k[2], k[3] and '$' + k[3], k[4], k[5], v])
        print('  %-7s %-22s mode %-4s state %-4s bank %-3s pc %-5s x%d' % (k[0], k[1], k[2], k[3], k[4], k[5], v))
with open(os.path.join(out, 'tagdigits_callers.csv'), 'w', newline='') as f:
    w = csv.writer(f, lineterminator='\n'); w.writerow(['run', 'event', 'site', 'mode', 'state', 'rom_bank', 'pc', 'count']); w.writerows(rows)
