// The device is itself a parallel machine. Rows are independent NAND dies, the
// strip on the left is the number of commands outstanding, and a command
// occupies one die for its whole service time.

include common;
unitsize(1.20cm);

int  NC = 12, ND = 4;
real cw = 1, ch = 0.52, svc = 3;

void panel(real y0, string letter, int depth) {
    label("\textbf{(" + letter + ")}", (-1.85, y0 + ND * ch - 0.30), fontsize(8.5pt));

    // Outstanding commands.
    for (int q = 0; q < ND; ++q) {
        pair lo = (-0.95, y0 + q * ch + 0.09);
        filldraw(rect(lo, lo + (0.55, ch - 0.18)), q < depth ? c_cpufill : white, c_edge);
    }

    // Dies.
    for (int d = 0; d < ND; ++d) {
        real y = y0 + d * ch;
        draw(rect((0, y), (NC * cw, y + ch)), c_faint);
    }

    // Issue `depth` commands at a time, round-robin over the dies.
    int t = 0, d = 0;
    while (t < NC) {
        for (int k = 0; k < depth; ++k) {
            real y = y0 + ((d + k) % ND) * ch;
            filldraw(rect((t * cw, y), (min(t + svc, NC) * cw, y + ch)), c_iofill, c_io);
        }
        d = (d + depth) % ND;
        t += (int) svc;
    }
}

panel(0.0, "b", 4);
panel(3.1, "a", 1);

draw((0, -0.55) -- (NC * cw, -0.55), c_axis, Arrow(TeXHead, 4));
label("time", (NC * cw / 2, -0.62), align = S, fontsize(8pt));
