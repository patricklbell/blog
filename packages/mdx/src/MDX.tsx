import { evaluate } from '@mdx-js/mdx'
import * as runtime from 'react/jsx-runtime'
import rehypeHighlight from 'rehype-highlight';
import rehypeMathJaxCHtml from 'rehype-mathjax/chtml';
import remarkMath from 'remark-math';
import { components } from './components';

export type MDXProps = {
    source: string;
    baseUrl?: string;
} & Exclude<{[key: string]: any}, "components">

export async function MDX({ source, baseUrl, ...props }: MDXProps) {
    // Run the compiled code
    const {
        default: MDXContent,
        ...MDXExports
    } = await evaluate(source, {
        ...runtime,
        baseUrl: baseUrl,
        remarkPlugins: [
            remarkMath
        ],
        rehypePlugins: [
            [rehypeMathJaxCHtml, {
                chtml: {
                    fontURL: 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/output/chtml/fonts/woff-v2',
                    mathmlSpacing: true,
                },
            }],
            rehypeHighlight
        ]
    })

    return <div className='font-sans leading-normal'>
        <MDXContent {...props} components={components} />
    </div>;
}