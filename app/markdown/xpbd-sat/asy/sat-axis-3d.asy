settings.outformat = "svg";
settings.prc = false;
settings.render=0;
import three;
size(10cm,0);

currentprojection = perspective(30*dir(75,0));

material flat_red = material(diffusepen=black+opacity(0.1), emissivepen=red+opacity(0.1), specularpen=black+opacity(0.1));
material flat_blue = material(diffusepen=black+opacity(0.1), emissivepen=blue+opacity(0.1), specularpen=black+opacity(0.1));

draw(shift(-2Y)*unitcube, surfacepen=flat_red, meshpen=red);
draw(shift(-2Y)*shift(1.7Y)*rotate(15,Y)*rotate(10,X)*(O -- (0,-0.5,0)), p=black, L=Label("$s$", position=EndPoint, align=N), arrow=ArcArrow3(DefaultHead2));
draw(shift(-2Y)*shift(2Y)*rotate(15,Y)*rotate(10,X)*unitcube, surfacepen=flat_blue, meshpen=blue);


draw(shift(2Y)*rotate(45,Z)*unitcube, surfacepen=flat_red, meshpen=red);
draw(shift(0.3Z)*shift(2Y)*shift(2.2Y)*(O -- (0,-0.5,0)), p=black, L=Label("$s$", position=EndPoint, align=N), arrow=ArcArrow3(DefaultHead2));
draw(rotate(90,Y)*shift(-2Z)*shift(2Y)*shift(2.4Y)*rotate(45,Z)*unitcube, surfacepen=flat_blue, meshpen=blue);