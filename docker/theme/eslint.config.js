// eslint.config.js
import js from "@eslint/js";

export default [
  js.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        console: "readonly",
        window: "readonly",
        document: "readonly",
      },
    },
    rules: {
      "semi": ["error", "always"],
      "quotes": ["error", "double"]
    }
  }
];
