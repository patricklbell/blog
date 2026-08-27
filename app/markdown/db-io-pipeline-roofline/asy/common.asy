// Shared setup for the database I/O diagrams.
//
// Two visual conventions run through every figure: blue is time spent waiting
// on the storage device, orange is time spent on a core. Red marks a critical
// path, purple marks a held lock.

settings.outformat = "svg";
defaultpen(fontsize(9pt));

usepackage("amsmath");

pen c_edge      = gray(0.30) + linewidth(0.7pt);
pen c_faint     = gray(0.82) + linewidth(0.4pt);
pen c_axis      = gray(0.35) + linewidth(0.6pt);
pen c_dash      = gray(0.50) + linewidth(0.6pt) + dashed;

pen c_io        = rgb(0.13, 0.35, 0.72) + linewidth(0.6pt);
pen c_iofill    = rgb(0.13, 0.35, 0.72) + opacity(0.22);
pen c_iosolid   = rgb(0.13, 0.35, 0.72);

pen c_cpu       = rgb(0.86, 0.50, 0.06) + linewidth(0.6pt);
pen c_cpufill   = rgb(0.86, 0.50, 0.06) + opacity(0.38);
pen c_cpusolid  = rgb(0.86, 0.50, 0.06);

pen c_crit      = rgb(0.78, 0.14, 0.14) + linewidth(1.15pt);
pen c_critsolid = rgb(0.78, 0.14, 0.14);

pen c_cachefill = rgb(0.18, 0.52, 0.30) + opacity(0.18);
pen c_cachesolid= rgb(0.18, 0.52, 0.30);

pen c_lock      = rgb(0.42, 0.24, 0.62) + linewidth(0.6pt);
pen c_lockfill  = rgb(0.42, 0.24, 0.62) + opacity(0.22);

pen c_idle      = gray(0.90);

path rect(pair lo, pair hi) {
    return lo -- (hi.x, lo.y) -- hi -- (lo.x, hi.y) -- cycle;
}

// A labelled box centred on c.
void node(pair c, real w, real h, string s, pen edge = c_edge, pen fillp = white) {
    filldraw(rect(c - (w / 2, h / 2), c + (w / 2, h / 2)), fillp, edge);
    label(s, c);
}

// A node for a stage that is one page or several, drawn as a stack. The copies
// trail down-right so that a link entering the top of the front box clears them;
// a link leaving the bottom must start 2*off lower.
void stacknode(pair c, real w, real h, string s, pen edge = c_edge, pen fillp = white, real off = 0.13) {
    for (int i = 2; i >= 0; --i) {
        pair d = (off * i, -off * i);
        path r = rect(c - (w / 2, h / 2) + d, c + (w / 2, h / 2) + d);
        // Opaque underlay: the fills are translucent, so without it the overlaps
        // darken and the stack reads as nesting rather than as copies.
        fill(r, white);
        filldraw(r, fillp, edge);
    }
    label(s, c);
}

// A timeline block whose lower-left corner is lo.
void block(pair lo, real w, real h, pen fillp, pen edge = c_edge) {
    filldraw(rect(lo, lo + (w, h)), fillp, edge);
}

void link(pair a, pair b, pen p = c_edge, real size = 2.6) {
    draw(a -- b, p, Arrow(TeXHead, size));
}

// A horizontal span marker with tick ends, used instead of braces so the
// figures stay legible when the SVG is scaled down.
void span(pair a, pair b, string s, pen p = c_edge, align al = S, real tick = 0.12) {
    draw(a -- b, p);
    draw(a - (0, tick) -- a + (0, tick), p);
    draw(b - (0, tick) -- b + (0, tick), p);
    label(s, (a + b) / 2, align = al, fontsize(8pt));
}

// Vertical counterpart of span().
void vspan(pair a, pair b, string s, pen p = c_edge, align al = W, real tick = 0.12) {
    draw(a -- b, p);
    draw(a - (tick, 0) -- a + (tick, 0), p);
    draw(b - (tick, 0) -- b + (tick, 0), p);
    label(s, (a + b) / 2, align = al, fontsize(8pt));
}

// Legend swatch.
void swatch(pair c, string s, pen fillp, pen edge = c_edge, real w = 0.34, real h = 0.20) {
    filldraw(rect(c, c + (w, h)), fillp, edge);
    label(s, c + (w + 0.10, h / 2), align = E, fontsize(8pt));
}
