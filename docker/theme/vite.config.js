import { defineConfig, loadEnv } from "vite";
import laravel from "laravel-vite-plugin";
import { wordpressPlugin, wordpressThemeJson } from "@roots/vite-plugin";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig(({ mode }) => {
  // Load env file based on mode (development/production)
  const env = loadEnv(mode, "../../../", ""); // going up to project root where .env lives

  return {
    base: `/app/themes/${env.WP_THEME_NAME}/public/build/`,
    plugins: [
      laravel({
        input: [
          "resources/css/app.css",
          "resources/js/app.js",
          "resources/css/editor.css",
          "resources/js/editor.js",
        ],
        refresh: true,
      }),

      wordpressPlugin(),

      // Generate the theme.json file in the public/build/assets directory
      // based on the Tailwind config and the theme.json file from base theme folder
      wordpressThemeJson({
        disableTailwindColors: false,
        disableTailwindFonts: false,
        disableTailwindFontSizes: false,
      }),
      tailwindcss(),
    ],
    resolve: {
      alias: {
        "@scripts": "/resources/js",
        "@styles": "/resources/css",
        "@fonts": "/resources/fonts",
        "@images": "/resources/images",
      },
    },
  };
});
