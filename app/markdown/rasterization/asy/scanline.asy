// One (start, end) pair per band. start is the leftmost x of any edge within
// the band, end the rightmost. The long edge feeds one side and the two-piece
// chain the other; which is which follows from the winding.

include common;
unitsize(1.26cm);

int w = 12, h = 10;

pair a = (2.2, 0.9), b = (10.6, 4.4), c = (4.4, 9.3);

// Sorted by y, as the traversal does.
pair s0 = a, s1 = b, s2 = c;
if (s0.y > s1.y) { pair t = s0; s0 = s1; s1 = t; }
if (s1.y > s2.y) { pair t = s1; s1 = s2; s2 = t; }
if (s0.y > s1.y) { pair t = s0; s0 = s1; s1 = t; }

real xat(pair p, pair q, real y) {
    if (q.y == p.y) return p.x;
    return p.x + (y - p.y) * (q.x - p.x) / (q.y - p.y);
}

// Leftmost and rightmost x of any edge of the primitive within [ya, yb].
real[] span(real ya, real yb) {
    real lo = infinity, hi = -infinity;
    pair[][] edges = {{s0, s1}, {s1, s2}, {s0, s2}};
    for (pair[] e : edges) {
        real ca = max(ya, e[0].y), cb = min(yb, e[1].y);
        if (ca > cb) continue;
        for (real y : new real[] {ca, cb}) {
            real x = xat(e[0], e[1], y);
            lo = min(lo, x); hi = max(hi, x);
        }
    }
    if (lo > hi) return new real[] {};
    return new real[] {lo, hi};
}

// Every band's emitted texels.
for (int row = 0; row < h; ++row) {
    real ya = max(row, s0.y), yb = min(row + 1, s2.y);
    if (ya > yb) continue;
    real[] e = span(ya, yb);
    if (e.length == 0) continue;
    int c0 = max((int) floor(e[0]), 0);
    int c1 = min((int) floor(e[1]), w - 1);
    for (int i = c0; i <= c1; ++i) shadetexel(i, row, c_emit);
}

grid(w, h);

fill(tri(s0, s1, s2), blue + opacity(0.05));

// Coloured by the side each feeds.
draw(P(s0) -- P(s2), deepgreen + linewidth(1.6pt));
draw(P(s0) -- P(s1) -- P(s2), red + linewidth(1.6pt));

marksamples(w, h, s0, s1, s2);

// Call out one band.
int row = 3;
real[] e = span(row, row + 1);
draw(P(0, row) -- P(w, row), black + linewidth(1.0pt));
draw(P(0, row + 1) -- P(w, row + 1), black + linewidth(1.0pt));

dot(P(e[0], row), deepgreen + linewidth(5pt));
dot(P(e[1], row + 1), red + linewidth(5pt));

draw(P(e[0], row + 1.2) -- P(e[1], row + 1.2), black + linewidth(0.7pt), bar = Bars);
label("start", P(e[0], row + 1.35), align = S, fontsize(8pt) + deepgreen);
label("end", P(e[1], row + 1.35), align = S, fontsize(8pt) + red);

label("$y_{\text{top}}$", P(-0.15, row), align = W, fontsize(8pt));
label("$y_{\text{bot}}$", P(-0.15, row + 1), align = W, fontsize(8pt));

label("$\pmb{v_0}$", P(s0), align = NW, fontsize(8pt));
label("$\pmb{v_1}$", P(s1), align = E, fontsize(8pt));
label("$\pmb{v_2}$", P(s2), align = SW, fontsize(8pt));
