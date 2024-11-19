import { ArticleBlock, MDX } from "@patricklbell/mdx";
import { createMarkdownPageMetadata, markdownManager } from "../../markdown/markdown";
import { promises as fs } from 'fs';
import { SlugParamsType } from "@/utils";
import { Anchor } from "@patricklbell/kit";
import { articleRelativeUrl } from "@/article/[slug]/info";

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
        <ArticleBlock className="font-sans leading-normal">
            <div className="flex flex-col items-center text-center break-words">
                This is an annex to
                <span>
                    <Anchor href={`${articleRelativeUrl}/${refererSlug}`}>
                        {articleTitle}
                    </Anchor>.
                </span>
            </div>
        </ArticleBlock>
        
        <MDX source={source} assetsUrl={assetsUrl} />
    </article>
}