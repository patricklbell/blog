import Link from "next/link";
import { cn } from "@patricklbell/kit";
import { markdownManager } from "@/lib/markdownManager";
import { ArticleCard } from "./ArticleCard";
import { NUM_NEWS_PAGES_MD, NUM_NEWS_PAGES_SM } from "./RecentNews";

/* The recent grid picks up where <RecentNews/> left off, so no article is shown
   twice, and shows whole rows of tiles. Both of those depend on the layout,
   mobile stacks into one column and only has room for two of the news tiles, so
   each breakpoint gets its own slice of the articles. */
const RECENT_LAYOUTS = [
    { news: NUM_NEWS_PAGES_SM, columns: 1, rows: 2 }, // below md
    { news: NUM_NEWS_PAGES_MD, columns: 2, rows: 1 }, // md
    { news: NUM_NEWS_PAGES_MD, columns: 3, rows: 1 }, // lg and above
];

type RecentLayout = (typeof RECENT_LAYOUTS)[number];
type RecentRange = { start: number, end: number };

const recentRange = ({ news, columns, rows: wanted }: RecentLayout, total: number): RecentRange => {
    /* <RecentNews/> renders nothing when there aren't enough articles to fill
       it, in which case there is nothing to skip. */
    const start = total < NUM_NEWS_PAGES_MD ? 0 : news;
    const available = Math.min(wanted * columns, Math.max(total - start, 0));

    /* Prefer dropping articles over a ragged last row, unless that would leave
       no tiles at all, ie. what is left over is shorter than a single row. */
    const rows = Math.floor(available / columns);
    return { start, end: start + (rows > 0 ? rows * columns : available) };
}

const isEmpty = ({ start, end }: RecentRange) => end <= start;
const contains = ({ start, end }: RecentRange, index: number) => index >= start && index < end;

/* Hides whatever each breakpoint has no room for.
   @note the important modifier is needed because @patricklbell/kit ships its own
   compiled utilities and is imported last, so its plain .block would otherwise
   win the cascade against this app's responsive display utilities. */
const visibility = ([sm, md, lg]: boolean[]) => cn(
    !sm && "max-md:!hidden",
    !md && "md:max-lg:!hidden",
    !lg && "lg:!hidden",
);

interface AllArticlesProps {
    recent?: boolean;
}

export const AllArticles = ({ recent }: AllArticlesProps) => {
    const articlesSortedByRecency = markdownManager.getArticles();
    const ranges = RECENT_LAYOUTS.map(layout => recentRange(layout, articlesSortedByRecency.length));

    /* Every article is already in <RecentNews/>, so there is nothing to show. */
    if (recent && ranges.every(isEmpty))
        return <></>

    const start = Math.min(...ranges.map(({ start }) => start));
    const articles = recent
        ? articlesSortedByRecency.slice(start, Math.max(...ranges.map(({ end }) => end)))
        : articlesSortedByRecency;

    return <section className={cn(
        "w-full max-w-container flex flex-col gap-5 md:gap-10",
        /* A breakpoint whose slice is empty shouldn't be left with a heading. */
        recent && visibility(ranges.map(range => !isEmpty(range))),
    )}>
        <div className="flex flex-row justify-between items-baseline">
            <h2 className="text-2xl">{recent ? "Recent articles" : "All articles"}</h2>
            {recent
                ? <Link
                    href="/articles"
                    className="transition ease-linear duration-200 underline underline-offset-[0.125rem] decoration-gray-400 hover:decoration-black"
                  >
                    All articles
                  </Link>
                : <span>{articlesSortedByRecency.length} articles</span>}
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            {articles.map((slug, index) =>
                <ArticleCard
                    className={cn(
                        "aspect-video",
                        recent ? "md:aspect-[3/4]" : "md:aspect-square",
                        recent && visibility(ranges.map(range => contains(range, start + index))),
                    )}
                    key={slug}
                    slug={slug}
                />
            )}
        </div>
    </section>
}
