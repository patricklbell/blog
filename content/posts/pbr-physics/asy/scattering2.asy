settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(10pt));

path cir = arc((0,0), (1,0), (-1,0));
draw(cir, red);
fill(cir -- cycle, red+opacity(0.1));

draw((-2,0) -- (2,0), red);
fill((-2,0) -- (2,0) -- (2,-0.5) -- (-2,-0.5) -- cycle, grey+opacity(0.05));

for(int i = 0; i <= 8; ++i) {
    real t = ((i+1) / (8+2))*pi;

    draw((0,0) -- (cos(t), sin(t)), red,  arrow=Arrow);
}
draw((1.5*cos(pi/4), 1.5*sin(pi/4)) -- (0,0), yellow+linewidth(1.5pt),  arrow=Arrow(10bp));
