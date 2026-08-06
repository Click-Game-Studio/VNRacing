# Contributing to docs-portal-template

This guide is for Click Game Studio developers contributing changes to the template itself, not for teams adopting the template for a project. For adoption guidance, see [`GUIDE.md`](GUIDE.md).

## Development setup

Requirements: Node.js 22.22.3 or newer and npm.

1. Clone the repository and install dependencies:

```bash
npm ci
```

2. Start the local development server:

```bash
npm run dev
```

Open `http://localhost:4321/` to see the portal. Changes to content, components, and models hot-reload automatically.

3. Use `nvm` or `fnm` to match the exact Node version:

```bash
nvm use
```

This reads `.nvmrc` and switches to Node 22.22.3.

## Testing changes

Before submitting a pull request, verify your changes pass all checks:

```bash
npm run check
npm run verify:root
npm run verify:subpath
```

- `npm run check` validates Astro content and TypeScript with zero errors.
- `npm run verify:root` builds the portal for root deployment (`BASE_PATH=/`), compiles all LikeC4 models, and validates that all 12 required routes exist, Pagefind search is present, and internal links resolve.
- `npm run verify:subpath` does the same for project-subpath deployment (`BASE_PATH=/example-project`).

Both verification commands must pass. A change that works in root deployment but breaks subpath deployment is incomplete.

## Making changes

### Updating sample content

Content lives under `src/content/docs/`. Latest pages are at the root; frozen versions are in `v1/` and `preview/`. Each version has its own sidebar declared in `astro.config.mjs` (Latest) or `src/content/versions/<version>.json` (frozen versions).

When changing a page, update the corresponding sidebar if the slug or label changes. Orphaned pages are invisible; sidebar entries with no matching page fail validation.

### Updating LikeC4 models

Each directory under `likec4/` is an independent project with a `model.c4` and `likec4.config.json`. Edit the model in place. The `viewId` passed from an architecture page must match a view declared in that project's model.

Because `throwIfInvalid: true` is set in `astro.config.mjs`, a malformed model or invalid reference fails the build immediately with the offending file named.

### Adding a new version

Adding a version touches seven places. Missing any one produces either a build failure or a version that renders another version's diagrams:

1. Copy the Latest pages to `src/content/docs/<version>/`.
2. Create `src/content/versions/<version>.json` with that snapshot's sidebar.
3. Register `{ slug: '<version>', label: '<version>' }` in `starlightVersions()` in `astro.config.mjs`.
4. Copy a LikeC4 project to `likec4/<version>/` and set `name` in its `likec4.config.json`.
5. Add a literal `<version>: () => import('likec4:react/<version>')` entry to `ENGINE_BY_PROJECT` in `src/components/DiagramView.tsx`.
6. Pass matching `project`, `label`, and version-prefixed `nodeLinks` from the `<version>` architecture page.
7. Add the four `<version>` routes to the required-route list in `scripts/validate-site.mjs`.

Run both verification commands after adding a version. Do not skip any step.

### Changing dependencies

Dependency changes must pass CI on Node 22.22.3 even when they pass locally on a newer version. After changing `package.json`, regenerate the lockfile and verify:

```bash
npm install
npm run check
npm run verify:root
npm run verify:subpath
```

Commit both `package.json` and `package-lock.json` together.

### Updating the deployment workflow

The bundled `.github/workflows/pages.yml` is the deployment workflow for repositories that adopt this template. Changes to it must be tested by creating a test repository, configuring Pages, and running a full deploy. Do not merge workflow changes that have not been tested against an actual GitHub Pages deployment.

## Pull request guidelines

### Before submitting

- [ ] All three checks pass: `npm run check`, `npm run verify:root`, `npm run verify:subpath`.
- [ ] Commit messages follow conventional commit format: `type(scope): description`.
- [ ] New versions include all seven integration points.
- [ ] Dependency changes include both `package.json` and `package-lock.json`.
- [ ] Changes to `.github/workflows/pages.yml` have been tested in a live deployment.

### Commit message format

Use conventional commits:

```
feat(diagrams): add lazy loading for LikeC4 engines
fix(validation): catch broken fragment links
docs(guide): clarify when to use manual sidebars
chore(deps): update astro to 6.5.0
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `perf`.

### Review checklist

Reviewers confirm:

- [ ] CI passes (all checks green).
- [ ] Changes match the stated intent.
- [ ] New versions follow the seven-point integration checklist.
- [ ] No hardcoded paths, organization names, or repository names in workflows or configs.
- [ ] Sample content remains project-neutral.
- [ ] Both root and subpath deployments work.

## Release process

Releases are tagged and documented in `CHANGELOG.md`. After a release:

1. Update the version in `package.json`.
2. Add a new `## [X.Y.Z]` entry at the top of `CHANGELOG.md` with the release date.
3. Commit with message `chore(release): X.Y.Z`.
4. Tag the commit `vX.Y.Z` and push the tag.
5. Create a GitHub release from the tag with the changelog entry as release notes.

Follow semantic versioning: breaking changes increment MAJOR, new features increment MINOR, bug fixes increment PATCH.
