"use client"

import { markdownManager } from "@/lib/markdownManager";
import {
  Sidebar,
  SidebarContent,
  SidebarGroupLabel,
  SidebarGroupContent,
  SidebarGroup,
  SidebarMenu,
  SidebarMenuItem,
  useIsMobile
} from "@patricklbell/kit";
import Link from "next/link";
import * as React from "react";

export interface BlogSidebarContextValue {
  override?: {
    title: string;
    children: {slug: string}[];
  }
}
export const BlogSidebarContext = React.createContext<BlogSidebarContextValue | null>(null);

export function useBlogSidebar() {
  const context = React.useContext(BlogSidebarContext)
  if (!context) {
    throw new Error("useBlogSidebar must be used within a BlogSidebarProvider.")
  }

  return context
}

const MAX_MENU_ITEMS = 3;

interface BlogSidebarMenuItemProps {
  href: string;
  children: React.ReactNode;
}

const BlogSidebarMenuItem = ({ href, children } : BlogSidebarMenuItemProps) => {
  return <SidebarMenu className="hover:bg-gray-50 hover:ring-8 rounded-sm ring-gray-50 my-6">
    <SidebarMenuItem>
      <Link href={href} className="font-semibold">
        <div>
          {children}
        </div>
      </Link>
    </SidebarMenuItem>
  </SidebarMenu>
}

interface BlogMarkdownSidebarMenuItemProps {
  slug: string;
  isProject?: boolean;
}

const BlogMarkdownSidebarMenuItem = ({ slug, isProject } : BlogMarkdownSidebarMenuItemProps) => {
  if (!isProject) {
    const meta = markdownManager.getMetadata(slug);
    const url = meta.url;
    const text = meta.title;
    return <BlogSidebarMenuItem href={url}>{text}</BlogSidebarMenuItem>
  }

  const {title, description, children} = markdownManager.getProject(slug);
  const url = markdownManager.getArticle(children[0].slug)?.url;
  const text = `${title}: ${description}`;

  return <BlogSidebarMenuItem href={url}>{text}</BlogSidebarMenuItem>
}

export const BlogSidebar = () => {
  const articlesSortedByRecency = markdownManager.getArticles();
  const moreArticles = articlesSortedByRecency.length > MAX_MENU_ITEMS;
  const articles = articlesSortedByRecency.slice(0, MAX_MENU_ITEMS);
  const {override} = useBlogSidebar();
  const projects = markdownManager.getProjects();
  const isMobile = useIsMobile();
  
  return (
    <Sidebar variant="inset" >
      <SidebarContent className="bg-white ml-2 mt-[var(--header-height)]">
        <SidebarGroup className={!isMobile ? "mt-32" : ""}>
          {override ? <>
              <SidebarGroupLabel>{override.title}</SidebarGroupLabel>
              <SidebarGroupContent>
                {override.children.map(({slug}) => <BlogMarkdownSidebarMenuItem key={slug} slug={slug}/>)}
              </SidebarGroupContent>
            </> : Boolean(projects?.length) && <>
              <SidebarGroupLabel>Projects</SidebarGroupLabel>
              <SidebarGroupContent>
                {projects.map(slug => <BlogMarkdownSidebarMenuItem key={slug} slug={slug} isProject/>)}
              </SidebarGroupContent>
            </>
          }

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