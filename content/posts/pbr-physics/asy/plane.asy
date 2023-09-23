settings.outformat = "png";
settings.prc = false;
settings.render=10;
size(5cm,0);
fontsize(8);
import three;
import graph3;

surface pln = surface(plane(O=O+1.1X+1.1Y, -2.2X, -2.2Y));

draw(pln, white+opacity(0.1));
draw(O -- 0.7Z, arrow=Arrow3(DefaultHead2), p=gray(0.5), L=Label("$n$", position=EndPoint));
draw(O -- 0.7Z+0.7X-0.7Y, arrow=Arrow3(DefaultHead2), p=blue, L=Label("$\omega_o$", position=EndPoint));

dot(O, p=orange, L=Label("$p$", orange));