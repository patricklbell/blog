import { annexBaseUrl } from "@/annex/[slug]/info";
import { articleBaseUrl } from "@/article/[slug]/info";
import { baseUrl } from "@/info";
import { Metadata } from "next";

export type Authors = "Patrick Bell";

export type MetadataType = 'article' | 'annex';

interface MarkdownMetadata {
    src: string;
    assetsUrl?: string;
    title: string;
    author: Authors;
    description: string;
    tags?: string[];
    publishedTime: Date;
    lastModified?: Date;
    type: MetadataType;
}

export interface ArticleMetadata extends MarkdownMetadata {
    codeLink?: string;
    demoLink?: string;
    headerAssetRelativePath: string;
    headerLoadingColor: string;
    type: 'article';
}

export interface AnnexMetadata extends MarkdownMetadata {
    refererSlug: string;
    type: 'annex';
}

const assetsRelativeUrl = '/markdown/';

class MarkdownManager {
    private ARTICLES: Record<string, ArticleMetadata>;
    private ANNEXES: Record<string, AnnexMetadata>;

    constructor() {
        this.ARTICLES = {
            "visualising-proteins": {
                src: '/app/markdown/visualising-proteins/index.mdx',
                title: "Adapting Spline Algorithms to Draw Proteins",
                description: "How to render ribbon diagrams by solidifying splines.",
                publishedTime: new Date(2022, 7, 5),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["3D Graphics", "WebAssembly", "Spline", "Computational biology"],
                codeLink: "https://github.com/patricklbell/chemical_visualizer",
                demoLink: "https://patricklbell.github.io/chemical_visualizer/",
                headerAssetRelativePath: "header.jpg",
                headerLoadingColor: "#57473E",
                type: 'article',
            },
            "visualising-graphics-engines": {
                src: '/app/markdown/visualising-graphics-engines/index.mdx',
                title: "Frame Analysis of Graphics Pipeline",
                description: "A frame analysis of my own engine, showing the effects of each render and effect pass.",
                publishedTime: new Date(2022, 11, 27),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["3D Graphics", "OpenGL", "Post Processing"],
                codeLink: "https://github.com/patricklbell/3d_engine",
                headerAssetRelativePath: "header.jpg",
                headerLoadingColor: "#5F3F28",
                type: 'article',
            },
            "kidney-vasculature-nn": {
                src: '/app/markdown/kidney-vasculature-nn/index.mdx',
                title: "Image Segmentation of Kidney Microscope Slides",
                description: "Using machine learning to identify veins from microscope slides of kidney cells.",
                publishedTime: new Date(2023, 8, 2),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["Machine Learning", "Image Segmentation"],
                codeLink: "https://github.com/patricklbell/HuBMAP",
                headerAssetRelativePath: "header.jpg",
                headerLoadingColor: "#A48261",
                type: 'article',
            },
            "pbr-physics": {
                src: "/app/markdown/pbr-physics/index.mdx",
                title: "Derivation of Physically Based Rendering",
                description: "The physical model and mathematical justification for physically based rendering.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["Rendering", "PBR", "Optics"],
                headerAssetRelativePath: "header.jpg",
                headerLoadingColor: "#726A58",
                type: 'article',
            },
        }

        this.ANNEXES = {
            'lambertian': {
                refererSlug: 'pbr-physics',
                src: '/app/markdown/pbr-physics/lambertian.mdx',
                title: "Lambertian BRDF",
                description: "Lambertian BRDF derivation from energy conservation.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["PBR", "Optics", "Proof"],
                type: 'annex',
            },
            'mirror': {
                refererSlug: 'pbr-physics',
                src: '/app/markdown/pbr-physics/mirror.mdx',
                title: "Mirror BRDF",
                description: "Prove a mirror BRDF conserves energy.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["PBR", "Optics", "Proof"],
                type: 'annex',
            },
            'pbr-4': {
                refererSlug: 'pbr-physics',
                src: '/app/markdown/pbr-physics/pbr-4.mdx',
                assetsUrl: '/markdown/pbr-physics/',
                title: "Proof of a Geometric Relation for Microfacets Normal and Halfway Vector",
                description: "Proof of a geometric relation for microfacets which explains the 4 in the PBR BRDF.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["PBR", "Optics", "Proof"],
                type: 'annex',
            },
        }
    }

    private addUrl<T extends MarkdownMetadata>(slug: string, meta: T) {
        switch (meta.type) {
            case 'article':
                return { url: `${articleBaseUrl}/${slug}`, ...meta }
            case 'annex':
                return { url: `${annexBaseUrl}/${slug}`, ...meta }
            default:
                throw new Error();
        }
        
    }

    private addAssetsUrl<T extends MarkdownMetadata>(slug: string, meta: T) {
        return { assetsUrl: `${assetsRelativeUrl}${slug}/`, ...meta }
    }

    public getArticles() {
        // @todo sorting, for now just sort by recency always
        return Object.entries(this.ARTICLES)
            .toSorted(([, m1], [, m2]) => m2.publishedTime.getTime() - m1.publishedTime.getTime())
            .map(([slug]) => slug);
    }

    public getAnnexes() {
        return Object.keys(this.ANNEXES);
    }

    public getAnnex(slug: string) {
        return this.addUrl(slug, this.addAssetsUrl(slug, this.ANNEXES[slug]))
    }

    public getArticle(slug: string) {
        const meta = this.addUrl(slug, this.addAssetsUrl(slug, this.ARTICLES[slug]));
        const imageUrl = `${meta.assetsUrl}${meta.headerAssetRelativePath}`;
        return { imageUrl, ...meta };
    }

    public getMetadata(slug: string) {
        if (slug in this.ARTICLES)
            return this.getArticle(slug);
        if (slug in this.ANNEXES)
            return this.getAnnex(slug);
        throw new Error();
    }
}

export const markdownManager = new MarkdownManager();

export const createMarkdownPageMetadata = (slug: string): Metadata => {
    const { title, description, author, tags, url, publishedTime, ...meta } = markdownManager.getMetadata(slug);

    return {
        title,
        description,
        authors: [{ name: author }],
        keywords: tags,
        openGraph: {
            title,
            description,
            type: 'article',
            publishedTime: publishedTime.toUTCString(),
            url,
            images: meta.type === 'article' ? [`${baseUrl}/${meta.imageUrl}`] : []
        },
    }
}