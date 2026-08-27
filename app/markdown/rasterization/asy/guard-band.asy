// The guard band. A triangle that leaves the viewport does not have to be cut
// up, as long as its coordinates still fit the fixed-point format: the geometry
// is kept whole and only the traversal is clamped. Only a triangle that leaves
// the guard band has to be clipped, and clipping is what introduces new
// vertices, so the band is made large enough that it rarely happens.

include common;
unitsize(0.32cm);

real vp = 16;      // viewport, [0, vp] in both axes
real gb = 16;      // how far the guard band extends beyond the viewport
real pad = 3;

real lo = -gb - pad, hi = vp + gb + pad;
path clipbox = P(lo, lo) -- P(hi, lo) -- P(hi, hi) -- P(lo, hi) -- cycle;

picture fig;

fill(fig, P(-gb, -gb) -- P(vp + gb, -gb) -- P(vp + gb, vp + gb) -- P(-gb, vp + gb) -- cycle,
     gray(0.955));

// Crossing the guard band boundary: must actually be clipped.
fill(fig, tri((-28, -10), (-6, -14), (-8, 2)), red + opacity(0.13));
draw(fig, tri((-28, -10), (-6, -14), (-8, 2)), red + linewidth(1.1pt));

// Outside the viewport, inside the guard band: kept whole.
fill(fig, tri((12, 10), (28, 18), (16, 28)), deepgreen + opacity(0.13));
draw(fig, tri((12, 10), (28, 18), (16, 28)), deepgreen + linewidth(1.1pt));

// Wholly inside the viewport.
fill(fig, tri((3, 3), (11, 5), (6, 13)), blue + opacity(0.16));
draw(fig, tri((3, 3), (11, 5), (6, 13)), blue + linewidth(1.1pt));

draw(fig, P(0, 0) -- P(vp, 0) -- P(vp, vp) -- P(0, vp) -- cycle, black + linewidth(1.4pt));
draw(fig, P(-gb, -gb) -- P(vp + gb, -gb) -- P(vp + gb, vp + gb) -- P(-gb, vp + gb) -- cycle,
     gray(0.4) + linewidth(1.0pt) + dashed);

clip(fig, clipbox);
add(fig);

label("viewport", P(vp + 0.8, vp - 1.5), align = E, fontsize(8pt));
label("guard band", P(vp + gb - 1.0, vp + gb - 1.0), align = NW, fontsize(8pt) + gray(0.3));

label("(a)", P(6, 7), fontsize(9pt) + blue);
label("(b)", P(19, 18), fontsize(9pt) + deepgreen);
label("(c)", P(-14, -7), fontsize(9pt) + red);
