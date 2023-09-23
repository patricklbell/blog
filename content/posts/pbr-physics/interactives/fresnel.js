init = (modules, scene, gui) => {
  THREE = modules.THREE;

  const camera = new THREE.PerspectiveCamera(50, 1, 1, 10);
  camera.position.z = 3;
  scene.userData.camera = camera;
  //   scene.background = new THREE.Color(1, 1, 1);

  controls = new modules.TrackballControls(camera, scene.userData.element);
  controls.rotateSpeed = 1.0;
  controls.zoomSpeed = 1.2;
  controls.panSpeed = 0.8;
  controls.maxDistance = 5.0;
  controls.minDistance = 2.5;
  scene.userData.controls = controls;

  // add one random mesh to each scene
  //   const geometry = new THREE.SphereGeometry(1.0, 100, 100);
  //   const geometry = new THREE.IcosahedronGeometry(1.0);
  const geometry = new THREE.TorusKnotGeometry(0.5, 0.2, 200, 20);

  uniforms = { time: { value: 0.0 } };
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

    varying vec4 p;
    varying vec3 n;

    void main() {
        vec3 N = normalize(n);
        vec3 L = -normalize(vec3(0.0,0.0,1.0) - p.xyz);
        vec3 V = normalize(cameraPosition - p.xyz);
        vec3 H = normalize(V + L);

        float cLdotH = max(dot(L,H), 0.0);

        vec3 F0 = vec3(0.01);
        vec3 color = F0 + (1.0-F0)*pow(1.0 - cLdotH, 5.0);

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
  const light = new THREE.PointLight(0xffffff);
  light.position.set(0, 0, 1.0);
  const helper = new THREE.PointLightHelper(light, 0.1);
  scene.add(helper);

  clock = new THREE.Clock();

  scene.userData.update = (scene) => {
    scene.userData.controls.handleResize();
    scene.userData.controls.update();

    dt = clock.getDelta();

    sphere = scene.getObjectByName("sphere");

    sphere.material.uniforms["time"].value += dt;
  };
};
