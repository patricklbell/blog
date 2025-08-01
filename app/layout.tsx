import type { Metadata, Viewport } from "next";
import localFont from "next/font/local";
import "@/globals.css";
import "@patricklbell/mdx/index.css";
import "@patricklbell/kit/index.css";
import { baseUrl } from "./info";
import { BlogLayout } from "./components/BlogLayout";

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
    images: [`${baseUrl}/icon.webp`] 
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
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} font-sans antialiased`}
      >
        <BlogLayout>
          {children}
        </BlogLayout>
      </body>
    </html>
  );
}
