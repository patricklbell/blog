// The execution model: one pinned thread per core, each owning a disjoint slice
// of the key space, its own file, cache and queue pair.

include common;
unitsize(1.70cm);

real sw = 2.55, sx = 3.05;
real[] cx = {0, sx, 2 * sx};

for (int i = 0; i < 3; ++i) {
    real x = cx[i];

    filldraw(rect((x - sw / 2, 0.55), (x + sw / 2, 3.55)), white, c_edge);
    label("\textbf{core " + string(i) + "}", (x, 3.28), fontsize(8.5pt));

    for (int k = 0; k < 4; ++k) {
        real y = 2.80 - 0.24 * k;
        block((x - 1.05, y - 0.08), 1.30 + 0.24 * (k % 2), 0.15, c_cpufill, c_cpu);
    }

    node((x, 1.55), 2.10, 0.42, "cache",  c_edge, c_cachefill);
    node((x, 0.95), 2.10, 0.42, "file", c_edge, gray(0.96));

    link((x, 4.05), (x, 3.60));
    link((x, 0.52), (x, 0.05));
    node((x, -0.25), 1.70, 0.42, "Queue", c_edge, c_iofill);
    link((x, -0.48), (x, -0.95));
}

node((sx, -1.25), 8.2, 0.55, "NVM", c_edge, gray(0.96));

draw(rect((-1.62, 0.32), (2 * sx + 1.62, 3.78)), c_dash);
