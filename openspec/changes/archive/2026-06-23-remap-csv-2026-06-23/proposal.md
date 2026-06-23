## Why

The OpenProject CSV used as the source of truth for VNRacing's product taxonomy was updated on 2026-06-23 (`Docs/OpenProject_Work_packages_2026-06-2320260623-9-re4snw.csv`, 515 rows) but the documentation set (`Docs/traceability.md`, `Docs/ld/`, `Docs/audit/`, `Docs/portal/`, `Docs/c4/`, `Docs/structurizr/`) is still keyed to the 2026-06-15 CSV from the last Plan B re-key. Approximately 115 new work-packages have no product code assigned, three new Epics (`#272 GAME MODE`, `#298 CUSTOMIZE`, `#366 SHOP & IAP`) are missing from the tree, and the existing flat-form traceability.md is dense enough to be hard to scan. This change re-keys the docs to the current contract so traceability, architecture diagrams, and feature pages stay aligned with what the team is actually scoping.

## What Changes

- **Rewrite `Docs/traceability.md`** from dense tree+table into a flat table with one row per Feature; Sub Features grouped under their parent in an adjacent column. Add a `🆕 since 2026-06-15` marker column for newly mapped items.
- **Add new product codes** for every Feature and Sub Feature added in CSV 06-23. Codes are additive — existing DM/VT/GM/CU/CDN/PC codes remain unchanged.
- **Rename** work-package `#320` description from `Main menu_Level` to `Main menu_Theme Change` in docs (the code `CU-MENU` is unchanged because the underlying concept — Customize-related UI shell — is the same).
- **Create skeleton `ld/<CODE>.md` and `audit/<CODE>.md` files** for each new Feature. Skeletons follow the existing `GM-DC_daily_challenge.md` "gap doc" pattern: header with code + OP ID + Epic + status, brief description from CSV, status flag, list of relevant User Stories, and an explicit "Code thật" section noting absence of subsystem code.
- **Mirror new Features into `Docs/portal/src/content/docs/features/`** as `.mdx` pages, porting the same skeleton. Add entries to `Docs/portal/astro.config.mjs` sidebar under the correct Epic section.
- **Update `Docs/c4/model.c4` + `Docs/c4/views.c4`** to add new `epic` and `feature` element kinds for the new codes, plus a `<CODE>_Components` view per new Feature. Mirror the same changes in `Docs/portal/likec4/` (the two `.c4` files must stay byte-identical — see existing Plan B convention).
- **Update `Docs/structurizr/workspace.dsl`** so every Feature gets a `<CODE>_Components` view (existing convention is `F##_Components` → rename to use new codes; back-compat is not required because views are project-internal).
- **Update both feature-catalog pages** (`Docs/structurizr/docs/04-feature-catalog.md` and `Docs/portal/src/content/docs/architecture/feature-catalog.md`) so they reflect the new flat table.
- **Update `Docs/_legacy_F-map.md`** with a note that no further F01-F17 codes have been added since 2026-06-15; the F## system is now closed and superseded by the product codes.

This change is **docs-only** — no UE source code, CSV, or support-subsystem refactors are touched. No `BREAKING` changes for end users; some old internal view names (`F##_Components`) are renamed in `structurizr/workspace.dsl` which is a **BREAKING** for any external documentation link referencing the old view IDs (acceptable because the views are internal and the change is part of an active re-key).

## Capabilities

### New Capabilities

- `feature-catalog`: The end-to-end mapping system that connects OpenProject work-packages (CSV 06-23 contract) → product codes → implementing C++ subsystems → feature design docs and architecture diagrams. Covers `Docs/traceability.md` (master), per-Feature `Docs/ld/<CODE>.md`, per-Feature `Docs/audit/<CODE>.md`, portal feature pages, c4 + structurizr views, and the two feature-catalog pages.

### Modified Capabilities

None. No spec-level behavior changes — the underlying product is unchanged; only its documentation taxonomy gains entries.

## Impact

- **Documentation**:
  - `Docs/traceability.md` (rewrite)
  - `Docs/_legacy_F-map.md` (note added)
  - `Docs/ld/` (24 existing files untouched + ~16 new skeleton files)
  - `Docs/audit/` (22 existing files untouched + ~16 new skeleton files)
  - `Docs/portal/src/content/docs/features/` (17 existing files untouched + ~16 new `.mdx`)
  - `Docs/portal/astro.config.mjs` (sidebar entries)
  - `Docs/portal/src/content/docs/architecture/feature-catalog.md` (rewrite)
  - `Docs/c4/model.c4`, `Docs/c4/views.c4` (add elements + views)
  - `Docs/portal/likec4/model.c4`, `Docs/portal/likec4/views.c4` (mirror of c4/)
  - `Docs/structurizr/workspace.dsl` (view renames + new views)
  - `Docs/structurizr/docs/04-feature-catalog.md` (rewrite)
- **Validation tooling**: 3 commands must continue to exit 0 — `npx likec4 validate` (Docs/c4), `structurizr-cli validate` (Docs/structurizr), `npm run build` (Docs/portal).
- **No code impact**: `PrototypeRacing/` UE source is untouched.
- **No contract impact**: `Docs/OpenProject_Work_packages_2026-06-23*.csv` is the source of truth and is not modified.
- **Git**: All work happens on branch `docs/versioned-c4-spike` which already has uncommitted 06-15 Plan B changes; the new work stacks on top.