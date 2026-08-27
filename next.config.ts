import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'export',
  distDir: 'dist',
  reactStrictMode: true,
  transpilePackages: ['@patricklbell/mdx'],
  // sharp is a native module; keep it out of the bundler.
  serverExternalPackages: ['sharp'],
  images: { unoptimized: true },
};

export default nextConfig
