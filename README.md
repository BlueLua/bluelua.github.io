# BlueLua Docs

Central documentation site for [BlueLua](https://github.com/BlueLua)'s Lua
modules, built using [VitePress](https://vitepress.dev/).

## Installation

Run the commands from [docs/](docs/):

```sh
npm install
```

## Build and Test Locally

1. Run this command to build the docs:

   ```sh
   npm run build
   ```

2. Once built, preview it locally by running:

   ```sh
   npm run preview
   ```

The `preview` command boots a local static server that serves the built site
from [docs/.vitepress/dist](docs/.vitepress/dist) at
[http://localhost:4173](http://localhost:4173).

> [!NOTE]
>
> To use a different port, run `npm run preview -- --port 8080`.

## Local Development

```sh
npm run dev
```

This starts the VitePress dev server at
[http://localhost:5173](http://localhost:5173).
