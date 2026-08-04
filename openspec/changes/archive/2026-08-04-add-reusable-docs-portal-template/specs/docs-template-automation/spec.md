## ADDED Requirements

### Requirement: Deterministic local validation
The template SHALL provide commands that check Astro content and types, compile all LikeC4 projects, build the static portal, confirm Pagefind output, confirm all twelve required version routes, and reject broken local links.

#### Scenario: Valid root-base build
- **WHEN** validation runs with `BASE_PATH=/`
- **THEN** checks, model compilation, static build, route validation, search validation, and internal-link validation complete successfully

#### Scenario: Valid project-base build
- **WHEN** validation runs with `BASE_PATH=/example-project`
- **THEN** the same validations complete with all generated links scoped to the project base

#### Scenario: Invalid model
- **WHEN** any versioned LikeC4 model contains invalid syntax or references
- **THEN** the production build fails rather than omitting or substituting a diagram

#### Scenario: Missing route or search index
- **WHEN** a required version route or Pagefind output is absent
- **THEN** the validation command exits non-zero with the missing artifact identified

#### Scenario: Broken local link
- **WHEN** generated HTML points to a missing internal page or asset
- **THEN** the validation command exits non-zero with the source page and broken target identified

### Requirement: Build-only VNRacing CI
The repository SHALL contain a path-scoped workflow at `.github/workflows/docs-template-check.yml` that validates template changes but never deploys them.

#### Scenario: Template pull request
- **WHEN** a pull request changes `Docs/portal-template/**` or the check workflow
- **THEN** CI installs with `npm ci` and validates root-base and project-base builds

#### Scenario: CI permissions
- **WHEN** the build-only workflow runs
- **THEN** it has read-only repository permissions and does not request Pages write or identity-token permissions

#### Scenario: Unrelated repository change
- **WHEN** a change does not touch template paths or the check workflow
- **THEN** the template validation workflow is not triggered by that change

### Requirement: Extracted GitHub Pages deployment
The template SHALL include `.github/workflows/pages.yml` inside its own directory so it is inert while nested in VNRacing and usable after template contents are copied to a repository root.

#### Scenario: Template remains nested
- **WHEN** the template is stored at `Docs/portal-template/` in VNRacing
- **THEN** GitHub does not register its nested deployment workflow and the existing VNRacing Pages deployment is unaffected

#### Scenario: Template becomes repository root
- **WHEN** the template contents are copied to a repository root and Pages through Actions is enabled
- **THEN** the bundled workflow installs, validates, uploads the generated static artifact, and deploys it to GitHub Pages

#### Scenario: Deployment metadata is configured
- **WHEN** repository variables provide site URL and base path
- **THEN** the deployment workflow passes them to the build rather than hardcoding a VNRacing repository name or organization

### Requirement: Scoped branch implementation
Implementation SHALL occur on `feat/docs-portal-template`, remain uncommitted and unpushed, and preserve user-owned changes in `.gitignore` and `CLAUDE.md`.

#### Scenario: Branch is created
- **WHEN** implementation begins from `docs/workshop-training`
- **THEN** the working branch becomes `feat/docs-portal-template` without discarding existing uncommitted files

#### Scenario: Implementation scope is inspected
- **WHEN** implementation finishes
- **THEN** only `Docs/portal-template/`, `.github/workflows/docs-template-check.yml`, and this OpenSpec change contain implementation additions, while `.gitignore` and `CLAUDE.md` remain user-owned and unstaged

#### Scenario: Delivery remains local
- **WHEN** the autonomous implementation completes
- **THEN** no commit is created and no branch is pushed
