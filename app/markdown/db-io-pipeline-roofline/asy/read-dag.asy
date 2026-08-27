// A point read as a dependency graph, read top to bottom. Every stage depends
// on the one above it, so the graph has no width for the engine to exploit.
//
// Labels are set in \texttt so they match the tags in the article's prose.
// Asymptote's double-quoted strings are verbatim, so backslashes pass through.

include common;
unitsize(1.55cm);

real w = 4.0, h = 0.90, pitch = 1.28, gap = 0.6;
real ixo = (w + gap) / 2;
real so = 0.10;

// Match the write graph's canvas so the two render at the same node size.
draw((-(ixo + w / 2), 0) -- (ixo + w / 2, 0), invisible);

pair nw = (0, 0 * -pitch);
pair t0 = (0, 1 * -pitch);
pair t1 = (0, 2 * -pitch);
pair t2 = (0, 3 * -pitch);
pair rw = (0, 4 * -pitch);
pair rs = (0, 5 * -pitch);

node(nw, w, h, "$\texttt{nw}$",   c_edge, white);
node(t0, w, h, "$\texttt{pt}_0$", c_edge, c_cachefill);
node(t1, w, h, "$\texttt{pt}_1$", c_edge, c_iofill);
node(t2, w, h, "$\texttt{pt}_2$", c_edge, c_iofill);
stacknode(rw, w, h, "$\texttt{rw}$", c_edge, c_iofill, so);
node(rs, w, h, "$\texttt{rs}$",   c_edge, white);

real e = h / 2;
link(nw - (0, e), t0 + (0, e), c_edge);
link(t0 - (0, e), t1 + (0, e), c_crit);
link(t1 - (0, e), t2 + (0, e), c_crit);
link(t2 - (0, e), rw + (0, e), c_crit);
link(rw - (0, e + 2 * so), rs + (0, e), c_edge);

vspan((-(w / 2 + 0.35), t0.y + e), (-(w / 2 + 0.35), rw.y - e), "$d$", c_crit, W);
