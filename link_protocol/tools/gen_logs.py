#!/usr/bin/env python3
"""Regenerates the link-cable sniff logs (CSV, one row per serial byte exchange) and the before/after saves.
Usage: python3 gen_logs.py OUTDIR      (needs ../libgbcov7.so, ../libgbcov7b.so, ../saves/*.sav, ../state7_a, the ROM)"""
import sys, os, csv
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE); sys.path.insert(0, os.path.dirname(HERE))
import exp, lsl2
OUT = sys.argv[1]; os.makedirs(os.path.join(OUT, 'sniff_logs'), exist_ok=True); os.makedirs(os.path.join(OUT, 'saves'), exist_ok=True)
def phase(a, b, m):
    c, st = a['DC44'], a['DC51']
    if c == 0 and st == 0: return 'HELLO'
    if c == 0 and st == 1: return 'INFO'
    if c == 1 and st == 1: return 'PRELUDE'
    if c == 1 and st == 2: return 'COMMAND'
    if c == 1 and st == 3: return 'SYNC'
    if c == 1 and st == 0: return 'DATA'
    return 'OTHER'
def dump(S, name, A_is_initiator=True):
    rows = []
    for n, s in enumerate(S.seq):
        pa, pb = s['pre']; ph = phase(pa, pb, s['m'])
        master = pa if s['m'] == 'A' else pb; slave = pb if s['m'] == 'A' else pa
        ini = 'A' if A_is_initiator else 'B'
        ini_tx, rsp_tx = (s['tx'], s['rx']) if s['m'] == ini else (s['rx'], s['tx'])
        idx = (master['DC4C'] << 8) | master['DC4D']
        rows.append([n, s['fr'], s['m'], '%02X' % s['tx'], '%02X' % s['rx'], ph, '%02X' % ini_tx, '%02X' % rsp_tx, '' if ph != 'DATA' else ('first(not stored)' if idx == 0xFFFF else idx),
                     pa['DC51'], pb['DC51'], '%02X' % pa['DC56'], '%02X' % pb['DC59'], '%02X' % pa['DC5B'], '%02X' % pb['DC5B'], s['ok']])
    with open(os.path.join(OUT, 'sniff_logs', name + '.csv'), 'w', newline='\n') as f:
        w = csv.writer(f, lineterminator='\n')
        w.writerow(['n', 'frame', 'master', 'master_tx', 'master_rx', 'phase', 'initiator_tx', 'responder_tx', 'data_index', 'A_stage', 'B_stage', 'A_cmd', 'B_cmd_rx', 'A_ready', 'B_ready', 'delivered'])
        w.writerows(rows)
    return rows
def new_S(): 
    S = lsl2.Sniffer2(); S.maxverbose = 10 ** 7; return S
def save(name, data): open(os.path.join(OUT, 'saves', name), 'wb').write(data)
# Flow 1: A initiates and sends photo 0 (A=CE10229233 27 photos -> B=CE10517662 empty)
S = new_S(); P = S.P; S.start('CE10229233', 'CE10517662'); a0 = bytes(P.A.sram()); b0 = bytes(P.B.sram())
P.act(2, 1, 4, 60); P.act(16, 0, 4, 200)
for i in range(60): P.act(16 if P.state(P.A)[1] in (3, 5) else 0, 0, 4, 12)
rows = dump(S, 'flow1_sender_initiates_photo0'); save('flow1_A_sender_before.sav', a0); save('flow1_A_sender_after.sav', bytes(P.A.sram())); save('flow1_B_receiver_before.sav', b0); save('flow1_B_receiver_after.sav', bytes(P.B.sram()))
print('flow1', len(rows))
# Flow 2: A (receiver) initiates, browses B's thumbnails, requests photo 11
import flowR
S = new_S(); P = S.P; S.start('CE10517662', 'CE10229233'); a0 = bytes(P.A.sram()); b0 = bytes(P.B.sram())
P.act(1, 2, 4, 60); P.act(16, 0, 4, 200); P.act(0, 0, 2, 300)
for k in range(3): P.act(1, 0, 4, 60)
for k in range(3): P.act(8, 0, 4, 60)
P.act(16, 0, 4, 60); P.act(0, 0, 2, 60); P.act(0, 16, 4, 60)
for i in range(14): P.act(0, 0, 2, 40)
rows = dump(S, 'flow2_receiver_initiates_browse_then_photo11'); save('flow2_A_receiver_before.sav', a0); save('flow2_A_receiver_after.sav', bytes(P.A.sram())); save('flow2_B_sender_before.sav', b0); save('flow2_B_sender_after.sav', bytes(P.B.sram()))
print('flow2', len(rows))
# Flow 3: abort, receiver album full (abort reasons 1 / 2)
S = new_S(); P = S.P; S.start('CE10229233', 'CE10238211'); P.act(2, 1, 4, 60); P.act(16, 0, 4, 200); P.run(600); print('flow3', len(dump(S, 'flow3_abort_receiver_album_full')))
# Flow 4: receiver cancels while browsing ($EF)
S = new_S(); P = S.P; S.start('CE10517662', 'CE10229233'); P.act(1, 2, 4, 60); P.act(16, 0, 4, 200); P.act(0, 0, 2, 300); P.act(32, 0, 4, 60); P.run(300); print('flow4', len(dump(S, 'flow4_cancel_while_browsing')))
# Flow 5: sender refuses (B) in the confirmation dialog
S = new_S(); P = S.P; S.start('CE10517662', 'CE10229233'); P.act(1, 2, 4, 60); P.act(16, 0, 4, 200); P.act(0, 0, 2, 300); P.act(16, 0, 4, 60); P.act(0, 0, 2, 100); P.act(0, 32, 4, 60); P.run(300); print('flow5', len(dump(S, 'flow5_sender_refuses')))
