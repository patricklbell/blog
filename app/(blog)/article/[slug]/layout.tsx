import * as React from "react";
import { BlogLayout } from "@/components/BlogLayout";
import { markdownManager } from "@/lib/markdownManager";

export default async function RootLayout({
  children, params
}: Readonly<{
  children: React.ReactNode;
  params: Promise<{ slug: string }>;
}>) {
  const { slug } = await params;
  
  const project = markdownManager.getProjectForArticle(slug);

  return <BlogLayout sidebar={{override: project}}>{children}</BlogLayout>;
}
