import { markdownManager } from "@/markdown/markdown";
import { ArticleCard } from "./ArticleCard";

const NUM_NEWS_PAGES = 3;

export const RecentNews = () => {
    const articlesSortedByRecency = markdownManager.getArticles();
    if (articlesSortedByRecency.length < NUM_NEWS_PAGES)
        return <></>

    const newsPages = articlesSortedByRecency.slice(0, NUM_NEWS_PAGES);
    return <section className="w-full max-w-container flex flex-col gap-16">
        <div className="flex flex-col items-center">
            <span className="text-base mb-1 tracking-wide">Home</span>
            <h1 className="text-4xl tracking-tight leading-tight">New Articles</h1>
        </div>
        <div className="w-full grid grid-cols-12 lg:grid-rows-2 gap-3">
            {/* @note tailwind is a bit annoying here since we can't use lg:col-span-8 directly because it conflcits with col-start */}
            <div className="lg:col-end-9 lg:row-span-2 col-start-1 col-end-13">
                <ArticleCard className="md:aspect-video h-full" priority slug={newsPages[0]} />
            </div>
            <div className="lg:row-start-1 lg:row-end-1 lg:col-start-9 lg:col-end-13 md:col-start-1 md:col-end-7 md:row-start-2 col-start-1 col-end-13">
                <ArticleCard className="md:aspect-video" priority slug={newsPages[1]} />
            </div>
            <div className="lg:row-start-2 lg:row-end-2 lg:col-start-9 lg:col-end-13 md:col-start-7 md:col-end-13 md:row-start-2 col-start-1 col-end-13">
                <ArticleCard className="md:aspect-video" priority slug={newsPages[2]} />
            </div>
        </div>
    </section>
}