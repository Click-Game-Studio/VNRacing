# Reusable documentation portal

> **This is a mirror.** The canonical source of truth is [`Click-Game-Studio/docs-portal-template`](https://github.com/Click-Game-Studio/docs-portal-template). This copy is kept inside VNRacing for dogfooding — to exercise template changes against a real repository's CI. Make fixes upstream first, then port them here.

Copyable static documentation portal using Astro, Starlight, MDX, React, LikeC4, and `starlight-versions`. The project is self-contained: install, build, and runtime use only files within this project root.

## When to use this template

Use this template when a project needs **versioned architecture documentation with diagrams that stay in sync with the text** — multiple documentation snapshots served side by side, C4 architecture models compiled from text at build time, and static hosting with full-text search.

It is a poor fit for single unversioned docs sites, prose-only documentation with no architecture model, or anything needing runtime content.

See [`GUIDE.md`](GUIDE.md) for the full adoption guide, the reasoning behind the design, and customization patterns. See [`CONTRIBUTING.md`](CONTRIBUTING.md) to change the template itself.

## Install and run locally

Requirements: Node.js 22.22.3 or newer and npm. Run `nvm use` to match the pinned version in `.nvmrc`.

```bash
npm ci
npm run dev
```

Open `http://localhost:4321/`. Production checks:

```bash
npm run check
npm run verify:root
npm run verify:subpath
```

`npm run check` validates Astro content and TypeScript. Each verification build compiles all LikeC4 projects with strict failure, generates static output and Pagefind search, then checks required routes and internal links. `verify:root` uses `/`; `verify:subpath` uses `/example-project`.

## Configure site URL and base path

`astro.config.mjs` reads:

| Variable | Purpose | Local default |
| --- | --- | --- |
| `SITE_URL` | Canonical origin, without project path | `http://localhost:4321` |
| `BASE_PATH` | Hosting path: `/` or `/repository-name` | `/` |

Examples:

```bash
SITE_URL=https://docs.example.com BASE_PATH=/ npm run build
SITE_URL=https://team.github.io BASE_PATH=/example-project npm run build
npm run validate
```

Root-absolute links authored in Markdown are rewritten exactly once under `BASE_PATH`. Relative links, anchors, external URLs, and protocol-relative URLs remain unchanged.

## Customize content and navigation

1. Replace title and description in `astro.config.mjs`.
2. Replace four Latest pages under `src/content/docs/`: overview, `architecture.mdx`, feature, and ADR.
3. Update manual sidebars in `astro.config.mjs` and each `src/content/versions/*.json`.
4. Keep normal links beside diagrams. They preserve navigation without JavaScript and give keyboard users a direct route.

Markdown handles normal pages. MDX architecture pages import `src/components/DiagramView.tsx` and mount it with `client:only="react"`.

## Maintain version snapshots

Latest pages live directly under `src/content/docs/`. Frozen versions use complete independent folders such as `v1/` and `preview/`, plus matching files in `src/content/versions/`.

To add a version:

1. Copy all Latest pages into `src/content/docs/<version>/`.
2. Create `src/content/versions/<version>.json` with that snapshot's sidebar.
3. Register version in `starlightVersions()` inside `astro.config.mjs`.
4. Copy a LikeC4 project to `likec4/<version>/` and set its config name.
5. Add literal `import('likec4:react/<version>')` entry in `DiagramView.tsx`.
6. Pass matching `project`, label, and version-prefixed `nodeLinks` from architecture page.
7. Add four version routes to `scripts/validate-site.mjs`.

Never make a historical page include Latest content. Snapshot duplication is intentional.

## Maintain LikeC4 models

Each directory under `likec4/` is a compact independent project. Edit its `model.c4`; page `viewId` must match a declared view. `throwIfInvalid: true` makes malformed syntax and references fail builds.

`DiagramView.tsx` loads project engines near viewport, reports loading and import errors, and offers retry. `nodeLinks` maps fully qualified LikeC4 node IDs to authored routes. Mapped clicks navigate; unmapped clicks stay under native LikeC4 pan, zoom, and drill-down control.

After model changes, run both verification commands. Also smoke-test architecture pages with mouse pan/zoom, keyboard focus on feature links and retry, and browser JavaScript disabled.

## Validate generated output

```bash
npm run build
npm run validate
```

Validator uses only Node.js standard library. It requires Pagefind output, all 12 routes, base-scoped root-absolute links, valid relative links, local assets, and existing fragment IDs. Failures name source page and target.

## Extract into another repository

Copy **contents** of this directory, including `.github/`, to new repository root. Do not copy this directory as a nested folder. Then:

1. Run `npm ci` and both verification commands.
2. Set repository variable `SITE_URL`, for example `https://team.github.io`.
3. Set repository variable `BASE_PATH`: `/` for user/custom-domain sites or `/repository-name` for GitHub project sites.
4. In repository **Settings → Pages**, select **GitHub Actions** as source.
5. Push to `main` or run bundled **Deploy documentation portal** workflow manually.

The bundled `.github/workflows/pages.yml` workflow activates when the template contents are at repository root. It installs dependencies, checks content, builds with repository variables, validates generated output, uploads `dist/`, and deploys through GitHub Pages.
