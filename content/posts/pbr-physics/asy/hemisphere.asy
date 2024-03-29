settings.outformat = "png";
settings.prc = false;
settings.render=10;
size(5cm,0);
defaultpen(fontsize(8pt));
import three;
import graph3;

path3 arc = Arc(c=O, normal=Z, v1=-Y, v2=Y, n=10);
path3 cir = circle(c=O, r=1, normal=Z);

surface hemisphere = surface(arc, angle1=0, angle2=180, c=O, axis=-Y, n=10);
surface pln = surface(plane(O=O+1.1X+1.1Y, -2.2X, -2.2Y));

draw(pln, white+opacity(0.1));
draw(hemisphere, surfacepen=material(diffusepen=black+opacity(0.1), emissivepen=orange+opacity(0.1), specularpen=black+opacity(0.1)), meshpen=invisible);
draw(O -- 0.7Z, arrow=ArcArrow3(DefaultHead2), p=material(diffusepen=black, emissivepen=gray(0.5), specularpen=black), L=Label("$n$", gray(0.5), position=EndPoint));
draw(O -- Z, p=invisible, L=Label("$\Omega$", orange, position=EndPoint));
draw(O -- 0.7Z+0.7X-0.7Y, arrow=ArcArrow3(DefaultHead2), p=material(diffusepen=black, emissivepen=blue, specularpen=black), L=Label("$\omega_r$", blue, position=EndPoint));
draw(O -- 1/sqrt(3)*Z-1/sqrt(3)*X+1/sqrt(3)*Y, p=orange+dashed, L=Label("$\omega_i$", position=EndPoint));
draw(O -- sqrt(3/7)*Z-sqrt(2/7)*X+sqrt(2/7)*Y, p=orange+dashed);
// draw(O -- sqrt(2/7)*Z-sqrt(3/7)*X+sqrt(2/7)*Y, p=orange+dashed);
draw(O -- sqrt(2/7)*Z-sqrt(2/7)*X+sqrt(3/7)*Y, p=orange+dashed);

dot(O, p=orange, L=Label("$p$", orange, align=1.1S));
draw(cir, orange+opacity(0.8));