// Downsampling across a silhouette. Taking the mean of the alpha channel keeps
// a block that is mostly background, and its position is a blend of surface and
// nothing. Taking the product keeps only blocks that are covered throughout.

include common;
unitsize(0.62cm);

int K = 4;          // block size
int W = 12, H = 8;  // pixels

// Coverage: everything to the left of a silhouette running down the image.
real edge(real y) { return 5.4 + 1.5 * Sin(180 * y / H); }
real alpha(int i, int j) {
    real x = i + 0.5;
    real e = edge(j + 0.5);
    if (x < e - 0.5) return 1.0;
    if (x > e + 0.5) return 0.0;
    return e + 0.5 - x;
}

void panel(picture pic, bool product, string t) {
    for (int i = 0; i < W; ++i)
        for (int j = 0; j < H; ++j) {
            real a = alpha(i, j);
            if (a > 0) fill(pic, rect((i, j), (i + 1, j + 1)), c_samp + opacity(0.55 * a));
        }
    for (int i = 0; i <= W; ++i) draw(pic, (i, 0) -- (i, H), c_grid);
    for (int j = 0; j <= H; ++j) draw(pic, (0, j) -- (W, j), c_grid);

    // Block boundaries.
    for (int i = 0; i <= W; i += K) draw(pic, (i, 0) -- (i, H), c_edge);
    for (int j = 0; j <= H; j += K) draw(pic, (0, j) -- (W, j), c_edge);

    for (int bi = 0; bi < W # K; ++bi)
        for (int bj = 0; bj < H # K; ++bj) {
            real acc = product ? 1.0 : 0.0;
            for (int i = 0; i < K; ++i)
                for (int j = 0; j < K; ++j) {
                    real a = alpha(bi * K + i, bj * K + j);
                    if (product) acc *= a; else acc += a / (K * K);
                }
            pair c = ((bi + 0.5) * K, (bj + 0.5) * K);
            bool keep = acc > 0.5;
            if (keep) dot(pic, c, c_rec + linewidth(5.0pt));
            else      draw(pic, (c - (0.3, 0.3)) -- (c + (0.3, 0.3)), c_badline);
            if (!keep) draw(pic, (c - (0.3, -0.3)) -- (c + (0.3, -0.3)), c_badline);
        }

    draw(pic, (edge(0), 0) .. (edge(H / 2), H / 2) .. (edge(H), H), c_surf);
    tag(pic, t, (W / 2, -1.0), fontsize(10pt));
}

picture a, b;
panel(a, false, "(a) mean");
panel(b, true,  "(b) product");

add(shift(0, 0) * a);
add(shift(14.5, 0) * b);
