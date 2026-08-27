import { MDXComponents } from 'mdx/types'
import { ArticleBlock } from './ArticleBlock'
import { ArticleImage } from './ArticleImage'
import { Anchor, cn } from '@patricklbell/kit';
import React from 'react'

export const components: MDXComponents = {
    p(props) {
        return <ArticleBlock className='my-6'>
            <p {...props} />
        </ArticleBlock>
    },
    a(props) {
        return <Anchor {...props}/>
    },
    strong: 'strong',
    em: 'em',
    blockquote({ className, ...props }) {
        return <ArticleBlock className='col-start-1 col-span-12 italic text-gray-800'><span {...props} /></ArticleBlock>
    },
    pre({ className, ...props }) {
        return <ArticleBlock>
            {/* tabIndex makes the scroll region reachable without a pointer. */}
            <pre
                tabIndex={0}
                className={cn(
                    'border rounded-lg font-mono p-2 overflow-x-auto',
                    // Code keeps its lines intact and scrolls; it must not pick up
                    // the wrapping applied to inline code below.
                    '[&_code]:whitespace-pre [&_code]:break-normal',
                    className,
                )}
                {...props}
            />
        </ArticleBlock>
    },
    code({ className, ...props }) {
        // Inline code is often a single long identifier, which has nowhere to
        // break on a narrow screen unless it is allowed to break anywhere.
        return <code className={cn('break-words', className)} {...props} />
    },
    h1({ className, ...props }) {
        return <ArticleBlock><h2 className={cn('text-[1.68rem] mt-10 mb-1')} {...props} /></ArticleBlock>
    },
    h2({ className, ...props }) {
        return <ArticleBlock><h3 className={cn('text-2xl mt-3 mb-1')} {...props} /></ArticleBlock>
    },
    h3({ className, ...props }) {
        return <ArticleBlock><h4 className={cn('text-xl mt-3 mb-1')} {...props} /></ArticleBlock>
    },
    h4({ className, ...props }) {
        return <ArticleBlock><h5 className={cn('text-xl mt-3 mb-1')} {...props} /></ArticleBlock>
    },
    h5({ className, ...props }) {
        return <ArticleBlock><h6 className={cn('text-xl mt-3 mb-1')} {...props} /></ArticleBlock>
    },
    h6({ className, ...props }) {
        return <ArticleBlock><h6 className={cn('text-xl mt-3 mb-1')} {...props} /></ArticleBlock>
    },
    hr: 'hr',
    ol({ className, ...props }) {
        return <ArticleBlock><ol className={cn('ml-3 list-decimal')} {...props}/></ArticleBlock>
    },
    ul({ className, ...props }) {
        return <ArticleBlock><ul className={cn('ml-3 list-disc')} {...props}/></ArticleBlock>
    },
    li({ className, ...props }) {
        return <li className={cn('ml-3')} {...props}/>
    },
    br: 'br',
    img: 'img',
    table({ className, ...props }) {
        // The wrapper scrolls, not the page: a table with more columns than the
        // column is wide must not widen its grid cell (see ArticleBlock).
        return <ArticleBlock className='my-6'>
            <div tabIndex={0} className='overflow-x-auto'>
                <table className={cn('w-full border-collapse text-[0.95em]', className)} {...props} />
            </div>
        </ArticleBlock>
    },
    thead: 'thead',
    tbody: 'tbody',
    tr({ className, ...props }) {
        return <tr className={cn('border-b last:border-b-0', className)} {...props} />
    },
    th({ className, ...props }) {
        return <th className={cn('text-left font-medium align-bottom py-2 pr-6 last:pr-0', className)} {...props} />
    },
    td({ className, ...props }) {
        return <td className={cn('text-left align-top py-2 pr-6 last:pr-0', className)} {...props} />
    },
    Image: ArticleImage,
    "mjx-container"({ className, ...props }) {
        return React.createElement(
            'mjx-container',
            { className: cn("overflow-x-auto overflow-y-hidden", className), ...props }
        )
    },
}