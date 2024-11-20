import type { Metadata, Viewport } from "next";
import localFont from "next/font/local";
import "@/globals.css";
import "@patricklbell/mdx/index.css";
import "@patricklbell/kit/index.css";
import Link from "next/link";
import { SiGithub, SiLinkedin } from "@icons-pack/react-simple-icons";
import { ArticleBlock } from "@patricklbell/mdx";
import Image from "next/image";
import { baseUrl } from "./info";

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});
const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

export const metadata: Metadata = {
  title: "Patrick Bell's Personal Website",
  description: "Patrick Bell's personal website covering graphics, machine learning and software engineering topics.",
  keywords: ["Graphics", "Mathematics", "Research", "Explanation", "Software Engineering"],
  openGraph: {
    type: "website",
    title: "Patrick Bell's Personal Website",
    siteName: "Patrick Bell's Personal Website",
    description: "Patrick Bell's personal website covering graphics, machine learning and software engineering topics.",
    url: baseUrl,
    images: [`${baseUrl}/home.webp`] 
  },
};

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1.0,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const currentYear = (new Date()).getFullYear();
  
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} font-sans antialiased`}
      >
        <header className="z-[100] top-0 w-full my-6">
          <ArticleBlock>
            <nav aria-label="Main" data-orientation="horizontal" dir="ltr" className="flex flex-row justify-center">
              <Link href="/" aria-label="Home">
                <Image width="32" height="32" src="/home.webp" alt="Icon" />
              </Link>
            </nav>
          </ArticleBlock>
        </header>
        <main>
          {children}
        </main>
        <footer className="mt-40 mb-8">
          <div className="flex flex-row justify-between max-w-container items-center">
            <span className="leading-taut text-sm">Patrick Bell, CC0 {2022}-{currentYear}</span>
            <div className="flex flex-row items-center gap-4">
              <Link target="_blank" href="https://github.com/patricklbell/" aria-label="Github">
                <SiGithub />
              </Link>
              <Link target="_blank" href="https://au.linkedin.com/in/patrick-bell-b9b478272" aria-label="LinkedIn">
                <SiLinkedin />
              </Link>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
