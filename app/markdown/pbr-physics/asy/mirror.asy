settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(14pt));

path cir = arc((0,0), (1,0), (-1,0));
draw(cir, grey);
fill(cir -- cycle, grey+opacity(0.1));

draw((-2,0) -- (2,0), grey);
fill((-2,0) -- (2,0) -- (2,-0.5) -- (-2,-0.5) -- cycle, grey+opacity(0.05));

draw((0,0) -- (0, 1.7*(1/sqrt(2))), grey+linewidth(1.5pt),  arrow=Arrow(10bp), L=Label("$n$", position=EndPoint, align=N));
draw((0,0) -- (cos(3*pi/4), sin(3*pi/4)), blue+linewidth(1.5pt),  arrow=Arrow(10bp));
dot((cos(3*pi/4), sin(3*pi/4)), blue);
draw((1.5*cos(pi/4), 1.5*sin(pi/4)) -- (0,0), orange+linewidth(1.5pt),  arrow=Arrow(10bp));
