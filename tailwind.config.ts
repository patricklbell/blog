// tailwind config is required for editor support

import type { Config } from "tailwindcss";
import sharedConfig from "@patricklbell/config-tailwind";

const config: Config = {
  content: ["./app/**/*.{js,ts,jsx,tsx,mdx}"],
  presets: [sharedConfig],
};

export default config;