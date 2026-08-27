// Throughput against queue depth, as a pair of bounds.
//
// Throughput cannot exceed the latency bound C/L0, which is a line of slope one
// on log-log axes, and cannot exceed the saturation bound Imax, which is flat.
// They cross at the saturation point C* = L0*Imax. Each bound is drawn thin and
// dashed where it is not the binding one, and the lower of the two is drawn
// heavy over the top.
//
// A real drive runs under both and rounds the corner between them. The shape
// drawn is the single-server approximation C / (L0 + (C-1)/Imax), which is tight
// at C = 1 and asymptotic to Imax. It is a guide to the shape, not a
// measurement. The datasheet quotes 1M at QD256 rather than at the QD80 where
// the bound reaches it, which is how we know the corner is rounded.
//
// Constants are the Micron 7450 PRO 7.68TB E1.S, from the technical product
// specification, rev. C:
//     READ latency (TYP)  80us   measured at queue depth 1
//     Random 4KB read     1.0M   IOPS, measured at queue depth 256
//     70/30 read/write    415K   IOPS
// The two dots are those first two rows plotted directly; nothing is fitted.

include common;
unitsize(1.95cm, 1.30cm);

real L0     = 80e-6;      // s, READ (TYP) at QD1
real imix   = 415e3;      // 70/30 random read/write
real iread  = 1.0e6;      // 100% 4KB random read
real Cmix   = L0 * imix;  // 33.2
real Cread  = L0 * iread; // 80, used only in the note above

real Xlo = -0.34, Xhi = 3.0;          // decades of queue depth, 1 .. 1000
real X(real c) { return log10(c); }
real Y(real t) { return log10(t) - 4; }
real H = 2.5;

pen p_tick  = fontsize(8pt);
pen p_lab   = fontsize(8.5pt);
pen p_ax    = fontsize(9pt);
pen p_bound = gray(0.55) + linewidth(0.5pt) + dashed;

draw((Xlo, 0) -- (Xhi, 0), c_axis);
draw((Xlo, 0) -- (Xlo, H), c_axis);
for (int i = 0; i <= 3; ++i) {
    draw((i, 0) -- (i, -0.06), c_axis);
    label(i == 0 ? "$1$" : "$10^{" + string(i) + "}$", (i, -0.10), align = S, p_tick);
}
for (int j = 4; j <= 6; ++j) {
    draw((Xlo, Y(10^j)) -- (Xlo - 0.05, Y(10^j)), c_axis);
    label("$10^{" + string(j) + "}$", (Xlo - 0.07, Y(10^j)), align = W, p_tick);
}
label("queue depth $C$", ((Xlo + Xhi) / 2, -0.52), p_ax);
label(rotate(90) * "requests per second $T(C)$", (Xlo - 0.70, H / 2), p_ax);

// Both bounds, thin, across the range. The latency bound is clipped where it
// leaves the top of the panel.
draw((X(1), Y(1 / L0)) -- (X(10^6.5 * L0), H), p_bound);
draw((Xlo, Y(imix)) -- (Xhi, Y(imix)), p_bound);

// The binding bound for the 70/30 mix.
draw((X(1), Y(1 / L0)) -- (X(Cmix), Y(imix)) -- (Xhi, Y(imix)),
     c_iosolid + linewidth(1.2pt));

// What a real drive does between the two.
guide sag;
for (real k = 0; k <= 120; ++k) {
    real c = 10^(k / 120 * Xhi);
    sag = sag -- (X(c), Y(c / (L0 + (c - 1) / imix)));
}
draw(sag, gray(0.45) + linewidth(0.7pt));
label("more realistic curve", (X(220), Y(220 / (L0 + 219 / imix))), align = SE,
      fontsize(8pt) + gray(0.35));

label("$C/L_0$", (X(3.4), Y(3.4 / L0)), align = NW, p_lab + c_iosolid);
label("$I_{\max}$", (X(400), Y(imix)), align = N, p_lab + c_iosolid);

// The saturation point.
draw((X(Cmix), 0) -- (X(Cmix), Y(imix)), c_dash);
label("$C^{*}\!=\!33$", (X(Cmix), 0.30), align = E, fontsize(8pt) + c_cpusolid);

// Datasheet anchors, plotted rather than fitted.
dot((X(1), Y(1 / L0)), c_critsolid);
label("QD1", (X(1.2), Y(1 / L0)), align = E, fontsize(8pt));
