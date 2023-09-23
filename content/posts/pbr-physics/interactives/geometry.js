init = (modules, scene, gui) => {
  THREE = modules.THREE;

  const camera = new THREE.PerspectiveCamera(50, 1, 1, 10);
  camera.position.z = 3;
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
  const geometry = new THREE.SphereGeometry(0.5, 100, 100);

  uniforms = {
    time: { value: 0.0 },
    alpha: { value: 0.5 },
    mode: { value: 0 },
  };
  const material = new THREE.ShaderMaterial({
    uniforms,
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
    uniform float time;
    uniform float alpha;
    uniform int mode;

    varying vec4 p;
    varying vec3 n;

    void main() {
        vec3 N = normalize(n);
        vec3 L = normalize(vec3(1.0,1.0,1.0));
        vec3 V = normalize(cameraPosition - p.xyz);

        float cLdotN = max(dot(L,N),0.0);
        float cVdotN = max(dot(L,N),0.0);
        
        vec3 color;

        if (mode == 0) {
          // Correlated Exact
          float a2 = alpha*alpha;
          float nom = 2.0 * cLdotN * cVdotN;
          float denom = cVdotN*sqrt(a2 + (1.0 - a2)*cLdotN*cLdotN) + cLdotN*sqrt(a2 + (1.0 - a2)*cVdotN*cVdotN);
          color = vec3(nom / denom);
        } else if (mode == 1) {
          // Correlated Approximation
          float nom = 2.0 * cLdotN * cVdotN;
          float denom = mix(nom, cLdotN + cVdotN, alpha);
          color = vec3(nom / denom);
        } else if (mode == 2) {
          // Uncorrelated Exact
          float a2 = alpha*alpha;
          float nom = 4.0 * cLdotN * cVdotN;
          float denom = (sqrt(a2 + (1.0 - a2)*cLdotN*cLdotN) + cLdotN) * (sqrt(a2 + (1.0 - a2)*cVdotN*cVdotN) + cVdotN);
          color = vec3(nom / denom);
        } else {
          // Uncorrelated Approximation
          float nom = 4.0 * cLdotN * cVdotN;
          float denom = ((2.0 - alpha)*cLdotN + alpha) * ((2.0 - alpha)*cVdotN + alpha);
          color = vec3(nom / denom);
        }

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
  const light = new THREE.DirectionalLight(0x000000);
  light.position.set(0.5, 0.5, 0.5);
  const helper = new THREE.DirectionalLightHelper(light, 0.1);
  scene.add(helper);

  clock = new THREE.Clock();

  const options = {
    mode: 0,
    alpha: 0.5,
  };
  scene.userData.options = options;
  if (gui) {
    gui
      .add(options, "mode", {
        "Correlated Exact": 0,
        "Correlated Approximation": 1,
        "Uncorrelated Exact": 2,
        "Uncorrelated Approximation": 3,
      })
      .name("Geometry");
    gui.add(options, "alpha", 0, 1).name("Alpha");
  }

  scene.userData.update = (scene) => {
    const d = scene.userData;
    d.controls.handleResize();
    d.controls.update();

    dt = clock.getDelta();

    sphere = scene.getObjectByName("sphere");

    sphere.material.uniforms.time.value += dt;
    sphere.material.uniforms.alpha.value = d.options.alpha;
    sphere.material.uniforms.mode.value = d.options.mode;
  };
};
