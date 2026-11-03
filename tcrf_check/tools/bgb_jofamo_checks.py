#!/usr/bin/env python3
"""BGB checks of four claims of the jofamo.com article "Secrets of the Pocket Camera" (README 16.27).  Everything is read from the real BGB: write watchpoints (-wp) log the writes of a WRAM
byte with the cycle count (2,097,152 per second) into debugmsg.txt.
usage: bgb_jofamo_checks.py OUTDIR ALBUM21.sram [bgm] [pvoice] [shoot] [speed] [bview]        (default: all five; the 21-copy album is stage2.sram of bgb_albumb_comments.py)
env: GBCAM_ROM (Japanese ROM), GBCAM_ROM_INTL (international ROM), GBCAM_SAV (all unlocked, 0 photos); BGB directory /home/claude/bgbq1 (copy of /home/claude/bgbx)
bgm     the music mailbox `$DD68` while the RUN! RUN! RUN! title is shown, on both ROMs (article: "BGM 04 is only used in the international version of RUN!RUN!RUN!")
pvoice  Slide show > Select > the P.VOICE option > A on a copied Album B picture: the four digits `$DD03-$DD06` and the sfx1 request `$DD60` for every one of the 21 slides, against the
        checksum bytes F34/F35 of the slot (article: "my theory is that the Pocket Camera generates a unique sound based on the contents of the photo")
shoot   SHOOT, shutter, save: the same digits and sfx1 at the save, against F34/F35 and a recomputation (sum and xor of the 3,584 photo bytes)
speed   the title screen (`$D510`) and the VIEW menu (`$D679`) with Up and Down held, both ROMs (article: speed change with up / down)
bview   VIEW > ALBUM on the first stock pictures of Album B (page B1 = B01, page B2 = B09): A A shows the picture in the B frame, R D A (the Comment cell of an A-album picture) opens nothing
        (article: "you cannot ... view or add comments to them" until they are copied)
Writes OUTDIR/jofamo_*.csv and prints the same lines."""
import sys, os, csv, shutil, functools
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
D = '/home/claude/bgbq1'
if not os.path.isdir(D): shutil.copytree('/home/claude/bgbx', D)
os.environ['BGB_DIR'] = D
import bgb_run; bgb_run.BGB = D
import guide_nodes as G
JP = os.environ.get('GBCAM_ROM', '/home/claude/gbcam_jp/pocketcamera_jp.gb')
US = os.environ.get('GBCAM_ROM_INTL', '/home/claude/gbcam_jp/roms/gbcam_usa_eu.gb')
SAV = os.environ.get('GBCAM_SAV', '/home/claude/gbcam_jp/saves_unl/GAMEBOYCAMERA_all_unlocked.sav')
out = os.path.abspath(sys.argv[1]); album = os.path.abspath(sys.argv[2]); what = sys.argv[3:] or ['bgm', 'pvoice', 'shoot', 'speed', 'bview']
os.makedirs(out, exist_ok=True)
CLK = 2097152.0; DM = D + '/debugmsg.txt'
NAME = dict(A='A', B='B', L='Left', R='Right', U='Up', D='Down', s='Select', S='Start')
def K(t): return (NAME[t], 4, 60 if t in 'LRUD' else 200)
KN = lambda k, h=4, w=60: (k, h, w)       # a key by its BGB name
def go(rom, sav, prefix, seq, wps, **kw):
    if os.path.exists(DM): os.remove(DM)
    r = bgb_run.run(rom, sav, prefix, seq, combo=kw.get('combo', 2), free=400, timeout=800, tail=kw.get('tail', 2), extra=['-wp', ','.join('%s//w/%s %%VALUE%% %%TOTALCLKS%%' % (a, n) for a, n in wps), '-setting', 'DebugMsgFile=1'])
    L = [l.split() for l in open(DM).read().splitlines() if len(l.split()) == 3] if os.path.exists(DM) else []
    return r, [(p[0], p[1], int(p[2], 16) / CLK) for p in L]
def write(name, head, rows):
    with open(os.path.join(out, name), 'w', newline='') as fh:
        w = csv.writer(fh, lineterminator='\n'); w.writerow(head); w.writerows(rows)
