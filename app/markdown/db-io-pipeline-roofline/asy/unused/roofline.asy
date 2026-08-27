// The storage roofline. Rows returned per read plays the part of arithmetic
// intensity; the sloped roof is the drive's request rate, and how far up that
// roof an engine reaches is set by how many reads it keeps in flight.
//
// Numbers match the table in the text, from the Micron 7450 datasheet:
// L = 80us, Imax = 1e6/s, B = 6800MB/s, and an assumed s = 100B, so
// B/s = 6.8e7 rows/s and the knee sits at r = 68.
//
// Every line is labelled where it runs, so the figure needs no markers, no
// legend and no background grid.

include common;
unitsize(4.20cm, 2.00cm);

real L      = 80e-6;   // per-read latency
real iopmax = 1e6;     // drive request rate
real roof   = 6.8e7;   // bandwidth B/s, in rows per second

real Xlo = -0.12, Xhi = 3;        // decades of rows per read: 1 .. 1000
real Ylo = 4, Yhi = 8;            // decades of rows per second

real X(real x) { return log10(x); }
real Y(real y) { return log10(y) - Ylo; }

real knee = roof / iopmax;        // rows per read where the two bounds meet

pen p_tick  = fontsize(11pt);
pen p_axis  = fontsize(12.5pt);
pen p_curve = fontsize(12pt);

// Frame.
draw((Xlo, 0) -- (Xhi, 0), c_axis);
draw((Xlo, 0) -- (Xlo, Yhi - Ylo), c_axis);
for (int i = 0; i <= 3; ++i) {
    draw((i, 0) -- (i, -0.07), c_axis);
    label(i == 0 ? "$1$" : "$10^{" + string(i) + "}$", (i, -0.10), align = S, p_tick);
}
for (int j = 0; j <= 4; ++j) {
    draw((Xlo, j) -- (Xlo - 0.05, j), c_axis);
    label("$10^{" + string(j + 4) + "}$", (Xlo - 0.07, j), align = W, p_tick);
}
label("rows per request, $r$", ((Xlo + Xhi) / 2, -0.58), p_axis);
label(rotate(90) * "rows per second, $T$", (Xlo - 0.68, (Yhi - Ylo) / 2), p_axis);

// The roof: request rate while it binds, bandwidth once it does not.
draw((X(1), Y(iopmax)) -- (X(knee), Y(roof)) -- (X(1000), Y(roof)), c_crit);
label("$I_{\max}\, r$", (X(7), Y(iopmax * 7)), align = 2.0 * NW, p_curve + c_critsolid);
label("$B / s$", (X(400), Y(roof)), align = 2.0 * N, p_curve + c_critsolid);

// The knee, dropped to the axis so the crossover in r can be read off.
draw((X(knee), 0) -- (X(knee), Y(roof)), c_dash);
label("$r = B / (s\,I_{\max})$", (X(knee), 2.02), align = 1.6 * W, p_curve);

// What one read at a time reaches: the same slope, a factor of L*Imax lower.
draw((X(1), Y(1 / L)) -- (X(1000), Y(1000 / L)), c_edge + linewidth(0.9pt));
label("$C = 1$", (X(300), Y(300 / L)), align = 2.0 * SE, p_curve);

// The one move worth an arrow: raising C lifts an engine onto the roof.
real ax = 0.16;
draw((ax, Y(1 / L) + 0.16) -- (ax, Y(iopmax) - 0.16),
     c_critsolid + linewidth(0.55pt), Arrow(TeXHead, 3.5));
label("$\times L\,I_{\max}$", (ax, (Y(1 / L) + Y(iopmax)) / 2),
      align = 1.4 * E, p_curve + c_critsolid);
