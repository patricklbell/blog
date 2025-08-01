import { annexBaseUrl } from "@/annex/[slug]/info";
import { articleBaseUrl } from "@/article/[slug]/info";
import { baseUrl } from "@/info";
import { projectBaseUrl } from "@/project/[slug]/info";
import { assertUnreachable } from "@/utils";
import { Metadata } from "next";

export type Authors = "Patrick Bell";

export type MetadataType = 'article' | 'annex' | 'project';

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

export interface ProjectMetadata extends MarkdownMetadata {
    codeLink?: string;
    demoLink?: string;
    article?: string;
    type: 'project';
}

const assetsRelativeUrl = '/markdown/';

class MarkdownManager {
    private ARTICLES: Record<string, ArticleMetadata>;
    private ANNEXES: Record<string, AnnexMetadata>;
    private PROJECTS: Record<string, ProjectMetadata>;

    constructor() {
        const defaultArticleMetadata = {
            author: "Patrick Bell",
            type: 'article',
            headerAssetRelativePath: "header.jpg",
        } as const
        this.ARTICLES = {
            "visualising-proteins": {
                ...defaultArticleMetadata,
                src: '/app/markdown/visualising-proteins/index.mdx',
                title: "Adapting Spline Algorithms to Draw Proteins",
                description: "How to render ribbon diagrams by solidifying splines.",
                publishedTime: new Date(2022, 7, 5),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["3D Graphics", "WebAssembly", "Spline", "Computational biology"],
                codeLink: "https://github.com/patricklbell/chemical_visualizer",
                demoLink: "https://patricklbell.github.io/chemical_visualizer/",
                headerLoadingColor: "#57473E",
            },
            "visualising-graphics-engines": {
                ...defaultArticleMetadata,
                src: '/app/markdown/visualising-graphics-engines/index.mdx',
                title: "Frame Analysis of Graphics Pipeline",
                description: "A frame analysis of my own engine, showing the effects of each render and effect pass.",
                publishedTime: new Date(2022, 11, 27),
                lastModified: new Date(2024, 10, 19),
                tags: ["3D Graphics", "OpenGL", "Post Processing"],
                codeLink: "https://github.com/patricklbell/3d_engine",
                headerLoadingColor: "#5F3F28",
            },
            "kidney-vasculature-nn": {
                ...defaultArticleMetadata,
                src: '/app/markdown/kidney-vasculature-nn/index.mdx',
                title: "Image Segmentation of Kidney Microscope Slides",
                description: "Using machine learning to identify veins from microscope slides of kidney cells.",
                publishedTime: new Date(2023, 8, 2),
                lastModified: new Date(2024, 10, 19),
                tags: ["Machine Learning", "Image Segmentation"],
                codeLink: "https://github.com/patricklbell/HuBMAP",
                headerLoadingColor: "#A48261",
            },
            "pbr-physics": {
                ...defaultArticleMetadata,
                src: "/app/markdown/pbr-physics/index.mdx",
                title: "Derivation of Physically Based Rendering",
                description: "The physical model and mathematical justification for physically based rendering.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["Rendering", "PBR", "Optics"],
                headerLoadingColor: "#726A58",
            },
            // "poisson-surface-reconstruction": {
            //     ...defaultArticleMetadata,
            //     src: "/app/markdown/poisson-surface-reconstruction/index.mdx",
            //     title: "Poisson Surface Reconstruction",
            //     description: "Explanation of Poisson surface reconstruction.",
            //     publishedTime: new Date(2025, 4, 16),
            //     lastModified: new Date(2025, 4, 16),
            //     tags: ["3D Graphics", "Surface Reconstruction"],
            //     headerLoadingColor: "#726A58",
            // },
        }

        const defaultAnnexMetadata = {
            author: "Patrick Bell",
            type: 'annex',
        } as const
        this.ANNEXES = {
            'lambertian': {
                ...defaultAnnexMetadata,
                refererSlug: 'pbr-physics',
                src: '/app/markdown/pbr-physics/lambertian.mdx',
                title: "Lambertian BRDF",
                description: "Lambertian BRDF derivation from energy conservation.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                tags: ["PBR", "Optics", "Proof"],
            },
            'mirror': {
                ...defaultAnnexMetadata,
                refererSlug: 'pbr-physics',
                src: '/app/markdown/pbr-physics/mirror.mdx',
                title: "Mirror BRDF",
                description: "Prove a mirror BRDF conserves energy.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                tags: ["PBR", "Optics", "Proof"],
            },
            'pbr-4': {
                ...defaultAnnexMetadata,
                refererSlug: 'pbr-physics',
                src: '/app/markdown/pbr-physics/pbr-4.mdx',
                assetsUrl: '/markdown/pbr-physics/',
                title: "Proof of a Geometric Relation for Microfacets Normal and Halfway Vector",
                description: "Proof of a geometric relation for microfacets which explains the 4 in the PBR BRDF.",
                publishedTime: new Date(2023, 8, 23),
                lastModified: new Date(2024, 10, 19),
                tags: ["PBR", "Optics", "Proof"],
            },
        }

        const defaultProjectMetadata = {
            author: "Patrick Bell",
            type: 'project',
        } as const
        this.PROJECTS = {
            'xpbd-physics-engine': {
                ...defaultProjectMetadata,
                src: "/app/markdown/xpbd-physics-engine/index.mdx",
                title: "XPBD",
                description: "Extended position based dynamics physics engine.",
                publishedTime: new Date(2025, 7, 2),
                lastModified: new Date(2025, 7, 2),
                codeLink: "https://github.com/patricklbell/xpbd",
                demoLink: "https://patricklbell.github.io/xpbd/",
                tags: ["3D Graphics", "Physics", "XPBD"],
            },
            'unnamed-lang': {
                ...defaultProjectMetadata,
                src: "/app/markdown/unnamed-lang/index.mdx",
                title: "Unnamed Lang",
                description: "Systems programming language using LLVM backend.",
                publishedTime: new Date(2025, 7, 2),
                lastModified: new Date(2025, 7, 2),
                codeLink: "https://github.com/patricklbell/unnamed-lang/xpbd",
                tags: ["Systems Programming", "Programming Languages"],
            },
            "chemical-visualizer": {
                ...defaultProjectMetadata,
                src: '/app/markdown/visualising-proteins/index.mdx',
                title: "CVIZ",
                description: "Protein & Molecule Visualiser.",
                publishedTime: new Date(2022, 7, 5),
                lastModified: new Date(2024, 10, 19),
                author: "Patrick Bell",
                tags: ["3D Graphics", "WebAssembly", "Spline", "Computational biology"],
                article: "visualising-proteins",
            },
            "graphics-engines": {
                ...defaultProjectMetadata,
                src: '/app/markdown/visualising-graphics-engines/index.mdx',
                title: "Graphics Engine",
                description: "Physically based renderer and editor.",
                publishedTime: new Date(2022, 11, 27),
                lastModified: new Date(2024, 10, 19),
                tags: ["3D Graphics", "OpenGL", "PBR"],
                codeLink: "https://github.com/patricklbell/3d_engine",
                article: "visualising-graphics-engines",
            },
        }
    }

