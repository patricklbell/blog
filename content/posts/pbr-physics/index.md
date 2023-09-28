---
date: "2023-09-23"
title: "Physically Based Rendering"
author: "Patrick Bell"
slug: "pbr-physics"
comments: true
tags: [ "Graphics", "Mathematics", "Interactive" ]
interactives: true
caption: "Deriving PBR from physical principles."
img:
  name: "/posts/pbr-physics/header.jpg"
  alt: "Microsurface of Gypsum, coloured SEM, see post for credits"
---

Physically based rendering (PBR) is a general term for techniques in 3D graphics that approximate physical laws. The term PBR has come to mean techniques which aim for realistic rendering of real world materials. The PBR approach developed by Disney in 2012{{< cite "Burley2012" >}} still forms the basis of real-time rendering of realistic materials. This post explains the physical models and mathematics behind PBR. My renderer uses a similar PBR system which can be found in the [PBR shader](https://github.com/patricklbell/3d_engine/blob/main/data/shaders/lib/pbr.glsl).

{{< interactive src="interactives/pbr.js" imgsrc="interactives/pbr-alt.png" caption="*A dielectric material lit by a directional light following a PBR model.*" controls=true >}}

## Principles
To realistically render materials in a consistent manner some important laws should be obeyed.
 - *Conservation of energy*, the energy of light hitting a surface is less than or equal to the energy reflected.
 - *Law of reflection*, the incident angle equals the reflected angle for light reflecting off a mirror.
 - *Fresnel Equations,* the proportion of light reflected or transmitted when hitting a surface follows the Fresnel equations.

Accurately simulating all the behaviors of light is infeasible for real-time graphics, simplifying assumptions about light are made in PBR including:
- Light is always unpolarized.
- Light's wave properties can be ignored (eg. diffraction, interference) and treated as rays, this is called geometry optics.
- Light would act the same going from a light source to viewer as vice versa, called [**Helmholtz reciprocity**](https://en.wikipedia.org/wiki/Helmholtz_reciprocity).

These assumptions rarely cause problems which are visible but certain situations or materials can exaggerate errors. For example, when multiple reflections occur between surfaces, accounting for polarization can visibly change the result{{<cite "Wilkie2012">}}.

## The Model
For each pixel on the screen imagine a ray which travels from a virtual eye and through the pixel. The ray will eventually hit an object. If the object is opaque (ignoring atmospheric effects) the colour of that pixel is determined by the light the object scatters from that point towards the pixel. PBR is about calculating the "intensity" of this light.

{{<figure src="asy/intersection.svg" caption="*The model.*" width="80%">}}

### Radiance and Irradiance
Intensity is an ambiguous term, radiance and irradiance are two physical units of light which can be mapped to a pixel's brightness. Radiance and irradiance technically have the same physical units of watts per square metre ({{< latex center=true >}}$\text{W}/\text{m}^2${{< /latex >}}) but understanding their differences is key to ensuring PBR conserves energy.

#### Irradiance
{{<figure src="asy/irradiance.png" caption="*Irradiance is the relative flux through or onto an area.*" width="80%">}}

Imagine a point emitting light in every direction with a total radiant flux of {{< latex >}}$\Phi${{< /latex >}} watts (joules per second). If we stand farther away from the light source, the flux is spread over a larger area. Imagine an area {{< latex >}}$dA${{< /latex >}}, in this case it happens to lie on the sphere's surface but it could be anywhere, some amount of flux {{< latex >}}$d\Phi${{< /latex >}} from the light source passes through this area. If we moved the area farther from the light source, the area appears "dim". If we increased the area and captured more flux, the area would still be "dim". This means the intensity we care about is an amount of flux **relative** to the area {{< latex >}}$dA${{< /latex >}} it passes through. The irradiance {{< latex >}}$E${{< /latex >}} is then

```latex
  E = \frac{d\Phi}{dA}.
```

The notation {{< latex >}}$dA${{< /latex >}} indicates that the area is very small, this is useful because it means the area is flat and has a normal.

#### Radiance
{{<figure src="asy/radiance.png" caption="*Radiance is the flux from a certain direction onto or reflected from an area.*" width="80%">}}

Irradiance considers flux coming from every direction, but in rendering we want to know the light from a certain direction. Radiance is the directional form of irradiance. The problem is, if we looked at the flux from precisely one direction it would always be zero (similar to how the probability of a dart hitting a point is zero at every point). To resolve this, imagine a unit sphere surrounding our area with flux coming from the direction of a small "patch" {{< latex >}}$d\omega${{< /latex >}} on the surface. Now that we have an area the flux can be non-zero. The patch is analogous to the arc of a circle. The length of an arc is measured in radians, the patch's area is measured in [steradians](https://en.wikipedia.org/wiki/Steradian) instead.

{{<figure src="asy/cosrule.png" caption="*Projecting the area {{< latex >}}$dA${{< /latex >}} so it is perpendicular to the flux.*" width="80%">}}

If the area {{< latex >}}$dA${{< /latex >}} is not perpendicular to the direction the flux is coming from, the flux through the area {{< latex >}}$dA${{< /latex >}} is not the same as the flux if {{< latex >}}$dA${{< /latex >}} was oriented towards {{< latex >}}$d\omega${{< /latex >}}. So that the orientation of the surface doesn't affect the radiance, {{< latex >}}$dA${{< /latex >}} is projected towards the light which is given by {{< latex center=true >}}$dA_{\perp} = dA \text{cos}(\theta)${{< /latex >}} where {{< latex >}}$\theta${{< /latex >}} is the angle between the area's normal and direction of the radiance.

  Putting everything together, radiance from a direction {{< latex >}}$\pmb{x}{{< /latex >}} is 
```latex
    \begin{equation*}
        \begin{aligned}
        L_x = \frac{d\Phi}{d\omega \, dA \text{cos} \theta}.
        \end{aligned}
    \end{equation*}
```
Just like an arc length is {{< latex >}}$r \theta${{< /latex >}}, the area of our patch is the projected area {{< latex center=true >}}$dA_{\perp}${{< /latex >}} multiplied by {{< latex >}}$d\omega${{< /latex >}} which we divide the incoming flux over. The notation {{< latex >}}$d${{< /latex >}} again indicates a small quantity, in practice the area {{< latex >}}$dA${{< /latex >}} becomes a point (eg. {{< latex center=true >}}$p${{< /latex >}}) and the solid angle becomes a ray. 

The reason why radiance is defined for a patch on a **sphere** is that it makes the radiance of a light source independent of the distance from the light source. This can be illustrating by considering the following. As the distance from a light source increases, the flux decreases following the inverse square law {{< latex >}}$\propto r^2${{< /latex >}}, but the solid angle occupied by the light source also decreases {{< latex >}}$\propto r^2${{< /latex >}}, cancelling out. 

We can find irradiance onto an area by adding radiances from all incident directions, defined to be {{< latex >}}$\Omega${{< /latex >}}[^2],
```latex
  E = \int_{\Omega} L(\omega) \text{cos}\theta\; d\omega = \int_{\phi=0}^{2\pi} \int_{\theta=0}^{\pi/2} L(\omega)\; \text{cos}\theta\text{sin}\theta \; d\theta d\phi
```
where {{< latex >}}$\text{cos}\theta${{< /latex >}} projects the flux back onto the area {{< latex >}}$dA${{< /latex >}}.

> Radiance is the radiant flux ({{< latex >}}$\Phi${{< /latex >}}) per unit solid angle ({{< latex >}}$\omega${{< /latex >}}) in the direction of a ray per unit projected area ({{< latex >}}$A\,\text{cos}\theta${{< /latex >}}) perpendicular to the ray. {{< cite "Torrance1967" >}}

In this post we are going to assume that the radiance {{< latex >}}$L${{< /latex >}} of each light in a scene is known. Graphics engines have different methods for calculating radiance for light sources. The simplest is a directional light such as the sun, which is a constant value.

### Colour
{{<figure src="imgs/spd.png" caption="*Spectral power distribution of sunlight.*" width="50%">}}

The radiances we deal with will vary with the wavelength (i.e. colour) of the light. We could calculate the radiance for every visible wavelength, called a spectral power distribution (SPD), but this would be very computationally expensive. Luckily, we can approximate the perceived SPD by combining red, green and blue (RGB) radiances. For this reason, treat radiance and any spectral quantities as RGB vectors where relevant[^1].

[^1]: If you prefer, treat each function which is spectral as having an extra wavelength parameter {{< latex >}}$\lambda${{< /latex >}}.
[^2]: Convert the surface element from a solid angle to polar form, {{< latex center=true >}}$d\omega = sin\theta d\theta\, d\phi${{< /latex >}}.

### Rendering Equation
Returning to our model, We only care about flux directed towards the pixel (light from other directions is not focused by a camera's lens or the cornea) from the object. The pixel's colour is determined by the radiance towards the pixel from the point on the object. The light the object scatters towards our eye is either reflected from the surroundings or emitted by the object. 
```latex
    \begin{equation*}
        \begin{aligned}
        \pmb{L}(\pmb{p},\omega_o) &= \pmb{L_e}(\pmb{p},\omega_o) + \pmb{L_r}(\pmb{p},\omega_o) \\ \\
        \pmb{p} &= \text{Point on surface} \\
        \omega_o &= \text{Direction from point to viewer (solid angle)} \\
        \pmb{L} &= \text{Total radiance from point towards viewer} \\
        \pmb{L_e} &= \text{Emitted radiance} \\
        \pmb{L_r} &= \text{Reflected radiance} \\
        \end{aligned}
    \end{equation*}
```
This is called the [rendering equation](https://en.wikipedia.org/wiki/Rendering_equation). {{< latex center=true >}}$\pmb{L_e}${{< /latex >}} can be a constant or sampled from a texture. {{< latex center=true >}}$\pmb{L_r}${{< /latex >}} depends on how all the lights of the scene interact with the material of the object at {{< latex >}}$\pmb{p}${{< /latex >}}. 

As mentioned earlier, the point {{< latex >}}$\pmb{p}${{< /latex >}} is analogous to a small planar area {{< latex >}}$dA${{< /latex >}} with normal {{< latex >}}$\pmb{n}${{< /latex >}}. Light which reflects off the surface can not come from behind the plane, so we consider only incident radiances directed from a hemisphere {{< latex center=true >}}$\Omega${{< /latex >}} lying on the surface. This assumption preclude large subsurface scattering (light hitting another point on the surface and scattering through the surface and emerging outside {{< latex >}}$dA${{< /latex >}}) which are significant in materials such as skin and water.

{{<figure src="asy/hemisphere.png" caption="*Hemisphere {{< latex >}}$\Omega${{< /latex >}} considers light from all directions {{< latex center=true >}}$\pmb{\omega_i}${{< /latex >}} incident on point {{< latex >}}$\pmb{p}${{< /latex >}}.*" width="80%">}}

We are trying to find the reflected radiance {{< latex center=true >}}$\pmb{L_r}${{< /latex >}}, this depends on the **irradiance** onto the surface. In the same manner we converted radiance to irradiance, we can convert incident radiances {{< latex center=true >}}$\pmb{L_i}${{< /latex >}} into an irradiance onto the surface. A function called the bidirectional reflectance distribution function (BRDF, units of {{< latex center=true >}}$\frac{\text{radiance}}{\text{irradiance}}${{< /latex >}}) then tells us how much of this irradiance becomes radiance in the reflected or viewing direction. 

```latex
    \begin{equation*}
        \begin{aligned}
        \pmb{L_r}(\pmb{p},\omega_o) &= \int_{\Omega} \pmb{f_r}(\pmb{p},\omega_i,\omega_o) \pmb{L_i}(\pmb{p},\omega_i) (\pmb{i} \cdot \pmb{n}) \, d\omega_i \\ \\
        \pmb{f_r} &= \text{Bidirectional reflectance distribution function (BRDF) } \\
        L_i &= \text{Radiance of incident light from } \omega_i \text{ onto } \pmb{p} \\
        \end{aligned}
    \end{equation*}
```
In this article {{< latex center=true >}}$\omega_x${{< /latex >}} will mean a solid angle which is directed towards {{< latex >}}$\pmb{x}${{< /latex >}}.

You may be wondering why the BRDF is defined in terms of incident **irradiance** and not radiance, it is so that a BRDF does not vary systematically with light direction. This does not mean the BRDF does not depend on light direction, only that it's directionality is explained by the reflection of the material itself and not by the projection of flux. Another way of thinking about this is that the {{< latex >}}$\pmb{i} \cdot \pmb{n}${{< /latex >}} term projects the incident radiance {{< latex center=true >}}$\pmb{L_i}${{< /latex >}} onto the area {{< latex >}}$dA${{< /latex >}}. This theoretical understanding can be checked by substituting the definitions of irradiance, radiance and the BRDF noting that
```latex
  E_i = \frac{d\Phi_i}{dA_i} = L_i \: \text{cos}(\theta_i) d\omega_i.
``` 

## BRDF

{{<figure src="imgs/MERL100Slices.jpg" caption="*Slices from the BRDFs of different materials showing how reflection varies according to incident direction, from the [MERL BRDF dataset](https://cdfg.csail.mit.edu/wojciech/brdfdatabase).*" width="80%">}}

BRDF is the proportion of radiance reflected towards {{< latex center=true >}}$\omega_r${{< /latex >}} for a certain irradiance from {{< latex center=true >}}$\omega_i${{< /latex >}},
```latex
  f_r(\pmb{p},\omega_i,\omega_o) = \frac{dL_r}{dE_i}.
``` 
Since the BRDF is defined by input **irradiance** energy conservation can be guaranteed if the reflected radiances are together less than the incident irradiance. Using the same conversion from radiance to irradiance, this time for the reflected radiances, we can ensure energy conservation if
```latex
  \frac{E_r}{E_i} = \int_{\Omega} f_r(\omega_i, \omega_r) (\pmb{r} \cdot \pmb{n}) d\omega_r \leq 1,
``` 
To satisfy [Helmholtz reciprocity](#principles) we should be able to swap incident and reflected directions,
```latex
  f_r(\omega_i, \omega_r) = f_r(\omega_r, \omega_i).
```

Different materials have different BRDFs which can be measured empirically or calculated from theoretical models. PBR consists of a group of energy conserving BRDFs which are usually derived from the microfacet model. Before deriving and explaining the microfacet BRDF we will derive some simpler BRDFs which will be important later.

### Lambertian

{{<figure src="imgs/snow.jpg" caption="*Unpacked snow is close to a lambertian material. \"[Snowy Hillside, Creag a' Bhealaich, Sutherland](https://www.geograph.org.uk/photo/6752541)\" by Andrew Tryon, [Creative Commons](http://creativecommons.org/licenses/by-sa/2.0/).*">}}

The simplest possible BRDF would be some constant, energy conserving value. This corresponds to a material which reflects light in every direction with equal radiance. A material may only be slightly lambertian, the part of the reflection which is lambertian is called **diffuse** reflection. 

{{<figure src="asy/scattering.svg" caption="">}}

When light hits a surface we usually think of it bouncing off like a mirror, how does a lambertian material fit into this model? While it's true that some light reflects off a surface like a mirror, this is the **specular** part of the reflection, some light is also transmitted into the material's surface. For most materials, transmitted light continues to be scattered in the subsurface of the material which until the light is directed back out of the material in a random direction, close to where it entered. This light has a random direction and is the diffuse reflection.

{{<figure src="asy/scattering2.svg" caption="*Yellow light hits a surface, the green wavelengths are absorbed in the subsurface and the red wavelengths scatter diffusely making the material appear red.*">}}

In coloured materials, some wavelengths of light are absorbed by the material in the process of refracting. These wavelengths are removed from the diffuse reflection, colouring the material. The colour of the diffuse reflection from white light is called the albedo of a material.

To calculate the Lambertian BRDF, set {{< latex center=true >}}$\frac{E_r}{E_i} = \rho${{< /latex >}} where {{< latex center=true >}}$\rho${{< /latex >}} is the albedo. Assuming a constant BRDF and ensuring energy conservation ([my derivation](/annex/lambertian)) we find
```latex
  f_r = \frac{\rho}{\pi}.
```
This is the Lambertian BRDF.

### Mirror

{{<figure src="imgs/mirror-ball.jpg" caption="*[Mirror ball ornament](https://pixnio.com/objects/glass/flower-glass-outdoor-ball-mirror-reflection-garden-wood) demonstrating specular reflection, [CC0](https://creativecommons.org/publicdomain/zero/1.0/).*">}}

We now consider the specular reflection off the surface. Metals, especially highly polished metals, reflect light to produce a mirrored appearance. How much a material is specular or diffuse will be accounted for eventually, for now we will focus on a perfect mirror. Unlike diffuse reflection, specular reflection is usually considered to not have a colour because the light is not absorbed by the material.

{{<figure src="asy/mirror.svg" caption="*BRDF of a perfect mirror for some specific incident direction.*">}}

The law of reflection tells us the reflected light is the incident light flipped about the normal. This means the mirror BRDF should only be positive when the reflection direction {{< latex >}}$\pmb{r}${{< /latex >}} equals the incident direction {{< latex >}}$\pmb{i}${{< /latex >}} flipped about the normal. The BRDF of a perfectly planar mirror can be expressed in two equivalent ways, in terms of the halfway vector {{< latex >}}$\pmb{h}${{< /latex >}}, or polar and azimuthal angles.
```latex
  f_r(\omega_i, \omega_r) = k \delta_{\pmb{n}}(\pmb{h}, \pmb{n}) = k \delta(\theta_i, \theta_r)\delta(\phi_i, \pi - \phi_r) ,
```
where {{< latex center=true >}}$k\in[0,1]${{< /latex >}}. {{< latex center=true >}}$\delta(x,y)${{< /latex >}} is the Dirac delta function which is positive only when {{< latex center=true >}}$x=y${{< /latex >}}, for example {{< latex center=true >}}$\delta_{\pmb{n}}(\pmb{h}, \pmb{n})${{< /latex >}} means the delta is positive when the halfway vector {{< latex center=true >}}$\pmb{h} \coloneqq \frac{\pmb{i}+\pmb{r}}{\lVert \pmb{i}+\pmb{r} \rVert}${{< /latex >}} equals the normal vector {{< latex >}}$\pmb{n}${{< /latex >}}. The mirror BRDF is energy conserving ([my derivation](/annex/mirror)).

### Specular Microfacet
If you scratch a metal it becomes less mirror-like, polishing makes it more mirror-like.  In scratching the metal we are changing the microscopic surface of the metal. A material's microsurface can be very complicated so we make an assumption that materials microsurfaces only vary in how "rough" they are and that there are no overhangs. Rough materials are less flat and more "bumpy." 

{{<figure src="imgs/gypsum.jpg" caption="*Microsurface of gypsum, coloured SEM by [Steve Gschmeissner](https://www.sciencephoto.com/contributor/sgs/).*" width="80%">}}

The microfacet model accounts for this bumpiness by treating our area {{< latex >}}$dA${{< /latex >}} as consisting of many smaller planes called microfacet which have random orientations. The normal of a microfacet is called a micronormal {{< latex >}}$\pmb{m}${{< /latex >}}, as opposed to the macronormal {{< latex >}}$\pmb{n}${{< /latex >}}. Materials which are smoother have more micronormals which align with the macronormal, and rougher materials have micronormals in more "random" orientations.

{{<figure src="asy/roughness-0.svg" caption="*Microsurface of a mirror, the roughness is {{< latex >}}$0${{< /latex >}} so all micronormals align with the macronormal.*">}}

{{<figure src="asy/roughness-1.svg" caption="*Microsurface of a rough material, reflections occur towards random orientations causing some reflections to be blocked.*">}}

If we consider microfacets of every possible orientation and add their contribution we can find the overall BRDF of the macrosurface.
```latex
  \begin{align*}
  f_r(\omega_i, \omega_r) &= \int_{\Omega} \rho_{\pmb{m}}(\omega_i, \omega_r) D(\pmb{m}) G_2(\pmb{i}, \pmb{r}, \pmb{m})\; \left(\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\, \left(\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) d\omega_m\\
  \rho_{\pmb{m}} &= \text{The BRDF for a microfacet with normal } \pmb{m}\\
  D      &= \text{The probability density of a micronormal being } \pmb{m}\\
  G_2    &= \text{Geometry term, the proportion of the microfacet } \pmb{m}\\ 
         & \text{ that is visible from both the incident and reflected directions}\\
  \end{align*}
```
where {{< latex >}}$\Omega${{< /latex >}} is still a hemisphere. {{< latex center=true >}}$\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}${{< /latex >}} and {{< latex center=true >}}$\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}${{< /latex >}} are how visible the microfacet is along the incident and refracted directions respectively. This accounts for the difference in projected areas for microfacets of different orientations. This is separate to the geometry term which accounts for one facet blocking another facet.

As stated, each microfacet will have it's own BRDF {{< latex center=true >}}$\rho_{\pmb{m}}${{< /latex >}}, in this section we are going to assume mirror-like microfacets that only reflect specularly.

#### Roughness
We defined roughness as a measure of the microscopic "bumpiness," a more rigorous definition is the variance in the orientations of the microfacets. Assuming microfacets on average point towards the macronormal, then rougher materials have more micronormals pointing at random. The roughness is usually represented by {{< latex >}}$\alpha${{< /latex >}} which is between {{< latex >}}$0${{< /latex >}} and {{< latex >}}$1${{< /latex >}}. Disney suggested a more visually "linear" roughness parameter {{< latex center=true >}}${\sqrt{\alpha}}${{< /latex >}} used when authoring.

#### Microfacet BRDF

It is common to treat each microfacet as a mirror, we will also assume perfect reflectance for now ({{< latex center=true >}}$\frac{E_r}{E_i} = 1${{< /latex >}}). From the mirror BRDF derived earlier,
```latex
  \rho_{\pmb{m}}(\omega_i, \omega_r) = k\, \delta_{\pmb{m}}(\pmb{h}, \pmb{m}),
```
where {{< latex >}}$k${{< /latex >}} is some function which ensures energy conservation. We need to solve for {{< latex >}}$k${{< /latex >}}, our energy conservation integral requires
```latex
  \frac{E_r}{E_i} = \int_{\Omega} k\, \delta_{\pmb{m}}(\pmb{h}, \pmb{m})\; (\pmb{r} \cdot \pmb{n}) d\omega_r = 1,
``` 

The delta function means that rather than having to sum over all incoming light, we only care about light coming from a direction our micronormal can reflect, when  {{< latex >}}$\pmb{h} = \pmb{m}${{< /latex >}}. For this reason, if the integral can be made in terms of {{< latex center=true >}}$d\omega_m${{< /latex >}}, not {{< latex center=true >}}$d\omega_r${{< /latex >}} we can solve for {{< latex >}}$k${{< /latex >}}. So we write
```latex
  \int_{\Omega} k\, \delta_{\pmb{m}}(\pmb{h}, \pmb{m}) (\pmb{r} \cdot \pmb{m})\; \frac{d\omega_r}{d\omega_m} d\omega_m = 1.
```
We now need to find {{< latex center=true >}}$\frac{d\omega_r}{d\omega_m}${{< /latex >}}, how {{< latex >}}$\omega_r${{< /latex >}} changes relative to {{< latex >}}$\omega_m${{< /latex >}}. This can be solved geometrically by projecting the translated solid angle, if you are interested [read my derivation](/annex/pbr-4). We find

```latex
  \frac{d\omega_r}{d\omega_m} = 4 (\pmb{r}\cdot\pmb{h}),
```

Substituting back into our energy conservation integral,
```latex
  \int_{\Omega} k\, \delta_{\pmb{m}}(\pmb{h}, \pmb{m}) (\pmb{r} \cdot \pmb{m}) (4(\pmb{r}\cdot\pmb{h})) d\omega_m = 1.
```
With the delta function enforcing {{< latex >}}$\pmb{m} = \pmb{h}${{< /latex >}},
```latex
  k = \frac{1}{4 (\pmb{r}\cdot\pmb{h})^2} = \frac{1}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})}
```

So our microfacet BRDF is
```latex
  \rho_{\pmb{m}}(\omega_i, \omega_r) = \frac{\delta_{\pmb{m}}(\pmb{h}, \pmb{m})}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})},
```

Substituting the microfacet BRDF, the overall specular BRDF is
```latex
  \begin{align*}
  f_r(\omega_i, \omega_r) &= \int_{\Omega} \frac{\delta_{\pmb{m}}(\pmb{h}, \pmb{m})}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})} D(\pmb{m}) G_2(\pmb{i}, \pmb{r}, \pmb{m})\; \left(\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\, \left(\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) d\pmb{m}. \\
  \end{align*}
```
Again, the delta function eliminates the integral and enforces {{< latex >}}$\pmb{h} = \pmb{m}${{< /latex >}}. This make sense intuitively, since we only care about microfacets when they can actually reflect light, meaning their normals align with the halfway vector.
```latex
  \begin{align*}
    f_r(\omega_i, \omega_r) &= \frac{1}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})} D(\pmb{h}) G_2(\pmb{i}, \pmb{r}, \pmb{h})\; \left(\frac{\pmb{h} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\, \left(\frac{\pmb{h} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) \\ \\
                            &= \frac{D(\pmb{h})\, G_2(\pmb{i}, \pmb{r}, \pmb{h})}{4 \lvert\pmb{n} \cdot \pmb{i}\rvert \lvert\pmb{n} \cdot \pmb{r}\rvert}
  \end{align*}
```

#### Density Term
If {{< latex >}}$D${{< /latex >}} is the probability density for a micronormal directed into a solid angle {{< latex >}}$\omega_m${{< /latex >}}. If you think of each microfacet as occupying tiny areas {{< latex >}}$da${{< /latex >}}, then if we project each microfacet they should cover our macro area {{< latex >}}$dA${{< /latex >}} because there are no overhangs. This can be expressed as the following
```latex
  \int_{\Omega} D(\omega_m) (\pmb{m} \cdot \pmb{n}) \,d\omega_m = 1.
```
A valid density term should fit this condition and be physically plausible. Since there can't be overhangs, assume if not stated that the distribution is {{< latex >}}$0${{< /latex >}} when {{< latex center=true >}}$\pmb{m} \cdot \pmb{n} \leq 0${{< /latex >}}.

There are different models of rough surfaces, one idea is to consider the height at each point on the surface as following a gaussian distribution with variance set to the roughness parameter {{< latex >}}$\alpha${{< /latex >}}. This is called the Beckmann distribution, the height distribution is converted to a probability distribution over solid angles,
```latex
  D_{\alpha}(\omega_m) = \frac{1}{\pi \alpha^2 \text{cos}^4 \theta_m} \; \text{e}^{\frac{-\text{tan}^2 \theta_m}{\alpha^2}}
```
```latex
  \text{cos} \theta_m = \pmb{m} \cdot \pmb{n}, \qquad \text{tan}^2 \theta_m = \frac{1}{(\pmb{m} \cdot \pmb{n})^2} - 1
```
Another model is GGX or Trowbridge-Reitz distribution proposed by Walter et al. {{< cite "Walter2007" >}}. The GGX distribution better matches empirical measurements of rough material which show longer tails of steeply angled microfacets than predicted by the Beckmann distribution. The probability distribution is
```latex
  D_{\alpha}(\omega_m) = \frac{\alpha^2}{\pi \text{cos}^4 \theta_m (\alpha^2 + \text{tan}^2 \theta_m)^2} = \frac{\alpha^2}{\pi((\pmb{m} \cdot \pmb{n})^2 (\alpha^2 - 1) + 1)^2}.
```
The GGX distribution is also simpler to calculate. The GGX distribution fits our area rule:
```latex
  \begin{align*}
    &  \int_{\Omega} D(\omega_m) \text{cos}\theta_m \,d\omega_m \\
    &= \int_{\phi=0}^{2\pi} \int_{\theta_m=0}^{\pi/2}  \frac{\alpha^2}{\pi \text{cos}^4 \theta_m (\alpha^2 + \text{tan}^2 \theta_m)^2} \text{cos}\theta_m \text{sin}\theta_m\: d\theta_m d\phi \\ \\
    &= \frac{\alpha^2}{\pi} \int_{\phi=0}^{2\pi} \int_{\theta_m=0}^{\pi/2} \frac{\text{tan}\theta_m \text{sec}^2 \theta_m}{(\alpha^2 + \text{tan}^2 \theta_m)^2} d\theta_m\: d\phi \\
    &= \frac{\alpha^2}{\pi} \int_{\phi=0}^{2\pi} \left[ \frac{-1}{2(\alpha^2 + \text{tan}^2 \theta_m)} \right]_{\theta_m=0}^{\pi/2} d\phi = 1 \\
  \end{align*}
```

The distributions presented here assume a constant roughness {{< latex >}}$\alpha${{< /latex >}} across our macrofacet, this is not true for some materials. Materials such as brushed metal can have a different "roughness" for different viewing direction, meaning the microfacets are aligned differently along different directions in the material. This is called anisotropic reflection, as opposed to the isotropic reflection presented here.

{{< interactive src="interactives/density.js" imgsrc="interactives/density-alt.png" caption="*Visualisation of the GGX and Beckmann density functions, at low roughness an off-peak bright spot is visible. **Drag to rotate.***" controls=true >}}

#### Geometry Term
The geometry term is the proportion of a microfacet that is visible from both the incident and reflected directions. Light which would hit a microfacet may be blocked by another part of the surface, this is called shadowing. Alternatively, reflected light may be blocked from the viewer by the surface, called occlusion.

{{<figure src="asy/roughness-g.svg" caption="*A rough surface which shows both shadowing and occlusion effects.*">}}

Since we don't know the actual microsurface, the geometry term tells us **expected** amount of occlusion and shadowing for the microfacet distribution. 

Smith {{< cite "Smith1967" >}} suggested an approximation for the geometry term {{< latex center=true >}}$G_2${{< /latex >}}. Helmoholtz reciprocity requires that the amount a microfacet is expected to be visible is the same from both the incident and reflected directions. Let the expected amount that the microfacet is visible from {{< latex center=true >}}$\pmb{x}${{< /latex >}} be {{< latex center=true >}}$G_1(\omega_x)${{< /latex >}}. Assuming that the visibility from {{< latex >}}$\pmb{r}${{< /latex >}} and {{< latex >}}$\pmb{i}${{< /latex >}} are independent then our geometry term is
```latex
  G_2(\pmb{i},\pmb{r}) = G_1(\pmb{i}) G_1(\pmb{r}).
```
This is an approximation because the visibility is not actually independent, for example a microfacet in a deep V is less visible from both directions. This is called a uncorrelated geometry function.

Smith derived a method to calculate {{< latex >}}$G_1${{< /latex >}} for any distribution of microfacets (from the density term {{< latex >}}$D${{< /latex >}}). This technique can be used to derive the Smith-GGX shadowing function, which was approximated by Schlick {{< cite "Schlick1994" >}}.

```latex
  \begin{align*}
  G_1(\pmb{x}) &= \frac{2 \pmb{n} \cdot \pmb{x}}{\sqrt{\alpha^2 + (1-\alpha^2) (\pmb{n} \cdot \pmb{x})^2} + \pmb{n} \cdot \pmb{x}} \\
  &\approx \frac{2 |\pmb{n} \cdot \pmb{x}|}{(2 - \alpha)|\pmb{n} \cdot \pmb{x}| + \alpha}.
  \end{align*}
```

If the surfaces heights are assumed to be uncorrelated then {{< latex >}}$G_2${{< /latex >}} is {{< latex center=true >}}$G_1(\pmb{i}) G_1(\pmb{r})${{< /latex >}}. Alternatively Earl Hammon Jr also suggested a cheap approximation to a correlated geometry term based on ray traced results,
```latex
  \begin{align*}
  G_2(\pmb{i},\pmb{r}) &\approx \frac{2 |\pmb{n} \cdot \pmb{i}| |\pmb{n} \cdot \pmb{r}|}{ (\pmb{n} \cdot \pmb{i})\sqrt{\alpha^2 + (1-\alpha^2) (\pmb{n} \cdot \pmb{i})^2} + (\pmb{n} \cdot \pmb{r})\sqrt{\alpha^2 + (1-\alpha^2) (\pmb{n} \cdot \pmb{r})^2}} \\ \\
  &\approx \frac{ |\pmb{n} \cdot \pmb{i}| |\pmb{n} \cdot \pmb{r}|}{ \text{lerp}(2|\pmb{n} \cdot \pmb{i}| |\pmb{n} \cdot \pmb{r}|, |\pmb{n} \cdot \pmb{i}| + |\pmb{n} \cdot \pmb{r}|, \alpha)}.
  \end{align*}
```

{{< interactive src="interactives/geometry.js" imgsrc="interactives/geometry-alt.png" caption="*Visualisation of the different geometry functions derived here, **Drag to rotate.***" controls=true >}}

### PBR

#### Fresnel Equation
In solving our specular microfacet BRDF we assumed that each microfacet was a perfect mirror, but as discussed when deriving the [Lambertian BRDF](#lambertian) some of the light is not reflected, but rather scattered inside the material. 

{{<figure src="asy/fresnel.svg" caption="*Some proportion of the incident energy is transimitted, and some is reflected.*">}}

The fresnel equations describe the proportion of incident radiance which is transmitted through a boundary, such as from air to our material. {{< latex >}}$F${{< /latex >}} is a simplied form of the Fresnel equation which is the proportion of unpolarized light which is specularly reflected from an air-dielectric boundary. {{< latex >}}$F${{< /latex >}} depends on normal at the boundary, light direction, and the index of refraction (IOR) of the dielectric. The full Fresnel equation can be computationally expensive, Schlick's approximation is commonly used instead,
```latex
  F(\pmb{i}, \pmb{h}) = F_0 + (1 - F_0)(1 - \pmb{i} \cdot \pmb{h})^5
```
where {{< latex center=true >}}$F_0${{< /latex >}} is the colour of the specularly reflected light coming from the normal. The Schlick approximation is a [Padé approximation](https://en.wikipedia.org/wiki/Pad%C3%A9_approximant) (similar to a taylor series) using the conditions that the reflection should be {{< latex center=true >}}$F_0${{< /latex >}} when incident light is perpendicular and {{< latex >}}$0${{< /latex >}} when incident light is perpendicular. The Schlick approximation has the advantage that the mediums' IOR don't have to be known, only the perpendicular specular colour {{< latex center=true >}}$F_0${{< /latex >}}. The derivation of the Schlick approximation is beyond this post but is well explained by the original paper {{< cite "Schlick1994" >}}.

A dialetric's {{< latex center=true >}}$F_0${{< /latex >}} is closer to white, meaning specular reflection is not tinted. A conductor's specular colour is closer to it's "albedo" or base colour, since the diffuse reflections disappears and the specular must account for the material's colour.

{{< interactive src="interactives/fresnel.js" imgsrc="interactives/fresnel-alt.png" class="w-[50%] mx-auto" caption="*An object shaded by Fresnel-Schlick, notice that grazing angles cause stronger specular reflections. **Drag to rotate.***" >}}

#### Specular and Diffuse
Our final PBR BRDF must combine the specular microfacet with a diffuse reflection. The specular reflection only occurs when light is not transmitted, following the Fresnel equation where the boundary is oriented towards the microfacets {{< latex >}}$\pmb{h}${{< /latex >}},
```latex
  f_{r,s}(\omega_i, \omega_r) = \frac{F(\pmb{i}, \pmb{h})\, D(\pmb{h})\, G_2(\pmb{i}, \pmb{r}, \pmb{h})}{4 \lvert\pmb{n} \cdot \pmb{i}\rvert \lvert\pmb{n} \cdot \pmb{r}\rvert}.
```
Light which is not specularly reflected is diffusely reflected, which means we have to solve our microfacet BRDF again for the case of a Lambertian microfacet BRDF ({{< latex center=true >}}$\rho_{\pmb{m}} = \frac{\rho}{\pi}${{< /latex >}}). Unfortunately, our microfacet integral
```latex
  \begin{align*}
  f_{r,d}(\omega_i, \omega_r) &= \int_{\Omega} \frac{\rho}{\pi} (1-F(\pmb{i}, \pmb{m})) D(\pmb{m}) G_2(\pmb{i}, \pmb{r}, \pmb{m})\; \left(\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\, \left(\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) d\pmb{m}, \\
  \end{align*}
```
has no closed form solution since there is no longer a delta function to eliminate the integral. It is simpler if we ignore the microfacets for the Lambertian and use the macrofacet normal {{< latex >}}$\pmb{n}${{< /latex >}} instead.

Our final PBR microfacet BRDF is then
```latex
  f_r(\omega_i, \omega_r) = (1-F(\pmb{i}, \pmb{h})) \frac{\rho}{\pi} + F(\pmb{i}, \pmb{h}) \frac{D(\pmb{h})\, G_2(\pmb{i}, \pmb{r}, \pmb{h})}{4 \lvert\pmb{n} \cdot \pmb{i}\rvert \lvert\pmb{n} \cdot \pmb{r}\rvert}.
```

The radiance directed towards the viewer is
```latex
  \pmb{L}(\pmb{p},\omega_r) = \pmb{L_e}(\pmb{p},\omega_o) + \int_{\Omega} f_r(\omega_i, \omega_r) \pmb{L_i}(\pmb{p},\omega_i) (\pmb{i} \cdot \pmb{n}) \, d\omega_i
```

Which can be solved analytically using [IBL](https://en.wikipedia.org/wiki/Image-based_lighting) or with an assumption of analytically light sources such as directional lights being the only incident radiances, for a set of {{< latex >}}$S${{< /latex >}} analytical light sources

```latex
  \pmb{L}(\pmb{p},\omega_r) = \pmb{L_e}(\pmb{p},\omega_o) + \sum_{L_i \in S} f_r(\omega_i, \omega_r) \pmb{L_i}(\pmb{p},\pmb{i}) (\pmb{i} \cdot \pmb{n})
```

## Code
The code for direct lighting of a dielectric PBR is found below for reference, there are some approximation used which can be found or derived from Edwards et al. {{< cite "Edwards2006" >}}. This code is for illustration purposes and is not optimised.
```glsl
#define M_PI    3.14159265358979323846264338327950288
#define EPSILON 1.19209e-07

uniform float time;

uniform int G2_mode;
uniform int D_mode;
uniform float alpha;
uniform float dir_radiance;
uniform vec3 albedo;
uniform vec3 specular;
uniform vec3 emissive;

varying vec4 p;
varying vec3 n;

vec3 F_Schlick(float cLdotH, vec3 F0) {
  return F0 + (1.0-F0)*pow(1.0 - cLdotH, 5.0);
}

float G2_GGX_corr(float cLdotN, float cVdotN) {
  // Correlated Approximation
  float nom = cLdotN * cVdotN;
  float denom = mix(2.0*nom, cLdotN + cVdotN, alpha) + EPSILON;
  return nom / denom;
}

float G2_GGX_uncorr(float cLdotN, float cVdotN) {
  // Uncorrelated Approximation
  float nom = 4.0 * cLdotN * cVdotN;
  float denom = ((2.0 - alpha)*cLdotN + alpha) * ((2.0 - alpha)*cVdotN + alpha);
  return nom / denom;
}

float G1_Beckmann(float cXdotN) {
  float a = 1.0 / (alpha*sqrt(1.0 / (cXdotN*cXdotN + EPSILON) - 1.0) + EPSILON);
  float a2 = a*a;

  return (a < 1.6) ? ((3.535*a + 2.181*a2) / (1.0 + 2.276*a + 2.577*a2)) : 1.0;
}

float G2_Beckmann_uncorr(float cLdotN, float cVdotN) {
  return G1_Beckmann(cLdotN) * G1_Beckmann(cVdotN);
}

// Derived from Λ = (1 - G1) / G1
float A_Beckmann(float cXdotN) {
  float a = 1.0 / (alpha*sqrt(1.0 / (cXdotN*cXdotN + EPSILON) - 1.0) + EPSILON);
  float a2 = a*a;

  return (a < 1.6) ? ((1.0 - 1.259*a + 0.396*a2) / (3.535*a + 2.181*a2)) : 0.0;
}

// G2 = 1 / (1 + Λ(i) + Λ(r))
float G2_Beckmann_corr(float cLdotN, float cVdotN) {
  return 1.0 / (1.0 + A_Beckmann(cLdotN) + A_Beckmann(cVdotN));
}

float D_Beckmann(float HdotN) {
  float a2 = alpha*alpha;
  float c2 = HdotN*HdotN;

  float t2 = 1.0/(c2+EPSILON) - 1.0;
  float nom = exp(-t2/a2);
  float denom = M_PI*a2*c2*c2 + EPSILON;
  return nom / denom;
}

float D_GGX(float HdotN) {
  float a2 = alpha*alpha;
  float c2 = HdotN*HdotN;

  float nom = a2;
  float denom = M_PI*(c2 * (a2 - 1.0) + 1.0)*(c2 * (a2 - 1.0) + 1.0);
  return nom / denom;
}

vec3 L_r(vec3 N, vec3 V, float cVdotN, vec3 L, float radiance) {
    vec3 H = normalize(V + L);
    float cLdotN = max(dot(L,N),0.0);
    float cLdotH = max(dot(L,H),0.0);
    float HdotN = dot(H,N);

    vec3 F = F_Schlick(cLdotH, specular);
    float D = D_GGX(HdotN);
    float G2 = G2_GGX_corr(cLdotN, cVdotN);

    vec3 brdf_s = F*D*G2 / (4.0 * cLdotN * cVdotN + EPSILON);
    vec3 brdf_d = (1.0 - F) * albedo / M_PI;

    return (brdf_s + brdf_d)*radiance*cLdotN;
}
```

## Further Reading
- Nayer et al. developed a microfacet model for diffuse reflection which is more accurate than the Lambertian used here {{<cite "Oren1994">}}.
- Walter et al. applied the microfacet model to refraction in transparent materials {{<cite "Walter2007">}}.
- Sébastien Lagarde's memo has a Mathematica notebook which is helpful for understanding the Fresnel equation and it's approximations ([link](https://seblagarde.wordpress.com/2013/04/29/memo-on-fresnel-equations/)).
- Suggest relevant or interesting articles and I will add them.

## References
{{< bibliography >}}


Let me know if there are any mistakes or problems with this post and I will fix them. Problems found so far
- None
