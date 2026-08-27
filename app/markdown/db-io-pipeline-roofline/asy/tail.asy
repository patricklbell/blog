// Two engines serving the same workload. The one with the better mean has the
// worse tail, because its background work is bursty rather than incremental.

include common;
unitsize(1.55cm, 1.95cm);

real T = 10.5;

draw((0, 0) -- (T, 0), c_axis);
draw((0, 0) -- (0, 3.2), c_axis);
label("time", (T / 2, -0.34), fontsize(8.5pt));
label(rotate(90) * "request latency", (-0.55, 1.6), fontsize(8.5pt));

// (a) bursty: low baseline, periodic stalls while deferred work is paid off.
real[] burst = {1.9, 4.4, 7.2, 9.6};
guide a;
for (real t = 0; t <= T; t += 0.05) {
    real v = 0.30 + 0.04 * sin(11 * t);
    for (int i = 0; i < burst.length; ++i) {
        real d = t - burst[i];
        if (d > -0.10 && d < 0.75) v = max(v, 0.30 + 2.35 * exp(-max(d, 0) * 4.5) * (d < 0 ? (d + 0.10) / 0.10 : 1));
    }
    a = a -- (t, v);
}
draw(a, c_cpusolid + linewidth(0.9pt));

// (b) steady: slightly higher baseline, no stalls.
guide b;
for (real t = 0; t <= T; t += 0.05) {
    b = b -- (t, 0.52 + 0.05 * sin(7 * t) + 0.03 * sin(17 * t + 1));
}
draw(b, c_iosolid + linewidth(0.9pt));

// Percentiles.
draw((0, 2.45) -- (T, 2.45), c_cpusolid + dashed + linewidth(0.6pt));
label("$p_{99}$", (T, 2.45), align = NW, fontsize(8pt) + c_cpusolid);
draw((0, 0.64) -- (T, 0.64), c_iosolid + dashed + linewidth(0.6pt));
label("$p_{99}$", (T, 0.64), align = NW, fontsize(8pt) + c_iosolid);

label("bursty", (5.2, 2.90), fontsize(8.5pt) + c_cpusolid);
label("steady", (6.15, 1.05), fontsize(8.5pt) + c_iosolid);
