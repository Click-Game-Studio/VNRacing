# 2. Use Structurizr Lite/Cloud/on-prem as the canonical architecture review mode

Date: 2026-06-10

## Status

Accepted

## Context

The VNRacing architecture package is not only diagrams. The workspace imports arc42-style documentation with `!docs docs` and architecture decisions with `!adrs adrs`. Reviewers need the C4 diagrams, feature catalog, quality notes, LD/audit links and ADRs together to understand the implementation map and evidence gaps.

Structurizr static export is useful for sharing diagram snapshots, but it does not preserve the full rich review experience for docs and decisions. Treating static output as canonical would hide the decision log and the source-grounded detail that explains the diagrams.

## Decision

The canonical review path for this documentation set is Structurizr Lite, Structurizr Cloud or an on-prem Structurizr deployment pointed at `Docs/structurizr/workspace.dsl`.

Static export may be generated as a supplemental diagram snapshot only. It must not be described as the complete architecture documentation package.

## Consequences

Positive:

- Reviewers see diagrams, documentation and ADRs in one navigable workspace.
- The documentation can keep C4 diagrams concise while moving detail into arc42/LD pages.
- The known static-export limitation is explicit instead of surprising reviewers.

Negative / trade-offs:

- Review requires a Structurizr runtime rather than only opening static files.
- Any Windows/Lite path quirks must be documented in local review instructions.

## References

- Workspace: `Docs/structurizr/workspace.dsl`
- Docs import: `!docs docs`
- ADR import: `!adrs adrs`
