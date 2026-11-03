#!/usr/bin/env python3
"""Game Boy Printer emulator that talks the BGB link protocol over TCP (BGB documentation, "bgblink"): BGB is started with  -connect HOST:PORT  and this
program is the other end of the "link cable".  It answers every sync1 (master byte) with a sync2 carrying the printer's reply byte and runs the usual printer
protocol: magic 88 33, command (01 INIT, 02 PRINT, 04 DATA, 0F INQUIRY), compression flag, 16-bit length, data, 16-bit checksum, then the replies 81 (device id)
and the status byte.  Image data (2bpp tiles, 20 per row) are collected and written as PNG pages when PRINT arrives; every packet is logged.
Library:  PrinterServer(port, outdir).start() ... .stop() ; CLI: bgb_printer.py PORT OUTDIR   (runs until killed; BGB side: -connect 127.0.0.1:PORT)
Status replies follow the owner's captures of a real printer (see Printer.packet_done)."""
import socket, struct, sys, os, json, threading, time
PKT = 8
def pkt(b1, b2=0, b3=0, b4=0, i1=0): return struct.pack('<BBBBI', b1, b2, b3, b4, i1)
SHADES = (255, 170, 85, 0)
PRINT_POLLS = int(os.environ.get('PRN_POLLS', '20'))      # INQUIRY polls answered 06 after a PRINT (a real printer needs about 140 for a photo)
# PRN_ERR = 'CMD:N:STATUS[:COUNT],...'  injects a status byte instead of the modelled reply: CMD = init | data | print | inq, N = 1-based number of that command's packet
# in the run, STATUS = hex byte (e.g. 10), COUNT = how many consecutive packets of that command get it (default 1).  With bit 0 (checksum error) or bit 4 (packet error)
# set, a DATA packet is dropped (not added to the page), as a real printer discards a packet it flagged.  README 16.16.
CMDS = dict(init=0x01, print=0x02, data=0x04, inq=0x0F)
def parse_err(s):
    out = []
    for it in filter(None, (s or '').split(',')):
        f = it.split(':'); out.append((CMDS[f[0]], int(f[1]), int(f[2], 16), int(f[3]) if len(f) > 3 else 1))
    return out

