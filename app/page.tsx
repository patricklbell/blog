import { markdownManager } from "./markdown/markdown";
import { PageCard } from "./components/PageCard";
import { articleRelativeUrl } from "./article/[slug]/info";
import { Metadata } from "next";
import { baseUrl } from "./info";

const NUM_NEWS_PAGES = 3;

interface ArticleCardProps {
    slug: string;
    className?: string;
    priority?: boolean;
}
const ArticleCard = ({ slug, className, priority }: ArticleCardProps) => {
    const meta = markdownManager.getArticle(slug);
    return <PageCard href={`${articleRelativeUrl}/${slug}`} className={className} priority={priority} {...meta} />
};

export const metadata: Metadata = {
    title: "New Articles and Archive",
    description: "Home page which shows new articles and archive.",
    openGraph: {
        images: [`${baseUrl}/home.webp`],
        title: "New Articles and Archive",
        description: "New articles and archive of Patrick Bell's personal website.",
    },
}

export default async function Home() {
    const articlesSortedByRecency = markdownManager.getArticles();
    const showNews = articlesSortedByRecency.length >= NUM_NEWS_PAGES;
    const newsPages = articlesSortedByRecency.slice(0, NUM_NEWS_PAGES);

    return <div className="w-full flex flex-col items-center justify-between gap-16">
        {showNews && (
            <section className="w-full max-w-container flex flex-col gap-16">
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
        )}
        <section className="w-full max-w-container flex flex-col gap-5 md:gap-10">
            <div className="flex flex-row justify-between items-baseline">
                <h2 className="text-2xl">Browse more</h2>
                <span>{articlesSortedByRecency.length} articles</span>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                {articlesSortedByRecency.map(slug => 
                    <ArticleCard className="aspect-video md:aspect-[3/4]" key={slug} slug={slug} />
                )}
            </div>
        </section>
    </div>
}