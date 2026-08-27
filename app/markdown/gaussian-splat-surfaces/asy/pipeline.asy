// The whole path from input images to a surface. The dashed return is the only
// part that needs the stochastic solve.
//
// Labels wrap to two lines so the chain stays narrower than the article column;
// scaled down to fit, the box text would be unreadable.

include common;
unitsize(1.0cm);

real w = 1.75, h = 1.00;
real dx = 2.45;

string[] s = {
    "Input views",
    "Gaussian surfels",
    "Depth maps",
    "Normals + mask",
    "Point cloud $S$",
    "Poisson solve",
    "$\partial M$"
};

pen[] fills = {
    gray(0.93),
    c_gaussfill,
    c_recfill,
    c_recfill,
    c_samp + opacity(0.18),
    c_rec + opacity(0.26),
    gray(0.93)
};

for (int i = 0; i < s.length; ++i) {
    node((i * dx, 0), w, h, minipage("\centering " + s[i], 1.55cm), c_edge, fills[i]);
    if (i > 0) link(((i - 1) * dx + w / 2, 0), (i * dx - w / 2, 0));
}

// The uncertainty path: the solve also scores the views it was given.
real last = (s.length - 1) * dx;
real yb = -1.35;
draw((last, -h / 2) -- (last, yb) -- (0, yb), c_dash);
draw((0, yb) -- (0, -h / 2), c_dash, Arrow(TeXHead, 2.6));
label("rank views by surface uncertainty", (last / 2, yb), align = S,
      fontsize(8pt) + gray(0.35));
