settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(14pt));
defaultpen(linewidth(1.5pt));
srand(5);

import stats;

pair normalize(pair x) {
    return x / length(x);
}

real xmax = 3;
real alpha = 1.5;
int num_micronormals = 50;
int num_rays = 20;

draw((-xmax,0) -- (xmax,0), grey+dashed);
draw((0,0) -- (0, 1.7*(1/sqrt(2))), grey,  arrow=Arrow(10bp), L=Label("$n$", position=EndPoint, align=N));

path microsurface = (-xmax,0);
for(int i = 0; i <= num_micronormals; ++i) {
    real x = ((i+1) / (num_micronormals+2))*2*xmax - xmax;
    real y = (alpha <= 0) ? 0 : (Gaussrand()*0.1*alpha);

    microsurface = microsurface -- (x,y);
}

microsurface = microsurface -- (xmax,0);
draw(microsurface, black+linewidth(1pt));
fill(microsurface -- (xmax,-1) -- (-xmax,-1) -- cycle, grey+opacity(0.05));

pen bpen = red+linewidth(3pt);
for(int i = 0; i <= num_rays; ++i) {
    real x = ((i+0.5) / (num_rays+1))*2*xmax - xmax;

    real pt = intersections((x+1, 1) -- (x-1,-1), microsurface)[0][1];
    pair intersection = point(microsurface, pt);

    path ray = (x+1, 1) -- intersection;
    real[] ray_times = times(ray, xmax);
    if (ray_times.length > 0) {
        draw(point(ray, ray_times[0]) -- intersection, orange, arrow=Arrow(10bp));
    } else {
        draw(ray, orange, arrow=Arrow(10bp));
    }

    pair incident = (-1, -1);
    pair tangent = dir(microsurface, pt);
    pair micronormal = normalize((-tangent.y, tangent.x));
    pair reflected = incident - 2.0*dot(incident, micronormal)*micronormal;

    real[][] r_pts = intersections(intersection -- intersection + 2.0*reflected, microsurface);
    
    if (r_pts.length > 1) {
        pair blocked = point(microsurface, r_pts[1][1]);
        draw(intersection -- blocked, grey);
        dot(blocked, bpen);
    } else {
        draw(intersection -- intersection + 0.3*reflected, blue,  arrow=Arrow(10bp));
    }
}