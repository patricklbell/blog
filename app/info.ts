let baseUrlValue;
if (process.env.NODE_ENV == "development") {
    baseUrlValue = ''
} else {
    baseUrlValue = 'https://patricklbell.xyz'
}

export const baseUrl = baseUrlValue;