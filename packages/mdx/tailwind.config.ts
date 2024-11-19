import type { Config } from "tailwindcss";
import sharedConfig from "@patricklbell/config-tailwind";

const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  presets: [sharedConfig],
};

export default config;