---
date: "2023-09-10"
title: "Annex: The 4 in PBR"
author: "Patrick Bell"
slug: "pbr-4"
comments: true
skippage: true
tags: [ "Mathematics", "Graphics" ]
_build:
    list: "never"
---

This annex to [Derivation of Physically Based Rendering](/posts/pbr-physics) derives how {{< latex >}}$\omega_r${{< /latex >}} changes relative to {{< latex >}}$\omega_m${{< /latex >}} for a specular microfacet.

The delta function enforces {{< latex >}}$\pmb{h} = \pmb{m}${{< /latex >}}, so {{< latex >}}${d\omega_m = d\omega_h}${{< /latex >}}. 

To make the problem simpler we can swap what's changing, that is, for some area on the unit sphere {{< latex center=true >}}$d\omega_r${{< /latex >}} at {{< latex >}}$\pmb{r}${{< /latex >}}, what is the corresponding area {{< latex center=true >}}$d\omega_h${{< /latex >}} at {{< latex >}}$\pmb{h}${{< /latex >}}, keeping {{< latex >}}$\pmb{i}${{< /latex >}} as a constant vector?

{{<figure src="asy/diagram.svg" alt="Illustration of geometric argument to explain the 4 in PBR">}}

We need to transforms the area {{< latex center=true >}}$d\omega_r${{< /latex >}} onto the corresponding area {{< latex center=true >}}$d\omega_h${{< /latex >}} following the definition of the halfway vector:

```latex
  \pmb{h} = \frac{\pmb{i}+\pmb{r}}{|\pmb{i}+\pmb{r}|}
```

So our area at {{< latex center=true >}}$d\omega_r${{< /latex >}} needs to be shifted from  {{< latex >}}$\pmb{r}${{< /latex >}} to {{< latex >}}$\pmb{i} + \pmb{r}${{< /latex >}}, then rescaled onto the unit sphere to become {{< latex center=true >}}$d\omega_h${{< /latex >}}. 

Shifting {{< latex center=true >}}$d\omega_r${{< /latex >}} to {{< latex >}}$\pmb{i}+\pmb{r}${{< /latex >}} doesn't change the area, but the area no longer lies perpendicular to a sphere, so it needs to be projected onto the sphere with radius {{< latex >}}$|\pmb{i}+\pmb{r}|${{< /latex >}}. {{< latex center=true >}}$d\omega_r${{< /latex >}}'s normal is {{< latex >}}$\pmb{r}${{< /latex >}} and the outer sphere's normal is {{< latex >}}$\pmb{h}${{< /latex >}} at {{< latex >}}$\pmb{i}+\pmb{r}${{< /latex >}}, so the projected area is {{< latex center=true >}}$dA_{\text{proj}} = (\pmb{r} \cdot \pmb{h}) d\omega_r${{< /latex >}}. 

We now need to rescale our area {{< latex >}}$dA${{< /latex >}} from the outer sphere onto the unit sphere. The proportion of {{< latex >}}$dA${{< /latex >}} to the outer sphere's surface area is equivalent to the proportion of {{< latex center=true >}}$d\omega_h${{< /latex >}} to the unit sphere's surface area,

```latex
  \frac{dA_{\text{proj}}}{4\pi |\pmb{i}+\pmb{r}|^2} \equiv \frac{d\omega_h}{4\pi}.
```
So substituting for {{< latex >}}$dA${{< /latex >}} and rearranging
```latex
  \frac{d\omega_r}{d\omega_m} = \frac{d\omega_r}{d\omega_h} = \frac{|\pmb{i}+\pmb{r}|^2}{\pmb{r} \cdot \pmb{h}}.
```
We need to find {{< latex center=true >}}$|\pmb{i}+\pmb{r}|${{< /latex >}}, one method is to note that {{< latex >}}$\pmb{i}+\pmb{r}${{< /latex >}} is parallel to {{< latex >}}$\pmb{h}${{< /latex >}} so 
```latex
  |\pmb{i}+\pmb{r}| = \pmb{h} \cdot (\pmb{i}+\pmb{r}) = \pmb{h}\cdot\pmb{i} + \pmb{h}\cdot\pmb{r} = 2 \pmb{r}\cdot\pmb{h}
```
Or equivalently, if {{< latex >}}$\theta${{< /latex >}} is the angle between {{< latex >}}$\pmb{h}${{< /latex >}} and {{< latex >}}$\pmb{r}${{< /latex >}}, then {{< latex >}}$2\theta${{< /latex >}} is the angle between {{< latex >}}$\pmb{i}${{< /latex >}} and {{< latex >}}$\pmb{r}${{< /latex >}} so
```latex
  |\pmb{i}+\pmb{r}|^2 = |\pmb{i}|^2 + |\pmb{r}|^2 + 2 (\pmb{i} \cdot \pmb{r}) = 2 + 2 \text{cos}(2\theta) = 4 \text{cos}^2 \theta
```
Substituting {{< latex center=true >}}$|\pmb{i}+\pmb{r}|^2${{< /latex >}},
```latex
  \frac{d\omega_r}{d\omega_m} = \frac{4 (\pmb{r}\cdot\pmb{h})^2}{\pmb{r}\cdot\pmb{h}} = 4 (\pmb{r}\cdot\pmb{h}),
```
