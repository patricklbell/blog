import path from "path";
import sharp from "sharp";

/**
 * Colour shown behind a header image while it loads.
 *
 * This is the average colour of the image itself, so the placeholder settles
 * into the photograph rather than flashing against it. It is resolved from the
 * file on disk rather than written out by hand, so replacing a header updates
 * the placeholder with it.
 *
 * The site is a static export, so this only ever runs during `next build`.
 */

/** Used when an image is missing or cannot be decoded, so a build never fails on a header. */
const FALLBACK = "#726A58";

const cache = new Map<string, Promise<string>>();

const toHex = (channels: number[]) =>
    "#" +
    channels
        .map((c) => Math.round(Math.min(255, Math.max(0, c))).toString(16).padStart(2, "0"))
        .join("")
        .toUpperCase();

async function computeAverageColor(publicUrl: string): Promise<string> {
    try {
        // publicUrl is rooted at public/, e.g. /markdown/rasterization/header.jpg
        const file = path.join(process.cwd(), "public", publicUrl);
        const { channels } = await sharp(file).stats();

        if (channels.length < 3) {
            // Greyscale: replicate the single channel.
            const mean = channels[0].mean;
            return toHex([mean, mean, mean]);
        }

        return toHex([channels[0].mean, channels[1].mean, channels[2].mean]);
    } catch (e) {
        console.warn(`headerColor: falling back for ${publicUrl}:`, e);
        return FALLBACK;
    }
}

/**
 * Average colour of the image at `publicUrl`, as `#RRGGBB`.
 *
 * Memoised for the lifetime of the build, since the same header is read once
 * per card it appears on.
 */
export function getHeaderColor(publicUrl: string): Promise<string> {
    let pending = cache.get(publicUrl);
    if (!pending) {
        pending = computeAverageColor(publicUrl);
        cache.set(publicUrl, pending);
    }
    return pending;
}
