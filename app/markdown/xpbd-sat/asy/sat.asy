settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(10pt));

path obj1 = (shift(-1,0))*((0.4,0) .. (1,0.5) .. (0.5,0.7) .. (0,0.7) .. (0,0.4) .. cycle);
draw(obj1, red);
fill(obj1 -- cycle, red+opacity(0.1));

path obj2 = (shift(+0.5,0))*((0,0) .. (0.5,0.1) .. (0.4,0.4) .. (0.0,0.7) .. (-0.2,0.4) .. cycle);
draw(obj2, blue);
fill(obj2 -- cycle, blue+opacity(0.1));

pair a = (0.1,-0.1);
pair b = (0.2,0.8);
pair d = (b-a);
draw(a -- b, black+linewidth(1.2pt));
draw((a + b)/2 -- ((a + b)/2 - 0.4*(-d.y, d.x)), black+linewidth(1.2pt), arrow=Arrow(TeXHead));
draw((a + b)/2 -- ((a + b)/2 + 0.4*(-d.y, d.x)), black+linewidth(1.2pt), arrow=Arrow(TeXHead));