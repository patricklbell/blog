// Why the tie-break exists. A quad split along a diagonal that passes exactly
// through sample points: the rule must hand each of those samples to exactly
// one of the two triangles.

include common;
unitsize(0.53cm);

int w = 9, h = 9;
real gap = 11.0;

// The quad, on half-integer coordinates so the diagonal hits sample points.
pair q0 = (1.5, 1.5), q1 = (7.5, 1.5), q2 = (7.5, 7.5), q3 = (1.5, 7.5);

// Triangle A takes the upper right, B the lower left; they share q0 -- q2.
pair a0 = q0, a1 = q1, a2 = q2;
pair b0 = q0, b1 = q2, b2 = q3;

// The sample points lying exactly on the shared diagonal.
pair[] diag;
for (int i = 2; i <= 6; ++i) diag.push((i + 0.5, i + 0.5));

void panel(real dx, string title, string note, int mode) {
    picture pic;

    for (int i = 0; i < w; ++i)
        for (int j = 0; j < h; ++j) {
            pair s = (i + 0.5, j + 0.5);
            bool inA, inB;

            if (mode == 0) {
                // Inclusive on every edge: both triangles claim the diagonal.
                inA = (area2(a0, a1, s) >= 0 && area2(a1, a2, s) >= 0 && area2(a2, a0, s) >= 0);
                inB = (area2(b0, b1, s) >= 0 && area2(b1, b2, s) >= 0 && area2(b2, b0, s) >= 0);
            } else if (mode == 1) {
                // Exclusive on every edge: neither claims it.
                inA = (area2(a0, a1, s) > 0 && area2(a1, a2, s) > 0 && area2(a2, a0, s) > 0);
                inB = (area2(b0, b1, s) > 0 && area2(b1, b2, s) > 0 && area2(b2, b0, s) > 0);
            } else {
                inA = covered(s, a0, a1, a2);
                inB = covered(s, b0, b1, b2);
            }

            int n = (inA ? 1 : 0) + (inB ? 1 : 0);
            if (n == 2) fill(pic, shift(P(i, j)) * scale(1, -1) * unitsquare, red + opacity(0.35));
            else if (n == 1) fill(pic, shift(P(i, j)) * scale(1, -1) * unitsquare, orange + opacity(0.16));
        }

    for (int i = 0; i <= w; ++i) draw(pic, P(i, 0) -- P(i, h), c_grid);
    for (int j = 0; j <= h; ++j) draw(pic, P(0, j) -- P(w, j), c_grid);

    draw(pic, tri(a0, a1, a2), c_tri);
    draw(pic, tri(b0, b1, b2), c_tri2);

    for (int i = 0; i < w; ++i)
        for (int j = 0; j < h; ++j) {
            pair s = (i + 0.5, j + 0.5);
            bool inA, inB;
            if (mode == 0) {
                inA = (area2(a0, a1, s) >= 0 && area2(a1, a2, s) >= 0 && area2(a2, a0, s) >= 0);
                inB = (area2(b0, b1, s) >= 0 && area2(b1, b2, s) >= 0 && area2(b2, b0, s) >= 0);
            } else if (mode == 1) {
                inA = (area2(a0, a1, s) > 0 && area2(a1, a2, s) > 0 && area2(a2, a0, s) > 0);
                inB = (area2(b0, b1, s) > 0 && area2(b1, b2, s) > 0 && area2(b2, b0, s) > 0);
            } else {
                inA = covered(s, a0, a1, a2);
                inB = covered(s, b0, b1, b2);
            }
            int n = (inA ? 1 : 0) + (inB ? 1 : 0);
            if (n > 0) fill(pic, circle(P(s), 0.10), n == 2 ? red : c_on);
            else fill(pic, circle(P(s), 0.05), c_off);
        }

    for (pair s : diag) draw(pic, circle(P(s), 0.22), black + linewidth(0.6pt));

    label(pic, title, P(w / 2, h + 0.9), fontsize(9pt));

    add(shift(dx, 0) * pic);
}

panel(0.0, "(a)", "", 0);
panel(gap, "(b)", "", 1);
panel(2 * gap, "(c)", "", 2);
