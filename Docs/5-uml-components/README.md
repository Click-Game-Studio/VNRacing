---
section: "UML Component Diagrams"
status: "pending"
created: "2026-02-02"
---

# 5. UML Component Diagrams

Sơ đồ UML Component cho VNRacing.

## Mục đích

Section này chứa các component diagrams và module designs:
- General component overview
- Module-specific designs
- Class và component diagrams

## Cấu trúc thư mục

| Thư mục | Nội dung |
|---------|----------|
| `general/` | Subsystem overview, feature dependencies |
| `modules/` | Design docs cho từng module (car-customization, progression, etc.) |
| `diagrams/` | Class diagrams, component interaction maps |

## Nội dung sẽ được migrate

- `features/*/design/` → `modules/[feature]/`
- `_cross-reference/component-interaction-map.md` → `diagrams/`
- `_cross-reference/feature-dependency-matrix.md` → `general/`

