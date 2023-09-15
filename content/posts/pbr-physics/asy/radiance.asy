settings.outformat = "png";
settings.prc = false;
settings.render=10;
size(5cm,0);
defaultpen(fontsize(8pt));
import three;
import graph3;

path3 arc = Arc(c=O, normal=Z, v1=-Y, v2=Y, n=10);
path3 cir = circle(c=O, r=1, normal=Z);

surface pln = surface(plane(O=O+1.1X+1.1Y, -2.2X, -2.2Y));

draw(pln, white+opacity(0.1));
draw(unitsphere, surfacepen=material(diffusepen=black+opacity(0.1), emissivepen=orange+opacity(0.1), specularpen=black+opacity(0.1)), meshpen=invisible);
draw(O -- 0.7Z, arrow=ArcArrow3(DefaultHead2), p=gray(0.5), L=Label("$n$", position=EndPoint));
draw(O -- Z, p=invisible, L=Label("$\Omega$", orange, position=EndPoint));
draw(O -- 0.7Z+0.7X-0.7Y, arrow=ArcArrow3(DefaultHead2), p=blue, L=Label("$\omega_o$", position=EndPoint));
draw(O -- 1/sqrt(3)*Z-1/sqrt(3)*X+1/sqrt(3)*Y, p=orange+dashed, L=Label("$\omega_i$", position=EndPoint));

dot(O, p=orange, L=Label("$p$", orange, align=S));
draw(cir, orange+opacity(0.8));