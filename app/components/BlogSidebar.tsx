import { markdownManager } from "@/markdown/markdown";
import {
  Sidebar,
  SidebarContent,
  SidebarGroupLabel,
  SidebarGroupContent,
  SidebarGroup,
  SidebarMenu,
  SidebarMenuItem
} from "@patricklbell/kit";
import Link from "next/link";

const MAX_MENU_ITEMS = 3;

interface BlogSidebarMenuItemProps {
  href: string;
  children: React.ReactNode;
}

const BlogSidebarMenuItem = ({ href, children } : BlogSidebarMenuItemProps) => {
  return <SidebarMenu className="my-2">
    <SidebarMenuItem>
      <Link href={href}>
        <div>
          {children}
        </div>
      </Link>
    </SidebarMenuItem>
  </SidebarMenu>
}

interface BlogMarkdownSidebarMenuItemProps {
  slug: string;
}

const BlogMarkdownSidebarMenuItem = ({ slug } : BlogMarkdownSidebarMenuItemProps) => {
  const meta = markdownManager.getMetadata(slug);
  let url = meta.url;
  let text = meta.title;

  if (meta.type == 'project') {
    if (meta.article) {
      url = markdownManager.getArticle(meta.article)?.url;
    }
    text = `${meta.title}: ${meta.description}`;
  }

  return <BlogSidebarMenuItem href={url}>{text}</BlogSidebarMenuItem>
}

export const BlogSidebar = () => {
  const articlesSortedByRecency = markdownManager.getArticles();
  const moreArticles = articlesSortedByRecency.length > MAX_MENU_ITEMS;
  const articles = articlesSortedByRecency.slice(0, MAX_MENU_ITEMS);

  const projects = markdownManager.getProjects(true);
  
  return (
    <Sidebar variant="inset" >
      <SidebarContent className="bg-white mt-[var(--header-height)]">
        <SidebarGroup>
          {Boolean(projects?.length) && <>
            <SidebarGroupLabel>Projects</SidebarGroupLabel>
            <SidebarGroupContent>
              {projects.map(slug => <BlogMarkdownSidebarMenuItem key={slug} slug={slug}/>)}
            </SidebarGroupContent>
          </>}

          {Boolean(articles?.length) && <>
            <SidebarGroupLabel>Recent articles</SidebarGroupLabel>
            <SidebarGroupContent>
              {articles.map(slug => <BlogMarkdownSidebarMenuItem key={slug} slug={slug}/>)}
              {moreArticles && <BlogSidebarMenuItem href='/articles'>All articles</BlogSidebarMenuItem>}
            </SidebarGroupContent>
          </>}
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  )
}