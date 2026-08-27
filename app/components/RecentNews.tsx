import { markdownManager } from "@/lib/markdownManager";
import { ArticleCard } from "./ArticleCard";

/* The third tile only fits from md up, so mobile shows one less. */
export const NUM_NEWS_PAGES_SM = 2;
export const NUM_NEWS_PAGES_MD = 3;

export const RecentNews = () => {
    const articlesSortedByRecency = markdownManager.getArticles();
    if (articlesSortedByRecency.length < NUM_NEWS_PAGES_MD)
        return <></>

    const newsPages = articlesSortedByRecency.slice(0, NUM_NEWS_PAGES_MD);
    return <section className="w-full max-w-container flex flex-col gap-16">
        <div className="flex flex-col items-center">
            <span className="text-base mb-1 tracking-wide">Home</span>
            <h1 className="text-4xl tracking-tight leading-tight">New Articles</h1>
        </div>
        <div className="w-full grid grid-cols-12 gap-3 md:grid-rows-3">
            {/* @note tailwind is a bit annoying here since we can't use lg:col-span-8 directly because it conflcits with col-start */}
            <div className="col-start-1 col-end-13 md:row-start-1 md:row-span-2">
                <ArticleCard className="md:aspect-video h-full" priority slug={newsPages[0]} />
            </div>
            <div className="col-start-1 col-end-13 md:col-start-1 md:col-end-7 md:row-start-3 md:row-span-1">
                <ArticleCard className="md:aspect-video" priority slug={newsPages[1]} />
            </div>
            <div className="max-md:!hidden md:col-start-7 md:col-end-13 md:row-start-3 md:row-span-1">
                <ArticleCard className="md:aspect-video" priority slug={newsPages[2]} />
            </div>
        </div>
    </section>
}