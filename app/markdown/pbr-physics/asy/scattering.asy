settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(10pt));
srand(5);

// path cir = arc((0,0), (1,0), (-1,0));
// draw(cir, blue);
// fill(cir -- cycle, blue+opacity(0.1));

draw((-2,0) -- (2,0), black);
fill((-2,0) -- (2,0) -- (2,-1) -- (-2,-1) -- cycle, grey+opacity(0.05));

for(int i = 0; i <= 8; ++i) {
    real x = ((i+1) / (8+2))*3.0 - 1.5;

    draw((x+1, 1) -- (x,0), orange+linewidth(1.5pt),  arrow=Arrow(10bp));

    real bounces = 3 + 4*unitrand();
    path refract = (x, 0);
    for (int j = 0; j < bounces; ++j) {
        pair p = (x - 0.3*(2*unitrand()-1), -0.5*unitrand());
        refract = refract -- p;
        dot(p, black);
    }
    pair end = (x - 0.2*(2*unitrand()-1), 0);
    refract = refract -- end;
    draw(refract, orange+dashed+1.2);

    real t = unitrand()*pi;
    draw(end -- (end + (0.2*cos(t), 0.2*sin(t))), blue, arrow=Arrow);
}

for (int i = 0; i <= 32; ++i) {
    for (int j = 0; j <= 8; ++j) {
        real x = ((i+1)/(32+2))*4 - 2;
        real y = ((j+1)/(8+2)) - 1;
        dot((x + (1/35)*(2*unitrand()-1), y + (1/12)*(2*unitrand()-1)), black);
    }
}