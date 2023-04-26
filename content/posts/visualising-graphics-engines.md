---
date: "2022-12-27"
title: "Breaking Down A Graphics Engine"
author: "Patrick Bell"
slug: "visualising-graphics-engines"
tags: [ "Graphics" ]
caption: "A frame analysis of my own engine, showing the effects of each render 'pass'"
img:
  name: "/FINAL.png"
  alt: "sponza"
---
\
{{<figure src="/FINAL.png" caption="*The final composited frame, Crytek's Sponza, a common test scene*" >}}
Game engines such as Unity and Unreal have made 3D graphics more accessible than ever. Unfortunately, in the process they have made it hard to visualize what is actually being drawn to the screen. In essence, how do games look good? To help answer this, I thought I would show each of the processes my own engine takes to create a frame.

{{<figure src="/BASE.png" caption="*Rendering the mesh with point and directional lighting*" >}}
The first step is rendering all the meshes with their correct materials. This involves switching between shaders to draw meshes with PBR, Blinn-Phong or other lighting models so that they react correctly to the point and directional lights in the scene.

# Shadows
{{<figure src="/SHADOWS.png" caption="*Base render with directional shadows*" >}}
To add shadows I sample a cascaded shadow map, this allows the material shader to determine if a point should be in shadow and hence set the directional light contribution to zero.
{{<figure src="/CSM.png" caption="*Nearest slice of the cascaded shadow map*" >}}
The cascaded shadow map is a depth only pass which happens before rendering, it stores the relative depth of geometry from the lights perspective. This can be compared with the scene depth and re-projected into world space to determine if a point is behind the light's view and hence in shadow. If you're curious the [shadow shader](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/null.glsl) is fairly simple (ignore the vegetation, skeletal animation and clipping) and the [sampling](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/lib/shadows.glsl) which is a bit harder to understand.

# Volumetrics
{{<figure src="/VOLUMETRICS.png" caption="*Volumetric fog*" >}}
Each point also samples an accumulated volumetric fog color which is added to the resulting color. This adds a sense of depth to the lighting by roughly approximating in scattering due to the particulates in the atmosphere (such as the small water droplets in fog). It also adds ambient some extra ambient lighting.
{{<figure src="/INTEGRATED_VOLUME.png" caption="*A slice of the raymarched volumetric 3D texture*" >}}
This accumulated color is computed by marching rays through the camera's frustrum, accumulating color and density in a low resolution 3D texture. This technique was created for EA's frostbite engine which they [documented](https://www.ea.com/frostbite/news/physically-based-unified-volumetric-rendering-in-frostbite) or you can see my own compute shaders: the [volume integration](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/volumetric_integration.glsl) and [raymarching](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/volumetric_raymarch.glsl)

# Post Processing
Most of these effects should be familiar, since they are usually configurable in video games. Antialiasing reduces the jagged edges created during the rasterisation process. Bloom adds a blur to bright regions caused by a saturation of the light sensing cells in our eyes. Eye exposure correction approximates the contraction and dilation of our pupils when its bright or dark, similar to how a film camera can automatically adjust it's exposure. Tonemapping and Gamma correction are processing unique to displaying an image on a computer. Tonemapping compresses the floating point colors we have been using into the 0-1 range of a monitor, Gamma correct then converts the linear brightness to a curve which fits the monitor's pixel true brightness. All these post processing steps are fairly simple, if fiddly, and can be found in a [single shader](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/post.glsl) for my engine.

{{<figure src="/AA.png" caption="*Fast Approximate Anti Aliasing (FXAA) and multisampling*" >}}
{{<figure src="/BLOOM.png" caption="*Additive blending with bloom texture*" >}}
{{<figure src="/SSAO.png" caption="*Screen space ambient occlusion, very subtle due to large error*" >}}

{{<figure src="/EXPOSURE-TONEMAPPING-GAMMA.png" caption="*Eye exposure correction, Uncharted 2 Tonemapping, Gamma correction*" >}}

{{<figure src="/FINAL.png" caption="*A simple vignette, darkens screen corners*" >}}
