---
section: "High Level Design Architecture"
status: "pending"
created: "2026-02-02"
---

# 3. High Level Design Architecture

Kiến trúc thiết kế cấp cao cho VNRacing.

## Mục đích

Section này chứa tài liệu kiến trúc hệ thống:
- System overview và diagrams
- Online/multiplayer model
- Technical requirements
- Architecture Decision Records (ADR)

## Cấu trúc thư mục

| Thư mục | Nội dung |
|---------|----------|
| `general-diagram/` | System overview, data flow, integration patterns |
| `online-model/` | Multiplayer architecture, Nakama/Edgegap integration |
| `tech-requirements/` | Technology stack, performance targets, mobile optimization |
| `adr/` | Architecture Decision Records |

## Nội dung sẽ được migrate

- `_architecture/*` → `3-high-level-design/`
- `_cross-reference/api-integration-map.md` → `online-model/`

