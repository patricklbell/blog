import { utcFormatDateTime } from "@/utils";
import { CodeLink, DemoLink } from "@/components/PageLink";
import { ArticleBlock } from "@patricklbell/mdx";

export interface PageTitleProps {
    publishedTime?: Date,
    title: string,
    description: string,
    codeLink?: string,
    demoLink?: string,
}

export const PageTitle = ({ publishedTime, title, description, codeLink, demoLink }: PageTitleProps) => {
    const showLinks = Boolean(codeLink || demoLink);

    return <ArticleBlock className="font-sans leading-normal">
        <div className="flex flex-col items-center text-center break-words">
            {publishedTime && <p className="max-w-full text-base mb-3 tracking-wide">{utcFormatDateTime(publishedTime)}</p>}
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
}