    private addUrl<T extends MarkdownMetadata>(slug: string, meta: T) {
        switch (meta.type) {
            case 'article':
                return { url: `${articleBaseUrl}/${slug}`, ...meta }
            case 'annex':
                return { url: `${annexBaseUrl}/${slug}`, ...meta }
            case 'project':
                return { url: `${projectBaseUrl}/${slug}`, ...meta }
        }
        return assertUnreachable(meta.type);
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

    public getProjects(includeRedirects=false) {
        if (includeRedirects)
            return Object.keys(this.PROJECTS)
        return Object.keys(this.PROJECTS)
            .filter(slug => !markdownManager.getProject(slug).article);
    }

    public getAnnex(slug: string) {
        return this.addUrl(slug, this.addAssetsUrl(slug, this.ANNEXES[slug]))
    }

    public getArticle(slug: string) {
        const meta = this.addUrl(slug, this.addAssetsUrl(slug, this.ARTICLES[slug]));
        const imageUrl = `${meta.assetsUrl}${meta.headerAssetRelativePath}`;
        return { imageUrl, ...meta };
    }

    public getProject(slug: string) {
        return this.addUrl(slug, this.addAssetsUrl(slug, this.PROJECTS[slug]))
    }

    public getMetadata(slug: string) {
        if (slug in this.ARTICLES)
            return this.getArticle(slug);
        if (slug in this.ANNEXES)
            return this.getAnnex(slug);
        if (slug in this.PROJECTS)
            return this.getProject(slug);
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