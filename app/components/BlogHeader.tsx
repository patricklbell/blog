import { SidebarTrigger } from "@patricklbell/kit";
import Link from "next/link";

export interface BlogHeaderProps {
    className?: string;
}

export const BlogHeader = ({ className }: BlogHeaderProps) => {
    return <header className={className}>
        <div className="h-full flex flex-col justify-center">
            <nav aria-label="Main" data-orientation="horizontal" dir="ltr" className="flex flex-row">
                <div className="flex flex-row items-center gap-8 justify-center w-[var(--sidebar-width)]">
                    <Link href="/" aria-label="Home">
                        <span className="text-2xl font-bold text-balance tracking-tight leading-tight hyphen-auto">Patrick Bell</span>
                    </Link>
                    <SidebarTrigger />
                </div>
            </nav>
        </div>
    </header>
}