class Printer:
    def __init__(self, outdir):
        self.outdir = outdir; os.makedirs(outdir, exist_ok=True)
        self.state = 0; self.cmd = 0; self.comp = 0; self.len = 0; self.cnt = 0; self.sum = 0; self.data = bytearray(); self.chk = 0
        self.status = 0; self.busy = 0; self.printing = False; self.unproc = False; self.buf = bytearray(); self.pages = []; self.log = []; self.bytes = 0
        self.ack_done = False; self.err = parse_err(os.environ.get('PRN_ERR')); self.ncmd = {}
    def xfer(self, tx):
        rx = 0x00; s = self.state; self.bytes += 1
        if s == 0:
            if tx == 0x88: self.state = 1
        elif s == 1:
            self.state = 2 if tx == 0x33 else (1 if tx == 0x88 else 0)
        elif s == 2: self.cmd = tx; self.sum = tx; self.state = 3
        elif s == 3: self.comp = tx; self.sum += tx; self.state = 4
        elif s == 4: self.len = tx; self.sum += tx; self.state = 5
        elif s == 5:
            self.len |= tx << 8; self.sum += tx; self.cnt = 0; self.data = bytearray(); self.state = 6 if self.len else 7
        elif s == 6:
            self.data.append(tx); self.sum += tx; self.cnt += 1
            if self.cnt >= self.len: self.state = 7
        elif s == 7: self.chk = tx; self.state = 8
        elif s == 8: self.chk |= tx << 8; self.state = 9; rx = 0x00
        elif s == 9: rx = 0x81; self.state = 10
        elif s == 10:
            ok = (self.sum & 0xFFFF) == self.chk
            self.packet_done(ok); rx = self.status; self.state = 0
        return rx
    def packet_done(self, ok):
        """Reply status model taken from real printer traces (the owner's Arduino captures of the Game Boy Camera printing, Game_Boy_Camera*.txt):
        INIT 00; first DATA 00, DATA after DATA 08; INQUIRY 00 (clears the flag); PRINT 08; then INQUIRY 06 for a while, 04 twice, then 00."""
        c = self.cmd; flag = self.unproc
        rec = dict(t=round(time.time() - T0, 3), cmd=c, comp=self.comp, len=self.len, checksum_ok=ok)
        reply = 0x00; self.ncmd[c] = n = self.ncmd.get(c, 0) + 1; inj = None
        for ec, en, es, ecount in self.err:
            if ec == c and en <= n < en + ecount: inj = es
        if inj is not None and c == 0x04 and inj & 0x11: self.data = bytearray()          # a flagged DATA packet is discarded
        if c == 0x01: self.busy = 0; self.printing = False; self.buf = bytearray(); self.unproc = False; reply = 0x00
        elif c == 0x04:
            if self.comp: rec['note'] = 'compressed data (run-length) not decoded'
            self.buf += self.data; reply = 0x08 if flag else 0x00; self.unproc = True
        elif c == 0x02:
            d = bytes(self.data) + bytes(4 - len(self.data))
            rec.update(sheets=d[0], margins='%02X' % d[1], palette='%02X' % d[2], exposure='%02X' % d[3], tile_bytes=len(self.buf))
            self.render(d); reply = 0x08; self.printing = True; self.busy = PRINT_POLLS
        elif c == 0x0F:
            if self.printing:
                if self.busy > 2: reply = 0x06; self.busy -= 1
                elif self.busy > 0: reply = 0x04; self.busy -= 1
                else: reply = 0x00; self.printing = False
                if reply == 0x00: self.unproc = False
            else: reply = 0x00; self.unproc = False
        if not ok: reply |= 0x01; rec['note'] = 'checksum error flagged'
        if inj is not None: reply = inj; rec['injected'] = '%02X' % inj
        rec['reply'] = '%02X' % reply
        self.status = reply; self.log.append(rec)
    def render(self, d):
        n = len(self.buf) // 16; rows = n // 20
        if rows == 0: self.pages.append(dict(note='PRINT with no image data', margins='%02X' % d[1])); return
        from PIL import Image
        pal = d[2]; W = 160; H = rows * 8; im = Image.new('L', (W, H), 255); px = im.load()
        for t in range(rows * 20):
            tx, ty = (t % 20) * 8, (t // 20) * 8
            for r in range(8):
                lo, hi = self.buf[t * 16 + r * 2], self.buf[t * 16 + r * 2 + 1]
                for b in range(8):
                    v = ((lo >> (7 - b)) & 1) | (((hi >> (7 - b)) & 1) << 1)
                    px[tx + b, ty + r] = SHADES[(pal >> (2 * v)) & 3]
        k = len(self.pages) + 1; fn = os.path.join(self.outdir, 'page_%02d.png' % k); im.save(fn)
        self.pages.append(dict(file=os.path.basename(fn), width=W, height=H, sheets=d[0], margins='%02X' % d[1], palette='%02X' % d[2], exposure='%02X' % d[3]))
        self.buf = bytearray()

T0 = time.time()
SYNC3_PERIOD = float(os.environ.get('PRN_SYNC3_PERIOD', '0')); SYNC3_TS = int(os.environ.get('PRN_SYNC3_TS', str(0x3FFFFFFF)))
class PrinterServer:
    def __init__(self, port, outdir, verbose=False):
        self.port = port; self.pr = Printer(outdir); self.verbose = verbose; self.counts = {}; self.first = []; self.t = None; self.stop_ev = threading.Event(); self.sock = None; self.connected = False
    def start(self):
        self.srv = socket.socket(); self.srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); self.srv.bind(('127.0.0.1', self.port)); self.srv.listen(1); self.srv.settimeout(0.5)
        self.t = threading.Thread(target=self.run, daemon=True); self.t.start(); return self
    def stop(self):
        self.stop_ev.set()
        if self.t: self.t.join(timeout=5)
        try: self.srv.close()
        except Exception: pass
        self.write_log()
    def write_log(self):
        json.dump(dict(packets=self.pr.log, pages=self.pr.pages, link_packets=self.counts, first_packets=self.first, printer_bytes=self.pr.bytes), open(os.path.join(self.pr.outdir, 'printer_log.json'), 'w'), indent=1)
    def run(self):
        conn = None
        while not self.stop_ev.is_set() and conn is None:
            try: conn, _ = self.srv.accept()
            except socket.timeout: pass
        if conn is None: return
        self.connected = True; conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1); conn.settimeout(0.01)
        conn.sendall(pkt(1, 1, 4, 0, 0))                           # version
        buf = b''; last_sync = 0.0; last_log = time.time()
        while not self.stop_ev.is_set():
            if SYNC3_PERIOD and time.time() - last_sync > SYNC3_PERIOD:         # keep BGB from waiting for our clock: report a timestamp far ahead of its own
                last_sync = time.time()
                try: conn.sendall(pkt(106, 0, 0, 0, SYNC3_TS))
                except OSError: break
            if time.time() - last_log > 3: last_log = time.time(); self.write_log()      # live progress for long runs
            try: d = conn.recv(4096)
            except socket.timeout: continue
            except OSError: break
            if not d: break
            buf += d
            while len(buf) >= PKT:
                p, buf = buf[:PKT], buf[PKT:]
                b1, b2, b3, b4, i1 = struct.unpack('<BBBBI', p)
                self.counts[b1] = self.counts.get(b1, 0) + 1
                if len(self.first) < 60: self.first.append((round(time.time() - T0, 2), b1, b2, b3, b4, i1))
                if b1 == 1:                                         # version: answer like BGB's listening side does (seen in a sniffed BGB<->BGB link): status 4 (supportreconnect), packet 158, status 5 (running)
                    conn.sendall(pkt(108, 4)); conn.sendall(pkt(158, 0, 0, 0, 19060)); conn.sendall(pkt(108, 5))
                elif b1 == 104:                                     # sync1: master byte -> sync2 with the printer's reply
                    rx = self.pr.xfer(b2)
                    if self.verbose: print('sync1 %02X -> %02X' % (b2, rx), flush=True)
                    conn.sendall(pkt(105, rx, 0x80, 0, 0))
                elif b1 == 106 and b2 == 0: conn.sendall(pkt(106, 0, 0, 0, i1))   # timestamp sync: echo
                elif b1 == 109: break
        try: conn.close()
        except Exception: pass
        self.connected = False

if __name__ == '__main__':
    port, out = int(sys.argv[1]), sys.argv[2]
    s = PrinterServer(port, out, verbose='-v' in sys.argv).start()
    try:
        while True: time.sleep(1); s.write_log()
    except KeyboardInterrupt: s.stop()
