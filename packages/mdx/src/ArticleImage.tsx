import { cn } from "@patricklbell/kit";
import { ArticleBlock } from "./ArticleBlock";
import React from "react";

export type ArticleImageProps = React.ImgHTMLAttributes<HTMLImageElement> & {
    children?: React.ReactElement;
    className?: string;
    wide?: boolean;
    /**
     * Sets the caption beside the figure rather than beneath it, for figures
     * that are tall and narrow and would otherwise sit in a column of empty
     * space.
     *
     * The caption must be passed as `caption`, not as children: children are
     * markdown, so MDX wraps them in the same ArticleBlock every other block
     * gets, which would re-apply the page grid inside the caption.
     */
    aside?: boolean;
    caption?: React.ReactNode;
    /**
     * Overrides whether the figure is scaled to the width of the text column.
     * Defaults on for vector sources, whose authored size is arbitrary, and off
     * for raster ones, which would be scaled past their resolution.
     */
    scale?: boolean;
    priority?: boolean;
};

export const ArticleImage = ({ children, caption, className, wide, aside, scale, priority, ...imgProps }: ArticleImageProps) => {
    const isVector = typeof imgProps.src === 'string' && imgProps.src.endsWith('.svg');
    const fill = scale ?? isVector;

    const picture = <div
        className={
            cn(
                'overflow-hidden rounded-md aspect-auto bg-transparent transition-[background] ease-in duration-300',
                // A scaled figure stops short of the column so that `wide`, which
                // breaks out of it, is a visible step up rather than a few percent.
                fill && (wide ? 'w-full' : 'w-full px-4 sm:px-10'),
                className
            )
        }>
        <picture className="mx-auto">
            <img
                decoding="async"
                loading={priority ? "eager" : "lazy"}
                // A vector figure's authored size is a drawing-unit artefact, not
                // a layout decision, so it is scaled to the column it sits in.
                // max-w-full alone keeps a raster figure from overflowing.
                className={fill ? 'w-full h-auto' : 'max-w-full h-auto'}
                {...imgProps}
            />
        </picture>
    </div>

    if (aside) {
        return <ArticleBlock>
            <div className="flex flex-col sm:flex-row sm:items-center gap-6 sm:gap-10 my-16">
                <div className="shrink-0 sm:basis-2/5">{picture}</div>
                {/* min-w-0 stops a long caption widening the row past the column. */}
                <div className="min-w-0">{caption ?? children}</div>
            </div>
        </ArticleBlock>
    }

    const content = <div className="flex flex-col items-center my-16">
        {picture}
        {children}
    </div>

    if (wide) {
        return content
    }
    return <ArticleBlock>{content}</ArticleBlock>
}
