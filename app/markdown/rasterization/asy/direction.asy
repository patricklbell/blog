// Which of a band's two horizontal lines to read.

include common;
defaultpen(fontsize(8pt));
unitsize(0.98cm);

real xat(pair p, pair q, real y) {
    if (q.y == p.y) return p.x;
    return p.x + (y - p.y) * (q.x - p.x) / (q.y - p.y);
}

// Left: a single edge crossing three bands. Its leftmost x within each band is
// at the band's upper edge when the edge leans right, and at the lower edge
// when it leans left.
picture panelA;
{
    int w = 7, h = 4;
    for (int i = 0; i <= w; ++i) draw(panelA, P(i, 0) -- P(i, h), c_grid);
    for (int j = 0; j <= h; ++j) draw(panelA, P(0, j) -- P(w, j), j == 0 || j == h ? c_grid : c_gridbold);

    pair p = (1.4, 0.5), q = (5.6, 3.6);      // leans right
    draw(panelA, P(p) -- P(q), deepgreen + linewidth(1.6pt));
    dot(panelA, P(p), deepgreen + linewidth(4.5pt));
    dot(panelA, P(q), deepgreen + linewidth(4.5pt));

    // Taken coordinate per band: the upper edge, since dx > 0.
    for (int row = 0; row < h; ++row) {
        real ya = max(row, p.y), yb = min(row + 1, q.y);
        if (ya > yb) continue;
        real x = xat(p, q, ya);
        dot(panelA, P(x, ya), red + linewidth(4.5pt));
        draw(panelA, P(x, ya) -- P(x, yb), red + linewidth(0.6pt) + dashed);
    }

    }

add(panelA);