def digits(L):
    """the digit tuples (DD03, DD04, DD05, DD06) in the order they were completed (a tuple ends with the write of DD06)"""
    tuples, cur = [], {}
    for n, v, t in L:
        if n in ('N3', 'N4', 'N5', 'N6'):
            cur[n] = int(v, 16)
            if n == 'N6': tuples.append((cur.get('N3'), cur.get('N4'), cur.get('N5'), cur.get('N6'), round(t, 2))); cur = {}
    return tuples
def nibbles(sram, base):
    s_, x_ = sram[base + 0xF34], sram[base + 0xF35]
    return (s_ >> 4, s_ & 15, x_ >> 4, x_ & 15)

if 'bgm' in what:
    rows = []
    for tag, rom, vk in (('international', US, 'R'), ('japanese', JP, 'L')):
        r, L = go(rom, SAV, out + '/bgm_' + tag, [('A', 4, 200)] + [K(t) for t in G.tokens('D A A', vk)], [('DD68', 'MUS')], tail=300)
        nz = [(v, round(t, 2)) for n, v, t in L if n == 'MUS' and v != '00']
        rows.append((tag, '%02X:%02X' % (r['mode'], r['state']), ' '.join('%s@%.2fs' % x for x in nz[:12])))
        print('bgm  %-13s end %02X:%02X  music mailbox non-zero writes: %s' % (tag, r['mode'], r['state'], rows[-1][2]))
    write('jofamo_bgm_run_title.csv', ['rom', 'bgb_end_mode_state', 'music_mailbox_DD68_non_zero_writes'], rows)

if 'pvoice' in what:
    # Slide show: the key path of the P.VOICE option: Left (VIEW), A (VIEW menu), Right, A, A (slide show), Select, Up (option screen), Right (P.VOICE), A (commit), then A starts the slide show
    seq = [('A', 4, 200), KN('Left'), KN('A', 4, 200), KN('Right'), KN('A', 4, 200), KN('A', 4, 200), KN('Select'), KN('Up'), KN('Right'), KN('A'), ('-', 1, 300), KN('A', 4, 300), ('-', 1, 1500)]
    wps = [('DD60', 'S1'), ('DD03', 'N3'), ('DD04', 'N4'), ('DD05', 'N5'), ('DD06', 'N6'), ('D7D2', 'OPT'), ('D5CF', 'ST')]
    r, L = go(JP, album, out + '/pvoice', seq, wps)
    sram = open(album, 'rb').read(); got = digits(L)
    opt = [(v, round(t, 1)) for n, v, t in L if n == 'OPT']
    s1 = [(v, round(t, 1)) for n, v, t in L if n == 'S1' and v != '00']
    print('pvoice end %02X:%02X, option D7D2 writes %s, sfx1 non-zero writes %s' % (r['mode'], r['state'], opt, s1[:6]))
    rows = []
    for k in range(21):
        exp = nibbles(sram, 0x2000 + k * 0x1000); g = got[k + 1][:4] if len(got) > k + 1 else None     # got[0] is the digit write of the first display before the slide show starts
        rows.append(('B%02d' % (k + 1), k, ''.join('%X' % v for v in exp), ''.join('%X' % v for v in g) if g else '', g == exp if g else False))
    print('pvoice digits (slide order) == F34/F35 nibbles:', sum(1 for x in rows if x[4]), 'of 21')
    write('jofamo_pvoice_digits.csv', ['picture', 'a_album_slot', 'F34F35_nibbles', 'logged_DD03_DD06', 'equal'], rows)

