// The top-left rule. The triangle is placed so that texel centres land exactly
// on all three of its edges, which is the only case the rule has an opinion on.

include common;
unitsize(1.49cm);

int w = 11, h = 11;

// Half-integer coordinates put sample points exactly on every edge.
pair a = (2.5, 2.5), b = (8.5, 2.5), c = (2.5, 8.5);

pen c_top = deepgreen + linewidth(1.6pt);
pen c_left = deepgreen + linewidth(1.6pt);
pen c_right = red + linewidth(1.6pt);

for (int i = 0; i < w; ++i)
    for (int j = 0; j < h; ++j)
        if (covered((i + 0.5, j + 0.5), a, b, c)) shadetexel(i, j, orange + opacity(0.13));

grid(w, h);
fill(tri(a, b, c), blue + opacity(0.04));

draw(P(a) -- P(b), c_top, arrow = MidArrow(TeXHead));
draw(P(b) -- P(c), c_right, arrow = MidArrow(TeXHead));
draw(P(c) -- P(a), c_left, arrow = MidArrow(TeXHead));

marksamples(w, h, a, b, c);

// Ring the samples that sit exactly on an edge.
void onedge(pair s) { draw(circle(P(s), 0.19), black + linewidth(0.6pt)); }
for (int i = 3; i <= 7; ++i) onedge((i + 0.5, 2.5));
for (int j = 3; j <= 7; ++j) onedge((2.5, j + 0.5));
for (int i = 3; i <= 7; ++i) onedge((i + 0.5, 11.0 - i - 0.5));

label("top", P(5.5, 2.35), align = N, fontsize(8pt) + deepgreen);
label("left", P(2.35, 5.5), align = W, fontsize(8pt) + deepgreen);
label("right", P(6.6, 6.6), align = NE, fontsize(8pt) + red);

label("$\pmb{v_0}$", P(a), align = NW);
label("$\pmb{v_1}$", P(b), align = NE);
label("$\pmb{v_2}$", P(c), align = SW);

