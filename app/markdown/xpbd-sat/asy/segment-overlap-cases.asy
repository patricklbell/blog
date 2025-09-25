settings.outformat = "svg";
unitsize(5cm);
defaultpen(fontsize(10pt));

real gap = 0.1;

pair global_offset = (0,0);

real column_2_x_offset;

label(Label("$A < C$ and $B > C$:"), position=(-gap,global_offset.y), align=W);
{
    {
        real overlap = 0.3;
        real width1 = 0.5;
        pair extents1 = (width1/2, 0.15);
        real width2 = 0.55;
        pair extents2 = (width2/2, 0.16);
        global_offset = (global_offset.x, global_offset.y - extents1.y);

        pair center1 = global_offset + (extents1.x, (extents1.y+extents2.y)/2);
        path rect1 = box(center1-extents1, center1+extents1);

        real y_offset = 0.1;

        pair center2 = center1 + (extents1.x + extents2.x - overlap, -extents1.y + extents2.y + y_offset);
        path rect2 = box(center2-extents2, center2+extents2);

        real axis_y_offset = global_offset.y-gap;

        //label(Label("1"), black+fontsize(20pt), position=(center1+center2)/2);

        pair a = (center1.x-extents1.x,axis_y_offset);
        pair b = (center1.x+extents1.x,axis_y_offset);
        pair c = (center2.x-extents2.x,axis_y_offset);
        pair d = (center2.x+extents2.x,axis_y_offset);
        draw(a -- b, bar=Bars);
        draw(c -- d, bar=Bars);
        draw(d -- shift(0.1,0)*d, arrow=Arrow(TeXHead));
        label(Label("$A$"), position=shift(0,-1.1*gap)*a, align=N);
        label(Label("$B$"), position=shift(0,-1.1*gap)*b, align=N);
        label(Label("$C$"), position=shift(0,-1.1*gap)*c, align=N);
        label(Label("$D$"), position=shift(0,-1.1*gap)*d, align=N);

        axis_y_offset -= 2*gap;
        //label(Label("$B - C < D - A$"), position=((center1.x+center2.x)/2, axis_y_offset), align=S);

        draw(rect1, red);
        fill(rect1, red+opacity(0.1));
        draw(rect2, blue);
        fill(rect2, blue+opacity(0.1));

        column_2_x_offset = center2.x+extents2.x+2*gap;
        global_offset = (global_offset.x + column_2_x_offset, global_offset.y);
    }

    {
        real overlap = 0.55;
        real width1 = 0.65;
        pair extents1 = (width1/2, 0.15);
        real width2 = 0.3;
        pair extents2 = (width2/2, 0.16);

        pair center1 = global_offset + (extents1.x, (extents1.y+extents2.y)/2);
        path rect1 = box(center1-extents1, center1+extents1);

        real y_offset = 0.05;

        pair center2 = center1 + (extents1.x + extents2.x - overlap, -extents1.y + extents2.y + y_offset);
        path rect2 = box(center2-extents2, center2+extents2);

        real axis_y_offset = global_offset.y-gap;

        //label(Label("2"), black+fontsize(20pt), position=(center1+center2)/2);

        pair a = (center1.x-extents1.x,axis_y_offset);
        pair b = (center1.x+extents1.x,axis_y_offset);
        pair c = (center2.x-extents2.x,axis_y_offset);
        pair d = (center2.x+extents2.x,axis_y_offset);
        draw(a -- b, bar=Bars);
        draw(c -- d, bar=Bars);
        draw(b -- shift(0.1,0)*b, arrow=Arrow(TeXHead));
        label(Label("$A$"), position=shift(0,-1.1*gap)*a, align=N);
        label(Label("$B$"), position=shift(0,-1.1*gap)*b, align=N);
        label(Label("$C$"), position=shift(0,-1.1*gap)*c, align=N);
        label(Label("$D$"), position=shift(0,-1.1*gap)*d, align=N);

        axis_y_offset -= 2*gap;
        //label(Label("$B - C \geq D - A$"), position=((center1.x+center2.x)/2, axis_y_offset), align=S);

        draw(rect1, red);
        fill(rect1, red+opacity(0.1));
        draw(rect2, blue);
        fill(rect2, blue+opacity(0.1));

        global_offset = (0, global_offset.y + axis_y_offset - 0.3);
    }
}

