// The band holding v1, where the short edges meet. Three coordinates land in
// it: the upper edge's crossing of the band's upper line, v1 itself, and the
// lower edge's crossing of the lower line. All three panels put the short edges
// on the right, so the extreme wanted is the rightmost.

include common;
unitsize(0.92cm);

real ytop = 6, ybot = 7;          // the band holding v1
real ylo = 5.4, yhi = 7.6;        // drawn window

real xat(pair p, pair q, real y) { return p.x + (y - p.y) * (q.x - p.x) / (q.y - p.y); }

void panel(real dx, pair v0, pair v1, pair v2, real xshift, string tag) {
    picture pic;
    real w = 5;

    // Local frame: world x minus xshift.
    pair L(real x, real y) { return P(x - xshift, y); }

    fill(pic, L(xshift, ytop) -- L(xshift + w, ytop) -- L(xshift + w, ybot) -- L(xshift, ybot) -- cycle,
         orange + opacity(0.10));

    for (int i = 0; i <= (int) w; ++i)
        draw(pic, P(i, ylo) -- P(i, yhi), c_grid);

    draw(pic, L(xshift, ytop) -- L(xshift + w, ytop), black + linewidth(1.0pt));
    draw(pic, L(xshift, ybot) -- L(xshift + w, ybot), black + linewidth(1.0pt));

    real xu = xat(v0, v1, ytop);          // upper edge, on the band's upper line
    real xl = xat(v1, v2, ybot);          // lower edge, on the band's lower line

    draw(pic, L(xat(v0, v1, ylo), ylo) -- L(v1.x, v1.y), red + linewidth(1.6pt));
    draw(pic, L(v1.x, v1.y) -- L(xat(v1, v2, yhi), yhi), orange + linewidth(1.6pt));

    real win = max(max(xu, xl), v1.x);
    draw(pic, L(win, ylo) -- L(win, yhi), deepgreen + linewidth(1.0pt) + dashed);

    draw(pic, circle(L(xu, ytop), 0.15), red + linewidth(1.1pt));
    draw(pic, circle(L(xl, ybot), 0.15), orange + linewidth(1.1pt));
    dot(pic, L(v1.x, v1.y), black + linewidth(5pt));

    label(pic, "$\pmb{v_1}$", L(v1.x, v1.y), align = SW, fontsize(8pt));
    label(pic, "end", L(win, ylo), align = N, fontsize(8pt) + deepgreen);
    label(pic, tag, L(xshift + w / 2, yhi + 0.35), align = S, fontsize(9pt));

    add(shift(dx, 0) * pic);
}

// (a) x0 < x1 < x2: both edges lean right, so the lower edge's crossing wins.
panel(0.0, (0, 0), (16, 6.5), (24, 12), 13.0, "(a)");
// (b) x0 > x1 > x2: both lean left, so the upper edge's crossing wins.
panel(6.4, (24, 0), (16, 6.5), (0, 12), 12.5, "(b)");
// (c) x0 < x1 > x2: both fall away from v1, so v1 itself wins.
panel(12.8, (0, 0), (24, 6.5), (8, 12), 19.8, "(c)");
