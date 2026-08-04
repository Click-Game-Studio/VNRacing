## ADDED Requirements

### Requirement: Independent reusable portal
The template SHALL be a self-contained project under `Docs/portal-template/` and SHALL NOT require files from `Docs/portal/` at install, build, or runtime.

#### Scenario: Template installs independently
- **WHEN** dependencies are installed from `Docs/portal-template/package-lock.json`
- **THEN** installation completes without reading a package manifest or source file from `Docs/portal/`

#### Scenario: Existing portal remains untouched
- **WHEN** the template change is implemented
- **THEN** no implementation edit is made under `Docs/portal/` or to `.github/workflows/docs.yml`

### Requirement: Core documentation experience
The portal SHALL provide Starlight navigation, manual sidebars, Markdown and MDX rendering, responsive light/dark presentation, and Pagefind-backed full-text search in production output.

#### Scenario: Production site contains search assets
- **WHEN** the portal is built for production
- **THEN** the output contains a Pagefind search index and all configured sidebar routes

#### Scenario: Markdown and MDX content render
- **WHEN** a user opens feature, decision, or architecture pages
- **THEN** Markdown pages render textual content and MDX architecture pages render interactive diagram islands

### Requirement: Three independent versions
The portal SHALL expose Latest, v1, and Preview through `starlight-versions`, with independent content and LikeC4 models for each version.

#### Scenario: Required pages exist in every version
- **WHEN** the production output is validated
- **THEN** index, architecture, example feature, and ADR routes exist for Latest, v1, and Preview

#### Scenario: Snapshot differences are visible
- **WHEN** a user switches among Latest, v1, and Preview
- **THEN** version status text and architecture model content visibly correspond to the selected snapshot

### Requirement: Neutral minimal sample content
Each version SHALL contain concise project-neutral examples covering an index, architecture view, one feature description, and one architecture decision record.

#### Scenario: Template is copied to another project
- **WHEN** a team reads the bundled content
- **THEN** it can identify where to replace project metadata, architecture model, feature documentation, and decisions without removing VNRacing-specific taxonomy

### Requirement: Interactive version-aware diagrams
Architecture pages SHALL load the selected LikeC4 project lazily, support native LikeC4 interaction, and map configured nodes to feature pages while preserving both deployment base path and documentation version.

#### Scenario: Latest node navigation
- **WHEN** a user activates the mapped feature node in a Latest diagram
- **THEN** navigation targets the Latest example feature under the configured base path

#### Scenario: Historical node navigation
- **WHEN** a user activates the mapped feature node in a v1 diagram
- **THEN** navigation targets the v1 example feature under the configured base path rather than Latest

#### Scenario: Preview node navigation
- **WHEN** a user activates the mapped feature node in a Preview diagram
- **THEN** navigation targets the Preview example feature under the configured base path rather than Latest

#### Scenario: Unmapped node interaction
- **WHEN** a diagram node has no configured page link
- **THEN** the wrapper does not cancel the event and LikeC4 retains control of native interaction

#### Scenario: Browser lacks IntersectionObserver
- **WHEN** the diagram component runs without `IntersectionObserver`
- **THEN** it starts loading the selected engine immediately

### Requirement: Explicit resilient diagram states
The diagram integration SHALL expose accessible loading, success, and failure states, SHALL catch engine import failures, SHALL allow retry after failure, and SHALL reject unknown project identifiers instead of silently rendering Latest.

#### Scenario: Diagram is loading
- **WHEN** the engine import is pending
- **THEN** assistive technology can identify a named loading status

#### Scenario: Diagram import fails
- **WHEN** the selected LikeC4 engine chunk rejects or cannot be loaded
- **THEN** the page displays an alert describing the failure and a retry control

#### Scenario: Retry succeeds
- **WHEN** a user activates retry after a transient import failure and the next import succeeds
- **THEN** the error state is replaced by the selected diagram

#### Scenario: Unknown project is requested
- **WHEN** the component receives a project identifier not present in the literal engine map
- **THEN** it displays an explicit error and does not load the Latest project as fallback

### Requirement: Navigation remains available without diagram activation
Every architecture page SHALL provide normal HTML links to represented feature pages in addition to clickable diagram nodes.

#### Scenario: JavaScript is unavailable
- **WHEN** a user reads an architecture page without client-side JavaScript
- **THEN** a normal link still reaches the example feature for the same version

#### Scenario: Keyboard navigation
- **WHEN** a keyboard-only user tabs through an architecture page
- **THEN** normal feature links and diagram retry controls receive visible focus and can be activated

### Requirement: Base-aware links
The portal SHALL support root hosting and project-subpath hosting without double prefixes, malformed slashes, or broken root-absolute authored links.

#### Scenario: Root deployment
- **WHEN** `BASE_PATH=/` is used for build and validation
- **THEN** all required routes and internal links resolve under root

#### Scenario: Project site deployment
- **WHEN** `BASE_PATH=/example-project` is used for build and validation
- **THEN** all required routes and internal links resolve under `/example-project` exactly once

#### Scenario: Non-internal links
- **WHEN** authored content contains relative links, anchors, external URLs, or protocol-relative URLs
- **THEN** base-path rewriting leaves those links unchanged

### Requirement: Configurable deployment metadata
The template SHALL read site origin and base path from documented environment variables with defaults suitable for local root-hosted development.

#### Scenario: Project customizes deployment
- **WHEN** `SITE_URL` and `BASE_PATH` are supplied during build
- **THEN** generated canonical URLs and internal navigation use those values without source edits

### Requirement: Clean adoption guide
The template README SHALL document local development, content/model replacement, version maintenance, root and project-site builds, checks, extraction to a repository root, repository variables, and deployment activation.

#### Scenario: New team adopts template
- **WHEN** a team follows README from a clean checkout
- **THEN** it can install, run, validate, customize, and deploy the portal without consulting VNRacing workshop documents
