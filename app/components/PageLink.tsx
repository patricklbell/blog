import { Button } from "@patricklbell/kit";
import { ArrowUpRightIcon } from "lucide-react";

type PageLinkProps = {
    src: string
};

export const CodeLink = ({ src }: PageLinkProps) => {
    return <Button asChild>
        <a href={src} target="_blank">
            View code
            <ArrowUpRightIcon/>
            <span className="sr-only">(Opens in a new tab)</span>
        </a>
    </Button>
}

export const DemoLink = ({ src }: PageLinkProps) => {
    return <Button variant="invert" asChild>
        <a href={src} target="_blank">
            View demo
            <ArrowUpRightIcon/>
            <span className="sr-only">(Opens in a new tab)</span>
        </a>
    </Button>
}