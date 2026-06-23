# 07. Decisions and Links

## ADR index

- ADR-0001: Move race ranking updates off per-frame Tick and remove client-side world scan.
- ADR-0002: Canonical architecture review uses Structurizr Lite/Cloud/on-prem; static export is diagram snapshot only.

## Serving and export note

Structurizr DSL imports docs and ADRs with `!docs docs` and `!adrs adrs`. The canonical review path is Structurizr Lite, Cloud or on-prem so reviewers can see diagrams, documentation and decisions together.

Static exports are useful for diagram snapshots, but they strip or omit the rich documentation/decision review experience. Do not treat a static export as the canonical architecture package.

## Source links

- High-level design: `Docs/VNRacing_HLD.md`
- Low-level design: `Docs/VNRacing_LLD.md`
- Feature audits: `Docs/audit/00_SUMMARY.md` and per-feature audits keyed by new code (DM-*/VT-*/GM-*/CU-*/CDN/SUP-*) — see `Docs/traceability.md`
- Feature LDs: per-feature LDs keyed by new code — see `Docs/traceability.md` and `Docs/_legacy_F-map.md`
- LikeC4 source model: `Docs/c4/model.c4`
- Structurizr workspace: `Docs/structurizr/workspace.dsl`
