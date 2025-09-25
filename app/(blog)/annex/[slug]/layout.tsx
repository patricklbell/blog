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
  
  const articleSlug = markdownManager.getAnnex(slug).refererSlug;
  const article = markdownManager.getArticle(articleSlug);
  const annexes = markdownManager.getArticleReferrers(articleSlug);

  return <BlogLayout
    sidebar={{override: {
      title: article.title,
      children: annexes.map((annex) => ({ slug: annex }))
    }}}
  >
      {children}
  </BlogLayout>;
}
