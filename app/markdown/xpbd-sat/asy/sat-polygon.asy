settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(10pt));

pair a = (1,0.15);
pair b = (1,0.5);
path obj1 = (shift(-1,0))*((0.4,0) -- a -- b -- (0.5,0.7) -- (0,0.7) -- (0,0.4) -- cycle);
draw(obj1, red);
fill(obj1 -- cycle, red+opacity(0.1));

path obj2 = (shift(+0.5,0))*((0,0) -- (0.5,0.1) -- (0.4,0.4) -- (0.0,0.7) -- (-0.2,0.4) -- cycle);
draw(obj2, blue);
fill(obj2 -- cycle, blue+opacity(0.1));

pair d = b - a;
pair a_start = shift(-0.85,0)*a-0.5*d;
draw(a_start -- a_start+2*d, black+linewidth(1.2pt));
draw((-1,-0.1) -- (1,-0.1), black+linewidth(1.2pt), L=Label("separating axis"), arrow=Arrow(TeXHead));