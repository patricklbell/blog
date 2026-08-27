// Vertex positions are converted to n.8 fixed point before anything else
// happens. Drawn with 8 fractional subdivisions per texel for legibility; the
// specification asks for 8 fractional bits, so 256.

include common;
unitsize(4.09cm);

int w = 4, h = 3;
int sub = 8;

// Subpixel grid.
for (int i = 0; i <= w * sub; ++i)
    draw(P(i / sub, 0) -- P(i / sub, h), gray(0.84) + linewidth(0.3pt));
for (int j = 0; j <= h * sub; ++j)
    draw(P(0, j / sub) -- P(w, j / sub), gray(0.84) + linewidth(0.3pt));

grid(w, h, c_gridbold);

// The conversion of D3D11.3 3.2.4: compute n * 2^f and take the integer.
pair tofixed(pair p) {
    return (round(p.x * sub) / sub, round(p.y * sub) / sub);
}

pair a = (0.42, 0.31), b = (3.57, 1.12), c = (1.68, 2.66);
pair sa = tofixed(a), sb = tofixed(b), sc = tofixed(c);

// The triangle as it arrives, and its fixed-point representation.
draw(tri(a, b, c), gray(0.40) + linewidth(1.1pt) + dashed);
fill(tri(sa, sb, sc), blue + opacity(0.07));
draw(tri(sa, sb, sc), c_tri);

void move(pair src, pair dst, string name, pair al) {
    dot(P(src), gray(0.45) + linewidth(3.5pt));
    dot(P(dst), red + linewidth(4.5pt));
    if (abs(src - dst) > 0.02)
        draw(P(src) -- P(dst), red + linewidth(0.7pt), arrow = Arrow(TeXHead, size = 3));
    label(name, P(dst), align = al, fontsize(8pt));
}

move(a, sa, "$\pmb{v_0}$", NW);
move(b, sb, "$\pmb{v_1}$", E);
move(c, sc, "$\pmb{v_2}$", NE);

// Callout of one subpixel cell.
draw(P(0, h + 0.25) -- P(1.0 / sub, h + 0.25), black + linewidth(0.7pt), bar = Bars);
label("$2^{-f}$", P(1.15 / sub, h + 0.25), align = E, fontsize(8pt));
