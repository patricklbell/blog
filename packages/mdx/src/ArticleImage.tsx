import { cn } from "@patricklbell/kit";
import { ArticleBlock } from "./ArticleBlock";
import React from "react";

export type ArticleImageProps = React.ImgHTMLAttributes<HTMLImageElement> & {
    children?: React.ReactElement;
    className?: string;
    wide?: boolean;
    priority?: boolean;
};

export const ArticleImage = ({ children, className, wide, priority, ...imgProps }: ArticleImageProps) => {
    const content = <div className="flex flex-col items-center my-16">
        <div
            className={
                cn(
                    'overflow-hidden rounded-md aspect-auto bg-transparent transition-[background] ease-in duration-300',
                    className
                )
            }>
            <picture className="mx-auto">
                <img decoding="async" loading={priority ? "eager" : "lazy"} {...imgProps} />
            </picture>
        </div>
        {children}
    </div>

    if (wide) {
        return content
    }
    return <ArticleBlock>{content}</ArticleBlock>
}