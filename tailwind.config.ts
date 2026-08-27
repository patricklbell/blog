// tailwind config is required for editor support

import type { Config } from "tailwindcss";
import sharedConfig from "@patricklbell/config-tailwind";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    // @patricklbell/mdx is transpiled into this app rather than shipping its own
    // stylesheet, so Tailwind has to scan it from here. Without this its
    // utilities are silently dropped: overflow-x-auto on a code block emits no
    // rule at all, and long lines push the page sideways instead of scrolling.
    // (@patricklbell/kit builds its own dist/index.css and is left out.)
    "./packages/mdx/src/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  presets: [sharedConfig],
};

export default config;