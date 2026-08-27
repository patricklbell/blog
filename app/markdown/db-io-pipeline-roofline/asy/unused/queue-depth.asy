// The storage roofline, drawn against queue depth.
//
// (a) throughput is the lower of two bounds: the latency bound C/L0, which is a
// line of slope one on log-log axes, and the device bound Imax, which is flat.
// They cross at C* = L0*Imax. (b) latency is flat below the knee and rises
// linearly above it, because past C* the extra requests only queue.
//
// Each bound is drawn thin and dashed where it is not the binding one, and the
// achievable curve -- the lower of the two -- is drawn heavy over the top.
//
// Constants are the Micron 7450 PRO 7.68TB E1.S, from the technical product
// specification, rev. C:
//     READ latency (TYP)  80us   measured at queue depth 1
//     Random 4KB read     1.0M   IOPS, measured at queue depth 256
//     70/30 read/write    415K   IOPS
// The two dots in (a) are those first two rows plotted directly; the model is
// not fitted to them, it is drawn through them.

include common;
unitsize(1.62cm, 1.15cm);

real L0     = 80e-6;      // s, READ (TYP) at QD1
real imix   = 415e3;      // 70/30 random read/write
real iread  = 1.0e6;      // 100% 4KB random read
real Cmix   = L0 * imix;  // 33.2
real Cread  = L0 * iread; // 80

real Xlo = -0.34, Xhi = 3.0;          // decades of queue depth, 1 .. 1000
real X(real c) { return log10(c); }

pen p_tick  = fontsize(7.5pt);
pen p_lab   = fontsize(8pt);
pen p_ax    = fontsize(8.5pt);
pen p_bound = gray(0.55) + linewidth(0.5pt) + dashed;

// ---------------------------------------------------------------- panel (a)
// Throughput, 1e4 .. 10^6.5 requests per second.
real Ya(real t) { return log10(t) - 4; }
real Ha = 2.5;

draw((Xlo, 0) -- (Xhi, 0), c_axis);
draw((Xlo, 0) -- (Xlo, Ha), c_axis);
for (int i = 0; i <= 3; ++i) {
    draw((i, 0) -- (i, -0.06), c_axis);
    label(i == 0 ? "$1$" : "$10^{" + string(i) + "}$", (i, -0.10), align = S, p_tick);
}
for (int j = 4; j <= 6; ++j) {
    draw((Xlo, Ya(10^j)) -- (Xlo - 0.05, Ya(10^j)), c_axis);
    label("$10^{" + string(j) + "}$", (Xlo - 0.07, Ya(10^j)), align = W, p_tick);
}
label("queue depth $C$", ((Xlo + Xhi) / 2, -0.52), p_ax);
label(rotate(90) * "requests per second", (Xlo - 0.66, Ha / 2), p_ax);

// Both bounds, thin, across the whole range.
// Clipped where it leaves the top of the panel.
draw((X(1), Ya(1 / L0)) -- (X(10^6.5 * L0), Ha), p_bound);
draw((Xlo, Ya(iread)) -- (Xhi, Ya(iread)), p_bound);
draw((Xlo, Ya(imix)) -- (Xhi, Ya(imix)), p_bound);

// The achievable curve for the 70/30 mix: the lower of the two throughout.
draw((X(1), Ya(1 / L0)) -- (X(Cmix), Ya(imix)) -- (Xhi, Ya(imix)),
     c_iosolid + linewidth(1.2pt));

// The reads-only roof, which the datasheet's QD256 rating sits on.
draw((X(Cread), Ya(iread)) -- (Xhi, Ya(iread)), c_critsolid + linewidth(1.0pt));

// A real drive runs under both bounds and rounds the corner between them. The
// shape drawn is the single-server approximation C / (L0 + (C-1)/Imax), which
// is tight at C = 1 and asymptotic to Imax; it is a guide to the shape, not a
// measurement. The datasheet quotes 1M at QD256 rather than at the QD80 where
// the bound reaches it, which is how we know the corner is rounded.
guide sag;
for (real k = 0; k <= 120; ++k) {
    real c = 10^(Xlo + 0.34 + k / 120 * Xhi);
    sag = sag -- (X(c), Ya(c / (L0 + (c - 1) / imix)));
}
draw(sag, gray(0.45) + linewidth(0.7pt));
label("a real drive", (X(70), Ya(70 / (L0 + 69 / imix))), align = SE,
      fontsize(7.5pt) + gray(0.35));

