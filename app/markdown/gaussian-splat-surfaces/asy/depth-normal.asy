// Reconstructing a normal from the depth map. Depth is back-projected to a view
// space position at each pixel, and the normal follows from central differences
// across the four neighbours.

include common;
// Widened so the rendered figure matches the others; see gaussian-normals.asy.
unitsize(1.85cm);

// (a) the pixel neighbourhood in the image
picture a;
fill(a, rect((1, 1), (2, 2)), c_samp + opacity(0.20));
pair[] nb  = {(2.5, 1.5), (0.5, 1.5), (1.5, 2.5), (1.5, 0.5)};
string[] nbl = {"$u{+}1$", "$u{-}1$", "$v{+}1$", "$v{-}1$"};
for (int i = 0; i < 4; ++i) {
    fill(a, rect(nb[i] - (0.5, 0.5), nb[i] + (0.5, 0.5)), c_rec + opacity(0.12));
    label(a, nbl[i], nb[i], fontsize(9.5pt) + gray(0.30));
}
for (int i = 0; i <= 3; ++i) {
    draw(a, (i, 0) -- (i, 3), c_grid);
    draw(a, (0, i) -- (3, i), c_grid);
}
dot(a, (1.5, 1.5), c_samp + linewidth(3.6pt));
label(a, "$(u,v)$", (1.5, 1.28), align = S, fontsize(9.5pt));
tag(a, "(a)", (1.5, -0.7), fontsize(10pt));

// (b) the same five pixels back-projected into view space
picture b;
pair c  = (1.7, 1.05);
pair px = (1.15, 0.22);   // tangent from the difference in u
pair py = (0.34, 0.86);   // tangent from the difference in v

path patch = (c - 1.30 * px - 1.05 * py) -- (c + 1.30 * px - 1.05 * py)
          -- (c + 1.30 * px + 1.05 * py) -- (c - 1.30 * px + 1.05 * py) -- cycle;
filldraw(b, patch, c_rec + opacity(0.06), c_faint);

for (pair d : new pair[] {-px, px, -py, py}) dot(b, c + d, c_rec + linewidth(3.2pt));

draw(b, c -- c + px, c_recline, Arrow(SimpleHead, 5));
draw(b, c -- c + py, c_recline, Arrow(SimpleHead, 5));
label(b, "$\mathbf{x}_u$", c + px, align = SE, fontsize(10pt) + c_rec);
label(b, "$\mathbf{x}_v$", c + py, align = W, fontsize(10pt) + c_rec);

// The normal, out of the plane spanned by the two tangents.
draw(b, c -- c + (0.62, 1.32), c_sampline + linewidth(1.1pt), Arrow(SimpleHead, 5));
label(b, "$\mathbf{N}_i(u,v)$", c + (0.62, 1.32), align = NE, fontsize(10pt) + c_samp);

dot(b, c, c_samp + linewidth(3.8pt));
tag(b, "(b)", (1.7, -0.7), fontsize(10pt));

add(shift(0, 0) * a);
add(shift(4.7, 0) * b);
