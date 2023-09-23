---
date: "2023-09-10"
title: "Annex: Mirror BRDF"
author: "Patrick Bell"
slug: "mirror"
comments: true
skippage: true
tags: [ "Mathematics", "Graphics" ]
_build:
    list: "never"
---

This annex to [Derivation of Physically Based Rendering](/posts/pbr-physics) demonstrates energy conservation for a mirror BRDF.

Define 
```latex
    f_r(\theta_i,\phi_i; \theta_r,\phi_r) = k\\, \delta(\theta_i - \theta_r)\delta(\phi_i + \pi - \phi_r)
```

where {{< latex >}}$k\in[0,1]${{< /latex >}}. Then we need
```latex
    \begin{align*}
        \frac{E_r}{E_i}  &= \int_{\Omega} f_r(\theta_i,\phi_i; \theta_r,\phi_r) \cdot (\omega_r \cdot \pmb{n}) d\omega_r \leq 1\\
                         &= \int_{\phi=0}^{2\pi} \int_{\theta=0}^{\pi/2} k\, \delta(\theta_i - \theta_r)\delta(\phi_i + \pi - \phi_r) \text{cos}\theta \text{sin}\theta d\theta \;d\phi \\
    \end{align*}
```
The delta function "transforms" the integral to a point where {{< latex center=true >}}$\theta_i = \theta_r${{< /latex >}} and {{< latex center=true >}}$\phi_i = \phi_r - \pi${{< /latex >}}. So
```latex
    \begin{align*}
        \frac{E_r}{E_i} = k \text{cos}\theta \text{sin}\theta \leq 1\\
    \end{align*}
```
because {{< latex center=true >}}$\phi_i \in [0,\pi/2]${{< /latex >}}. The mirror BRDF is energy conserving.