label(Label("$C < A$ and $D > A$:"), position=(-gap,global_offset.y), align=W);
{
    {
        real overlap = 0.55;
        real width1 = 0.65;
        pair extents1 = (width1/2, 0.15);
        real width2 = 0.3;
        pair extents2 = (width2/2, 0.16);

        global_offset = (global_offset.x, global_offset.y - extents1.y);

        pair center1 = global_offset + (extents1.x, (extents1.y+extents2.y)/2);
        path rect1 = box(center1-extents1, center1+extents1);

        real y_offset = 0.05;

        pair center2 = center1 + (extents1.x + extents2.x - overlap, -extents1.y + extents2.y + y_offset);
        path rect2 = box(center2-extents2, center2+extents2);

        real axis_y_offset = global_offset.y-gap;

        //label(Label("3"), black+fontsize(20pt), position=(center1+center2)/2);

        pair a = (center1.x-extents1.x,axis_y_offset);
        pair b = (center1.x+extents1.x,axis_y_offset);
        pair c = (center2.x-extents2.x,axis_y_offset);
        pair d = (center2.x+extents2.x,axis_y_offset);
        draw(a -- b, bar=Bars);
        draw(c -- d, bar=Bars);
        draw(b -- shift(0.1,0)*b, arrow=Arrow(TeXHead));
        label(Label("$C$"), position=shift(0,-1.1*gap)*a, align=N);
        label(Label("$D$"), position=shift(0,-1.1*gap)*b, align=N);
        label(Label("$A$"), position=shift(0,-1.1*gap)*c, align=N);
        label(Label("$B$"), position=shift(0,-1.1*gap)*d, align=N);

        axis_y_offset -= 3*gap;
        label(Label("$B - C < D - A$"), position=((center1.x+center2.x)/2, axis_y_offset), align=S);

        draw(rect2, red);
        fill(rect2, red+opacity(0.1));
        draw(rect1, blue);
        fill(rect1, blue+opacity(0.1));

        global_offset = (global_offset.x + column_2_x_offset, global_offset.y);
    }

    {
        real overlap = 0.3;
        real width1 = 0.5;
        pair extents1 = (width1/2, 0.15);
        real width2 = 0.55;
        pair extents2 = (width2/2, 0.16);

        pair center1 = global_offset + (extents1.x, (extents1.y+extents2.y)/2);
        path rect1 = box(center1-extents1, center1+extents1);

        real y_offset = 0.1;

        pair center2 = center1 + (extents1.x + extents2.x - overlap, -extents1.y + extents2.y + y_offset);
        path rect2 = box(center2-extents2, center2+extents2);

        real axis_y_offset = global_offset.y-gap;

        //label(Label("4"), black+fontsize(20pt), position=(center1+center2)/2);

        pair a = (center1.x-extents1.x,axis_y_offset);
        pair b = (center1.x+extents1.x,axis_y_offset);
        pair c = (center2.x-extents2.x,axis_y_offset);
        pair d = (center2.x+extents2.x,axis_y_offset);
        draw(a -- b, bar=Bars);
        draw(c -- d, bar=Bars);
        draw(d -- shift(0.1,0)*d, arrow=Arrow(TeXHead));
        label(Label("$C$"), position=shift(0,-1.1*gap)*a, align=N);
        label(Label("$D$"), position=shift(0,-1.1*gap)*b, align=N);
        label(Label("$A$"), position=shift(0,-1.1*gap)*c, align=N);
        label(Label("$B$"), position=shift(0,-1.1*gap)*d, align=N);

        axis_y_offset -= 3*gap;
        label(Label("$D - A \leq B - C$"), position=((center1.x+center2.x)/2, axis_y_offset), align=S);

        draw(rect2, red);
        fill(rect2, red+opacity(0.1));
        draw(rect1, blue);
        fill(rect1, blue+opacity(0.1));


        global_offset = (0, global_offset.y + axis_y_offset - 0.4);
    }
}