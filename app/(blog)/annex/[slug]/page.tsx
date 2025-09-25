import { MDX } from "@patricklbell/mdx";
import { createMarkdownPageMetadata, markdownManager } from "../../../lib/markdownManager";
import { promises as fs } from 'fs';
import { SlugParamsType } from "@/lib/utils";
import { articleRelativeUrl } from "@/(blog)/article/[slug]/info";
import { PageAnnexTitle } from "@/components/PageAnnexTitle";

// if a dynamic segment is visited, show 404
export const dynamicParams = false

export async function generateStaticParams() {
    return markdownManager.getAnnexes()
        .map(slug => ({ slug }));;
}

export async function generateMetadata({ params }: SlugParamsType) {
    const slug = (await params).slug
    return createMarkdownPageMetadata(slug);
}

export default async function Article({
    params,
}: SlugParamsType) {
    const slug = (await params).slug

    const { src, assetsUrl, refererSlug } = markdownManager.getAnnex(slug);
    const { title: articleTitle } = markdownManager.getArticle(refererSlug);
    const source = await fs.readFile(process.cwd() + src, 'utf8');

    return <article className="flex flex-col">
        <PageAnnexTitle mainArticleTitle={articleTitle} mainArticleLink={`${articleRelativeUrl}/${refererSlug}`} />
        
        <MDX source={source} assetsUrl={assetsUrl} />
    </article>
}