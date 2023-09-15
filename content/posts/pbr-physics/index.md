---
date: "2023-09-03"
title: "Physically Based Rendering"
author: "Patrick Bell"
slug: "pbr-physics"
comments: true
tags: [ "Mathematics", "Graphics" ]
katex: true
caption: "Deriving PBR from physical principles."
img:
  name: "/posts/pbr-physics/header.png"
  alt: ""
---

Physically based rendering (PBR) is a general term for techniques in 3D graphics that approximate physical laws. This is fairly arbitrary, but the term PBR has come to mean techniques which aim for realistic rendering of real world materials. The PBR approach to materials developed by Disney in 2012{{< cite "Burley2012" >}} still forms the basis of real-time realistic rendering. This post explains the physical models and mathematics behind PBR. My renderer uses a similar PBR system which can be found in the [PBR shader](https://github.com/patricklbell/3d_engine/blob/main/data/shaders/lib/pbr.glsl).

## Principles
A list of principles includes:
1. Conservation of energy
2. Law of reflection
3. Fresnel equations

I will try to explain each of these principles as they come up. Along the way we also make various assumptions and approximations about light, some of the important ones are:
- It follows straight lines which behave the same from a viewer to a source as vice versa (Helmholtz reciprocity)
- It does not interfere or interact with other light
- It is always unpolarized (even after scattering off a surface which the full fresnel equations tell us should cause some polarization)

## The Model
For each pixel on the screen imagine a ray which travels from our eye, through the pixel until it hits an object in the world. If the object is opaque and we ignore any atmospheric effects, the colour of our pixel should be determined by how much light the object scatters at that point towards us. How bright a pixel is depends on the radiance directed towards our pixel. 

{{<figure src="imgs/intersection.svg" caption="*Illustrates ray travelling from a virtual eye, through a pixel, and hitting an opaque sphere.*" width="80%">}}


### Radiance and Irradiance

#### Irradiance
{{<figure src="asy/irradiance.png" caption="*Irradiance is the amount of radiant power over an area.*" width="80%">}}

Imagine a point emitting light in every direction with a total radiant flux of $\Phi$ watts (joules per second). If we stand farther away from the light source, it's flux is spread over a larger area and it is perceived as dimmer. Dividing our flux $\Phi$ over a sphere's surface tells us the **irradiance** at a distance $r$, $\frac{\Phi}{4\pi r^2}$. 

Surfaces are only flat planes infinitesimally, so imagine our area $A \rightarrow 0 \text{m}^2$, then the irradiance would be 
\\[
  E = \frac{d\Phi}{dA}.
\\]
If we think of each pixel of our screen as a little square area, then the pixel's brightness should be determined by the irradiance onto the pixel's area.

{{<figure src="asy/radiance.png" caption="*Radiance represents the flux onto an infinitesimal area perpendicular to the surface through an infinitesimal solid angle.*" width="80%">}}

#### Radiance

You may have noticed that the irradiance diagram shows the area tangent to the sphere of light. What if our area is not perpendicular to the light rays? In this case the same flux would be spread over a larger projected area. The projected area $dA$ would be $\frac{dA_{\perp}}{\text{cos}(\theta)}$ where $\theta$ is the angle between the area's normal and the light direction. This means that irradiance changes depending on the angle of the area. This is one of the problems that **radiance** solves by being a "directional irradiance".

Since radiance is directional, it doesn't make sense to talk about the radiance from a single point, since light travelling from the same direction from a single point would not illuminate an area[^1]. To resolve this, imagine a sphere surrounding our area with a "tiny patch" in the direction of the light, if we consider flux across the whole patch then our radiance can be non-zero. The "tiny patch" is analogous to a "tiny arc" on a unit circle, the tiny arc would take up an angle $d\phi$ radians, for a unit sphere the "tiny patch" is $d\omega$ steradians (steradians are the unit of [solid angle](https://en.wikipedia.org/wiki/Solid_angle)). Putting everything together, radiance is 
\\[
    \begin{equation*}
        \begin{aligned}
        L = \frac{d^2 \Phi}{d\omega \\, dA \text{cos} \theta},
        \end{aligned}
    \end{equation*}
\\]
where "$dA \\, \text{cos}(\theta)$" un-projects the area so that radiance is independent of the surface's orientation. Since we are dividing by the solid angle $d\omega$, radiance is also independent of the distance from the light source (if this is not clear from the definition, then you could also say that as distance increases the flux decreases $\propto r^2$, but the solid angle also decreases $\propto r^2$, cancelling out). We can recover the direction-less irradiance from radiance by re-projecting radiances from all possible directions $\Omega$[^3],
\\[
  E = \int_{\Omega} L(\omega) \text{cos}\theta\\; d\omega = \int_{\phi=0}^{2\pi} \int_{\theta=0}^{\pi/2} L(\omega)\\; \text{cos}\theta\text{sin}\theta \\; d\theta d\phi
\\]

> Radiance is the radiant flux ($\Phi$) per unit solid angle ($\omega$) in the direction of a ray per unit projected area ($A\\,\text{cos}\theta$) perpendicular to the ray. {{< cite "Torrance1967" >}}

In this post we are going to assume that the radiance $L$ of each light is known. Graphics engines can have ad-hoc methods for calculating radiance (eg. directional light is a constant, point sources are attenuated by the atmosphere empirically).

### Colour
{{<figure src="imgs/spd.png" caption="*Spectral power distribution of sunlight*" width="50%">}}

The radiances we deal with will clearly depend on the wavelength (i.e. colour) of the light. We could calculate the radiance for every visible wavelength, called a spectral power distribution (SPD), but this would be very computationally expensive. Luckily, we can approximate the perceived SPD by combining red, green and blue (RGB) radiances. For this reason, I will treat radiance as an RGB vector of radiances[^2].

[^1]: A point source illuminating a material with zero roughness will not have visible specular reflections.
[^2]: Alternatively, each function could be defined as spectral with an extra wavelength parameter $\lambda$.
[^3]: The second part applies relies on $d\omega = sin\theta d\theta\\, d\phi$, because both quantities are the same surface area element on the unit sphere.

### Rendering Equation
For a point on the object, light is either reflected from, or emitted by, the object. So radiance is given by
\\[
    \begin{equation*}
        \begin{aligned}
        \pmb{L}(\pmb{p},\omega_o) &= \pmb{L_e}(\pmb{p},\omega_o) + \pmb{L_r}(\pmb{p},\omega_o) \\\ \\\
        \pmb{p} &= \text{Point on surface} \\\
        \omega_o &= \text{Direction from point to viewer (solid angle)} \\\
        \pmb{L} &= \text{Total radiance from point towards viewer} \\\
        \pmb{L_e} &= \text{Emitted radiance} \\\
        \pmb{L_r} &= \text{Reflected radiance} \\\
        \end{aligned}
    \end{equation*}
\\]
which is called the [rendering equation](https://en.wikipedia.org/wiki/Rendering_equation). The emission radiance $\pmb{L_e}$ depends on the object and can be a constant or sampled from a texture. The reflected light $\pmb{L_r}$ depends on the lights coming from the surroundings towards the point $\pmb{p}$. We can approximate our point as existing on a planar boundary with normal $\pmb{n}$, meaning light which can be reflected must come from a hemisphere lying on the surface.

{{<figure src="asy/hemisphere.png" caption="*Hemisphere $\Omega$ considers light from all directions $\pmb{\omega_i}$ incident on point $\pmb{p}$*" width="80%">}}

We can express this as an integral which sums the radiance of reflected light over the hemisphere. Light from certain directions and of certain wavelengths will be reflected more strongly towards $\omega_o$. The ratio of radiance reflected towards $\omega_o$ to irradiance onto $p$ from $\omega_i$ is called the BRDF (units of $\frac{\text{radiance}}{\text{irradiance}}$).
\\[
    \begin{equation*}
        \begin{aligned}
        \pmb{L_r}(\pmb{p},\omega_o) &= \int_{\Omega} \pmb{f_r}(\pmb{p},\omega_i,\omega_o) \pmb{L_i}(\pmb{p},\omega_i) (\omega_i \cdot \pmb{n}) \\, d\omega_i \\\ \\\
        \pmb{f_r} &= \text{Bidirectional reflectance distribution function (BRDF) } \\\
        L_i &= \text{Radiance of incident light from } \omega_i \text{ onto } \pmb{p} \\\
        \end{aligned}
    \end{equation*}
\\]

You may be wondering what the $\omega_i \cdot \pmb{n}$ term means. Since $\omega_i$ is a solid angle, $\omega_i \cdot \pmb{n}$ is an abuse of notation which is more correctly stated as $\text{cos}(\theta_i)$ where $\theta_i$ is the angle between $\pmb{n}$ and the direction of $\omega_i$. The $\omega_i \cdot \pmb{n}$ term converts the incident radiance $\pmb{L_i}$ into an differential irradiance $\pmb{E_i}$ for the BRDF:
\\[
  E_i = \frac{d\Phi_i}{dA_i} = L_i \\: \text{cos}(\theta_i) d\omega_i.
\\] 

Our reflectance equation's assumptions preclude subsurface effects (light hitting another point on the surface and scattering through the surface and emerging at $\pmb{p}$). Subsurface effects can be important for some material, such as skin and water, but will be ignored.

## BRDF
BRDF is the proportion of radiance reflected towards $\omega_o$ for a certain irradiance from $\omega_i$. 
\\[
  f_r(\pmb{p},\omega_i,\omega_o) = \frac{dL_r(\omega_r)}{dE_i(\omega_i)}
\\] 
An advantage of the BRDF being defined in terms of incident irradiance is that energy conservation can be guaranteed if the reflected irradiance is less than the incident irradiance,
\\[
  \frac{E_r}{E_i} = \int_{\Omega} f_r(\omega_i, \omega_r) (\omega_r \cdot \pmb{n}) d\omega_r \leq 1,
\\] 
which comes from [converting the total reflected radiances to an irradiance](#radiance). Additionally, to satisfy [Helmholtz reciprocity](#principles) we should be able to swap incident and reflected directions,
\\[
  f_r(\omega_i, \omega_r) = f_r(\omega_r, \omega_i).
\\]

### Lambertian
The simplest possible BRDF would be some constant, energy conserving value. This corresponds to a material which reflects light in every direction with equal radiance. This is called **diffuse** reflection. 

**TODO picture showing scattering**

When light hits a surface we usually think of it bouncing off like a mirror (we will define the BRDF for a mirror after this), how does a lambertian material fit into this model? While it's true that some light reflects off a surface like a mirror (called **specular** reflection), some light is also refracted through the material. For most materials the refracted light continues to be refracted in the subsurface of the material which scrambles the light direction until some of the light is directed back out of the material. This light has a random direction and is the diffuse reflection.

**TODO picture showing absorption?**

In coloured materials, some wavelengths of light are absorbed by the material in the process of refracting. These wavelengths are removed from the diffuse reflection, leading the diffuse reflection to consist of only some colours. The colour of the diffuse reflection is called the albedo of a material. To calculate the diffuse BRDF in practice, the scalar BRDF we calculate below is simply multiplied by the RGB albedo of the material.

To calculate the Lambertian BRDF, set $\frac{E_r}{E_i} = \rho$ where $\rho$ is the reflectivity{{< cite "Mobley2021" >}} ($\rho \in [0,1]$). Assuming a constant BRDF and ensuring energy conservation ([my derivation](/annex/lambertian)) we find
\\[
  f_r = \frac{\rho}{\pi}.
\\]
This is the Lambertian BRDF.

**TODO picture of snow**

### Mirror
We now consider the specular light which **is** reflected off the surface. Metals, especially highly polished metals, reflect light to produce a mirrored appearance. How much a material is specular or diffuse and why polishing maters will be explained later. Unlike diffuse reflection, specular reflection doesn't have a colour because light is not refracted and absorbed by the material (does a mirror have a colour?).

**TODO mirror ball pic**

Reflected light will follow the law of reflection (flipped about the normal). It is easier to express the law of reflection if we replace our solid angles $\omega$ with equivalent polar and azimuthal angle pairs $(\theta,\phi)$. Then the incident and reflected light are $(\theta_i,\phi_i)$ and $(\theta_i,\phi_i - \pi)$ respectively. 

**TODO picture of law of reflection for polar and azimuthal angles**

The BRDF will only be positive when the reflection direction, $\omega_r$, equals the reflection of the irradiance direction, $\omega_i$. The BRDF of a perfectly planar mirror is then 
\\[
  f_r(\theta_i,\phi_i; \theta_r,\phi_r) = k \delta(\theta_i - \theta_r)\delta(\phi_i + \pi - \phi_r) = k \delta_{\pmb{n}}(\pmb{H}, \pmb{n}),
\\]
where $\delta$ is the [delta function](https://en.wikipedia.org/wiki/Dirac_delta_function) and $k\in[0,1]$. The second, equivalent statement, means, for the measure $\pmb{n}$, the delta is positive when the halfway vector $\pmb{H} = \frac{\overrightarrow{w_i}+\overrightarrow{w_r}}{\lVert \overrightarrow{w_i}+\overrightarrow{w_r} \rVert}$ equals the normal vector $\pmb{n}$. This form will come in handy when dealing with microfacets. This BRDF still conserves energy ([my derivation](/annex/mirror)).

### Specular Microfacet
If you scratch a metal it becomes less mirror-like, polishing makes it more mirror-like.  In scratching the metal we are changing the microscopic surface of the metal. A material's microsurface is very complicated, so the microfacet approximates the surface by choosing a statistical distribution of micronormals which is parameterized by **TODO microsurface, -> summarized by one parameter, roughness**. Rough materials are not flat but rather are "bumpy," roughness can be generalized to all materials. The microfacet model accounts for this bumpiness by treating our area $dA$ as consisting of many smaller planes called microfacet which have random orientations. The normal of a microfacet is called a micronormal $\pmb{m}$, as opposed to the macronormal $\pmb{n}$. We will treat each microfacet as a tiny mirror which follow our mirror BRDF. Materials which are smoother have more micronormals which align with the macronormal, and rougher materials have micronormals in more "random" orientations. If a material is very rough the specular reflections are equal for all directions, which is the same as the diffuse reflections, so the material is perfectly Lambertian.

**TODO no overhangs, caves, weaves etc**


**TODO microfacet picture**


Our overall BRDF is the sum of the contributions of all the microfacets so
\\[
  \begin{align*}
  f_r(\omega_i, \omega_r) &= \int_{\Omega} \rho_m(\pmb{i}, \pmb{r}, \pmb{m}) D(\pmb{m}) G_2(\pmb{i}, \pmb{r}, \pmb{m})\\; \left(\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\\, \left(\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) d\pmb{m} \\\
  \rho_m &= \text{The BRDF for a microfacet oriented at } \pmb{m}\\\
  D      &= \text{The probability density of a micronormal being } \pmb{m}\\\
  G_2    &= \text{Geometry term, the probability that the microfacet } \pmb{m}\\\ 
         & \text{ is visible from both the incident and reflected directions}\\\
  \end{align*}
\\]
where $\Omega$ is still a unit hemisphere but now defined in terms of a unit vector $\pmb{m}$. $\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}$ and $\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}$ are how visible the microfacet is along the incident and refracted directions, accounting for irradiance being directional. This is separate to the geometry term which is the likelihood that a facet is not blocked by another facet.

#### Roughness
We defined roughness as a measure of the microscopic "bumpiness," a more rigorous definition would be the variance in the orientations of the microfacets. Assuming microfacets on average point towards the macronormal, then rougher materials have more micronormals pointing at random. The roughness is usually represented by $\alpha$ which is between $0$ and $1$. Disney suggested a more visually "linear" roughness parameter ${\sqrt{\alpha}}$ used when authoring.

**TODO roughness picture, 0-> flat, 1 -> random direction**

#### Microfacet BRDF

It is common to treat each microfacet as a mirror with perfect reflectance ($\frac{E_r}{E_i} = 1$). From the mirror BRDF derived earlier,
\\[
  \rho_m(\overrightarrow{\omega_i}, \overrightarrow{\omega_r}, \pmb{m}) = k\\, \delta_{\pmb{m}}(\pmb{H}, \pmb{m}),
\\]
where $k$ is some function which ensure energy conservation and $\pmb{H}$ is the halfway vector again. To solve for $k$, our energy conservation integral requires
\\[
  \frac{E_r}{E_i} = \int_{\Omega} k\\, \delta_{\pmb{m}}(\pmb{H}, \pmb{m}) (\pmb{r} \cdot \pmb{n}) d\omega_r = 1,
\\] 

Our delta function means that rather than having to sum over all incoming light, we only care about light coming from a direction our micronormal can reflect (when  $\pmb{H} = \pmb{m}$). For this reason, if the integral can be made in terms of $d\pmb{m}$, not $d\omega_r$ we can solve for $k$. So
\\[
  \int_{\Omega} k\\, \delta_{\pmb{m}}(\pmb{h}, \pmb{m}) (\pmb{r} \cdot \pmb{m})\\; \frac{d\omega_r}{d\omega_m} d\omega_m = 1.
\\]
We now need to find $\frac{d\omega_r}{d\omega_m}$, how $\omega_r$ changes relative to $\omega_m$. The delta function enforces $\pmb{h} = \pmb{m}$, so ${d\omega_m = d\omega_h}$. 

To make the problem simpler we can swap what's changing, that is, for some area on the unit sphere $d\omega_r$ at $\pmb{r}$, what is the corresponding area $d\omega_h$ at $\pmb{h}$, keeping $\pmb{i}$ as a constant vector. We then proceed with a geometric argument which transforms the area $d\omega_r$ onto the corresponding area $d\omega_h$ following the definition of the halfway vector:

\\[
  \pmb{h} = \frac{\pmb{i}+\pmb{r}}{\lVert \pmb{i}+\pmb{r} \rVert}
\\]

So our area at $d\omega_r$ needs to be shifted from  $\pmb{r}$ to $\pmb{i} + \pmb{r}$, then rescaled onto the unit sphere to become $d\omega_h$. 

Shifting $d\omega_r$ to $\pmb{i}+\pmb{r}$ doesn't change the area, but the area no longer lies perpendicular to a sphere, so it needs to be projected onto the sphere with radius $\lVert \pmb{i}+\pmb{r} \rVert$. $d\omega_r$'s normal is $\pmb{r}$ and the outer sphere's normal is $\pmb{h}$ at $\pmb{i}+\pmb{r}$, so the projected area is $dA_{\text{proj}} = (\pmb{r} \cdot \pmb{h}) d\omega_r$. 

We now need to rescale our area $dA$ from the outer sphere onto the unit sphere. The proportion of $dA$ to the outer sphere's surface area is equivalent to the proportion of $d\omega_h$ to the unit sphere's surface area,

\\[
  \frac{dA_{\text{proj}}}{4\pi \lVert \pmb{i}+\pmb{r} \rVert^2} \equiv \frac{d\omega_h}{4\pi}.
\\]
So substituting for $dA$ and rearranging
\\[
  \frac{d\omega_r}{d\omega_m} = \frac{d\omega_r}{d\omega_h} = \frac{\lVert \pmb{i}+\pmb{r} \rVert^2}{\pmb{r} \cdot \pmb{h}}.
\\]
We need to find $\lVert \pmb{i}+\pmb{r} \rVert$, one method is to note that $\pmb{i}+\pmb{r}$ is parallel to $\pmb{h}$ so 
\\[
  \lVert \pmb{i}+\pmb{r} \rVert = \pmb{h} \cdot (\pmb{i}+\pmb{r}) = \pmb{h}\cdot\pmb{i} + \pmb{h}\cdot\pmb{r} = 2 \pmb{r}\cdot\pmb{h}
\\]
Or equivalently, if $\theta$ is the angle between $\pmb{h}$ and $\pmb{r}$, then $2\theta$ is the angle between $\pmb{i}$ and $\pmb{r}$ so
\\[
  \lVert \pmb{i}+\pmb{r} \rVert^2 = \lVert \pmb{i} \rVert^2 + \lVert \pmb{r} \rVert^2 + 2 (\pmb{i} \cdot \pmb{r}) = 2 + 2 \text{cos}(2\theta) = 4 \text{cos}^2 \theta
\\]
Substituting $\lVert \pmb{i}+\pmb{r} \rVert^2$,
\\[
  \frac{d\omega_r}{d\omega_m} = \frac{4 (\pmb{r}\cdot\pmb{h})^2}{\pmb{r}\cdot\pmb{h}} = 4 (\pmb{r}\cdot\pmb{h}),
\\]

Substituting back into our energy conservation integral,
\\[
  \int_{\Omega} k\\, \delta_{\pmb{m}}(\pmb{h}, \pmb{m}) (\pmb{r} \cdot \pmb{m}) (4(\pmb{r}\cdot\pmb{h})) d\omega_m = 1.
\\]
With the delta function enforcing $\pmb{m} = \pmb{h}$,
\\[
  k = \frac{1}{4 (\pmb{r}\cdot\pmb{h})^2} = \frac{1}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})}
\\]

