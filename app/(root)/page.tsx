import { Metadata } from "next";
import { baseUrl } from "@/lib/info";
import { RecentNews } from "@/components/RecentNews";
import { AllArticles } from "@/components/AllArticles";
import { BlogLayout } from "../components/BlogLayout";

export const metadata: Metadata = {
    title: "New Articles and Archive",
    description: "Home page which shows new articles and archive.",
    openGraph: {
        images: [`${baseUrl}/home.webp`],
        title: "New Articles and Archive",
        description: "Home page which shows new articles and archive.",
    },
}

export default async function Home() {
    return <BlogLayout>
        <div className="w-full flex flex-col items-center justify-between gap-16">
            <RecentNews />
            <AllArticles recent />
        </div>
    </BlogLayout>
}