import type { Metadata } from "next";
import localFont from "next/font/local";
import "./globals.css";

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
const ebGaramondSansSerif = localFont({
  src: [
    {
      path: './fonts/EBGaramond-VF.ttf',
      style: 'normal',
    },
    {
      path: './fonts/EBGaramond-Italic-VF.ttf',
      style: 'italic',
    },
  ],
  variable: "--font-garamond",
  weight: "100 900",
});

export const metadata: Metadata = {
  title: "Patrick Bell",
  description: "Patrick Bell's blog about graphics, machine learning and software engineering",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} ${ebGaramondSansSerif.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
