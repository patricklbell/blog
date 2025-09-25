import { cn } from "@patricklbell/kit";

export interface ArticleBlockProps {
    children: React.ReactNode;
    className?: string;
}

export const ArticleBlock = ({ className, children }: ArticleBlockProps) => {
    return <div className="grid grid-cols-12 max-w-container mx-auto">
        <div className={cn("max-w-none col-span-12 md:col-span-8 md:col-start-3", className)}>
            {children}
        </div>
    </div>
}