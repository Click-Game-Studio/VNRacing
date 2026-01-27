---
feature: Documentation Language Professionalization
version: 1.0.0
status: approved
created: 2026-01-26
last_updated: 2026-01-26
---

# Documentation Language Professionalization

## Overview

Professionalize all documentation language across the VNRacing project by removing informal Vietnamese expressions, standardizing approximation notation, creating a terminology glossary, and implementing consistent placeholder formats. This initiative ensures documentation maintains a professional tone suitable for technical specifications and stakeholder review.

## Problem Statement

Current documentation contains informal Vietnamese expressions that reduce professionalism:
- Informal approximations: `~50%`, `khoảng 3 giây`
- Colloquial terms: `ít trừng phạt hơn`, `khoan dung`, `húc văng`, `đập hộp`
- Incomplete content markers: `sẽ bổ sung sau`, trailing `...`
- Inconsistent technical terminology: `Rubber Banding` vs `RubberBand`, `CoolDown` vs `Cooldown`

## User Stories

### US-DLP-001: Professional Documentation (Priority: P1) 🎯 MVP

As a developer, I want professional documentation so that I can understand technical specs clearly without informal language obscuring meaning.

**Independent Test**: Select 10 random documents and verify zero informal patterns detected.

**Acceptance Criteria**:
- [ ] AC-DLP-001: WHEN validation script runs, THEN zero informal patterns SHALL be detected across all 640 markdown files.

### US-DLP-002: Consistent Terminology (Priority: P1) 🎯 MVP

As a stakeholder, I want consistent terminology so that documentation appears professional and maintains credibility.

**Independent Test**: Search for terminology variations and verify all match glossary standards.

**Acceptance Criteria**:
- [ ] AC-DLP-002: WHEN reading any document, THEN all approximations SHALL use standard notation (approximately X or ≈X).
- [ ] AC-DLP-004: WHEN technical terms appear, THEN they SHALL match the terminology glossary.

### US-DLP-003: Standardized Placeholders (Priority: P2)

As a new team member, I want standardized placeholders so that I know what content is pending and who is responsible.

**Independent Test**: Search for placeholder patterns and verify all use standard format.

**Acceptance Criteria**:
- [ ] AC-DLP-003: WHEN content is incomplete, THEN standardized [PENDING] placeholder format SHALL be used.
- [ ] AC-DLP-005: WHEN phase documents exist, THEN they SHALL have YAML frontmatter.

## Terminology Glossary

### Informal → Professional Vietnamese

| Informal | Professional | Context |
|----------|--------------|---------|
| ít trừng phạt hơn | giảm mức độ ảnh hưởng tiêu cực | Collision mechanics |
| khoan dung | có dung sai cao / linh hoạt | Physics tolerance |
| húc văng | đẩy ra khỏi đường đua | Collision description |
| đập hộp | mở hộp quà | Loot crate mechanics |
| sẽ bổ sung sau | [PENDING] placeholder | Incomplete content |
| bứt phá qua | vượt qua | Movement |
| dính vào tường | mắc kẹt tại rào chắn | Collision |

### Approximation Notation

| Informal | Prose | Table/Code |
|----------|-------|------------|
| ~50% | approximately 50% | ≈50% |
| ~100km/h | approximately 100 km/h | ≈100 km/h |
| khoảng 3 giây | approximately 3 seconds | 3s (±0.5s) |

### Technical Terms Standardization

| Variations | Standard | Definition |
|------------|----------|------------|
| Rubber Banding, RubberBand | Rubber Banding | Dynamic difficulty adjustment |
| CoolDown, Cooldown | Cooldown | Ability recharge period |
| A.I, AI, A.I. | AI | Artificial Intelligence |

## Placeholder Format Standard

All incomplete content SHALL use this standardized format:

```markdown
> **[PENDING]** Brief description of pending content.  
> **Owner**: [Team/Role]  
> **Target Date**: [Date or TBD]
```

## Out of Scope

- Content changes (only language/formatting changes)
- Fixing corrupted code snippets
- Splitting long files into smaller documents
- Translation to English (Vietnamese remains primary language)
- Structural reorganization of documentation

## Dependencies

- **Extends**: `.kiro/specs/documentation-standardization/`
- **References**: `Docs/_standards/documentation-standards.md`
- **Scope**: 640 markdown files in `Docs/` folder

## Success Metrics

| Metric | Target |
|--------|--------|
| Informal patterns detected | 0 |
| YAML frontmatter compliance | 100% |
| Terminology glossary adherence | 100% |
| Placeholder format compliance | 100% |
| Cross-reference validity | 100% |

## Assumptions (Auto-inferred)

| Decision | Chosen | Reasoning | Alternatives |
|----------|--------|-----------|--------------|
| Primary language | Vietnamese | Existing documentation is Vietnamese | English-only |
| Approximation symbol | ≈ | Unicode standard, widely supported | ~ (informal) |
| Placeholder format | Blockquote | Visual distinction, clear ownership | Comment syntax |
| Validation approach | PowerShell script | Consistent with existing tooling | Python, Node.js |

