#!/usr/bin/env python3
"""A 15-puzzle solver for the Hello Kitty sliding puzzle (mode $0F; 2026-11-14).

The board is the 16 bytes $D960-$D96F, row by row; the value of a cell is the number of the piece it holds, 0-14, and 15 is the empty
cell; the puzzle is solved when the cells hold 0, 1, ... 15 in order (Puzzle15_IsSolved, 07:5576). A key slides the piece next to the
empty cell into it, so it moves the empty cell the other way: Up = empty cell one row down, Down = one row up, Left = one column
right, Right = one column left (core, 2026-11-14).

solve(board) runs a weighted A* (f = g + 1.6 h, h = Manhattan distance + linear conflicts): not the shortest solution, but one in
40-70 moves found in well under a second for the boards the game deals (it shuffles by playing random legal moves, so every board
is solvable). keys(board) gives the solution as key names.
"""
import heapq
GOAL = tuple(range(16))
STEP = {'Up': (0, 1), 'Down': (0, -1), 'Left': (1, 0), 'Right': (-1, 0)}       # key -> move of the empty cell (dx, dy)
def h(b):
    s = 0
    for i, v in enumerate(b):
        if v != 15: s += abs(i % 4 - v % 4) + abs(i // 4 - v // 4)
    for r in range(4):                          # linear conflicts: two pieces in their goal row (column) in the wrong order
        row = [b[4 * r + c] for c in range(4) if b[4 * r + c] != 15 and b[4 * r + c] // 4 == r]
        s += 2 * sum(1 for i in range(len(row)) for j in range(i + 1, len(row)) if row[i] % 4 > row[j] % 4)
    for c in range(4):
        col = [b[4 * r + c] for r in range(4) if b[4 * r + c] != 15 and b[4 * r + c] % 4 == c]
        s += 2 * sum(1 for i in range(len(col)) for j in range(i + 1, len(col)) if col[i] // 4 > col[j] // 4)
    return s
def keys(board, w=1.6, limit=3000000):
    b = tuple(board)
    assert sorted(b) == list(range(16)), 'not a board: %r' % (b,)
    openq = [(w * h(b), 0, b)]; came = {b: None}; g = {b: 0}; n = 0
    while openq:
        _, gc, s = heapq.heappop(openq)
        if s == GOAL: break
        if gc > g[s]: continue
        n += 1
        if n > limit: raise RuntimeError('puzzle15: no solution within %d nodes' % limit)
        e = s.index(15); x, y = e % 4, e // 4
        for k, (dx, dy) in STEP.items():
            nx, ny = x + dx, y + dy
            if 0 <= nx < 4 and 0 <= ny < 4:
                t = list(s); j = 4 * ny + nx; t[e], t[j] = t[j], t[e]; t = tuple(t)
                if gc + 1 < g.get(t, 1 << 30):
                    g[t] = gc + 1; came[t] = (s, k); heapq.heappush(openq, (gc + 1 + w * h(t), gc + 1, t))
    out = []; s = GOAL
    while came[s] is not None: s, k = came[s]; out.append(k)
    return out[::-1]
def apply(board, ks):
    b = list(board)
    for k in ks:
        e = b.index(15); x, y = e % 4 + STEP[k][0], e // 4 + STEP[k][1]; j = 4 * y + x; b[e], b[j] = b[j], b[e]
    return b
if __name__ == '__main__':
    import random
    for _ in range(20):
        b = list(GOAL)
        for _ in range(500):
            k = random.choice(list(STEP)); e = b.index(15); x, y = e % 4 + STEP[k][0], e // 4 + STEP[k][1]
            if 0 <= x < 4 and 0 <= y < 4: b = apply(b, [k])
        ks = keys(b); assert apply(b, ks) == list(GOAL)
    print('puzzle15: 20 random boards solved')
