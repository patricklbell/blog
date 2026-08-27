// Latency against queue depth, the same two bounds read from the client's side.
//
// Latency is at least the unloaded latency L0 and at least C/Imax, so it is flat
// below the saturation point and climbs linearly above it. Past C* the drive is
// already saturated, so the extra wait buys no throughput.
//
// Constants are the Micron 7450 PRO 7.68TB E1.S, as in the companion figure.

include common;
unitsize(1.95cm, 1.30cm);

real L0   = 80e-6;      // s, READ (TYP) at QD1
real imix = 415e3;      // 70/30 random read/write
real Cmix = L0 * imix;  // 33.2

real Xlo = -0.34, Xhi = 3.0;          // decades of queue depth, 1 .. 1000
real X(real c) { return log10(c); }
real Y(real us) { return log10(us) - 1.5; }   // 31.6us .. 10ms
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
for (int j = 2; j <= 4; ++j) {
    draw((Xlo, Y(10^j)) -- (Xlo - 0.05, Y(10^j)), c_axis);
    label("$10^{" + string(j) + "}$", (Xlo - 0.07, Y(10^j)), align = W, p_tick);
}
label("queue depth $C$", ((Xlo + Xhi) / 2, -0.52), p_ax);
label(rotate(90) * "latency, $\mu$s", (Xlo - 0.70, H / 2), p_ax);

// The two bounds, thin where they are not binding.
draw((Xlo, Y(80)) -- (Xhi, Y(80)), p_bound);
// Clipped where it leaves the bottom of the panel.
draw((X(Cmix), Y(80)) -- (X(imix * 31.6e-6), 0), p_bound);

// max(L0, C/Imax): flat, then slope one.
draw((X(1), Y(80)) -- (X(Cmix), Y(80)), c_iosolid + linewidth(1.2pt));
draw((X(Cmix), Y(80)) -- (Xhi, Y(10^Xhi / imix * 1e6)), c_iosolid + linewidth(1.2pt));
label("$L_0$", (X(2.6), Y(80)), align = S, p_lab + c_iosolid);
label("$C/I_{\max}$", (X(760), Y(760 / imix * 1e6)), align = SE, p_lab + c_iosolid);

// What a real drive does: L0 + (C-1)/Imax, tight at C = 1 and asymptotic to the
// rising bound. A guide to the shape, not a measurement.
guide sag;
for (real k = 0; k <= 120; ++k) {
    real c = 10^(k / 120 * Xhi);
    sag = sag -- (X(c), Y((L0 + (c - 1) / imix) * 1e6));
}
draw(sag, gray(0.45) + linewidth(0.7pt));
label("a real drive", (X(11), Y((L0 + 10 / imix) * 1e6)), align = NW,
      fontsize(8pt) + gray(0.35));

draw((X(Cmix), 0) -- (X(Cmix), Y(80)), c_dash);
label("$C^{*}\!=\!33$", (X(Cmix), 0.30), align = E, fontsize(8pt) + c_cpusolid);

// Past the saturation point the extra wait buys nothing.
draw((X(Cmix) + 0.06, H - 0.30) -- (X(600), H - 0.30), c_cpusolid, Arrow(TeXHead, 2.6));
label("no throughput left to win", ((X(Cmix) + X(600)) / 2, H - 0.30),
      align = N, fontsize(8pt) + c_cpusolid);
