// Why a normal taken from a Gaussian's shortest axis is not a surface normal.
// The ellipses are a cross section of what a photometric loss actually produces
// near a surface: varying sizes, off the surface, overlapping, and some of them
// close to round.

include common;
// Sized so that the rendered width matches the other figures in the article;
// the labels are absolute, so a wider drawing gives them their usual weight.
unitsize(2.2cm);

path surf = (-2.6, 0) .. (-1.3, 0.30) .. (0, 0.12) .. (1.3, -0.28) .. (2.6, -0.15);

// The solid lies below the surface, so the inward normal points down.
pair innorm(path g, real t) { pair d = dir(g, t); return (d.y, -d.x); }

// centre, semi-axes, rotation of the short axis away from the true normal
real[][] g = {
    {-2.20,  0.18, 0.52, 0.15,  12},
    {-1.55, -0.10, 0.40, 0.20, -35},
    {-0.95,  0.34, 0.30, 0.26,  55},   // nearly round: the short axis is arbitrary
    {-0.30,  0.02, 0.60, 0.13,   8},
    { 0.35,  0.30, 0.34, 0.17, -22},
    { 0.55, -0.26, 0.44, 0.15,  20},   // two Gaussians covering one patch
    { 1.25, -0.14, 0.28, 0.25, -62},   // nearly round
    { 1.95, -0.36, 0.52, 0.14,  14},
    { 2.35,  0.05, 0.36, 0.19, -30}
};

picture a;
draw(a, surf, c_faint + linewidth(0.8pt));
for (real[] e : g) {
    pair c = (e[0], e[1]);
    transform T = shift(c) * rotate(e[4]);
    filldraw(a, T * scale(e[2], e[3]) * unitcircle, c_gaussfill, c_gauss);
    // The short axis, drawn both ways: nothing in the representation says which
    // end points into the solid.
    pair d = (Cos(e[4] + 90), Sin(e[4] + 90));
    draw(a, c - 0.36 * d -- c + 0.36 * d, c_badline, Arrows(SimpleHead, 4));
    dot(a, c, c_bad + linewidth(3.0pt));
}
tag(a, "(a)", (0, -0.95));

picture b;
draw(b, surf, c_surf);
for (int i = 0; i <= 10; ++i) {
    real t = i * length(surf) / 10;
    sample(b, point(surf, t), innorm(surf, t), 0.34);
}
tag(b, "(b)", (0, -0.95));

add(shift(0, 0) * a);
add(shift(0, -1.85) * b);
