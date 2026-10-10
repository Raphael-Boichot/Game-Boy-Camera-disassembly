import sys; sys.path.insert(0,'/home/claude/gbcam_jp/cov/linksniff'); sys.path.insert(0,'/home/claude/gbcam_jp/cov')
import exp, lsl2
def flow_receiver_initiator(savA, savB, sel_downs=3, sel_rights=3, verbose=True, cancel_sender=False, linked=True):
    """A = receiver + initiator (Right, A), B = sender/responder (Left).  A browses the thumbnails of B and picks a photo; B confirms."""
    S = lsl2.Sniffer2(); S.maxverbose = 0; P = S.P; S.start(savA, savB); P.connected = linked
    a0 = bytes(P.A.sram()); b0 = bytes(P.B.sram())
    def show(tag):
        la, lb = P.lnk(P.A), P.lnk(P.B)
        if verbose: print('%-16s fr%5d A%s st%d end%d cmd%02x/%02x pick=%d | B%s st%d end%d cmd%02x/%02x nx%d' % (tag, P.frames, P.state(P.A), la['stage'], la['ended'], P.A.peek(0xDC56), P.A.peek(0xDC59), P.A.peek(0xD5D8), P.state(P.B), lb['stage'], lb['ended'], P.B.peek(0xDC56), P.B.peek(0xDC59), P.nx))
    P.act(1, 2, 4, 60); P.act(16, 0, 4, 200); P.act(0, 0, 2, 300); show('browse')
    for k in range(sel_rights): P.act(1, 0, 4, 60)
    for k in range(sel_downs): P.act(8, 0, 4, 60)
    show('cursor'); P.act(16, 0, 4, 60); show('A pick')
    P.act(0, 0, 2, 60); show('wait')
    P.act(0, 32 if cancel_sender else 16, 4, 60); show('B ' + ('cancels' if cancel_sender else 'confirms'))
    for i in range(14):
        sa = P.state(P.A)[1]
        P.act(0, 0, 2, 40)
        if i % 2 == 0: show('wait')
    return S, a0, b0, bytes(P.A.sram()), bytes(P.B.sram())
if __name__ == '__main__':
    S, a0, b0, a1, b1 = flow_receiver_initiator('CE10517662', 'CE10229233')
    print('B(sender) photos', exp.nphotos(b0), '->', exp.nphotos(b1), ' A(receiver)', exp.nphotos(a0), '->', exp.nphotos(a1))
