"""Generate TailscaleGlyph.ttf: the Tailscale mark as polybar glyphs.

The mark is a 3x3 dot grid in two tones. Polybar paints each text run in a
single color, so the two tones are split into separate glyphs: DIM is
zero-width and overlays BRIGHT, letting the script color each layer.

Run with: nix-shell -p fontforge --run "fontforge -script build.py"
"""

import os
import tempfile

import fontforge
import psMat

BRIGHT_DOTS = [(3, 12), (12, 12), (21, 12), (12, 21)]
DIM_DOTS = [(3, 3), (12, 3), (21, 3), (3, 21), (21, 21)]

DIM = 0xE100     # dimmed dots only, zero-width overlay
BRIGHT = 0xE101  # bright dots only, advances the pen
ALL = 0xE102     # every dot, for the disconnected states

RADIUS = 3.0
SCALE = 0.78
BEARING = 60
CENTER = 300  # vertical center, in em units, shared with the bar's text

SIZE = 1000 * SCALE
BOTTOM = CENTER - SIZE / 2
ADVANCE = SIZE + 2 * BEARING


def circle(cx, cy):
    r = RADIUS
    return (f"M{cx + r} {cy}a{r} {r} 0 1 1 {-2 * r} 0"
            f"a{r} {r} 0 1 1 {2 * r} 0z")


def write_svg(path, dots):
    with open(path, "w") as fh:
        fh.write('<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">'
                 f'<path d="{"".join(circle(x, y) for x, y in dots)}"/></svg>')


def add_glyph(font, codepoint, name, dots, width, tmp):
    svg = os.path.join(tmp, f"{name}.svg")
    write_svg(svg, dots)
    glyph = font.createChar(codepoint, name)
    glyph.importOutlines(svg)
    # importOutlines maps the viewBox onto the em box, so one fixed transform
    # keeps every glyph on a shared grid.
    glyph.transform(psMat.compose(
        psMat.translate(0, 200),
        psMat.compose(psMat.scale(SCALE), psMat.translate(BEARING, BOTTOM))))
    glyph.correctDirection()
    glyph.width = int(width)


font = fontforge.font()
font.em = 1000
font.ascent, font.descent = 800, 200
font.fontname = "TailscaleGlyph"
font.familyname = "Tailscale Glyph"
font.fullname = "Tailscale Glyph"

with tempfile.TemporaryDirectory() as tmp:
    add_glyph(font, DIM, "tailscaleDim", DIM_DOTS, 0, tmp)
    add_glyph(font, BRIGHT, "tailscaleBright", BRIGHT_DOTS, ADVANCE, tmp)
    add_glyph(font, ALL, "tailscaleAll", BRIGHT_DOTS + DIM_DOTS, ADVANCE, tmp)

font.generate(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "TailscaleGlyph.ttf"))
