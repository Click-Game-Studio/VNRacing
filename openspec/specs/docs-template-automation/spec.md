# docs-template-automation Specification

## Purpose
Automated validation and deployment infrastructure for the documentation portal template, providing deterministic local checks, CI validation, and GitHub Pages deployment capability.
## Requirements
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

### Requirement: GitHub Pages deployment workflow
The template SHALL include `.github/workflows/pages.yml` that installs dependencies, validates content, builds static output, and deploys to GitHub Pages when at repository root.

#### Scenario: Workflow activates at repository root
- **WHEN** template contents are at repository root and workflow is triggered
- **THEN** GitHub registers the workflow and executes deployment steps

#### Scenario: Deployment metadata configured via repository variables
- **WHEN** repository variables provide site URL and base path
- **THEN** the deployment workflow passes them to the build without hardcoded values

#### Scenario: Deployment permissions configured
- **WHEN** the deployment workflow runs
- **THEN** it has Pages write and id-token permissions for deployment

