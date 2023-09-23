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

  const material = new THREE.ShaderMaterial({
    uniforms: {
      time: { value: 0.0 },
      alpha: { value: 0.5 },
      mode: { value: 1 },
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
    uniform float alpha;
    uniform int mode;

    varying vec4 p;
    varying vec3 n;

    void main() {
        vec3 N = normalize(n);
        vec3 L = normalize(vec3(1.0,1.0,1.0));
        vec3 V = normalize(cameraPosition - p.xyz);
        vec3 H = normalize(L + V);

        float HdotN = dot(H,N);
        
        vec3 color = vec3(0.0);

        float a2 = alpha*alpha;
        float c2 = HdotN*HdotN;
        if (mode == 0) {
          // Beckmann
          if (HdotN > 0.0) {
            float t2 = 1.0/(c2+EPSILON) - 1.0;
            float nom = exp(-t2/a2);
            float denom = M_PI*a2*c2*c2+EPSILON;
            color = vec3(nom / denom);
          }
        } else {
          // GGX (Trowbridge-Reitz)
          float nom = a2;
          float denom = M_PI*(c2 * (a2 - 1.0) + 1.0)*(c2 * (a2 - 1.0) + 1.0)+EPSILON;
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
    mode: 1,
    alpha: 0.5,
  };
  scene.userData.options = options;
  if (gui) {
    gui
      .add(options, "mode", {
        Beckmann: 0,
        "GGX (Trowbridge-Reitz)": 1,
      })
      .name("Distribution");
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
