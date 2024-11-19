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
    blockquote: 'blockquote',
    pre({ className, ...props }) {
        return <ArticleBlock><pre className={cn('border rounded-lg font-mono p-2 overflow-x-scroll')} {...props} /></ArticleBlock>
    },
    code: 'code',
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
    Image: ArticleImage,
    "mjx-container"({ className, ...props }) {
        return React.createElement(
            'mjx-container',
            { className: cn("overflow-x-scroll", className), ...props }
        )
    },
}