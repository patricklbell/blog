---
date: "2023-09-10"
title: "Annex: Lambertian BRDF"
author: "Patrick Bell"
slug: "lambertian"
comments: true
skippage: true
tags: [ "Mathematics", "Graphics" ]
katex: true
_build:
    list: "never"
---

This annex to [Derivation of Physically Based Rendering](/posts/pbr-physics) derives an energy conserving Lambertian BRDF.

\\[
    \begin{align*}
        \rho &= \int_{\Omega} f_r \cdot (\omega_r \cdot \pmb{n}) d\omega_r \\\
             &= \int_{\phi=0}^{2\pi} \int_{\theta=0}^{\pi/2} f_r \cdot \text{cos}\theta \text{sin}\theta d\theta \\;d\phi \\\
             &= f_r \int_{\phi=0}^{2\pi} \left( \int_{\theta=0}^{\pi/2} \frac{1}{2} \text{sin}2\theta d\theta \right) \\;d\phi \\\
             &= \frac{1}{2} f_r \int_{\phi=0}^{2\pi} d\phi = \pi f_r
    \end{align*}
\\]
Rearranging for $f_r$,
\\[
    f_r = \frac{\rho}{\pi}
\\]