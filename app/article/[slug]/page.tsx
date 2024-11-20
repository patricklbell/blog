import { ArticleBlock, MDX } from "@patricklbell/mdx";
import { createMarkdownPageMetadata, markdownManager } from "../../markdown/markdown";
import { promises as fs } from 'fs';
import { CodeLink, DemoLink } from "../../components/PageLink";
import { ArticleImage } from "../../../packages/mdx/src/ArticleImage";
import { SlugParamsType, utcFormatDateTime } from "@/utils";

// if a dynamic segment is visited, show 404
export const dynamicParams = false

export async function generateStaticParams() {
    return markdownManager.getArticles()
        .map(slug => ({ slug }));
}

export async function generateMetadata({ params }: SlugParamsType) {
    const slug = (await params).slug
    return createMarkdownPageMetadata(slug);
}

export default async function Article({
    params,
}: SlugParamsType) {
    const slug = (await params).slug

    const { src, title, publishedTime, description, codeLink, demoLink, imageUrl, assetsUrl } = markdownManager.getArticle(slug);
    const source = await fs.readFile(process.cwd() + src, 'utf8');

    const showLinks = Boolean(codeLink || demoLink);

    return <article className="flex flex-col">
        <ArticleBlock className="font-sans leading-normal">
            <div className="flex flex-col items-center text-center break-words">
                <p className="max-w-full text-base mb-3 tracking-wide">{utcFormatDateTime(publishedTime)}</p>
                <h1 className="max-w-full text-7xl text-balance tracking-tight leading-tight hyphen-auto">{title}</h1>
                <div className="max-w-full text-xl text-balance mt-6">{description}</div>
                {showLinks && (
                <div className="max-w-full flex flex-row gap-1 justify-center mt-9">
                    {demoLink && <DemoLink src={demoLink}/>}
                    {codeLink && <CodeLink src={codeLink}/>}
                </div>
                )}
            </div>
        </ArticleBlock>
        
        <ArticleImage src={imageUrl} priority />
        <MDX source={source} assetsUrl={assetsUrl} />
    </article>
}