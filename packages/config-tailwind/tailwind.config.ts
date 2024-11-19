import type { Config } from "tailwindcss";
import plugin from "tailwindcss/plugin";

// We want each package to be responsible for its own content.
const config: Omit<Config, "content"> = {
    theme: {
        extend: {
            fontFamily: {
                "serif": ["var(--font-garamond)", "serif"],
                "sans": ["var(--font-geist-sans)", "sans-serif"],
                "mono": ["var(--font-geist-mono)", "mono"],
            },
            lineHeight: {
                'tight': '110%',
                'taut': '130%',
                'normal': '150%',
            },
        },
    },
    plugins: [
        require("tailwindcss-inner-border"),
        plugin(function ({ addUtilities }) {
            addUtilities({
                '.max-w-container': {
                    'margin-left': 'auto',
                    'margin-right': 'auto',
                    'max-width': '100%',
                    '@media (max-width: 70.5rem)': {
                        'padding-left': '1.25rem',
                        'padding-right': '1.25rem',
                    },
                    '@media (min-width: 48rem)': {
                        'max-width': '68rem',
                    }
                }
            })
        }),
    ],
};
export default config;