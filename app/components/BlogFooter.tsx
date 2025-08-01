import { SiGithub, SiLinkedin } from "@icons-pack/react-simple-icons";
import { cn } from "@patricklbell/kit";
import Link from "next/link";

export interface BlogFooterProps {
    className?: string;
}

export const BlogFooter = ({ className }: BlogFooterProps) => {
    const currentYear = (new Date()).getFullYear();

    return <footer className={cn("mt-40 mb-8", className)}>
        <div className="flex flex-row justify-between max-w-container items-center">
        <span className="leading-taut text-sm">Patrick Bell, CC0 {2022}-{currentYear}</span>
        <div className="flex flex-row items-center gap-4">
            <Link target="_blank" href="https://github.com/patricklbell/" aria-label="Github">
            <SiGithub />
            </Link>
            <Link target="_blank" href="https://au.linkedin.com/in/patrick-bell-b9b478272" aria-label="LinkedIn">
            <SiLinkedin />
            </Link>
        </div>
        </div>
    </footer>
}