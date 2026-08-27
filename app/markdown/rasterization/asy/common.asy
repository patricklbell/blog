// Shared setup for the rasterization diagrams.
//
// Framebuffer coordinates have y pointing down, so every diagram is drawn
// through P(), which flips y. Texel (i, j) occupies [i, i+1) x [j, j+1).

settings.outformat = "svg";
defaultpen(fontsize(9pt));

usepackage("amsmath");

pen c_grid      = gray(0.78) + linewidth(0.4pt);
pen c_gridbold  = gray(0.55) + linewidth(0.7pt);
pen c_tri       = blue + linewidth(1.1pt);
pen c_trifill   = blue + opacity(0.07);
pen c_tri2      = red + linewidth(1.1pt);
pen c_tri2fill  = red + opacity(0.07);
pen c_on        = orange;
pen c_off       = gray(0.6);
pen c_band      = orange + opacity(0.13);
pen c_emit      = orange + opacity(0.20);
pen c_note      = black;

pair P(real x, real y) { return (x, -y); }
pair P(pair p) { return (p.x, -p.y); }

// A w x h grid of texels with its origin at the top left.
void grid(int w, int h, pen p = c_grid) {
    for (int i = 0; i <= w; ++i) draw(P(i, 0) -- P(i, h), p);
    for (int j = 0; j <= h; ++j) draw(P(0, j) -- P(w, j), p);
}

// Texel centres, the sample positions of single sampling.
void centres(int w, int h, pen p = c_off, real r = 0.045) {
    for (int i = 0; i < w; ++i)
        for (int j = 0; j < h; ++j)
            fill(circle(P(i + 0.5, j + 0.5), r), p);
}

path tri(pair a, pair b, pair c) { return P(a) -- P(b) -- P(c) -- cycle; }

void drawtri(pair a, pair b, pair c, pen line = c_tri, pen fillpen = c_trifill) {
    path t = tri(a, b, c);
    fill(t, fillpen);
    draw(t, line);
}

// Twice the signed area, positive when a b c wind clockwise on screen.
real area2(pair a, pair b, pair c) {
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
}

// Is p inside triangle a b c under the top-left rule? Edges are taken in
// clockwise-on-screen order, so a top edge runs left to right and a left edge
// runs upwards.
bool covered(pair p, pair a, pair b, pair c) {
    if (area2(a, b, c) == 0) return false;
    pair[] v = (area2(a, b, c) > 0) ? new pair[] {a, b, c} : new pair[] {a, c, b};

    for (int i = 0; i < 3; ++i) {
        pair s = v[i], e = v[(i + 1) % 3];
        real d = area2(s, e, p);
        if (d > 0) continue;
        if (d < 0) return false;
        bool top = (s.y == e.y) && (e.x > s.x);
        bool left = e.y < s.y;
        if (!(top || left)) return false;
    }
    return true;
}

// Mark the texel centres covered by a triangle.
void marksamples(int w, int h, pair a, pair b, pair c, pen on = c_on, pen off = c_off) {
    for (int i = 0; i < w; ++i)
        for (int j = 0; j < h; ++j) {
            pair s = (i + 0.5, j + 0.5);
            if (covered(s, a, b, c)) fill(circle(P(s), 0.085), on);
            else fill(circle(P(s), 0.045), off);
        }
}

void shadetexel(int i, int j, pen p) {
    fill(P(i, j) -- P(i + 1, j) -- P(i + 1, j + 1) -- P(i, j + 1) -- cycle, p);
}
