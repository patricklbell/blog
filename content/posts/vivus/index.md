---
date: "2023-04-26"
title: "Using Vivus with React"
author: "Patrick Bell"
slug: "vivus"
comments: true
tags: [ "React" ]
caption: "A component to use the Vivus library with React"
---
I wanted to use to animated an SVG in React using [Vivus](https://www.npmjs.com/package/vivus). The problem is Vivus is designed around vanilla javascript, there is [react-vivus](https://www.npmjs.com/package/react-vivus), but it comes with styling which will not work if you are using tailwindcss (or other postcss). For anyone looking for something better, here's a simple component to animate an SVG with Vivus.
 
```js
import { useEffect, useId } from 'react';
import Vivus from 'vivus';

const AnimatedSvg = ({ config, resize = true, as: As, ...otherProps }) => {
  const id = useId();

  useEffect(() => {
    const vivusObject = new Vivus(id, config);

    if (resize) {
      // Create your observer and set up a callback on resize
      const resizeObserver = new ResizeObserver(() => {
        // Recalculate the line lengths
        vivusObject.recalc();
      });
      resizeObserver.observe(vivusObject.el);
    }
  }, []);

  return <As id={id} {...otherProps} />;
};

export default AnimatedSvg;
```

The observer allows scaling SVG transforms (see the [Vivus documentation](https://github.com/maxwellito/vivus#non-scaling)).