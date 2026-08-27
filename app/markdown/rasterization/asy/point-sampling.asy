// Point sampling: a texel is covered when a sample point lies inside the
// triangle. How much of the texel the triangle overlaps is irrelevant.

include common;
unitsize(1.37cm);

int w = 11, h = 8;

pair a = (1.4, 0.9), b = (9.3, 3.1), c = (3.7, 7.2);

for (int i = 0; i < w; ++i)
    for (int j = 0; j < h; ++j)
        if (covered((i + 0.5, j + 0.5), a, b, c)) shadetexel(i, j, orange + opacity(0.16));

grid(w, h);
drawtri(a, b, c, c_tri, blue + opacity(0.05));
marksamples(w, h, a, b, c);

label("$\pmb{v_0}$", P(a), align = NW);
label("$\pmb{v_1}$", P(b), align = E);
label("$\pmb{v_2}$", P(c), align = SW);

// A texel the triangle covers most of, but whose sample point falls outside.
int mx = 7, my = 2;
draw(P(mx, my) -- P(mx + 1, my) -- P(mx + 1, my + 1) -- P(mx, my + 1) -- cycle,
     black + linewidth(0.9pt) + dashed);
// Axes.
draw(P(0.1, -0.5) -- P(1.6, -0.5), c_note, arrow = Arrow(TeXHead),
     L = Label("$x$", position = EndPoint, align = N));
draw(P(-0.5, 0.1) -- P(-0.5, 1.6), c_note, arrow = Arrow(TeXHead),
     L = Label("$y$", position = EndPoint, align = W));
