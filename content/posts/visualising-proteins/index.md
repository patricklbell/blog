---
date: "2022-08-05"
title: "Modifying Spline Algorithms to Draw Proteins with WebAssembly"
author: "Patrick Bell"
slug: "visualising-proteins"
tags: [ "Graphics", "Mathematics"]
comments: true
caption: "An overview of the mathematics and programming involved in rendering Ribbon Diagrams"
img:
  name: "/posts/visualising-proteins/header.png"
  alt: "Haemoglobin Chains"
---

*This post is a modified version of a presentation I gave about my protein visualiser [available online](https://patricklbell.github.io/chemical_visualizer/) with WebAssembly*

Proteins are the building blocks of our cells and allow for the incredibly complicated behaviours of the body. Knowing how important proteins are then, models of protein's structures allow scientists to quickly compare and understand a protein's features. One protein model is the [ribbon diagram](https://en.wikipedia.org/wiki/Ribbon_diagram) which has been around since the 1980s. They were originally hand drawn but were quickly created by computers. A Ribbon Diagram shows the shape of a protein by drawing 'ribbons' between the alpha-carbons (which are central to the peptide bonds of a polypeptide chain) of each amino-acid. Looking at only the alpha-carbons simplifies the thousands of individual atoms down to relatively few points which can be connected into a shape.

{{<figure src="imgs/IgG.png" link="https://www.rcsb.org/structure/1igt" caption="*The IgG2 antibody of a mouse, left are the input atoms, right is the ribbon diagram*" >}}

## Reading Protein Files
Before we can create our diagrams we first need the atoms which make up our protein, thankfully there is a well established (and documented!) format (PDB) along with a database of proteins called the [Worldwide Protein Data Bank](https://www.wwpdb.org/). While the format is a bit old, it really isn't too bad, [my reader (See loadPdbFile)](https://github.com/patricklbell/chemical_visualizer/blob/500440aff3c2200fac61c7097174478f0ba4a6a2/src/loader.cpp) came out at ~300 lines of {{< latex >}}$C\texttt{++}${{< /latex >}}. Or you could use one of many [libraries](https://mmcif.wwpdb.org/docs/software-resources.html) suggested by the PDB people. Either way you now have your atoms and bonds loaded into a nice and pretty data structure. For my online viewer, reading is quick enough that I don't even bother caching anything, the PDB is processed every page load although this could certainly be improved. On to rendering!

## A Brief Word On Rendering
To draw our proteins, like pretty much all 3D graphics, we need to form meshes which the GPU can understand. These meshes consist of triangles, each consisting of three vertices in 3D space which together enclose the ribbon of a protein, for correct lighting we also need a normal for each vertex. I'm going to skip over the details of my renderer, ultimately you could draw the meshes with any 3D program you liked or even export 3D models.

{{<figure src="imgs/protein-wireframe.png" link="https://www.rcsb.org/structure/1bzv" caption="*The triangles which make up a Ribbon Diagram*" >}}

## Creating The Ribbons
Creating a ribbon consists of two steps, fitting a spline to the alpha-carbons and extruding a 'profile' along this spline. A spline takes a pair of points and creates a curve which consists of many points which smoothly move between the pair. To extrude our spline we have to know the normal and tangent at each of these points. A profile is the shape of the ribbon's cross section and can be circular or rectangular.

### The Spline Algorithm
Before creating the spline I first average adjacent alpha-carbon positions to create a smoother look, we then need to choose tangents (parallel to tube) for each point. You could use more chemically accurate tangents but I used a Cardinal interpolation to achieved a smoother look. The Cardinal method uses a dampened vector between adjacent position, so that the tangent is given by

```latex
\Large{\overrightarrow{T_k} = (1-c) (\overrightarrow{P_{k+1}} - \overrightarrow{P_{k-1}})}.
```
{{<figure src="imgs/protein-cardinal.png" link="https://www.rcsb.org/structure/1bzv" caption="*Averaged points and their tangents (c = 0.25)*">}}

Now we need to actually generate the spline, it's important that our spline not only smoothly interpolates position but also tangent, normals and binormals. That is, the spline's first and second derivatives must be continuous. Specifying the tangents at each point ensures that adjacent splines have matching first derivatives but not second derivates. If we want we could use a quadratic spline, but we sacrifice smoothness and I found that this produces a poor result. Rather, I discard the true normal and calculate the normal from the current tangent and previous point's normal. For smoothness set the endpoint second derivative to zero, as in the natural Hermite Cubic. This ensures continuity, since the continuity of the tangents are guaranteed and simplifies calculation. If the previous normal is invalid I set the binormal to the perpendicular component, relative to the tangent, of the average of the endpoints' binormals, but I'm sure there are better choices. 

The position {{< latex >}}$\overrightarrow{P}\;${{< /latex >}}, where {{< latex >}}$t \in [0, 1]${{< /latex >}}, is given by
```latex
\overrightarrow{P}(t) = (2t^3 - 3t^2 + 1)\overrightarrow{P_{k}} + (-2t^3 + 3t^2)\overrightarrow{P_{k+1}} + (t^3 - 2t^2 + t)\overrightarrow{T_{k}} + (t^3 - t^2)\overrightarrow{T_{k+1}}.
```
And the tangent {{< latex >}}$\overrightarrow{T}\;${{< /latex >}} is
```latex
\overrightarrow{T}(t) = (6t^2 - 6t)\overrightarrow{P_{k}} + (-6t^2 + 6t)\overrightarrow{P_{k+1}} + (3t^2 - 4t + 1)\overrightarrow{T_{k}} + (3t^2 - 2t)\overrightarrow{T_{k+1}}.
```
The tangent is then be normalized and used to calculate the binormal and normal 
```latex
\overrightarrow{B}(t) = T(t) \times N(t - \Delta),\qquad \overrightarrow{N}(t) = B(t) \times T(t).
```

Or in [code](https://github.com/patricklbell/chemical_visualizer/blob/500440aff3c2200fac61c7097174478f0ba4a6a2/src/utilities.cpp) if you prefer (simplified to remove profile blending and doubled normals) 

```cpp
auto bref = (b0 + b1) / 2.f;
for(int i = 0; i < num_points_per_spline; i++) {
    auto t1 = (float)i / (num_points_per_spline-1);
    auto t2 = t1*t1;
    auto t3 = t1*t2;

    auto p = (2*t3-3*t2+1)*pp0 
           + (t3-2*t2+t1)*m0
           + (-2*t3+3*t2)*pp1
           + (t3-t2)*m1;

    auto tn = (6*t2-6*t1)*pp0 
            + (3*t2-4*t1+1)*m0
            + (-6*t2+6*t1)*pp1
            + (3*t2-2*t1)*m1;

    tn = normalize(tn);
    vec3 bn;
    if(length(prev_normal) > EPSILON) {
        bn = normalize(cross(tn, prev_normal));
    } else {
        bn = normalize(perpendicularComponent(bref, tn));
    }
    auto n = cross(bn, tn);

    projectPointsOnPlane(num_splines, p, bn, n, pf, &points[num_splines*i]);
    projectPointsOnPlane(num_splines, vec3(0), bn, n, pfn, &normals[num_splines*i]);
    prev_normal = n;
}
```
