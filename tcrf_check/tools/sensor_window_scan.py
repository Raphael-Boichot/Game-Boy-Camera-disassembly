#!/usr/bin/env python3
"""Does any code of the ROM use more of the MAC-GBD / sensor register window than the five sensor registers and the matrix? (README 18.11)

Reads an mgbdis disassembly (bank_NNN.asm, the form used by copy_sites.py) and the byte-class map of the coverage run and reports
  1. every instruction operand in $A000-$A0FF (the camera registers are $A000-$A035 with RAM bank $10 selected; $A100 and up is the photo SRAM): which addresses, how many sites, in which execution class
     (C = run organically, F = run only in forced runs, N = never run);
  2. every access to the WRAM shadows of the sensor registers ($D594-$D599) outside organically executed code;
  3. the RAM-bank selects written with `ld a,imm` just before `ld [$4000],a` (the camera registers are bank $10; no other value from $10 up occurs; a select through a variable is not seen);
  4. optionally: the same sites in the international ROM's bank $0A and the bytes in which the two sensor-driver banks differ.
usage: sensor_window_scan.py DISASM_DIR rom_map.csv [ROM_JP ROM_US]
  e.g. sensor_window_scan.py rtrepo/fixed coverage/v8/report_v8/rom_map.csv pocketcamera_jp.gb gbcam_usa_eu.gb"""
import sys, re, csv, glob, collections, os
dis, mapfn = sys.argv[1], sys.argv[2]
idx = collections.defaultdict(list)
for r in csv.DictReader(open(mapfn)): idx[int(r['bank'], 16)].append((int(r['start'], 16), int(r['length']), r['class']))
def clsof(b, a):
    for s, l, c in idx[b]:
        if s <= a < s + l: return c
    return '?'
INS = r'\s+(ld|ldh|call|jp|add|cp|bit|set|res|inc|dec|and|or|xor|sub|push|pop)\b'
regs = collections.Counter(); other = collections.Counter(); notC = []; shadows = []; banks = collections.Counter()
for f in sorted(glob.glob(os.path.join(dis, 'bank_*.asm'))):
    b = int(os.path.basename(f)[5:8], 16)
    for ln in open(f):
        if ln.lstrip().startswith(';') or not re.match(INS, ln): continue
        am = re.search(r';\s*\$([0-9a-f]{4}):', ln)
        if not am: continue
        a = int(am.group(1), 16); c = clsof(b, a)
        m = re.search(r'\$a([0-9a-f]{3})\b', ln, re.I)
        if m:
            k = int(m.group(1), 16)
            (regs if k < 0x100 else other)[(0xA000 + k)] += 1
            banks[(b, 'reg' if k < 0x100 else 'sram')] += 1
            if k < 0x100 and c != 'C': notC.append((b, a, c, ln.strip().split(';')[0].strip()))
        if re.search(r'\$d59[4-9]\b', ln, re.I) and c != 'C': shadows.append((b, a, c, ln.strip().split(';')[0].strip()))
print('1. operands in the register window $A000-$A0FF: %d sites, addresses %s .. %s, %d distinct (the matrix $A006-$A035 included)' % (sum(regs.values()), hex(min(regs)), hex(max(regs)), len(regs)))
print('   beyond $A035 inside $A000-$A0FF: %s' % ([hex(x) for x in sorted(regs) if x > 0xA035] or 'none'))
print('   register-window sites per bank:', {'%02X' % b: n for (b, k), n in sorted(banks.items()) if k == 'reg'})
print('   operands from $A100 up (photo SRAM, RAM bank 0): %d sites, %d addresses' % (sum(other.values()), len(other)))
print('   register-window sites not run organically:'); [print('     %02X:%04X class %s  %s' % x) for x in notC]
print('2. accesses to the sensor-register shadows $D594-$D599 outside organically run code:'); [print('     %02X:%04X class %s  %s' % x) for x in shadows]
sel = collections.Counter()
for f in sorted(glob.glob(os.path.join(dis, 'bank_*.asm'))):
    L = open(f).read().split('\n')
    for i, l in enumerate(L):
        if re.search(r'ld \[\$4000\], a', l):
            for j in range(i - 1, max(i - 4, 0), -1):
                mm = re.match(r'\s+ld a, \$([0-9a-f]{2})\s', L[j])
                if mm: sel[mm.group(1)] += 1; break
print('3. RAM-bank selects with an immediate:', dict(sorted(sel.items())))
if len(sys.argv) >= 5:
    jp, us = open(sys.argv[3], 'rb').read(), open(sys.argv[4], 'rb').read()
    base = 0x0A * 0x4000
    def pats(rom):
        return [(i - base + 0x4000, rom[i], rom[i + 1]) for i in range(base, base + 0x4000 - 2) if rom[i] in (0xEA, 0xFA, 0x21, 0x11, 0x01) and rom[i + 2] == 0xA0 and rom[i + 1] <= 0x35]
    d = [i for i in range(0x4000) if jp[base + i] != us[base + i]]
    print('4. bank $0A, Japanese vs international: %d differing bytes (of 16,384), %d vs %d register-window operand sites, identical positions and operands: %s' % (len(d), len(pats(jp)), len(pats(us)), pats(jp) == pats(us)))
    kinds = collections.Counter()
    ins = {}
    for ln in open(os.path.join(dis, 'bank_00a.asm')):
        m = re.search(r';\s*\$([0-9a-f]{4}):((?:\s*\$[0-9a-f]{2})+)', ln)
        if m:
            for k in range(len(re.findall(r'\$[0-9a-f]{2}', m.group(2)))): ins[int(m.group(1), 16) + k] = (k, ln.split(';')[0].split()[0])
    for i in d:
        k, op = ins.get(0x4000 + i, (None, 'data'))
        kinds[op + (' opcode' if k == 0 else ' operand' if k else '')] += 1
    print('   differing bytes lie in %04X-%04X; by instruction (Japanese listing): %s' % (0x4000 + d[0], 0x4000 + d[-1], dict(kinds)))
