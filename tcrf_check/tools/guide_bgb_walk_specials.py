"""Space Fever II first-wave routes of the guide walk (shared by guide_bgb_walk.py and make_guide_sheets.py)."""
def shoot(direction, hold=12, n=36):            # Space Fever II first wave: direction held 'hold' frames, A pulsed (4 on / 4 off) from frame 6 (the route of 17.6)
    s = [(direction, 6, 0), (direction + '+A', 4, 0), (direction, hold - 10, 0), ('-', 2, 2)] if hold >= 12 else None
    return s + [('A', 4, 4)] * n + [('-', 120 if n else 200, 0)]
PRE = [('A', 4, 200), ('Down', 4, 60), ('A', 4, 200)]            # main menu -> PLAY -> Space Fever II first wave
def dj(extra=()): return PRE + shoot('Right', n=0) + list(extra) + [('-', 200, 0)]
SPECIAL = [   # id, label, builder(vk) -> seq
    ('P20', 'BALL (shoot the BALL target)',                  lambda vk: PRE + shoot('Left')),
    ('P30', 'D.J.: shoot the D.J. target: COOL DATA title',  lambda vk: dj()),
    ('P31', 'D.J. title: Left',                              lambda vk: dj([('Left', 4, 100)])),
    ('P32', 'D.J. title: Right',                             lambda vk: dj([('Right', 4, 100)])),
    ('P33', 'D.J. title: A (default item) = confirm screen',  lambda vk: dj([('A', 4, 250)])),
    ('P34', 'D.J. title: Left, A = confirm screen',          lambda vk: dj([('Left', 4, 100), ('A', 4, 250)])),
    ('P35', 'D.J. title: Right, A = confirm screen',         lambda vk: dj([('Right', 4, 100), ('A', 4, 250)])),
    ('P36', 'D.J.: default item, A, A = performance screen', lambda vk: dj([('A', 4, 250), ('A', 4, 250)])),
    ('P37', 'D.J.: Left item, A, A',                         lambda vk: dj([('Left', 4, 100), ('A', 4, 250), ('A', 4, 250)])),
    ('P38', 'D.J.: Right item, A, A',                        lambda vk: dj([('Right', 4, 100), ('A', 4, 250), ('A', 4, 250)])),
    ('P39', 'D.J.: default item, Select = SOUND I',          lambda vk: dj([('A', 4, 250), ('A', 4, 250), ('Select', 4, 200)])),
    ('P3A', 'D.J.: Left item, Select = SOUND I',             lambda vk: dj([('Left', 4, 100), ('A', 4, 250), ('A', 4, 250), ('Select', 4, 200)])),
    ('P3B', 'D.J.: Right item, Select = SOUND I',            lambda vk: dj([('Right', 4, 100), ('A', 4, 250), ('A', 4, 250), ('Select', 4, 200)])),
    ('P3C', 'D.J.: Select x2 = SOUND II',                    lambda vk: dj([('A', 4, 250), ('A', 4, 250), ('Select', 4, 200), ('Select', 4, 200)])),
    ('P3D', 'D.J.: Select x3 = NOISE',                       lambda vk: dj([('A', 4, 250), ('A', 4, 250)] + [('Select', 4, 200)] * 3)),
]
SPECIAL_NODES = [(('PLAY'), nid, label, None) for nid, label, f in SPECIAL]