label("$C/L_0$", (X(3.4), Ya(3.4 / L0)), align = NW, p_lab + c_iosolid);
label("$I_{\max}$, reads only", (X(120), Ya(iread)), align = N, p_lab + c_critsolid);
label("$I_{\max}$, 70/30", (X(330), Ya(imix)), align = S, p_lab + c_iosolid);

// The knee.
draw((X(Cmix), 0) -- (X(Cmix), Ya(imix)), c_dash);
label("$C^{*}\!=\!33$", (X(Cmix), 0.30), align = E, fontsize(7.5pt) + c_cpusolid);

// Datasheet anchors, plotted rather than fitted.
dot((X(1), Ya(1 / L0)), c_critsolid);
label("QD1, $80\,\mu$s", (X(1.2), Ya(1 / L0)), align = E, fontsize(7.5pt));
dot((X(256), Ya(iread)), c_critsolid);
label("QD256, 1M", (X(256), Ya(iread)), align = S, fontsize(7.5pt));

label("(a)", (Xlo + 0.10, Ha + 0.10), align = E, fontsize(9pt));

// ---------------------------------------------------------------- panel (b)
// Latency, 31.6us .. 10ms, offset to the right of (a).
real dx = 4.85;
real Yb(real us) { return log10(us) - 1.5; }
real Hb = 2.5;

draw((Xlo + dx, 0) -- (Xhi + dx, 0), c_axis);
draw((Xlo + dx, 0) -- (Xlo + dx, Hb), c_axis);
for (int i = 0; i <= 3; ++i) {
    draw((i + dx, 0) -- (i + dx, -0.06), c_axis);
    label(i == 0 ? "$1$" : "$10^{" + string(i) + "}$", (i + dx, -0.10), align = S, p_tick);
}
for (int j = 2; j <= 4; ++j) {
    draw((Xlo + dx, Yb(10^j)) -- (Xlo + dx - 0.05, Yb(10^j)), c_axis);
    label("$10^{" + string(j) + "}$", (Xlo + dx - 0.07, Yb(10^j)), align = W, p_tick);
}
label("queue depth $C$", ((Xlo + Xhi) / 2 + dx, -0.52), p_ax);
label(rotate(90) * "latency, $\mu$s", (Xlo + dx - 0.66, Hb / 2), p_ax);

// L(C) = max(L0, C/Imax): flat, then slope one.
draw((Xlo + dx, Yb(80)) -- (Xhi + dx, Yb(80)), p_bound);
draw((X(1) + dx, Yb(80)) -- (X(Cmix) + dx, Yb(80)), c_iosolid + linewidth(1.2pt));
draw((X(Cmix) + dx, Yb(80)) -- (Xhi + dx, Yb(10^Xhi / imix * 1e6)),
     c_iosolid + linewidth(1.2pt));
label("$L_0$", (X(2.6) + dx, Yb(80)), align = N, p_lab + c_iosolid);
label("$C/I_{\max}$", (X(760) + dx, Yb(760 / imix * 1e6)), align = SE, p_lab + c_iosolid);

draw((X(Cmix) + dx, 0) -- (X(Cmix) + dx, Yb(80)), c_dash);
label("$C^{*}$", (X(Cmix) + dx, 0.30), align = E, fontsize(7.5pt) + c_cpusolid);

// Past the knee the drive is already saturated, so the extra wait buys nothing.
draw((X(Cmix) + dx + 0.06, Hb - 0.30) -- (X(600) + dx, Hb - 0.30), c_cpusolid,
     Arrow(TeXHead, 2.6));
label("no throughput left to win", ((X(Cmix) + X(600)) / 2 + dx, Hb - 0.30),
      align = N, fontsize(7.5pt) + c_cpusolid);

label("(b)", (Xlo + dx + 0.10, Hb + 0.10), align = E, fontsize(9pt));
