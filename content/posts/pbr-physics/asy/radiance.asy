settings.outformat = "png";
settings.prc = false;
settings.render=16;
size(5cm,0);
defaultpen(fontsize(8pt));

import three;
import graph3;

surface pln = surface(plane(O=O-0.15X-0.15Y, 0.3X, 0.3Y));

draw(pln, surfacepen=material(diffusepen=black, emissivepen=grey, specularpen=black), meshpen=invisible);
draw(unitsphere, surfacepen=material(diffusepen=grey+opacity(0.05), emissivepen=orange+opacity(0.05), specularpen=black+opacity(0.05)), meshpen=invisible);

draw(O -- O+0.2Z, arrow=ArcArrow3(DefaultHead2), p=black, L=Label("$dA$", position=EndPoint, align=N));

real h = 0.005; // height of spherical cap
triple n = -sqrt(1/5)*X + sqrt(2/5)*Y + sqrt(2/5)*Z;
path3 cap = circle(c=O+(1-h)*n, r=sin(acos(1 - h)), normal=n);

draw(extrude(cap, O -- cycle), material(diffusepen=black+opacity(0.1), emissivepen=orange+opacity(0.1), specularpen=black+opacity(0.1)));
draw(cap, orange, L=Label("$d\omega$", orange, align=NE));

path3 cap2 = circle(c=O+1.5n, r=1.5*sin(acos(1 - h)), normal=n);
draw(cap2, blue, L=Label("$d\Phi$", blue, align=NE));
draw(O+1.5n -- O+1.25n, arrow=ArcArrow3(DefaultHead2), p=material(diffusepen=black, emissivepen=blue, specularpen=black));

path3 area_perp = circle(c=O, r=0.1, normal=n);
draw(area_perp, orange);

draw(O -- O+0.2n, arrow=ArcArrow3(DefaultHead2), p=material(diffusepen=black, emissivepen=orange, specularpen=black));