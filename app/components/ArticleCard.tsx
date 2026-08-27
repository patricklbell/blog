import { markdownManager } from "@/lib/markdownManager";
import { getHeaderColor } from "@/lib/headerColor";
import { PageCard } from "./PageCard";

interface ArticleCardProps {
    slug: string;
    className?: string;
    priority?: boolean;
}

export const ArticleCard = async ({ slug, className, priority }: ArticleCardProps) => {
    const meta = markdownManager.getArticle(slug);
    const headerLoadingColor = meta.headerLoadingColor ?? await getHeaderColor(meta.imageUrl);
    return <PageCard
        href={meta.url}
        className={className}
        priority={priority}
        {...meta}
        headerLoadingColor={headerLoadingColor}
    />
};
