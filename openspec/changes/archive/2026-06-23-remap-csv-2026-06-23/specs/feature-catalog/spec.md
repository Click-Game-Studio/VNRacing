# Feature Catalog — Specification

The feature-catalog capability defines the contract between OpenProject work-packages (source: CSV), documentation codes, and architecture diagrams. It is the single source of truth for mapping product taxonomy → implementing code → status.

## ADDED Requirements

### Requirement: Flat-table master mapping

The `Docs/traceability.md` SHALL use a flat table with one row per Feature.

| Column | Content |
|---|---|
| Mã | Product code (e.g. DM-PHYS, CU-VIS) |
| OP ID | OpenProject work-package number (e.g. #279) |
| Tên Feature | Work-package Subject from CSV |
| Epic | Parent Epic name |
| 🆕 | `🆕 since 2026-06-23` for items not present in the 06-15 CSV |
| Sub Features | Comma-separated list of sub-feature codes with OP IDs |
| Code thật | Names of implementing C++ subsystems (or `—` if none / content) |
| TT | Status: ✅ impl, ⚠️ partial, ❌ gap, 🎨 content, 🔧 infra |
| Map cũ | Legacy F## code (or `—` for new entries) |
| LD | Link to per-Feature design doc under `Docs/ld/` |

Rows SHALL be sorted by Epic then Mã alphabetically. Sub Features with their own Mã SHALL appear as an inline list in the Sub Features column. Support subsystems (SUP-*) SHALL have their own section below the product-tree table.

#### Scenario: New Feature row is added
- **WHEN** a Feature appears in CSV 06-23 but has no traceability.md row yet
- **THEN** the implementer SHALL add one row with all 10 columns filled, mark 🆕, and assign the correct Mã per the coding convention

### Requirement: Per-Feature design doc (ld/)

Every Feature with a Mã SHALL have a `Docs/ld/<Mã>_<kebab-name>.md` file. Sub Features SHALL NOT have separate ld files — they SHALL be sections (`###`) inside their parent Feature's ld doc.

Each ld file SHALL contain:
- Frontmatter: `<Mã>`, `OP ID`, `Tên Feature`, `Epic`, `Status`
- Description from CSV Description column
- In-scope User Stories (from CSV, children of this Feature)
- The `## Code thật` section naming the implementing C++ subsystems (or `—` for gap/content)
- If Sub Features exist: `### <Sub-Mã>` sections for each

The `ld/GM-DC_daily_challenge.md` gap-doc pattern SHALL be followed for Features with status ❌.

#### Scenario: New Feature added to CSV
- **WHEN** a Feature has status ❌ (gap — no code yet)
- **THEN** its ld doc SHALL follow the gap-doc pattern: header, CSV description, status ❌, list of parent User Stories, and `**Code thật**: — (chưa có code)`.

#### Scenario: Sub Feature appears in CSV
- **WHEN** a CSV row of Type "Sub Feature" exists and its parent is a Feature that has its own Mã
- **THEN** the Sub Feature SHALL be a `###` section inside the parent Feature's ld doc, NOT a separate ld file

### Requirement: Audit doc (audit/)

Every Feature with a Mã SHALL have a `Docs/audit/<Mã>_<kebab-name>.md` file. Sub Features SHALL follow the same nesting rule as ld/.

Each audit doc SHALL contain:
- Frontmatter with Mã, OP ID, Status
- The exact status check for each implementing subsystem, as per the existing `Docs/audit/` convention

#### Scenario: Gap Feature audit
- **WHEN** a Feature has status ❌ (no code)
- **THEN** its audit doc SHALL contain `### Missing — code chưa impl` as the sole section, with the explanation that the feature exists in CSV but has no C++ subsystem yet

### Requirement: Portal pages

Every Feature with a Mã SHALL have a `Docs/portal/src/content/docs/features/<Mã>.mdx` page.

Each mdx page SHALL:
- Use the existing Starlight frontmatter pattern (`title`, `sidebar`, `opId`, `status`, `epic`)
- Port content from the ld/ doc
- Appear in `Docs/portal/astro.config.mjs` sidebar under the correct Epic section

#### Scenario: New Feature page
- **WHEN** a Feature row is added to traceability.md
- **THEN** a portal .mdx page SHALL be created and its sidebar entry added to astro.config.mjs

### Requirement: c4 model + views

Every Epic and Feature with a Mã SHALL have a corresponding element in `Docs/c4/model.c4` using kind `epic` for Epics and `feature` for Features/Sub Features.

Every Feature with a Mã SHALL have a `<Mã>_Components` view in `Docs/c4/views.c4`.

The same element and view definitions SHALL exist in `Docs/portal/likec4/` as byte-identical copies.

#### Scenario: New Feature element
- **WHEN** a Feature row is added to traceability.md
- **THEN** a corresponding `feature` element SHALL be added to `Docs/c4/model.c4` and the `<Mã>_Components` view to `Docs/c4/views.c4`

### Requirement: structurizr workspace

Every Feature with a Mã SHALL have a `<Mã>_Components` view in `Docs/structurizr/workspace.dsl`.

#### Scenario: structurizr view rename
- **WHEN** a Feature's Mã changes (e.g. F## → CODE)
- **THEN** the old `F##_Components` view name SHALL be removed and replaced by `<CODE>_Components`

### Requirement: Feature-catalog pages

Both `Docs/structurizr/docs/04-feature-catalog.md` and `Docs/portal/src/content/docs/architecture/feature-catalog.md` SHALL contain a table matching the flat-table format in traceability.md.

#### Scenario: Catalog table update
- **WHEN** a Feature row is added to traceability.md
- **THEN** both feature-catalog pages SHALL have a corresponding row in their tables

### Requirement: Validation

The following commands SHALL exit 0 after implementation:

1. `cd Docs/c4 && npx --no-install likec4 validate .`
2. `cd Docs/structurizr && java -cp ".tools/cli/lib/*" com.structurizr.cli.StructurizrCliApplication validate -workspace workspace.dsl`
3. `cd Docs/portal && npm run build`
4. `node c4/render-ld.mjs`

#### Scenario: Validate failure
- **WHEN** any validate command exits with a non-zero status
- **THEN** the implementer SHALL fix the root cause before proceeding to the next command