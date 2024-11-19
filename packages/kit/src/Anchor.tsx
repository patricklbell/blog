import React from "react"
import { cn } from "./utils"

export interface AnchorProps
    extends React.AnchorHTMLAttributes<HTMLAnchorElement> {}

const Anchor = React.forwardRef<HTMLAnchorElement, AnchorProps>(
  ({ className, children, ...props }, ref) => {

    return (
        <a
            className={cn("transition ease-linear duration-200 underline-offset-[0.125rem] underline decoration-gray-400 hover:decoration-black", className)} {...props}
            ref={ref}
            {...props}
        >
            <u className='decoration-inherit'>
                <span>{children}</span>
            </u>
        </a>
    )
  }
)
Anchor.displayName = "Anchor"

export { Anchor }