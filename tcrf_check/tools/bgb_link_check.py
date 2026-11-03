#!/usr/bin/env python3
"""Analyse a bgb_link.py run: which photo left the sender, which slot the receiver filled, byte-level comparison of the two slots (image area, tag F00-F5B, echo F5C-FB7),
reception counters F12-F14 and tag checksums.   usage: bgb_link_check.py OUTPREFIX SAV_SENDER SAV_RECEIVER"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import bgb_run, sram_analyze as S
pre, sa, sb = sys.argv[1:4]
a0, b0 = open(sa, 'rb').read(), open(sb, 'rb').read()
sa1 = bgb_run.read_state(pre + '_sender.sna'); sb1 = bgb_run.read_state(pre + '_receiver.sna')
a1 = (sa1.get('SRAM') or sa1.get('CART RAM')); b1 = (sb1.get('SRAM') or sb1.get('CART RAM'))
print('SRAM chunk sizes', len(a1), len(b1))
def vec(b): return list(b[0x11B2:0x11B2 + 30])
print('sender   vector before', vec(a0)); print('sender   vector after ', vec(a1)); print('receiver vector before', vec(b0)); print('receiver vector after ', vec(b1))
gone = [i for i in range(30) if vec(a0)[i] < 30 and vec(a1)[i] >= 30]; new = [i for i in range(30) if vec(b0)[i] >= 30 and vec(b1)[i] < 30]
print('sender position emptied:', gone, ' receiver position filled:', new)
if gone and new:
    ps, pr = vec(a0)[gone[0]], vec(b1)[new[0]]            # photo numbers = slot numbers (0-based? see README)
    for off in (0, 1):
        sb_ = S.slot_base(ps + off); rb_ = S.slot_base(pr + off)
        x, y = a0[sb_:sb_ + 0x1000], b1[rb_:rb_ + 0x1000]
        d = [i for i in range(0x1000) if x[i] != y[i]]
        print('slot numbering +%d: sender slot base %05X receiver slot base %05X: %d bytes differ; offsets: %s' % (off, sb_, rb_, len(d), ' '.join('%03X' % i for i in d[:24])))
        if d and max(d) >= 0xF00:
            t0, t1 = x[0xF12:0xF15], y[0xF12:0xF15]; print('   F12-F14 sender-before', t0.hex(), 'receiver-after', t1.hex(), ' tag block valid (receiver):', S.blk_ok(b1, rb_ + 0xF00, 0x5A), S.blk_ok(b1, rb_ + 0xF5C, 0x5A))
