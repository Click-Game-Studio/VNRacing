## Why

The workshop material demonstrates a capable documentation portal, but its current implementation and content are coupled to VNRacing. Teams need a small, complete, copyable reference that teaches the same workflow and can seed other projects without carrying VNRacing taxonomy, content, deployment settings, or known navigation and error-state defects.

## What Changes

- Add an independent `Docs/portal-template/` Astro, Starlight, React, LikeC4, and `starlight-versions` project.
- Provide minimal neutral content for Latest, v1, and Preview, each with an index, architecture diagrams, one example feature, and one ADR.
- Provide full-text search, manual sidebars, version switching, MD/MDX content, version-specific LikeC4 projects, base-aware internal links, lazy diagram loading, version-correct node routing, accessible loading/error states, and normal-link fallbacks.
- Add a root GitHub Actions workflow that build-checks the nested template without deploying it from the VNRacing repository.
- Include a GitHub Pages deployment workflow inside the template for use after copying the template to a repository root.
- Add deterministic local checks for Astro content/types, production builds at root and project subpaths, generated search index, required version routes, and internal links.
- Keep the existing VNRacing portal and deployment workflow unchanged.

## Capabilities

### New Capabilities
- `reusable-docs-portal`: Copyable, versioned documentation portal behavior, neutral sample content, interactive architecture diagrams, resilient accessible states, and base-aware navigation.
- `docs-template-automation`: Build-only validation while nested in VNRacing and reusable GitHub Pages deployment automation after extraction to another repository.

### Modified Capabilities

None.

## Impact

- Adds a new independent Node project under `Docs/portal-template/` with its own lockfile and dependencies.
- Adds `.github/workflows/docs-template-check.yml` for path-scoped validation only.
- Adds OpenSpec artifacts under `openspec/changes/add-reusable-docs-portal-template/` during delivery.
- Does not modify `Docs/portal/`, `.github/workflows/docs.yml`, `.gitignore`, or `CLAUDE.md`.
- Does not deploy, commit, or push the template as part of implementation.
