"use client"

import { SidebarProvider } from "@patricklbell/kit"
import { BlogSidebar } from "./BlogSidebar"
import { BlogHeader } from "./BlogHeader"
import { BlogFooter } from "./BlogFooter"

export interface BlogLayoutProps {
    children: React.ReactNode
}

export const BlogLayout = ({ children }: BlogLayoutProps) => {
  return  <SidebarProvider>
    <BlogHeader className="h-[var(--header-height)] z-[100] w-screen bg-white fixed"/>
    <BlogSidebar />
    <main className="min-h-[calc(100vh-var(--header-height))] flex flex-col justify-between w-full xl:mx-24 mt-[var(--header-height)]">
      <div className="flex flex-col flex-grow w-full mt-8">
        {children}
      </div>
      <BlogFooter />
    </main>
  </SidebarProvider>
}