---
date: "2022-12-27"
lastmod: "2023-04-26"
title: "Breaking Down A Graphics Engine"
author: "Patrick Bell"
slug: "visualising-graphics-engines"
comments: true
tags: [ "Graphics" ]
katex: true
caption: "A frame analysis of my own engine, showing the effects of each render 'pass'"
img:
  name: "/posts/visualising-graphics-engines/header.png"
  alt: "sponza"
---
\
{{<figure src="imgs/FINAL.png" caption="*The final composited frame, Crytek's Sponza, a common test scene*" >}}
Modern game engines such as Unity and Unreal have made 3D graphics more accessible than ever. Unfortunately, in the process they have made it hard to know how things actually show up on the screen. How do games look good? To help answer this, I thought I would show each of the processes my own engine takes to create a frame.

## Materials

{{<figure src="imgs/BASE.png" caption="*Rendering the mesh with point and directional lighting*" >}}
The first step is rendering all the meshes with their correct materials. This involves switching between shaders to draw meshes with PBR, Blinn-Phong or other lighting models so that they react correctly to the point and directional lights in the scene. I am skipping over a lot here because this is a topic which deserves a better explanation than I can give but [Google's Filament documentation](https://google.github.io/filament/Materials.html) is a great resources for understanding materials.

At this stage things looks either way too dark or way too bright, that's mainly because of tonemapping. Tonemapping is one of the last steps in my pipeline and it will transform from a high dynamic range (HDR) to something screens can display properly.

## Shadows
{{<figure src="imgs/SHADOWS.png" caption="*Base render with directional shadows*" >}}
To add shadows I sample a cascaded shadow map, this allows a shader to know if a point should be in shadow. Being in shadow in this case means that the directional light contribution is zero, because point lights don't cast shadows (shadows are very expensive so reducing the number of casters is important).

{{<figure src="imgs/CSM.png" width="80%" caption="*Nearest slice of the cascaded shadow map*" >}}

The cascaded shadow map is a depth only pass which happens before rendering, it stores the relative depth of geometry from a directional light's perspective. A point can be projected into the light's view and it's depth compared with the depth map to determine if the point is in shadow. If you're curious, the [shadow shader](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/null.glsl) is fairly simple (ignore the vegetation, skeletal animation and clipping) and the [sampler](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/lib/shadows.glsl) which reduces aliasing from sampling the shadow map.

## Volumetrics
{{<figure src="imgs/VOLUMETRICS.png" caption="*Volumetric fog*" >}}
Each point also samples an accumulated volumetric fog color which is added to the resulting color. This adds a sense of depth to the lighting by roughly approximating in-scattering due to particulates in the atmosphere (such as the small water droplets in fog). This has the byproduct of adding some extra ambient lighting.

{{<figure src="imgs/INTEGRATED_VOLUME.png" width="100%" caption="*A slice of the raymarched volumetric 3D texture*" >}}
This accumulated color is computed by marching rays through the camera's frustrum, accumulating color and density in a low resolution 3D texture. This technique was created for EA's frostbite engine which they [documented](https://www.ea.com/frostbite/news/physically-based-unified-volumetric-rendering-in-frostbite) or you can see my compute shaders, which I broke into two steps: [volume integration](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/volumetric_integration.glsl) and [raymarching](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/volumetric_raymarch.glsl)

## Post Processing
Most of these effects should be familiar to anyone who has played 3D games, so I am going to move quickly over them. All these post processing steps are fairly simple, if fiddly, and can be found in a [single shader](https://github.com/patricklbell/3d_engine/blob/569e867ce7fa31a6845a40d63169516a03f49e12/data/shaders/post.glsl) for my engine.

### Antialiasing
{{<figure src="imgs/AA.png" caption="*Fast Approximate Anti Aliasing (FXAA) and multisampling*" >}}
Antialiasing reduces the jagged edges created during the rasterization process. FXAA is a screen space effect which was developed by NVIDIA which essentially blurs jagged edges. It is becoming less important with the development of temporal antialiasing techniques and neural network based up-samplers.

### Bloom
{{<figure src="imgs/BLOOM.png" caption="*Additive blending with bloom texture*" >}}
Bloom simulates the blurring that occurs when looking at bright lights. This effect is achieved by creating a blurred version of the screen texture and blending additively ($ color_{bloom} = color_{screen} + color_{blurred} $). I use the classic progressive downsampling method after I foun it less expensive than a Gaussian blur with no noticeable quality loss.

### Ambient Occlusion
{{<figure src="imgs/SSAO.png" caption="*Screen space ambient occlusion, very subtle due to large error*" >}}

Screen space ambient occlusion (SSAO) calculates regions with high concavity and adds extra shadows, I have kept this extremely subtle because this is mostly a failed experiment (I replaced SSAO with a lightmapper which produces much more physically accurate results but was too slow to generate for Sponza on my laptop).

### Exposure and Dynamic Range
{{<figure src="imgs/EXPOSURE-TONEMAPPING-GAMMA.png" caption="*Eye exposure correction, Uncharted 2 Tonemapping, Gamma correction*" >}}
Eye exposure correction approximates the contraction and dilation of our pupils when it is very bright or dark, similar to how a film camera can automatically adjust it's exposure. Tonemapping compresses the floating point colors (HDR) we have been using into the 0-1 range of a monitor, Gamma correction then converts the linear brightness to a curve which fits the perceived brightness of the monitor's pixels.

### Effects
{{<figure src="imgs/FINAL.png" caption="*A simple vignette, darkens screen corners*" >}}
