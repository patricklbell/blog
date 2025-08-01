import { markdownManager } from "./markdown/markdown"
import { baseUrl } from "./info"
import { MetadataRoute } from "next"

// route segment configuration
export const dynamic = 'force-static'

const toSitemapDate = (dt: Date) => {
  return dt.toISOString().split('T')[0];
}

export default function sitemap(): MetadataRoute.Sitemap {
  const markdown = [
    ...markdownManager.getArticles(),
    ...markdownManager.getAnnexes(),
    ...markdownManager.getProjects()
  ]
    .map(slug => markdownManager.getMetadata(slug))
    .map(({ url, lastModified }) => (lastModified ? {
      url,
      lastModified: toSitemapDate(lastModified),
    } : { url }))

  const routes = [''].map((route) => ({
    url: `${baseUrl}${route}`,
  }))

  return [...markdown, ...routes]
}