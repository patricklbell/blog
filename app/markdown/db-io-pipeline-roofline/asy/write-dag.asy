// One write as a dependency graph, read top to bottom. The descent is the same
// chain as a read's; the two index descents are independent of each other but
// have different heights, so the critical path runs through the deeper one.
//
// The write-ahead rule appears as the fl -> ck edge: no page may reach the data
// file until the log covering it is durable. ck is drawn dashed because it is
// off the response path, contributing to n but not to d.

include common;
unitsize(1.55cm);

real w = 4.0, h = 0.90, pitch = 1.28, gap = 0.6;
real ixo = (w + gap) / 2;
real so = 0.10;

pair nw = (0,    0 * -pitch);
pair t0 = (0,    1 * -pitch);
pair t1 = (0,    2 * -pitch);
pair t2 = (0,    3 * -pitch);
pair rw = (0,    4 * -pitch);
pair ia = (-ixo, 5 * -pitch);
pair ib = ( ixo, 5 * -pitch);
pair ic = ( ixo, 6 * -pitch);
pair wa = (0,    7 * -pitch);
pair fl = (0,    8 * -pitch);
pair rs = (-ixo, 9 * -pitch);
pair ck = ( ixo, 9 * -pitch);

// The network stages are I/O but not storage I/O, so they are drawn unfilled to
// keep them out of the blue that marks a device round trip.
node(nw, w, h, "$\texttt{nw}$",   c_edge, white);
node(rs, w, h, "$\texttt{rs}$",   c_edge, white);
node(t0, w, h, "$\texttt{pt}_0$", c_edge, c_cachefill);
node(t1, w, h, "$\texttt{pt}_1$", c_edge, c_iofill);
node(t2, w, h, "$\texttt{pt}_2$", c_edge, c_iofill);
stacknode(rw, w, h, "$\texttt{rw}$", c_edge, c_iofill, so);
node(ia, w, h, "$\texttt{ix}_0$", c_edge, c_iofill);
node(ib, w, h, "$\texttt{ix}_0$", c_edge, c_iofill);
node(ic, w, h, "$\texttt{ix}_1$", c_edge, c_iofill);
node(wa, w, h, "$\texttt{wa}$",   c_edge, c_iofill);
node(fl, w, h, "$\texttt{fl}$",   c_crit, c_critsolid + opacity(0.18));
node(ck, w, h, "$\texttt{ck}$",   c_io + dashed, c_iofill);

real e = h / 2;
link(nw - (0, e), t0 + (0, e), c_edge);
link(t0 - (0, e), t1 + (0, e), c_crit);
link(t1 - (0, e), t2 + (0, e), c_crit);
link(t2 - (0, e), rw + (0, e), c_crit);
link(wa - (0, e), fl + (0, e), c_crit);

// The index arms are unequal: the left index is one level deep and the right is
// two, so the left has a row of slack before the join at wa.
real fan = 0.5;
link((-fan, rw.y - e - 2 * so), (-fan, ia.y + e), c_edge);
link(( fan, rw.y - e - 2 * so), ( fan, ib.y + e), c_crit);
link(ib - (0, e), ic + (0, e), c_crit);
link((-fan, ia.y - e), (-fan, wa.y + e), c_edge);
link(( fan, ic.y - e), ( fan, wa.y + e), c_crit);

// The response and the write-back both hang off the flush and are independent.
link((-fan, fl.y - e), (-fan, rs.y + e), c_edge);
link(( fan, fl.y - e), ( fan, ck.y + e), c_io + dashed);

vspan((ixo + w / 2 + 0.35, t0.y + e), (ixo + w / 2 + 0.35, ic.y - e), "$d$", c_crit, E);
