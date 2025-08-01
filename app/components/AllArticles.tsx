import { markdownManager } from "@/markdown/markdown";
import { ArticleCard } from "./ArticleCard";

export const AllArticles = () => {
    const articlesSortedByRecency = markdownManager.getArticles();    

    return <section className="w-full max-w-container flex flex-col gap-5 md:gap-10">
        <div className="flex flex-row justify-between items-baseline">
            <h2 className="text-2xl">All articles</h2>
            <span>{articlesSortedByRecency.length} articles</span>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            {articlesSortedByRecency.map(slug => 
                <ArticleCard className="aspect-video md:aspect-[3/4]" key={slug} slug={slug} />
            )}
        </div>
    </section>
}