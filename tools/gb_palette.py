"""One palette for every Game Boy picture of the repository (owner 2026-11-12): the four grey levels the project's own renders use
(white, light grey $AA, dark grey $55, black). gray(img) maps BGB's default greens (the screenshots of roms/*/screens/ as BGB saved
them) to these greys and leaves every other colour as it is; the screenshots themselves are kept as recorded."""
from PIL import Image
BGB = {(232, 252, 204): (255, 255, 255), (172, 212, 144): (170, 170, 170), (84, 140, 112): (85, 85, 85), (20, 44, 56): (0, 0, 0)}
def gray(img):
    im = img.convert('RGB'); px = im.load(); w, h = im.size
    for y in range(h):
        for x in range(w):
            c = px[x, y]
            if c in BGB: px[x, y] = BGB[c]
    return im
