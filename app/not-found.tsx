import { BlogLayout } from "./components/BlogLayout";

export default function NotFound() {
    return <BlogLayout><div className="flex flex-col items-center justify-center flex-grow">
        <h1 className="max-w-full text-7xl text-balance tracking-tight leading-tight hyphen-auto">404.</h1>
    </div></BlogLayout>
}