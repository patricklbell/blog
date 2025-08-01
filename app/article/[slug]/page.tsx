import { MDX, ArticleImage } from "@patricklbell/mdx";
import { createMarkdownPageMetadata, markdownManager } from "../../markdown/markdown";
import { promises as fs } from 'fs';
import { SlugParamsType } from "@/utils";
import { PageTitle } from "@/components/PageTitle";

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

    return <article className="flex flex-col">
        <PageTitle
            title={title}
            description={description}
            publishedTime={publishedTime}
            codeLink={codeLink}
            demoLink={demoLink}
        />
        
        <ArticleImage src={imageUrl} priority />
        <MDX source={source} assetsUrl={assetsUrl} />
    </article>
}