// Shared setup for the Gaussian splat surface diagrams.
//
// Every figure is a 2D cross section of a 3D situation. The solid M is shaded,
// its boundary is drawn solid, and samples carry inward normals following
// Kazhdan et al. Orange marks a sample or a quantity derived from one, blue
// marks the reconstructed quantity, red marks a failure.

settings.outformat = "svg";
defaultpen(fontsize(9pt));

usepackage("amsmath");

pen c_edge      = gray(0.30) + linewidth(0.7pt);
pen c_faint     = gray(0.82) + linewidth(0.4pt);
pen c_grid      = gray(0.80) + linewidth(0.4pt);
pen c_dash      = gray(0.50) + linewidth(0.6pt) + dashed;

// The true surface and the solid it bounds.
pen c_surf      = rgb(0.20, 0.22, 0.26) + linewidth(1.2pt);
pen c_solid     = gray(0.88);

// Samples and their normals.
pen c_samp      = rgb(0.86, 0.50, 0.06);
pen c_sampline  = rgb(0.86, 0.50, 0.06) + linewidth(0.9pt);

// Reconstructed or blended quantities.
pen c_rec       = rgb(0.13, 0.35, 0.72);
pen c_recline   = rgb(0.13, 0.35, 0.72) + linewidth(1.1pt);
pen c_recfill   = rgb(0.13, 0.35, 0.72) + opacity(0.14);

// Failures.
pen c_bad       = rgb(0.78, 0.14, 0.14);
pen c_badline   = rgb(0.78, 0.14, 0.14) + linewidth(1.1pt);
pen c_badfill   = rgb(0.78, 0.14, 0.14) + opacity(0.16);

// Gaussians.
pen c_gauss     = rgb(0.42, 0.24, 0.62) + linewidth(0.6pt);
pen c_gaussfill = rgb(0.42, 0.24, 0.62) + opacity(0.16);

path rect(pair lo, pair hi) {
    return lo -- (hi.x, lo.y) -- hi -- (lo.x, hi.y) -- cycle;
}

void node(picture pic = currentpicture, pair c, real w, real h, string s,
          pen edge = c_edge, pen fillp = white) {
    filldraw(pic, rect(c - (w / 2, h / 2), c + (w / 2, h / 2)), fillp, edge);
    label(pic, s, c);
}

void link(picture pic = currentpicture, pair a, pair b, pen p = c_edge, real size = 2.6) {
    draw(pic, a -- b, p, Arrow(TeXHead, size));
}

// A sample: a dot at p with its normal drawn as an arrow of length len.
void sample(picture pic = currentpicture, pair p, pair n, real len = 0.42,
            pen p_dot = c_samp, pen p_arr = c_sampline) {
    draw(pic, p -- p + len * unit(n), p_arr, Arrow(SimpleHead, 4));
    dot(pic, p, p_dot + linewidth(3.6pt));
}

// Panel tag, placed below the figure it labels. Figures are scaled to the
// article column, so a drawing whose natural width is already near the column
// needs a larger absolute size here to match the others on screen.
void tag(picture pic = currentpicture, string s, pair at, pen p = fontsize(8pt)) {
    label(pic, s, at, p);
}

// The inward normal of a closed path at time t. Which side of the tangent the
// interior lies on depends on the winding, so test rather than assume it.
pair innormal(path g, real t) {
    pair d = dir(g, t);
    pair p = point(g, t);
    pair n = (-d.y, d.x);
    return inside(g, p + 0.03 * n) ? n : -n;
}
