import { defineConfig } from "vitepress";
import {
  groupIconMdPlugin,
  localIconLoader,
  groupIconVitePlugin,
} from "vitepress-plugin-group-icons";

const repoUrl = "https://github.com/BlueLua";
const siteOrigin = "https://BlueLua.github.io";
const siteBasePath = "/";
const siteUrl = `${siteOrigin}${siteBasePath}`;
const assetBasePath = process.argv.includes("dev") ? "/" : siteBasePath;
const siteTitle = "BlueLua";
const siteDescription = "Pure standalone Lua modules.";
const siteImage = `${siteUrl}og.svg`;
const siteImageAlt = "BlueLua documentations";
const groupIcons = Object.fromEntries(
  [".lua", "luarocks"].map((iconName) => [
    iconName,
    localIconLoader(
      import.meta.url,
      `../src/assets/${iconName.replace(/^\./, "")}.svg`,
    ),
  ]),
);
const websiteJsonLd = {
  "@context": "https://schema.org",
  "@type": "WebSite",
  name: siteTitle,
  url: siteUrl,
  description: siteDescription,
};

export default defineConfig({
  srcDir: "./src",
  title: "BlueLua",
  description: "Centralized docs for BlueLua",
  base: siteBasePath,
  appearance: true,
  markdown: {
    config(md) {
      md.use(groupIconMdPlugin);
    },
  },
  vite: {
    plugins: [groupIconVitePlugin({ customIcon: groupIcons })],
  },
  // prettier-ignore
  head: [
    ["link", { rel: "preconnect", href: "https://fonts.googleapis.com" }],
    ["link", { rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "" }],
    ["link", { rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600;700&display=swap" }],
    ["link", { rel: "icon", type: "image/svg+xml", href: `${assetBasePath}logo.svg` }],
    ["link", { rel: "icon", type: "image/png", sizes: "512x512", href: `${assetBasePath}logo.png` }],
    ["meta", { property: "og:type", content: "website" }],
    ["meta", { property: "og:site_name", content: siteTitle }],
    ["meta", { property: "og:title", content: siteTitle }],
    ["meta", { property: "og:description", content: siteDescription }],
    ["meta", { property: "og:locale", content: "en_US" }],
    ["meta", { property: "og:url", content: siteUrl }],
    ["meta", { property: "og:image", content: siteImage }],
    ["meta", { property: "og:image:alt", content: siteImageAlt }],
    ["meta", { name: "twitter:card", content: "summary_large_image" }],
    ["meta", { name: "twitter:title", content: siteTitle }],
    ["meta", { name: "twitter:description", content: siteDescription }],
    ["meta", { name: "twitter:url", content: siteUrl }],
    ["meta", { name: "twitter:image", content: siteImage }],
    ["meta", { name: "twitter:image:alt", content: siteImageAlt }],
    ["meta", { name: "robots", content: "index,follow" }],
    ["link", { rel: "canonical", href: siteUrl }],
    ["script", { type: "application/ld+json" }, JSON.stringify(websiteJsonLd)],
  ],
  themeConfig: {
    logo: "/logo.svg",
    outline: [2, 5], // show h2-h5
    search: { provider: "local" },
    socialLinks: [{ icon: "github", link: repoUrl }],
    nav: [
      { text: "Home", link: "/" },
      {
        text: "Projects",
        items: [
          { text: "evdev", link: "evdev" },
          { text: "timeutil", link: "timeutil" },
          { text: "tty", link: "tty" },
        ],
      },
      { text: "GitHub", link: "https://github.com/BlueLua" },
      {
        text: "🇵🇸 Free Palestine",
        link: "https://techforpalestine.org/learn-more",
      },
    ],
  },
});
