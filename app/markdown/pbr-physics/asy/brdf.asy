settings.outformat="png";
settings.prc=false;
settings.render=16;
size(5cm,0);

import graph3;
import grid3;
import palette;

real xmin=-2, xmax=2;
real ymin=-2, ymax=1.5;
real zmin=-2.5, zmax=2.5;
limits((xmin,ymin,zmin),(xmax,ymax,zmax));


real linewidth=1.1;
real linewidthprojections=.15;

//////// SURFACE PART I ////////

surface smoothSurface(triple[][] points) {
  int nu = points.length - 1;
  if (nu <= 0) abort("Grid must have at least two rows to produce a surface.");
  int nv = points[0].length - 1;
  if (nv <= 0) abort("Grid must have at least two columns to produce a surface.");

  // Create a parametric function that is designed specifically for integer values.
  triple f(pair uv) { return points[floor(uv.x)][floor(uv.y)]; }

  // Now graph that parametric function:
  return surface(f, (0,0), (nu, nv), nu=nu, nv=nv, usplinetype=Spline, vsplinetype=Spline);
}

real bump(real x) {
    if (abs(x) >= 1) return 0;

    return exp(-1/(1-x*x))*exp(-4*x*x);
}

pen[][] pens = new pen[0][0];
triple[][] points = new triple[0][0];

for (int i=1; i<51; ++i) {
    triple[] currentrow = new triple[0];
    pen[] penrow = new pen[0];

    for (int j = 0; j < 21; ++j) {
        real t = (i/50)*(pi/2); real p = (j/20)*(2pi);

        real r = 1 + 3.0*bump(5*(t-pi/4))*bump(2*(p-pi/2));
        real x = r*sin(t)*cos(p);
        real y = r*sin(t)*sin(p);
        real z = r*cos(t);

        // Remember the color in which this patch should be drawn.
        pen p = (r > 1.2) ? blue : red;

        currentrow.push((x,y,z));
        penrow.push(p);
    }
    points.push(currentrow);
    pens.push(penrow);
}

surface s=surface(points);
s.colors(pens);
// s.colors(palette(s.map(zpart),Rainbow()));

draw(s);
draw(
    sequence(
        new path3(int i){
            return s.s[i].external();
        },
        s.s.length
    ), bp+orange);