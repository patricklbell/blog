export const utcFormatDateTime = (dt: Date, short: boolean = false) => {
    const month = dt.toLocaleString('en-US', { month: short ? 'short' : 'long', timeZone: 'UTC' });
    return `${month} ${dt.getUTCDay()}, ${dt.getUTCFullYear()}`
};

export interface SlugParamsType {
    params: Promise<{ slug: string }>
}

export const assertUnreachable = (_: never): never => {
    throw new Error("Didn't expect to get here");
}