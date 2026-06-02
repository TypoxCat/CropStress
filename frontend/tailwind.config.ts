import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/lib/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        crop: {
          ink: "#1b2a24",
          panel: "#f6f8f5",
          line: "#d9e1d8",
          field: "#2f6f4e",
          amber: "#e0a100",
          flame: "#d95f18",
          alert: "#c83535",
        },
      },
    },
  },
  plugins: [],
};

export default config;
