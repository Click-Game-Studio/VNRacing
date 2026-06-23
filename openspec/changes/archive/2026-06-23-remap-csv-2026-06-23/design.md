## Context

The doc set was re-keyed from F01-F17 to the OpenProject product taxonomy in Plan B (2026-06-15). At that point the contract CSV (`OpenProject_Work_packages_2026-06-15…9yb19d.csv`), which has since been superseded by `OpenProject_Work_packages_2026-06-23…re4snw.csv` (515 rows, ~115 new items). The board team added three new Epics, ~16 new Features/Sub Features, and renamed `#320`. The existing docs — `traceability.md`, `ld/`, `audit/`, `portal/`, `c4/`, `structurizr/` — cover only the 06-15 taxonomy.

The architectural problem: the doc set has **two consumers** (architecture models c4/structurizr + portal/likec4) that must share element codes but are added in separate files (`c4/model.c4` + `portal/likec4/model.c4`). Any mismatch breaks `likec4 validate`. This design reuses Plan B's mirroring convention: edit `c4/*.c4` then copy to `portal/likec4/`.

## Goals / Non-Goals

**Goals:**
1. Assign a product code to every new Feature/Sub Feature in CSV 06-23 (additive — existing codes unchanged).
2. Flat-table rewrite of `traceability.md` (one row per Feature, Sub Features grouped by parent).
3. Create `ld/<CODE>.md` + `audit/<CODE>.md` skeleton for each new Feature (gap-doc pattern matching `GM-DC_daily_challenge.md`).
4. Create `portal/src/content/docs/features/<CODE>.mdx` for each new Feature.
5. Update `astro.config.mjs` sidebar to include new pages under the correct Epic section.
6. Add elements + views to `c4/model.c4` + `c4/views.c4`, mirror to `portal/likec4/`.
7. Update `structurizr/workspace.dsl` with `<CODE>_Components` views.
8. Update both feature-catalog pages (`structurizr/docs/04-feature-catalog.md` + `portal/src/content/docs/architecture/feature-catalog.md`).
9. All 3 validate commands exit 0.
10. `node c4/render-ld.mjs` renders all ld files without error.

**Non-Goals:**
- No UE C++ code changes.
- No CSV edits.
- No SUP-* support-subsystem refactors (they remain as-is; their audit/ld docs are already created and unchanged).
- No new content for Features that already have code (only metadata update — status, OP ID — if needed, but no new subsystem mapping).
- No new ld/audit sub-docs for Sub Features beyond what the parent Feature doc already covers (Sub Features live as sections inside their parent Feature's ld, as per Plan B convention).

## Decisions

### 1. Coding convention for new product codes
**Decision:** Codes follow the existing `EPIC-AREA` pattern: two-letter Epic prefix, hyphen, then a short mnemonic for the Feature. Sub Features append a suffix after a hyphen.

Examples:
```
#400 Theme Change          → CU-THEME
#401 Car Customize Visual  → CU-VIS
  #555 Body Parts          → CU-VIS-BODY
#402 Car Customize Perf.   → CU-PERF
  #563 Core Upgrades       → CU-PERF-CORE
#366 SHOP & IAP (Epic)     → SH
  #405 Shop Display        → SH-DISP
```

**Rationale:** Reuses the established convention from Plan B (`DM-PHYS`, `VT-CITY`). Keeps the existing alphabetical sort grouping features by Epic for readable output.

### 2. How Sub Features nest in the flat table
**Decision:** Sub Features appear as a comma-separated list in the parent Feature's row, with their own code, OP ID, status, and code reference. Each Sub Feature also gets its own `ld/` section (not separate file — section within parent's ld doc). Example row:

```
| CU-VIS  | #401 | Car Customize Visual | CUSTOMIZE | 🆕 ❌ gap | — | ... | Docs/ld/CU-VIS_car_customize_visual.md |
```

Parent Feature only gets a `ld/` file. Sub Features are sections with `###` headings inside the parent's `ld/` file.

**Rationale:** This avoids file explosion (5 Sub Features × 2 files = 10 files for one Feature). Matches Plan B convention where `VT-CITY` ld doc has `### VT-CITY-GU` sections rather than separate files.

