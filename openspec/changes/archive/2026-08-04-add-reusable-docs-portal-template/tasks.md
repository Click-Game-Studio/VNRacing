## 1. Branch and project foundation

- [x] 1.1 Confirm user-owned `.gitignore` and `CLAUDE.md` changes, then create and switch to `feat/docs-portal-template` without staging, committing, or discarding them
- [x] 1.2 Create the independent `Docs/portal-template/` Astro/Starlight project manifest, lockfile, TypeScript/content configuration, ignore file, and environment declarations
- [x] 1.3 Configure environment-driven site URL/base path, Starlight navigation/search, three documentation versions, MDX, React, LikeC4 projects, strict model compilation, and base-aware Markdown links ← (verify: template config has no VNRacing metadata or runtime dependency on `Docs/portal/`)

## 2. Versioned content and architecture models

- [x] 2.1 Create concise neutral Latest index, architecture MDX, example feature, and accepted ADR
- [x] 2.2 Create independent v1 snapshot pages with historical status and a visibly smaller architecture model
- [x] 2.3 Create independent Preview pages with proposed status and a visibly expanded architecture model
- [x] 2.4 Create valid compact LikeC4 projects for `current`, `v1`, and `preview`, with views consumed by matching architecture pages ← (verify: all 12 routes exist and each version renders its own distinct text and model)

## 3. Interactive diagram integration

- [x] 3.1 Implement literal version-engine imports with viewport-ahead lazy loading and immediate fallback when `IntersectionObserver` is unavailable
- [x] 3.2 Implement explicit accessible loading, success, and import-error states with retry and no silent fallback for unknown projects
- [x] 3.3 Implement configured node navigation that preserves base path and version prefix while leaving unmapped LikeC4 interactions untouched
- [x] 3.4 Add normal version-matched feature links and accessible diagram labels to every architecture page ← (verify: loading/error/retry are announced, keyboard/non-JavaScript navigation remains available, and v1/Preview clicks never route to Latest)

## 4. Documentation and validation

- [x] 4.1 Write a self-contained README covering install, local use, customization, snapshots, models, environment variables, root/subpath builds, checks, extraction, and GitHub Pages setup
- [x] 4.2 Add a standard-library generated-site validator for Pagefind output, 12 required routes, base-aware internal links, anchors/assets, and actionable failures
- [x] 4.3 Add package scripts for Astro check, production build, validation, and the two supported base-path verification runs
- [x] 4.4 Run `npm ci`, type/content checks, root-base build validation, and `/example-project` build validation ← (verify: LikeC4 rejects invalid models, Pagefind exists, all required routes and local links pass in both deployment modes)

## 5. Automation and scope safety

- [x] 5.1 Add root `.github/workflows/docs-template-check.yml` with path-scoped triggers, read-only permissions, Node cache, clean install, and both validation modes
- [x] 5.2 Add template-local `.github/workflows/pages.yml` that uses repository variables, validates, uploads, and deploys only after extraction to a repository root
- [x] 5.3 Inspect final branch and working tree to prove `Docs/portal/`, `.github/workflows/docs.yml`, `.gitignore`, and `CLAUDE.md` were not implementation-edited or staged, and prove no commit or push occurred ← (verify: only scoped template, check workflow, and OpenSpec additions belong to this change)
