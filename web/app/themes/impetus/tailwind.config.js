/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/views/**/*.blade.php",
    "./app/**/*.php",
    "./resources/scripts/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          light: "#3AB0FF",
          DEFAULT: "#007BFF",
          dark: "#0056b3",
        },
        neutral: {
          light: "#f5f5f5",
          DEFAULT: "#d4d4d4",
          dark: "#a3a3a3",
        },
      },
      fontFamily: {
        sans: ["Inter var", "sans-serif"],
        heading: ["Poppins", "sans-serif"],
        body: ["Roboto", "sans-serif"],
      },
    },
  },
  plugins: [],
};
