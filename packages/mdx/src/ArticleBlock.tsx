import { cn } from "@patricklbell/kit";

export interface ArticleBlockProps {
    children: React.ReactNode;
    className?: string;
}

export const ArticleBlock = ({ className, children }: ArticleBlockProps) => {
    return <div className="grid grid-cols-12 max-w-container mx-auto">
        {/*
          * min-w-0 is load bearing. A grid item defaults to min-width:auto, which
          * resolves to the min-content width of its contents, so a wide child such
          * as a code block or a display equation would stretch the column and push
          * the page sideways. With min-width:0 the column keeps its size and the
          * child's own overflow-x takes over.
          */}
        <div className={cn("max-w-none min-w-0 col-span-12 md:col-span-8 md:col-start-3", className)}>
            {children}
        </div>
    </div>
}