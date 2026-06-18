import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import matter from "gray-matter";
import { defineConfig } from "vitepress";
import {
  groupIconMdPlugin,
  localIconLoader,
  groupIconVitePlugin,
} from "vitepress-plugin-group-icons";

const configDir = path.dirname(fileURLToPath(import.meta.url));
const docsSrcDir = path.resolve(configDir, "../src");
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

function listProjects() {
  return fs
    .readdirSync(docsSrcDir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .filter((project) =>
      fs.existsSync(path.join(docsSrcDir, project, "index.md")),
    )
    .sort();
}

function titleFromFile(file) {
  return file.replace(/\.md$/, "").replace(/-/g, " ");
}

function titleFromDir(dir) {
  if (dir === "api") return "API";

  return dir.replace(/-/g, " ").replace(/\b\w/g, (char) => char.toUpperCase());
}

function pageData(project, relativeFile) {
  const filePath = path.join(docsSrcDir, project, relativeFile);
  const content = fs.readFileSync(filePath, "utf8");
  return matter(content).data;
}

function pageTitle(project, relativeFile) {
  const title = pageData(project, relativeFile).title;
  if (typeof title === "string" && title.trim() !== "") {
    return title;
  }
  if (relativeFile === "index.md") {
    return project;
  }

  return titleFromFile(path.basename(relativeFile));
}

function pageItem(project, relativeFile) {
  const slug = relativeFile.replace(/\.md$/, "");
  return {
    text: pageTitle(project, relativeFile),
    link: `/${project}/${slug}`,
  };
}

function pageOrder(project, relativeFile) {
  const order = pageData(project, relativeFile).order;

  return Number.isFinite(order) ? order : Number.POSITIVE_INFINITY;
}

function listMarkdownFiles(project, relativeDir = "") {
  const dir = path.join(docsSrcDir, project, relativeDir);

  return fs
    .readdirSync(dir, { withFileTypes: true })
    .filter((entry) => entry.isFile())
    .map((entry) => entry.name)
    .filter(
      (file) =>
        file.endsWith(".md") && file !== "index.md" && file !== "types.md",
    )
    .sort((a, b) => {
      const relA = path.join(relativeDir, a);
      const relB = path.join(relativeDir, b);
      const orderA = pageOrder(project, relA);
      const orderB = pageOrder(project, relB);

      if (orderA !== orderB) return orderA - orderB;
      return a.localeCompare(b);
    });
}

function listNestedDocDirs(project) {
  const dir = path.join(docsSrcDir, project);

  return fs
    .readdirSync(dir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .filter((name) => listMarkdownFiles(project, name).length > 0)
    .sort();
}

function buildSidebar() {
  return Object.fromEntries(
    listProjects().map((project) => {
      const items = [
        {
          text: pageTitle(project, "index.md"),
          items: [
            { text: "Getting Started", link: `/${project}/` },
            ...listMarkdownFiles(project).map((file) =>
              pageItem(project, file),
            ),
          ],
        },
        ...listNestedDocDirs(project).map((dir) => ({
          text: titleFromDir(dir),
          items: listMarkdownFiles(project, dir).map((file) =>
            pageItem(project, `${dir}/${file}`),
          ),
        })),
      ];

      const typesPath = path.join(docsSrcDir, project, "types.md");
      if (fs.existsSync(typesPath)) {
        items.push({
          text: "Types",
          items: [{ text: "Types", link: `/${project}/types` }],
        });
      }

      return [`/${project}/`, items];
    }),
  );
}

function buildProjectNavItems() {
  return listProjects().map((project) => ({
    text: pageTitle(project, "index.md"),
    link: `/${project}/`,
  }));
}

function buildEditLink({ filePath }) {
  const [repo, ...rest] = filePath.split("/");
  const isApi = rest[0] === "api";
  const target = isApi
    ? `types/${rest.slice(1).join("/").replace(/\.md$/, ".d.lua")}`
    : `docs/${rest.join("/")}`;
  return `https://github.com/BlueLua/${repo}/edit/main/${target}`;
}

function filterSearchResult(result) {
  const project = location.pathname.match(/^\/([^/]+)(?:\/|$)/)?.[1];
  if (!project) {
    return true;
  }

  return result.id === `/${project}/` || result.id.startsWith(`/${project}/`);
}

export default defineConfig({
  srcDir: "./src",
  title: "BlueLua",
  description: "Centralized docs for BlueLua",
  base: siteBasePath,
  cleanUrls: true,
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
    search: {
      provider: "local",
      options: {
        miniSearch: { searchOptions: { filter: filterSearchResult } },
      },
    },
    editLink: { pattern: buildEditLink },
    socialLinks: [
      { icon: "github", link: repoUrl },
      { icon: "kofi", link: "https://ko-fi.com/haithium" },
    ],
    // prettier-ignore
    nav: [
      { text: "Home", link: "/" },
      { text: "Modules", items: buildProjectNavItems() },
      { text: "🇵🇸 Free Palestine", link: "https://techforpalestine.org/learn-more" },
    ],
    sidebar: buildSidebar(),
  },
});
