import { ArticleBlock } from "@patricklbell/mdx";
import { Anchor } from "@patricklbell/kit";

export interface PageAnnexTitleProps {
    mainArticleTitle: string,
    mainArticleLink: string,
}

export const PageAnnexTitle = ({ mainArticleTitle, mainArticleLink }: PageAnnexTitleProps) => {
    return <ArticleBlock className="font-sans leading-normal">
        <div className="flex flex-col items-center text-center break-words">
            This is an annex to
            <span>
                <Anchor href={mainArticleLink}>
                    {mainArticleTitle}
                </Anchor>.
            </span>
        </div>
    </ArticleBlock>
}