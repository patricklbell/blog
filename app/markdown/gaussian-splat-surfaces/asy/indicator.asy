// What PSR solves for. The samples on the left carry inward normals; the
// indicator function in the middle is what those normals are the gradient of;
// the surface on the right is one of its level sets.

include common;
unitsize(1.0cm);

path blob = (0,1.55) .. (1.35,1.15) .. (1.75,-0.15) .. (0.75,-1.35)
         .. (-0.85,-1.25) .. (-1.7,-0.1) .. (-1.2,1.2) .. cycle;

// (a) oriented samples
picture a;
for (int i = 0; i < 14; ++i) {
    real t = i * length(blob) / 14;
    pair p = point(blob, t);
    sample(a, p, innormal(blob, t), 0.40);
}
draw(a, blob, c_faint);
tag(a, "(a)", (0, -2.15));

// (b) the indicator function, drawn as a filled interior with a few interior
// level curves to suggest that the solve produces a field, not a surface
picture b;
fill(b, blob, c_recfill);
for (real s : new real[] {0.76, 0.52}) {
    draw(b, scale(s) * blob, c_rec + linewidth(0.4pt) + opacity(0.5));
}
draw(b, blob, c_recline);
label(b, "$\chi_M = 1$", (0, -0.1), fontsize(8pt) + c_rec);
label(b, "$\chi_M = 0$", (0, 1.95), fontsize(8pt) + gray(0.35));
tag(b, "(b)", (0, -2.15));

// (c) the extracted level set
picture c;
draw(c, blob, c_surf);
label(c, "$\partial M$", (1.62, 1.12), align = NE, fontsize(8pt));
tag(c, "(c)", (0, -2.15));

add(shift(0, 0) * a);
add(shift(4.9, 0) * b);
add(shift(9.8, 0) * c);
