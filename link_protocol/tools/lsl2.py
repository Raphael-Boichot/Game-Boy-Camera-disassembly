"""Sniffer v2: every exchange is logged with the master's/slave's link state at the moment the master starts the byte."""
import sys; sys.path.insert(0,'/home/claude/gbcam_jp/cov/linksniff'); sys.path.insert(0,'/home/claude/gbcam_jp/cov')
import lsl
KEYS = ['DC43','DC44','DC45','DC46','DC47','DC4C','DC4D','DC4E','DC4F','DC50','DC51','DC52','DC54','DC55','DC56','DC57','DC58','DC59','DC5A','DC5B','DC5C','DC5E']
def lstate(c):
    d = {k: c.peek(int(k[2:], 16) + 0xDC00 - 0xDC) if False else c.peek(0xDC00 + int(k[2:], 16)) for k in KEYS}
    return d
class Sniffer2(lsl.Sniffer):
    def __init__(self):
        super().__init__(); P = self.P; me = self
        def ev(X, Y, e):
            if e & 1:
                P.nx += 1; nameX = 'A' if X is P.A else 'B'
                ok = P.connected and (Y.L.gb_link_sc() & 0x81) == 0x80 and Y.L.gb_link_cd() == 0
                pre = (lstate(P.A), lstate(P.B)) if len(me.seq) < me.maxverbose else None
                if ok:
                    rx = Y.L.gb_link_sb(); tx = X.L.gb_link_out()
                    X.L.gb_link_set_rx(rx); Y.L.gb_link_deliver(tx, X.L.gb_link_cd())
                else:
                    rx = 0xFF; tx = X.L.gb_link_out()
                me.seq.append(dict(fr=P.frames, m=nameX, tx=tx, rx=rx, ok=int(ok), st=(P.state(P.A)[1], P.state(P.B)[1]), pre=pre))
        P._event = ev; self.maxverbose = 60
