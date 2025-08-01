import { markdownManager } from "@/markdown/markdown";
import { PageCard } from "./PageCard";

interface ArticleCardProps {
    slug: string;
    className?: string;
    priority?: boolean;
}

export const ArticleCard = ({ slug, className, priority }: ArticleCardProps) => {
    const meta = markdownManager.getArticle(slug);
    return <PageCard href={meta.url} className={className} priority={priority} {...meta} />
};