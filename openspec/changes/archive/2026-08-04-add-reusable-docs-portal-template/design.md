## Context

VNRacing already contains a production documentation portal under `Docs/portal/`, built with Astro, Starlight, React, LikeC4, and `starlight-versions`. It proves the desired workflow but embeds project-specific metadata, a large taxonomy, three sizeable content/model snapshots, and deployment assumptions. The reusable example must remain independent so copying it does not require disentangling VNRacing code and so work on the example cannot regress the live portal.

The repository has user-owned uncommitted changes in `.gitignore` and `CLAUDE.md`. Implementation is constrained to `Docs/portal-template/`, `.github/workflows/docs-template-check.yml`, and this OpenSpec change. It must create `feat/docs-portal-template`, must not commit, and must not push.

## Goals / Non-Goals

**Goals:**
- Deliver a small, complete portal that another project can copy and customize.
- Demonstrate Markdown/MDX, search, sidebars, three independent documentation versions, interactive architecture diagrams, feature navigation, static output, and GitHub Pages deployment.
- Make site URL and base path configurable without introducing a separate configuration framework.
- Preserve version context when a diagram node opens a feature page.
- Provide accessible and explicit loading, success, and error behavior with normal links available when JavaScript or diagram interaction is unavailable.
- Validate content, models, generated routes, links, and Pagefind output locally and in build-only CI.

**Non-Goals:**
- Refactor or repair `Docs/portal/`.
- Deploy the nested template from VNRacing.
- Reproduce VNRacing taxonomy, content volume, generated images, workshop handover documents, or Cloudflare host settings.
- Add a general plugin system, shared package, configuration factory, test framework, or runtime server.
- Commit or push implementation changes.

## Decisions

### Keep the template as an independent Node project

`Docs/portal-template/` owns its package manifest, lockfile, Astro configuration, content, components, models, checks, and embedded deployment workflow. It does not import files from `Docs/portal/`.

This duplicates a small amount of integration code, but extraction becomes a directory copy and production portal changes cannot silently break the template. Sharing components or package configuration was rejected because it would couple the reference to this monorepo.

### Use native Starlight and existing integrations

Starlight provides layout, responsive navigation, theme behavior, sidebar, accessibility foundations, and Pagefind search. `starlight-versions` provides version switching. LikeC4's Vite plugin compiles diagrams at build time. React is used only for the interactive diagram island.

No custom search, navigation, version registry, or static-site framework is introduced.

### Store three real snapshots

Latest, v1, and Preview each own four pages and one small LikeC4 project. Each snapshot visibly differs so users can confirm that switching versions changes both text and diagrams. Content is not symlinked or included across versions because a historical snapshot must remain stable when Latest changes.

Each LikeC4 project uses one compact `model.c4` containing specification, model, and views. Splitting the small examples into three files adds navigation cost without teaching additional behavior.

### Keep configuration explicit and small

`astro.config.mjs` reads `SITE_URL` and `BASE_PATH` from environment variables and applies a normalized base consistently to Astro and the Markdown link rewriting plugin. Defaults support local root hosting.

The three LikeC4 imports remain a literal map because Vite requires statically visible module specifiers for separate chunks. Node-to-page links are supplied explicitly per diagram instance or version rather than encoded as a VNRacing-style global taxonomy. Unknown project/view imports are errors, not silent fallbacks.

A separate application configuration layer was rejected as unnecessary for two deployment values and three fixed demo versions.

### Treat diagram interaction as enhancement

The diagram component begins loading near the viewport with `IntersectionObserver` and immediately loads in browsers without observer support. It exposes named loading status, success content, and an error alert with retry. Import failures are caught. Every architecture page includes normal HTML links to the represented feature so navigation remains available to keyboard users and without JavaScript.

Mapped node clicks preserve the current version route prefix and configured site base. Unmapped nodes remain under LikeC4 control. Invalid project identifiers do not fall back to Latest.

### Validate behavior with deterministic build scripts

The template exposes Astro check/build commands plus a small standard-library Node validation script. The script inspects generated output for all twelve required page routes, Pagefind assets, and broken local links. CI installs with `npm ci`, checks content/types, builds and validates at `/`, then builds and validates at `/example-project`.

A browser test framework is not added. Interactive pan/zoom and keyboard behavior are documented as manual smoke checks; generated routes, links, version paths, model compilation, and search artifacts are automated.

### Separate nested validation from extracted deployment

`.github/workflows/docs-template-check.yml` is path-scoped and has read-only permissions. It never uploads a Pages artifact. `Docs/portal-template/.github/workflows/pages.yml` is inert while nested because GitHub only loads workflows from repository-root `.github/workflows`; after the template becomes a repository root, it builds and deploys using repository variables for site URL and base path.

Adding the template to the existing portal deploy workflow was rejected because one repository Pages environment should not receive competing artifacts.

## Risks / Trade-offs

- [Dependency versions diverge from the production portal] → Pin direct dependencies in the template lockfile and validate independently; upgrades are deliberate template maintenance.
- [GitHub Pages variables are omitted after extraction] → Document root/project-site examples and provide safe local defaults; deployment workflow passes variables explicitly.
- [Interactive behavior cannot be fully proven by static validation] → Keep interaction progressive, expose normal links, and document a short keyboard/pan/zoom smoke test.
- [Three snapshots duplicate content] → Limit each to four short pages; duplication is intentional evidence that snapshots are independent.
- [LikeC4 client chunks are large] → Keep lazy dynamic imports per project and trigger near viewport.
- [Nested workflow could be mistaken for active VNRacing CI] → README states it becomes active only after copying template contents to repository root; root CI remains build-only.
- [Dirty user files enter a future commit] → Switch branches without staging and use exact pathspecs if the user later asks for a commit; verify cached diff first.

## Migration Plan

1. Create `feat/docs-portal-template` from the current branch while preserving uncommitted user files.
2. Add only the independent template, root build-check workflow, and OpenSpec artifacts.
3. Run clean install, checks, root-base build validation, and project-base build validation.
4. Confirm `Docs/portal/`, `.github/workflows/docs.yml`, `.gitignore`, and `CLAUDE.md` have no implementation edits.
5. Leave all implementation changes uncommitted and unpushed.
6. For adoption, copy the contents of `Docs/portal-template/` to a new repository root, set repository variables, enable GitHub Pages through Actions, and run the bundled workflow.

Rollback before commit consists of removing only newly added scoped files and returning to the prior branch; no production portal or deployment migration occurs.

## Open Questions

None. Live deployment from VNRacing was explicitly rejected; the nested template receives build-only validation.
