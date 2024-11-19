import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'export',
  distDir: 'dist',
  reactStrictMode: true,
  transpilePackages: ['@patricklbell/mdx'],
  images: { unoptimized: true },
};

export default nextConfig
