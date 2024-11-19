settings.outformat = "png";
settings.prc = false;
settings.render=10;
size(5cm,0);
defaultpen(fontsize(8pt));
import three;
import graph3;

surface pln = surface(plane(O=O+Y-0.1X-0.1Z, 0.2X, 0.2Z));

material flat = material(diffusepen=black, emissivepen=orange, specularpen=black);

draw(pln, surfacepen=flat, meshpen=invisible);
draw(unitsphere, surfacepen=material(diffusepen=grey+opacity(0.05), emissivepen=orange+opacity(0.05), specularpen=black+opacity(0.05)), meshpen=invisible);

dot(O, p=orange);
dot(O+0.4Z, p=invisible, L=Label("$\Phi$", orange, align=N));
draw(O+0.05Y+0.05Z -- O+0.2Y+0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O+0.05X+0.05Z -- O+0.2X+0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O+0.05Y-0.05Z -- O+0.2Y-0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O+0.05X-0.05Z -- O+0.2X-0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O-0.05Y+0.05Z -- O-0.2Y+0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O-0.05X+0.05Z -- O-0.2X+0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O-0.05Y-0.05Z -- O-0.2Y-0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);
draw(O-0.05X-0.05Z -- O-0.2X-0.2Z, arrow=ArcArrow3(DefaultHead2), p=flat);

dot(O+Y+0.15Z, p=invisible, L=Label("$d\Phi$", orange, align=N));
draw(O+Y -- O+1.3Y, arrow=ArcArrow3(DefaultHead2), p=black, L=Label("$dA$", position=EndPoint));