if 'shoot' in what:
    seq = [('A', 4, 200), ('A', 4, 200), ('A', 4, 200), ('A', 4, 300), ('A', 4, 200), ('A', 4, 300), ('-', 1, 200)]         # SHOOT, live view, shutter, save, shutter, save
    wps = [('DD60', 'S1'), ('DD68', 'MU'), ('DD03', 'N3'), ('DD04', 'N4'), ('DD05', 'N5'), ('DD06', 'N6')]
    r, L = go(JP, SAV, out + '/shoot', seq, wps)
    sram = r['st']['SRAM']; got = digits(L); rows = []
    s1 = [(v, round(t, 2)) for n, v, t in L if n == 'S1' and v != '00']
    t10 = [t for v, t in s1 if v == '10']                       # the P.VOICE request (sfx1 $10)
    print('shoot end %02X:%02X, photos %d, sfx1 non-zero writes %s' % (r['mode'], r['state'], r['st']['WRAM'][0xD561 - 0xC000], s1))
    print('  digit tuples (DD03-DD06, completed at s):', got)
    for slot in range(r['st']['WRAM'][0xD561 - 0xC000]):          # only the photos that were really saved
        b = 0x2000 + slot * 0x1000; ph = sram[b:b + 0xE00]
        rec = (sum(ph) & 0xFF, functools.reduce(lambda a, c: a ^ c, ph, 0)); stored = (sram[b + 0xF34], sram[b + 0xF35]); nb = nibbles(sram, b)
        before = [g for g in got if t10 and g[4] <= t10[min(slot, len(t10) - 1)] + 0.01]       # the last tuple completed before the P.VOICE request
        g = before[-1][:4] if before else None
        rows.append((slot, '%02X %02X' % stored, '%02X %02X' % rec, ''.join('%X' % v for v in nb), ''.join('%X' % v for v in g) if g else '', g == nb if g else False))
        print('  slot %d  F34/F35 %s  recomputed %s  nibbles %s  last tuple before sfx1 $10 %s  equal %s' % rows[-1])
    write('jofamo_shoot_save_digits.csv', ['a_album_slot', 'F34_F35', 'recomputed_sum_xor', 'nibbles', 'logged_DD03_DD06', 'equal'], rows)

if 'speed' in what:
    rows = []
    for tag, rom, vk in (('japanese', JP, 'Left'), ('international', US, 'Right')):
        seq = [('-', 1, 300), ('Up', 60, 60), ('-', 1, 60), ('Down', 60, 60), ('-', 1, 30)]
        r, L = go(rom, SAV, out + '/title_' + tag, seq, [('D510', 'UP'), ('D5CF', 'ST')], combo=0)
        ups = [(v, t) for n, v, t in L if n == 'UP']
        print('speed title %-13s D510 writes %d, values %s' % (tag, len(ups), sorted(set(v for v, _ in ups))))
        rows.append(('title', tag, 'D510 writes (Up held 60 frames, Down 60 frames)', len(ups), ' '.join(sorted(set(v for v, _ in ups)))))
        seq = [('A', 4, 200), (vk, 4, 60), ('A', 4, 200), ('-', 1, 120), ('Up', 60, 90), ('-', 1, 60), ('Down', 60, 90), ('-', 1, 60)]
        r, L = go(rom, SAV, out + '/view_' + tag, seq, [('D679', 'SPD')], combo=2)
        prev = None; ch = []
        for n, v, t in L:
            if n == 'SPD' and v != prev: ch.append('%s@%.2fs' % (v, t)); prev = v
        print('speed view  %-13s end %02X:%02X  D679 changes: %s' % (tag, r['mode'], r['state'], ' '.join(ch)))
        rows.append(('view', tag, 'D679 changes (03 = Up, 07 = none, 0F = Down)', len(ch), ' '.join(ch)))
    write('jofamo_speed.csv', ['screen', 'rom', 'what', 'count', 'values'], rows)

if 'bview' in what:
    import bgb_us_jp_job as J
    def seq(path): return [('A', 4, 200)] + [K(t) for t in G.tokens(path, 'L')]
    os.makedirs(out + '/bview', exist_ok=True); jobs = []
    for p in (4, 5):        # page 3 (0-based) ends with A30 (D5D8 = 24-29), page 4 starts with B01 (D5D8 = 30), page 5 with B09 (D5D8 = 38)
        for tag, path in (('grid', ''), ('AA', ' A A'), ('AA_RDA', ' A A R D A')):
            jobs.append(('p%d_%s' % (p, tag), JP, album, seq('V A A' + ' R' * (2 * p) + path), out + '/bview', 2, 400, 2))
    res = J.run_jobs(jobs, 2)
    rows = [(k.split('_')[0], k.split('_', 1)[1], v.split(' D63D')[0], v.split('D5D8=')[1].split()[0]) for k, v in res.items() if v]
    write('jofamo_albumb_view.csv', ['page', 'keys_after_the_page', 'bgb_mode_state', 'D5D8_picture_index (30 = B01, 38 = B09)'], rows)
    for x in rows: print('bview', *x)
