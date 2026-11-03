#!/usr/bin/env python3
"""The names and comments of the stock pictures of Album B (Japanese ROM), README 16.27.
Each of the 30 stock slots (0xDA000 + i*0x1000, same layout as an SRAM slot) carries a name (F04-F0C, 9 cells) and a comment (F15-F2F, 27 cells = 3 lines of 9) that the game shows
only after the picture has been COPYed into the A album (the Comment screen of VIEW > ALBUM, mode 0A:0E).  B01-B21 have both, B22-B30 are empty.
usage: albumb_comments.py ROM OUT.csv [--check DIR]
  OUT.csv   one row per slot: codes in hex, the decoded text (charset_jp.py), my English gloss (I: my own reading of the kana, not a translation taken from anywhere)
  --check DIR   DIR/Bnn.bmp = the BGB screenshots of the Comment screen of the copy of Bnn (bgb_albumb_comments.py); every 8x16 cell (72+8*col, 48+16*line) of the 160x144 picture
                is compared with the bank-$2A glyph of the code (palette 255/174/92/25, a blank cell is white) and the number of differing pixels is printed (0 = pixel-exact)"""
import sys, os, csv, argparse
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import charset_jp as CS

GLOSS = {   # my reading of the kana (I); the names are the signature line shown above the comment
 1: ('Flip-kun', 'When you put a stamp, try keeping the A button held down.'),
 2: ('Mister Black', 'Those who do their best at BALL get a Pokemon stamp...'),
 3: ('Yokogaki Noriko ("horizontal writing")', 'If you get 2000 points in S.FEVER2...'),
 4: ('Tategaki Shoji ("vertical writing")', 'Use it for memos.'),
 5: ('Gakkosuki (gakko = school)', "Get tomorrow's preparations done today."),
 6: ('Comment Puribo', 'When printing, if you press the Start button (beforehand)...'),
 7: ('Printer 5800', 'Print stickers can be stuck on postcards too, cant they.'),
 8: ('Staff, everyone', 'RUNRUNRUN: aim for within 22 seconds!!'),
 9: ('DJ PAPA1', 'On the SOUND1 screen of EDIT mode... to be continued'),
 10: ('DJ PAPA2', 'If you press the A button while holding the Start button... to be continued'),
 11: ('DJ PAPA3', 'You can print the score data. Hey, did you hear that?'),
 12: ('Slide Joe', 'Change the speed with the up/down keys.'),
 13: ('Nomura Fujiko', "I'm Poketa! Let's be friends (heart). Take lots of pictures."),
 14: ('DJ Technician', 'Further right than SE, further left than TEMPO, woof.'),
 15: ('Game Model', "Huh... a doodle? Under 'play' there is a secret..."),
 16: ('Kentaro', 'I keep waving until your shrinking figure can no longer be seen.'),
 17: ("Don't hit (me)", 'Erase the arms and legs (frame by frame) and try to make an animation!'),
 18: ('Original Mario', 'Playing with your sweetheart, working together well is nice too.'),
 19: ('Hosokawa Takehiko', 'Please look after the Wario series as well. (signed) Tamanori Papa'),
 20: ('Electro Lion', 'Unique, overflowing targets born from electronics.'),
 21: ('SP Gun 980 yen', 'You can enjoy a safe, scientific feeling.'),
}

def rows(rom):
    out = []
    for i in range(30):
        b = 0xDA000 + i * 0x1000; nm = rom[b + 0xF04:b + 0xF0D]; cm = rom[b + 0xF15:b + 0xF15 + 27]
        ln = [CS.dec(cm[k * 9:k * 9 + 9]).rstrip('　') for k in range(3)]
        g = GLOSS.get(i + 1, ('', ''))
        out.append(dict(b='B%02d' % (i + 1), flat='%06X' % b, name_codes=nm.hex().upper(), name=CS.dec(nm).strip('　'),
                        comment_codes=cm.hex().upper(), line1=ln[0], line2=ln[1], line3=ln[2], name_en=g[0], comment_en=g[1]))
    return out

def check(rom, d):
    import numpy as np
    from PIL import Image
    pal = {0: 255, 1: 174, 2: 92, 3: 25}; rep = []
    for n in range(1, 22):
        im = np.array(Image.open(os.path.join(d, 'B%02d.bmp' % n)).convert('L')); bad = tot = 0
        cm = rom[0xDA000 + (n - 1) * 0x1000 + 0xF15:][:27]
        for i, c in enumerate(cm):
            ln, col = divmod(i, 9); yy, xx = 48 + ln * 16, 72 + col * 8
            patch = im[yy:yy + 16, xx:xx + 8]
            exp = np.full((16, 8), 255) if c in (0, 0x87) else np.array([[pal[v] for v in r] for r in CS.glyph(rom, c)])
            bad += int((patch != exp).sum()); tot += 128
        rep.append((n, bad, tot))
    return rep

if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('rom'); ap.add_argument('out'); ap.add_argument('--check')
    a = ap.parse_args(); rom = open(a.rom, 'rb').read()
    R = rows(rom)
    with open(a.out, 'w', newline='', encoding='utf-8') as fh:
        w = csv.DictWriter(fh, fieldnames=list(R[0]), lineterminator='\n'); w.writeheader(); w.writerows(R)
    print('wrote', a.out, '-', sum(1 for r in R if r['name_codes'].strip('0')), 'slots with a name,', sum(1 for r in R if r['comment_codes'].strip('0')), 'with a comment')
    for r in R[:21]: print('%s  %-12s | %s / %s / %s' % (r['b'], r['name'], r['line1'], r['line2'], r['line3']))
    if a.check:
        rep = check(rom, a.check)
        print('pixel check of', a.check, ':', ' '.join('B%02d:%d' % (n, b) for n, b, t in rep), '-> all exact' if all(b == 0 for _, b, _ in rep) else '-> DIFFERENCES')
