// The Vulkan standard sample locations. Every one is a multiple of 1/16 of a
// texel, so all of them land exactly on the subpixel grid.

include common;
unitsize(2.17cm);

// Positions in sixteenths, exactly as the specification's table gives them.
int[][] s1  = {{8, 8}};
int[][] s2  = {{12, 12}, {4, 4}};
int[][] s4  = {{6, 2}, {14, 6}, {2, 10}, {10, 14}};
int[][] s8  = {{9, 5}, {7, 11}, {13, 9}, {5, 3}, {3, 13}, {1, 7}, {11, 15}, {15, 1}};
int[][] s16 = {{9, 9}, {7, 5}, {5, 10}, {12, 7}, {3, 6}, {10, 13}, {13, 11}, {11, 3},
               {6, 14}, {8, 1}, {4, 2}, {2, 12}, {0, 8}, {15, 4}, {14, 15}, {1, 0}};

void panel(real dx, int[][] pts, string title) {
    picture pic;

    // The sixteenth grid the positions are quantised to.
    for (int i = 0; i <= 16; ++i) {
        draw(pic, P(i / 16.0, 0) -- P(i / 16.0, 1), gray(0.90) + linewidth(0.25pt));
        draw(pic, P(0, i / 16.0) -- P(1, i / 16.0), gray(0.90) + linewidth(0.25pt));
    }
    draw(pic, P(0, 0) -- P(1, 0) -- P(1, 1) -- P(0, 1) -- cycle, c_gridbold);

    for (int[] p : pts)
        fill(pic, circle(P(p[0] / 16.0, p[1] / 16.0), 0.045), c_on);

    label(pic, title, P(0.5, 1.28), fontsize(8pt));
    add(shift(dx, 0) * pic);
}

panel(0.0, s1, "1 sample");
panel(1.55, s2, "2 samples");
panel(3.10, s4, "4 samples");
panel(4.65, s8, "8 samples");
panel(6.20, s16, "16 samples");
