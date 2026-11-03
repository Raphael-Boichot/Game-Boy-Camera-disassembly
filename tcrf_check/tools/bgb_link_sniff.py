"""Sniffer for the BGB link protocol: two BGB instances (one `-listen`, one `-connect`) are joined by this TCP relay, which forwards every 8-byte packet and logs it
(time, direction, b1 b2 b3 b4 i1).  This is how the handshake that the printer helper (bgb_printer.py) has to imitate was found: version, status 4, packet 158 (i1 = 19060),
status 5, then sync3 echoes every 2048 cycles.  Paths (ROM, save, BGB directory) are hard-coded below: adapt them.  Needs bgb_run.py and a BGB directory."""
import socket, struct, threading, subprocess, os, time, sys, shutil
sys.path.insert(0,'/home/claude/gbcam_jp/tools')
os.environ['BGB_DIR']='/home/claude/bgbpr91'
import bgb_run
ROM='/home/claude/gbcam_jp/pocketcamera_jp.gb'; SAV='/home/claude/gbcam_jp/bgbtrace/dj_print1/in.sav'
LOG=[]; T0=time.time()
def pump(a,b,tag):
    buf=b''
    while True:
        try: d=a.recv(4096)
        except OSError: break
        if not d: break
        b.sendall(d); buf+=d
        while len(buf)>=8:
            p,buf=buf[:8],buf[8:]; LOG.append((round(time.time()-T0,3),tag)+struct.unpack('<BBBBI',p))
srv=socket.socket(); srv.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1); srv.bind(('127.0.0.1',8766)); srv.listen(1)
def mk(role,extra,dem_frames):
    p='/home/claude/gbcam_jp/bgbtrace/sniff_'+role
    open(p+'.dem','wb').write(bgb_run.make_demo([('-',dem_frames,0)],0,403,tail=30)); shutil.copy(SAV,p+'.sav')
    for f in (p+'.sna',p+'.bmp'):
        if os.path.exists(f): os.remove(f)
    d='/home/claude/bgbpr91'
    cmd=['xvfb-run','-a','wine',d+'/bgb.exe','-hf','-nowarn','-nowriteini','-nobattsave','-ini',d+'/bgb.ini','-rom',ROM,'-demoplay',p+'.dem','-stateonexit',p+'.sna','-screenonexit',p+'.bmp','-loadbatt',p+'.sav']+extra
    return subprocess.Popen(cmd,env=dict(os.environ,WINEDEBUG='-all',WINEPREFIX='/root/wineprefix'),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
pa=mk('listener',['-listen','127.0.0.1:8765'],200); time.sleep(4)
pb=mk('client',['-connect','127.0.0.1:8766'],200)
c,_=srv.accept(); u=socket.socket(); u.connect(('127.0.0.1',8765))
threading.Thread(target=pump,args=(c,u,'client->listener'),daemon=True).start(); threading.Thread(target=pump,args=(u,c,'listener->client'),daemon=True).start()
for p in (pa,pb):
    try: p.wait(timeout=100)
    except subprocess.TimeoutExpired: p.kill(); print('killed')
print('exit codes',pa.returncode,pb.returncode,'after %.1f s'%(time.time()-T0))
import collections
print(collections.Counter((l[1],l[2]) for l in LOG))
for l in LOG[:40]: print(l)
print('...'); 
for l in LOG[-6:]: print(l)
