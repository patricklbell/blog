import { articleBaseUrl } from "@/article/[slug]/info";
import { baseUrl } from "@/info";
import { metadata } from "@/layout";
import { markdownManager } from "@/markdown/markdown"

// route segment configuration
export const dynamic = 'force-static'

export async function GET() {
  const itemsXml = markdownManager.getArticles()
    .map(
      (slug) => {
            const meta = markdownManager.getArticle(slug);
          return `
        <item>
            <title>${meta.title}</title>
            <link>${articleBaseUrl}/${slug}</link>
            <description>${meta.description}</description>
            <pubDate>${meta.publishedTime.toUTCString()}</pubDate>
        </item>`
      })
    .join('\n')

  const rssFeed = `<?xml version="1.0" encoding="UTF-8" ?>
  <rss version="2.0">
    <channel>
        <title>${metadata.title}</title>
        <link>${baseUrl}</link>
        <description>${metadata.description}</description>
        ${itemsXml}
    </channel>
  </rss>`

  return new Response(rssFeed, {
    headers: {
      'Content-Type': 'text/xml',
    },
  })
}