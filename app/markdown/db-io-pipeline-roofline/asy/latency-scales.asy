// The latency ladder a storage engine sits on.

include common;
unitsize(2.10cm);

real X(real t) { return log10(t) + 9; }

draw((-0.45, 0) -- (7.45, 0), c_axis);

string[] ticks = {
    "$1\,$ns", "$10\,$ns", "$100\,$ns", "$1\,\mu$s",
    "$10\,\mu$s", "$100\,\mu$s", "$1\,$ms", "$10\,$ms"
};
for (int i = 0; i < 8; ++i) {
    draw((i, 0) -- (i, -0.13), c_axis);
    label(ticks[i], (i, -0.18), align = S, fontsize(8pt));
}

void mark(real t, string s, real h) {
    real x = X(t);
    draw((x, 0) -- (x, h), c_edge);
    fill(circle((x, 0), 0.05), c_critsolid);
    label(s, (x, h), align = N, fontsize(8.5pt));
}

mark(1e-9, "L1",          0.42);
mark(8e-8, "DRAM",        0.42);
mark(8e-5, "NVMe read",   0.42);
mark(4e-4, "NVMe flush",  1.02);
mark(8e-3, "disk seek",   0.42);

real a = X(8e-8), b = X(8e-5);
span((a, 1.62), (b, 1.62), "$\approx 1000\times$", c_crit, N);
draw((a, 0.52) -- (a, 1.58), c_dash);
draw((b, 0.52) -- (b, 1.58), c_dash);