### 3. How the `traceability.md` flat table works
**Decision:** The table has columns: Mã | OP ID | Tên Feature | Epic | 🆕 | Sub Features (compressed) | Code thật | TT | Map cũ | LD.

Rows are sorted by Epic then Mã alphabetically. Each row = one Feature. Sub Features with their own code appear as an inline list in the Sub Features column. The Support subsystems (SUP-*) maintain their own section below the product table.

**Rationale:** A user reads by Mã (the shortest identifier), not by CSV row number. The table compresses 3+ tree levels into a scannable grid.

### 4. How to handle the mirror between `c4/model.c4` and `portal/likec4/model.c4`
**Decision:** Exactly as Plan B — manually edit `Docs/c4/model.c4`, then copy (`cp`) to `Docs/portal/likec4/model.c4`. Same for `views.c4`. The files must be byte-identical.

**Rationale:** LikeC4's multi-project setup resolves both directories independently; if they diverge, `likec4 validate` reports mismatches. The `cp` after every edit is the simplest reliable sync.

### 5. How to handle `structurizr/workspace.dsl` view renames
**Decision:** Rename `F##_Components` views to `<CODE>_Components` for all codes. Old F## views are removed (no backward-compat entry needed — they're internal views). New Feature codes get a new `<CODE>_Components` view.

**Rationale:** The structurizr workspace is project-internal and the old view names are not linked from external docs.

### 6. Portal pages for new Features
**Decision:** Each new Feature gets a `.mdx` file under `portal/src/content/docs/features/`. The content is ported from the `ld/` doc, following the same frontmatter pattern as existing pages (title, sidebar label, OP ID, status, Epic). The sidebar in `astro.config.mjs` gets a new entry under the correct Epic group.

**Rationale:** Portal is the user-facing docs; every product Feature needs a page.

### 7. Validation order
**Decision:** The implementation runs these checks in dependency order:
1. `cd Docs/c4 && npx --no-install likec4 validate .` — validates c4 model (fast, fail-fast)
2. `cd Docs/structurizr && java -cp ".tools/cli/lib/*" com.structurizr.cli.StructurizrCliApplication validate -workspace workspace.dsl` — validates structurizr DSL (slower)
3. `cd Docs/portal && npm run build` — validates portal includes everything (slowest)
4. `node c4/render-ld.mjs` — renders local-design HTML for each ld file (fast)

**Rationale:** Fastest failure detection first. If likec4 fails, the rest is moot.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| **c4 ↔ portal/likec4 drift**: The `cp` mirror step is manual and can be forgotten, causing likec4 validate to fail. | The verify step runs `likec4 validate` after every implementation batch. If it fails, the fix is `cp Docs/c4/model.c4 Docs/portal/likec4/model.c4` (same for views.c4). |
| **Portal sidebar omission**: New `.mdx` pages exist but the sidebar entry is missing, building a page that can't be navigated to. | `npm run build` succeeds even with orphan pages, so this won't fail CI. Mitigate by verifying `astro.config.mjs` manually: each new <CODE>.mdx must have a corresponding sidebar entry. |
| **structurizr CLI version mismatch**: The `java -cp ".tools/cli/lib/*"` path may not resolve if the structurizr tools jar is missing. | The repo's `.gitignore` may exclude `.tools/`. Fallback: `cd Docs/structurizr && npx @structurizr/cli validate -workspace workspace.dsl` (or install CLI globally). |
| **ld file naming clashes**: Two Features could accidentally share the same shortened name. | Each `ld/<CODE>_<name>.md` uses the 2-5 char code prefix as the primary disambiguator. The `_name` portion is cosmetic and does not affect rendering. |

## Open Questions

- Should the `render-ld.mjs` script handle the new ld files, or is a separate rendering pass needed? **Answer from Plan B precedent:** `render-ld.mjs` does a `Glob("**/ld/*.md")` and renders every `.md` in the `ld/` folder; new files are automatically picked up. No script change needed.
- Does `structurizr/docs/04-feature-catalog.md` have a corresponding sidebar in structurizr? **Answer:** No sidebar — the structurizr docs are a flat set of Markdown files served by the structurizr static-site generator. No update needed beyond the file content itself.