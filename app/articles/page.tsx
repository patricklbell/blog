import { Metadata } from "next";
import { baseUrl } from "@/info";
import { AllArticles } from "@/components/AllArticles";

export const metadata: Metadata = {
    title: "Articles",
    description: "Archive of all articles.",
    openGraph: {
        images: [`${baseUrl}/home.webp`],
        title: "Articles",
        description: "Archive of all articles.",
    },
}

export default async function Articles() {
    return <div className="w-full flex flex-col items-center">
        <AllArticles />
    </div>
}