So our microfacet BRDF is
\\[
  \rho_m(\overrightarrow{\omega_i}, \overrightarrow{\omega_r}, \pmb{m}) = \frac{\delta_{\pmb{m}}(\pmb{H}, \pmb{m})}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})},
\\]

Substituting the microfacet BRDF, the overall specular BRDF is
\\[
  \begin{align*}
  f_r(\omega_i, \omega_r) &= \int_{\Omega} \frac{\delta_{\pmb{m}}(\pmb{h}, \pmb{m})}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})} D(\pmb{m}) G_2(\pmb{i}, \pmb{r}, \pmb{m})\\; \left(\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\\, \left(\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) d\pmb{m}. \\\
  \end{align*}
\\]
Again, the delta function eliminates the integral and enforces $\pmb{h} = \pmb{m}$. This make sense intuitively, since we only care about microfacets when they can actually reflect light. So
\\[
  \begin{align*}
    f_r(\omega_i, \omega_r) &= \frac{1}{4 (\pmb{r}\cdot\pmb{h})(\pmb{i}\cdot\pmb{h})} D(\pmb{h}) G_2(\pmb{i}, \pmb{r}, \pmb{h})\\; \left(\frac{\pmb{h} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\\, \left(\frac{\pmb{h} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) \\\ \\\
                            &= \frac{D(\pmb{h})\\, G_2(\pmb{i}, \pmb{r}, \pmb{h})}{4 \lvert\pmb{n} \cdot \pmb{i}\rvert \lvert\pmb{n} \cdot \pmb{r}\rvert}
  \end{align*}
\\]

#### Density Term
If $D$ is the probability density function for $\pmb{m}$, then projected areas of all the micronormals must cover the surface
\\[
  \int_{\Omega} D(\pmb{m}) (\pmb{m} \cdot \pmb{n}) \\,d\omega_m = 1.
\\]
since our model assumes no overhangs. Equivalently,
\\[
  \int_{\Omega} D(\pmb{m}) \\,d\omega_m > 1
\\]
if our surface has any roughness.

#### Geometry Term
Helmoholtz reciprocity tells us that the probability that the microfacet is visible from the incident direction should be the same as the probability it is visible from the reflected direction. So, if $G_1(\overrightarrow{\omega},\pmb{m})$ is the probability that the microfacet is visible from one of these directions and we assume that visibility from $\pmb{r}$ and $\pmb{i}$ are independent (called a height uncorrelated $G_2$) then our geometry term is
\\[
  G_2(\overrightarrow{\omega_i}, \overrightarrow{\omega_r}, \pmb{m}) = G_1(\overrightarrow{\omega_i},\pmb{m}) G_1(\overrightarrow{\omega_r},\pmb{m}).
\\]

### PBR

#### Fresnel Equation
In solving our specular microfacet BRDF we assumed that each microfacet was a perfect mirror, but as discussed when deriving the [Lambertian BRDF](#lambertian) some of the light is not reflected, but rather scattered inside the material. 

The fresnel equation, $F$, is the proportion incident radiance which is reflected specularly (doesn't refract inside material). $F$ depends on the surface normal, light direction, and the index of refraction (IOR) of the incident and refracting mediums. The full Fresnel equation can be computationally expensive, Schlick's approximation is commonly used instead,
\\[
  F(\pmb{i}, \pmb{h}) = F_0 + (1 - F_0)(1 - \pmb{i} \cdot \pmb{h})^5
\\]
where $F_0$ is the colour of the specularly reflected light coming from the normal. The Schlick approximation is a [Padé approximation](https://en.wikipedia.org/wiki/Pad%C3%A9_approximant) (similar to a taylor series) using only the conditions that the reflection should be $F_0$ when incident light is perpendicular and $0$ when incident light is perpendicular. The Schlick approximation has the advantage that the mediums' IOR don't have to be known, only the perpendicular specular colour $F_0$. The derivation of the Schlick approximation is beyond this post but is well explained by the original paper {{< cite "Schlick1994" >}}.

**TODO graphs, Schlick is a good approximation of the true Fresnel when going from air to a dielectric for most materials, but is a poorer approximation of air conductor**

A dialetric's $F_0$ is closer to white, meaning specular reflection is not tinted. A conductor's specular colour is closer to it's "albedo," since the diffuse reflection disappears and the specular must account for the material's colour.

#### Specular and Diffuse
Our final PBR BRDF must combine the specular microfacet with a diffuse reflection. The specular reflection only occurs when light is not transmitted, following the Fresnel equation where the boundary is oriented towards the microfacets $\pmb{h}$,
\\[
  f_{r,s}(\omega_i, \omega_r) = \frac{F(\pmb{i}, \pmb{h})\\, D(\pmb{h})\\, G_2(\pmb{i}, \pmb{r}, \pmb{h})}{4 \lvert\pmb{n} \cdot \pmb{i}\rvert \lvert\pmb{n} \cdot \pmb{r}\rvert}.
\\]
Light which is not specularly reflected is diffusely reflected, which means we have to solve our microfacet BRDF again for the case of a Lambertian microfacet BRDF ($\rho_m = \frac{\rho}{\pi}$). Unfortunately, our microfacet integral
\\[
  \begin{align*}
  f_{r,d}(\omega_i, \omega_r) &= \int_{\Omega} \frac{\rho}{\pi} (1-F(\pmb{i}, \pmb{m})) D(\pmb{m}) G_2(\pmb{i}, \pmb{r}, \pmb{m})\\; \left(\frac{\pmb{m} \cdot \pmb{i}}{\lvert\pmb{n} \cdot \pmb{i}\rvert}\right)\\, \left(\frac{\pmb{m} \cdot \pmb{r}}{\lvert\pmb{n} \cdot \pmb{r}\rvert}\right) d\pmb{m}, \\\
  \end{align*}
\\]
has no closed form solution since there is no longer a delta function to eliminate the integral. It is simpler if we ignore the microfacets for our Lambertian and use our macrofacet normal $\pmb{n}$ instead.

Our final PBR microfacet BRDF is then
\\[
  f_r(\omega_i, \omega_r) = (1-F(\pmb{i}, \pmb{h})) \frac{\rho}{\pi} + F(\pmb{i}, \pmb{h}) \frac{D(\pmb{h})\\, G_2(\pmb{i}, \pmb{r}, \pmb{h})}{4 \lvert\pmb{n} \cdot \pmb{i}\rvert \lvert\pmb{n} \cdot \pmb{r}\rvert}.
\\]

The radiance directed towards the viewer is
\\[
  \pmb{L}(\pmb{p},\omega_r) = \pmb{L_e}(\pmb{p},\omega_o) + \int_{\Omega} f_r(\omega_i, \omega_r) \pmb{L_i}(\pmb{p},\omega_i) (\pmb{i} \cdot \pmb{n}) \\, d\omega_i
\\]

Which can be solved analytically using [IBL](https://en.wikipedia.org/wiki/Image-based_lighting) or with an assumption of analytically light sources such as point sources and directional lights being the only incident radiances, for a set of $S$ analytical light sources

\\[
  \pmb{L}(\pmb{p},\omega_r) = \pmb{L_e}(\pmb{p},\omega_o) + \sum_{L_i \in \Omega} f_r(\omega_i, \omega_r) \pmb{L_i}(\pmb{p},\pmb{i}) (\pmb{i} \cdot \pmb{n})
\\]

**TODO consistent vector and solid angle notation**

## Further Reading
- Nayer et al. developed a microfacet model for diffuse reflection which is more accurate than the Lambertian used here {{<cite "Oren1994">}}.
- Walter et al. applied the microfacet model to refraction in transparent materials {{<cite "Walter2007">}}.
- Sébastien Lagarde's memo has a Mathematica notebook which is helpful for understanding the Fresnel equation and it's approximations ([link](https://seblagarde.wordpress.com/2013/04/29/memo-on-fresnel-equations/)).
- Suggest relevant or interesting articles and I will add them.

## References
{{< bibliography >}}