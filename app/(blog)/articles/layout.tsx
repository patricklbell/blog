import { BlogLayout } from "@/components/BlogLayout";

export default function RootLayout({
  children
}: Readonly<{
  children: React.ReactNode;
}>) {
  return <BlogLayout>{children}</BlogLayout>;
}
