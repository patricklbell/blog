settings.outformat = "png";
settings.prc = false;
settings.render=16;
unitsize(5cm);
defaultpen(fontsize(10pt));

draw((-1,0) -- (1.7,0), grey);
draw((-.7,1) -- (-.7,0));
draw((-.3,1) -- (-.3,0));
draw((-.7,.5) -- (-.3,.5), L=Label("$d\Phi$", align=(0,0), position=MidPoint, filltype=Fill(white)), arrow=Arrows());
draw((-.7,0) -- (-.3,0), grey);
draw((-.7,0) -- (-.3,0), black, L=Label("$dA$", align=(0,0), position=MidPoint, filltype=Fill(white)));

draw((+1.7,1) -- (+.7,0));
draw((+1.3,1) -- (+.3,0));
draw((+1.2,.5) -- (+.8,.5), L=Label("$d\Phi$", align=(0,0), position=MidPoint, filltype=Fill(white)), arrow=Arrows());
draw((+.7,0) -- (+.3,0), grey);
draw((+.7,0) -- (+.5,.2), orange, L=Label("$dA_{\perp}$", orange, align=(0,0), position=MidPoint, filltype=Fill(white)));
draw(arc((+.7,0), (+.65,.05), (+.6,0)), orange, L=Label("$\theta$", orange+fontsize(5pt), align=W+0.2N));
draw((+.7,0) -- (+.3,0), black, L=Label("$dA$", align=(0,0), position=MidPoint, filltype=Fill(white)));