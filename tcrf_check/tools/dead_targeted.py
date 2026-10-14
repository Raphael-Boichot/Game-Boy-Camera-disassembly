#!/usr/bin/env python3
"""Targeted forcing of the dead sound code in the display-tracking core (README 16.26): the generic sweep of dead_jump.py calls a routine with the registers of the idle point; the sound routines need
their input (a request byte, the channel pointer DE) so they are called here with it.  Reports the writes to the sound registers and the mailboxes.
  * Snd_UiEffect_Dead (00:10AC) with $D92E = 1..8: writes NR10-NR14 of channel 1 from the table at 00:10D0
  * Unused_Sfx1_Init_46DD (1F:46DD) with DE = $DD62 (what Snd_RunSfx1 leaves in DE for an init routine): Snd_Sfx_Start loads NR10-NR14 from Sfx1_Data_46D8
usage: dead_targeted.py CACHE_DIR OUT.json            (environment as dead_jump.py)"""
import sys, os, json
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import dead_jump as J
g = J.g
APU = {0xFF10: 'NR10', 0xFF11: 'NR11', 0xFF12: 'NR12', 0xFF13: 'NR13', 0xFF14: 'NR14', 0xFF16: 'NR21', 0xFF17: 'NR22', 0xFF18: 'NR23', 0xFF19: 'NR24', 0xFF1A: 'NR30', 0xFF25: 'NR51'}

def run(base, bank, entry, pokes=(), regs=None):
    def setup(r, idle):
        for a, v in pokes: g.poke(a, v)
        g.jump(entry, bank, idle); g.set_stop(idle)
        if regs:
            rr = g.regs(); g.set_regs(regs.get('a', rr['a']), regs.get('f', rr['f']), regs.get('bc', rr['bc']), regs.get('de', rr['de']), regs.get('hl', rr['hl']), rr['sp'])
    rep = J.observe(0, base, setup)
    d = rep['direct']
    return dict(returned=rep['returned'], frames_to_return=rep['frames_to_return'], apu=[(APU.get(a, '%04X' % a), v) for a, v in d['io'] if a in APU] if d else None,
                requests=d['mailbox'] if d else None, vram=len(d['vram']) if d else None)

if __name__ == '__main__':
    B = J.bases(sys.argv[1]); base = B[16]; out = {}
    for n in range(1, 9):
        out['uieffect_%d' % n] = run(base, 0, 0x10AC, pokes=[(0xD92E, n)])
        print('uieffect', n, out['uieffect_%d' % n])
    out['sfx1_46DD'] = run(base, 0x1F, 0x46DD, regs=dict(de=0xDD62)); print('46DD', out['sfx1_46DD'])
    json.dump(out, open(sys.argv[2], 'w'), indent=1)
