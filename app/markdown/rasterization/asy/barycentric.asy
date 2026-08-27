// Coverage from barycentric weights. The three sub-triangle areas are the
// weights attribute interpolation needs anyway; a sample is inside when none of
// them is negative.

include common;
unitsize(1.21cm);

pair v0 = (0.9, 0.9), v1 = (5.3, 2.2), v2 = (2.5, 5.2);

void panel(real dx, pair p, string tag) {
    picture pic;

    // A weight is negative when p lies on the far side of the opposite edge.
    real w0 = area2(v0, v1, p);
    real w1 = area2(v1, v2, p);
    real w2 = area2(v2, v0, p);

    pen neg = red + opacity(0.30);

    fill(pic, P(v0) -- P(v1) -- P(p) -- cycle, w0 < 0 ? neg : blue + opacity(0.18));
    fill(pic, P(v1) -- P(v2) -- P(p) -- cycle, w1 < 0 ? neg : deepgreen + opacity(0.18));
    fill(pic, P(v2) -- P(v0) -- P(p) -- cycle, w2 < 0 ? neg : orange + opacity(0.22));

    draw(pic, P(v0) -- P(p), gray(0.5) + linewidth(0.5pt));
    draw(pic, P(v1) -- P(p), gray(0.5) + linewidth(0.5pt));
    draw(pic, P(v2) -- P(p), gray(0.5) + linewidth(0.5pt));

    draw(pic, tri(v0, v1, v2), c_tri + linewidth(1.4pt));
    dot(pic, P(p), black + linewidth(4.5pt));

    label(pic, "$\pmb{v_0}$", P(v0), align = SW, fontsize(8pt));
    label(pic, "$\pmb{v_1}$", P(v1), align = E, fontsize(8pt));
    label(pic, "$\pmb{v_2}$", P(v2), align = SW, fontsize(8pt));
    label(pic, "$\pmb{p}$", P(p), align = SE, fontsize(8pt));

    // Label each weight at the centroid of the sub-triangle it measures.
    label(pic, "$w_0$", P((v0 + v1 + p) / 3), fontsize(8pt) + (w0 < 0 ? red : blue));
    label(pic, "$w_1$", P((v1 + v2 + p) / 3), fontsize(8pt) + (w1 < 0 ? red : deepgreen));
    label(pic, "$w_2$", P((v2 + v0 + p) / 3), fontsize(8pt) + (w2 < 0 ? red : orange));

    label(pic, tag, P(3, -0.45), fontsize(8pt));
    add(shift(dx, 0) * pic);
}

panel(0.0, (2.9, 2.7), "(a)");
panel(6.6, (4.6, 4.4), "(b)");
