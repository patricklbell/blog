init = (modules, scene, gui) => {
  THREE = modules.THREE;

  const camera = new THREE.PerspectiveCamera(50, 0.1, 1, 10);
  camera.position.z = 4;
  scene.userData.camera = camera;
  // scene.background = new THREE.Color(1, 1, 1);

  controls = new modules.TrackballControls(camera, scene.userData.element);
  controls.rotateSpeed = 1.0;
  controls.zoomSpeed = 1.2;
  controls.panSpeed = 0.8;
  controls.maxDistance = 5.0;
  controls.minDistance = 2.5;
  scene.userData.controls = controls;

  // add one random mesh to each scene
  const geometry = new THREE.TorusKnotGeometry(0.5, 0.2, 200, 20);

  const material = new THREE.ShaderMaterial({
    uniforms: {
      time: { value: 0.0 },
      alpha: { value: 0.5 },
      dir_radiance: { value: 1.0 },
      point_radiance: { value: 1.0 },
      D_mode: { value: 0 },
      G2_mode: { value: 0 },
      albedo: { value: new THREE.Vector3(0.4, 0.4, 0.8) },
      specular: { value: new THREE.Vector3(0.01) },
      emissive: { value: new THREE.Vector3(0.0) },
    },
    vertexShader: `
    varying vec4 p;
    varying vec3 n;

    void main() {
        p = modelMatrix * vec4(position, 1.0 );
        n = normal;
        gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
    }
`,
    fragmentShader: `
    #define M_PI   3.14159265358979323846264338327950288
    #define EPSILON 1.19209e-07

    uniform float time;

    uniform int G2_mode;
    uniform int D_mode;
    uniform float alpha;
    uniform float dir_radiance;
    uniform float point_radiance;
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

    // Λ = (1 - G1) / G1,
    // see "Understanding the Masking-Shadowing Function in Microfacet-Based BRDF"
    // https://jcgt.org/published/0003/02/03/paper.pdf
    float A_Beckmann(float cXdotN) {
      float a = 1.0 / (alpha*sqrt(1.0 / (cXdotN*cXdotN + EPSILON) - 1.0) + EPSILON);
      float a2 = a*a;

      return (a < 1.6) ? ((1.0 - 1.259*a + 0.396*a2) / (3.535*a + 2.181*a2)) : 0.0;
    }

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
        float D;
        if (D_mode == 0) {D = D_GGX(HdotN);}
        else             {D = D_Beckmann(HdotN);}

        float G2;
        if (D_mode == 0) {
          if (G2_mode == 0)      {G2 = G2_GGX_uncorr(cLdotN, cVdotN);}
          else                   {G2 = G2_GGX_corr(cLdotN, cVdotN);}
        } else {
          if (G2_mode == 0)      {G2 = G2_Beckmann_uncorr(cLdotN, cVdotN);}
          else                   {G2 = G2_Beckmann_corr(cLdotN, cVdotN);}
        }

        vec3 brdf_s = F*D*G2 / (4.0 * cLdotN * cVdotN + EPSILON);
        vec3 brdf_d = (1.0 - F) * albedo / M_PI;

        return (brdf_s + brdf_d)*radiance*cLdotN;
    }

    void main() {
        vec3 N = normalize(n);
        vec3 V = normalize(cameraPosition - p.xyz);
        float cVdotN = max(dot(V,N),0.0);

        vec3 L_dir = L_r(N, V, cVdotN, normalize(vec3(1.0,1.0,1.0)), dir_radiance);
        // vec3 L_point = L_r(N, V, cVdotN, normalize(vec3(1.5*cos(time),0.0,1.5*sin(time))-p.xyz), point_radiance);
        vec3 color = emissive + L_dir;

        const float gamma = 2.2;
        color = color / (color + vec3(1.0));
        color = pow(color, vec3(1.0 / gamma)); // Gamma-correction

        gl_FragColor = vec4(color, 1.0);
    }
`,
  });

  sphere = new THREE.Mesh(geometry, material);
  sphere.name = "sphere";
  scene.add(sphere);

  //   var geo = new THREE.EdgesGeometry(sphere.geometry); // or WireframeGeometry
  //   var mat = new THREE.LineBasicMaterial({ color: 0xeeeeee, linewidth: 3 });
  //   var wireframe = new THREE.LineSegments(geo, mat);
  //   sphere.add(wireframe);

  // Fake light for helper
  const dir_light = new THREE.DirectionalLight(0x000000);
  dir_light.position.set(1.0, 1.0, 1.0);
  const dir_helper = new THREE.DirectionalLightHelper(dir_light, 0.1);
  scene.add(dir_helper);

  // const point_light = new THREE.PointLight(0x000000);
  // point_light.position.set(0.0, 0.0, 0.0);
  // point_light.name = "pointlight";
  // scene.add(point_light);
  // const point_helper = new THREE.PointLightHelper(point_light, 0.1);
  // point_helper.name = "pointlighthelper";
  // scene.add(point_helper);

  clock = new THREE.Clock();

  const options = {
    roughness: 0.6,
    dir_radiance: 5.0,
    point_radiance: 5.0,
    D_mode: 0,
    G2_mode: 1,
    albedo: [0.3, 0.4, 0.8],
    specular: [0.6, 0.6, 0.6],
    emissive: [0.05, 0.05, 0.05],
  };
  scene.userData.options = options;
  if (gui) {
    gui.add(options, "roughness", 0.0001, 1).name("Roughness");
    gui.add(options, "dir_radiance", 0, 50.0).name("Directional Radiance");
    // gui.add(options, "point_radiance", 0, 50.0).name("Point Radiance");
    gui.addColor(options, "albedo").name("Diffuse Albedo");
    gui.addColor(options, "specular").name("Specular Reflection");
    gui.addColor(options, "emissive").name("Emissive Radiance");
    gui
      .add(options, "D_mode", { "GGX (Trowbridge-Reitz)": 0, Beckmann: 1 })
      .name("Distribution");
    gui
      .add(options, "G2_mode", { Uncorrelated: 0, Correlated: 1 })
      .name("Geometry");
  }

  scene.userData.update = (scene) => {
    const d = scene.userData;
    d.controls.handleResize();
    d.controls.update();

    dt = clock.getDelta() * 0.2;

    sphere = scene.getObjectByName("sphere");

    sphere.material.uniforms.time.value += dt;
    sphere.material.uniforms.alpha.value =
      d.options.roughness * d.options.roughness;
    sphere.material.uniforms.dir_radiance.value = d.options.dir_radiance;
    sphere.material.uniforms.point_radiance.value = d.options.point_radiance;
    sphere.material.uniforms.albedo.value = new THREE.Vector3(
      ...d.options.albedo
    );
    sphere.material.uniforms.specular.value = new THREE.Vector3(
      ...d.options.specular
    );
    sphere.material.uniforms.emissive.value = new THREE.Vector3(
      ...d.options.emissive
    );
    sphere.material.uniforms.D_mode.value = d.options.D_mode;
    sphere.material.uniforms.G2_mode.value = d.options.G2_mode;

    // const time = sphere.material.uniforms.time.value;
    // const pointlight = scene.getObjectByName("pointlight");
    // pointlight.position.set(1.5 * Math.cos(time), 0.0, 1.5 * Math.sin(time));
    // scene.getObjectByName("pointlighthelper").update();
  };
};
