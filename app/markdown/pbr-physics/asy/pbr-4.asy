settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(14pt));


real t = pi/10;
real ti = pi/10;
real th = ti + t;
real tr = ti + 2*t;
real wr = pi/24;

pair i = (cos(ti), sin(ti));
pair h = (cos(th), sin(th));
pair r = (cos(tr), sin(tr));

real r_large = length(i+r);

real HdotR = dot(h, r);
real wh = wr * (HdotR / (r_large*r_large));

path cir_large = arc((0,0), (r_large,0), (0,r_large)) -- (0,0) -- cycle;
draw(cir_large, grey+dashed);

path cir = arc((0,0), (1,0), (0,1)) -- (0,0) -- cycle;
draw(cir, blue+opacity(0.1));
fill(cir, blue+opacity(0.05));

draw((-0.1,0) -- (r_large+0.1,0), grey, L=Label("$|i + r|$", position=MidPoint, align=S));
fill((-0.1,0) -- (r_large+0.1,0) -- (r_large+0.1,-0.2) -- (-0.1,-0.2) -- cycle, grey+opacity(0.05));

draw((0,0) -- (0, r_large+0.1), grey+linewidth(1.5pt),  arrow=Arrow(10bp), L=Label("$n$", position=EndPoint, align=N));


draw((0,0) -- i, red, arrow=Arrow, L=Label("$i$"));

draw((0,0) -- r, blue, arrow=Arrow, L=Label("$r$"));
draw(arc((0,0), (cos(tr - wr), sin(tr - wr)), (cos(tr + wr), sin(tr + wr))), blue+linewidth(1.5pt), L=Label("$d\omega_r$", align=NE));

draw((0,0) -- h, black, arrow=Arrow, L=Label("$h$"));
draw(arc((0,0), (cos(th - wh), sin(th - wh)), (cos(th + wh), sin(th + wh))), black+linewidth(1.5pt), L=Label("$d\omega_h$", align=NE));
draw((0,0) -- arc((0,0), r_large*(cos(th - wh), sin(th - wh)), r_large*(cos(th + wh), sin(th + wh))) -- cycle, black+dashed);

draw(r -- i+r, red, arrow=Arrow, L=Label("$i$", align=N));
draw(arc((0,0)+i, (cos(tr - wr), sin(tr - wr))+i, (cos(tr + wr), sin(tr + wr))+i), blue+linewidth(1.5pt));
draw(arc((0,0), r_large*(cos(th - wh), sin(th - wh)), r_large*(cos(th + wh), sin(th + wh))), black+linewidth(1.5pt));

draw(i+r -- i+r + 0.3*r, blue, arrow=Arrow);
draw(i+r -- i+r + 0.3*h, black, arrow=Arrow, L=Label("$dA_{proj}$", position=EndPoint, align=E));