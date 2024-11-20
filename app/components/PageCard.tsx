import Link from "next/link";
import { cn } from "@patricklbell/kit";
import { utcFormatDateTime } from "@/utils";
import Image from "next/image";

type PageCardProps = {
    title: string;
    publishedTime: Date;
    headerLoadingColor: string;
    imageUrl: string;
    href: string;
    className?: string;
    priority?: boolean;
};

export const PageCard = ({ title, publishedTime, imageUrl, headerLoadingColor, href, className, priority } : PageCardProps) => {
    return (
        <Link
            className={cn("group text-white block relative w-full max-w-full rounded-md aspect-[3/4] overflow-hidden", className)}
            style={{backgroundColor: headerLoadingColor}}
            href={href}
            aria-label={title}
        >
            <div className="absolute inset-5 z-10">
                <div className="w-full absolute top-0 left-0">
                    <span className="text-sm block leading-snug break-none truncate">
                        {utcFormatDateTime(publishedTime, true)}
                    </span>
                </div>
                <div className="absolute bottom-0 left-0 text-balance">
                    <span className="line-clamp-4 text-lg leading-snug text-balance">
                        {title}
                    </span>
                </div>
            </div>
            <Image priority={priority} src={imageUrl} width={1366} height={768} alt={`${title} > cover image`} className="object-cover w-full h-full inset-0 transition-transform ease-in-out duration-150 group-hover:scale-110 text-[0]"/>
        </Link>
    )
}