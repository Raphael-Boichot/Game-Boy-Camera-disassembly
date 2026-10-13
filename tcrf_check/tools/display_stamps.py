"""Walk every category and every scroll position of the stamp tool (mode $11, palette state 3) with the display-tracking core, once with an ordinary save
and once with the CoroCoro-tag save (so that category 3 and all ten Pokemon pages exist), by real key presses.  Output: OUT/stamps_<label>.npz (README 16.24).
usage: display_stamps.py OUTDIR [CORPUS]"""
import sys, os, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import display_core as R; g = R.g
OUTD = sys.argv[1] if len(sys.argv) > 1 else '.'; os.makedirs(OUTD, exist_ok=True)
C = R.Corpus(sys.argv[2] if len(sys.argv) > 2 else os.environ.get('CORPUS_DIR', '/mnt/attach/outputs/coverage_run') + '/merged_corpus_v3/corpus.jsonl')
i=C.best((0x11,3))
SAVS=[('PC10696894',None),('tag','unl_CE10238211_tagtest')]
def st(): return dict(cat=g.peek(0xD63D),page=g.peek(0xD63E),item=g.peek(0xD63F),focus=g.peek(0xD614))
res=[]
for label,savname in SAVS:
    sav=R.SAV(savname) if savname else None
    C.replay(i,sav=sav); g.run(30)
    print(label,'start',R.cur(),st(),'D582=',g.peek(0xD582),flush=True)
    for c in range(0,17):
        s=st(); n=0
        while s['cat']!=c and n<40:
            if s['focus']==0:
                for _ in range(5): R.press(g.RIGHT)
            R.press(g.DOWN); s=st(); n+=1
            if s['cat']>c or (s['cat']==16 and c!=16): break
        if s['cat']!=c: print('  cat',c,'unreachable, at',s['cat']); continue
        if s['focus']==1: R.press(g.LEFT)
        for _ in range(25): R.press(g.UP,3,6)
        for _ in range(4): R.press(g.LEFT,3,6)
        items=[]
        for step in range(70):
            s=st(); items.append(s['item']); R.press(g.DOWN,3,8)
            if st()['item']==s['item'] and step>1: break
        # also sweep Right/Left inside pages
        for _ in range(5): R.press(g.RIGHT)
        print('  cat',c,'items to',max(items),'page',st()['page'],flush=True)
    R.save(OUTD + '/stamps_%s.npz' % label)
    # Select / Start inside the tool (palette / confirm) for completeness
    print(label,'done',R.cur(),flush=True)
