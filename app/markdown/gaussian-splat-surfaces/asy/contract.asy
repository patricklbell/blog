// The three requirements a Gaussian point cloud breaks, each drawn as the
// reconstruction it produces. Grey is the true surface, red is what the solve
// returns from the samples shown.

include common;
unitsize(1.0cm);

path blob = (0,1.4) .. (1.25,1.05) .. (1.6,-0.15) .. (0.7,-1.25)
         .. (-0.8,-1.15) .. (-1.55,-0.1) .. (-1.1,1.1) .. cycle;

int n = 16;

// A copy of g displaced along its inward normal, so a defect can be placed at
// the parameter of the sample that causes it.
typedef real offset(real);
path perturb(path g, offset f, int m = 96) {
    guide q;
    for (int i = 0; i < m; ++i) {
        real t = i * length(g) / m;
        q = q .. point(g, t) + f(i / m) * unit(innormal(g, t));
    }
    return q .. cycle;
}

// A bump of the given width centred on u0, wrapping around u = 1.
real bump(real u, real u0, real width, real amp) {
    real d = abs(u - u0);
    d = min(d, 1 - d);
    return d > width ? 0 : amp * (0.5 + 0.5 * Cos(180 * d / width));
}

// (a) one normal flipped
int flip = 3;
real uflip = flip / n;
picture a;
draw(a, blob, c_faint);
draw(a, perturb(blob, new real(real u) { return bump(u, uflip, 0.16, 0.85); }), c_badline);
for (int i = 0; i < n; ++i) {
    real t = i * length(blob) / n;
    pair p = point(blob, t);
    pair nn = innormal(blob, t);
    bool flipped = (i == flip);
    sample(a, p, flipped ? -nn : nn, 0.36,
           flipped ? c_bad : c_samp,
           flipped ? c_badline : c_sampline);
}
tag(a, "(a)", (0, -2.05));

// (b) samples clustered on one arc, with no area weight to compensate
picture b;
draw(b, blob, c_faint);
draw(b, perturb(blob, new real(real u) {
    return bump(u, 0.08, 0.30, -0.30) + bump(u, 0.62, 0.34, 0.30);
}), c_badline);
for (int i = 0; i < n; ++i) {
    real u = (i + 0.5) / n;
    real t = (u ** 2.3) * length(blob);
    pair p = point(blob, t);
    sample(b, p, innormal(blob, t), 0.36);
}
tag(b, "(b)", (0, -2.05));

// (c) samples scattered off the surface
picture c;
draw(c, blob, c_faint);
draw(c, perturb(blob, new real(real u) { return -0.14 - 0.10 * Cos(360 * 3 * u); }), c_badline);
real[] jit = {0.30, -0.26, 0.22, -0.34, 0.12, 0.28, -0.30, 0.18,
              -0.22, 0.34, -0.14, 0.26, -0.28, 0.20, 0.32, -0.18};
for (int i = 0; i < n; ++i) {
    real t = i * length(blob) / n;
    pair nn = unit(innormal(blob, t));
    pair p = point(blob, t) + jit[i] * nn;
    sample(c, p, nn, 0.36);
}
tag(c, "(c)", (0, -2.05));

add(shift(0, 0) * a);
add(shift(4.6, 0) * b);
add(shift(9.2, 0) * c);
