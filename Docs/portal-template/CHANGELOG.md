# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-08-06

### Added

- `.github/workflows/ci.yml` ("Validate portal") gating every pull request and every push to a non-main branch with `npm run check`, `npm run verify:root`, and `npm run verify:subpath`, so both the root-base and project-subpath deployment shapes are proven before merge
- `ignore` entry for `likec4` in `.github/dependabot.yml`, holding major and minor bumps while still allowing 1.55.x patch updates, with the reason recorded inline
- "Dependency constraints" section in `CONTRIBUTING.md` documenting the LikeC4 pin where a contributor about to bump a dependency will find it

### Fixed

- `CHANGELOG.md` recorded the 1.0.0 release as 2026-08-05; the tagged commit is dated 2026-08-06

## [1.0.0] - 2026-08-06

### Added

- Versioned documentation portal with Latest, v1, and Preview snapshots
- Starlight navigation with manual sidebars for each version
- LikeC4 diagram integration with lazy-loaded versioned engines
- Interactive architecture diagrams with click-to-navigate nodes
- Base-path flexibility for root or project-subpath deployment
- Pagefind full-text search in production builds
- Build-time validation of models, routes, and internal links
- GitHub Pages deployment workflow with repository variable configuration
- Node.js version management with `.nvmrc` (22.22.3)
- EditorConfig for consistent editor settings
- Prettier configuration for code formatting
- Professional adoption and design guide (`GUIDE.md`)
- Contribution guidelines for studio developers (`CONTRIBUTING.md`)
- Sample content: index, architecture view, example feature, and ADR for each version
- Deterministic validation commands for root and subpath deployments
- Resilient diagram loading with accessible states and retry capability
- Normal HTML links alongside every diagram for keyboard and no-JS navigation

### Pinned

- `likec4` is held at 1.55.0, the last release built against vite ^7.3.1. From 1.56.0 onward LikeC4 depends on vite ^8 (rolldown-based), which installs a nested vite@8 next to the vite@7 (rollup-based) that astro 6.4.6 hoists. The two `PluginContextMeta` types are incompatible and `npm run check` fails at the `LikeC4VitePlugin()` call in `astro.config.mjs`. Revisit when Astro moves to vite 8. See "Dependency constraints" in `CONTRIBUTING.md`.

[1.0.1]: https://github.com/Click-Game-Studio/docs-portal-template/releases/tag/v1.0.1
[1.0.0]: https://github.com/Click-Game-Studio/docs-portal-template/releases/tag/v1.0.0
