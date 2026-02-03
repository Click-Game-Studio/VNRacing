---
title: "Link Mapping"
description: "Bảng ánh xạ đường dẫn cũ sang đường dẫn mới"
version: "1.1.0"
last_updated: "2026-02-02"
status: "active"
migration_phase: "Phase 1 - Foundation"
---

# Link Mapping

**Breadcrumbs:** [Docs](./README.md) > link-mapping

## Mục Đích

Tài liệu này cung cấp bảng ánh xạ từ đường dẫn cũ sang đường dẫn mới để:

1. **Cập nhật cross-references** trong các file markdown
2. **Redirect links** nếu cần thiết
3. **Kiểm tra tính toàn vẹn** của liên kết sau migration

---

## Quy Tắc Ánh Xạ

### Prefix Mapping

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `_architecture/system-overview.md` | `3-high-level-design/general-diagram/system-overview.md` |
| `_architecture/data-flow.md` | `3-high-level-design/general-diagram/data-flow.md` |
| `_architecture/integration-patterns.md` | `3-high-level-design/general-diagram/integration-patterns.md` |
| `_architecture/technology-stack.md` | `3-high-level-design/tech-requirements/technology-stack.md` |
| `_architecture/mobile-optimization.md` | `3-high-level-design/tech-requirements/mobile-optimization.md` |
| `_architecture/performance-targets.md` | `3-high-level-design/tech-requirements/performance-targets.md` |
| `_architecture/security-architecture.md` | `3-high-level-design/tech-requirements/security-architecture.md` |
| `_cross-reference/api-integration-map.md` | `3-high-level-design/online-model/api-integration-map.md` |
| `_cross-reference/component-interaction-map.md` | `5-uml-components/diagrams/component-interaction-map.md` |
| `_cross-reference/data-structure-index.md` | `4-data-modeling/data-schema/` |
| `_cross-reference/feature-dependency-matrix.md` | `5-uml-components/general/feature-dependency-matrix.md` |
| `_templates/*` | `7-context-system/templates/` |
| `_standards/` | `_standards/` (KEEP - không migrate) |
| `features/*/requirements/*` | `2-features-userstories/[feature]/` |
| `features/*/design/*` | `5-uml-components/modules/[feature]/` |
| `features/*/planning/*` | `_archive/features/[feature]/planning/` |
| `features/*/testing/*` | `_archive/features/[feature]/testing/` |
| `features/*/implementation/*` | `_archive/features/[feature]/implementation/` |

---

## Chi Tiết Ánh Xạ

### 1. Architecture Files → 3-high-level-design/

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `_architecture/system-overview.md` | `3-high-level-design/general-diagram/system-overview.md` |
| `_architecture/data-flow.md` | `3-high-level-design/general-diagram/data-flow.md` |
| `_architecture/integration-patterns.md` | `3-high-level-design/general-diagram/integration-patterns.md` |
| `_architecture/technology-stack.md` | `3-high-level-design/tech-requirements/technology-stack.md` |
| `_architecture/mobile-optimization.md` | `3-high-level-design/tech-requirements/mobile-optimization.md` |
| `_architecture/performance-targets.md` | `3-high-level-design/tech-requirements/performance-targets.md` |
| `_architecture/security-architecture.md` | `3-high-level-design/tech-requirements/security-architecture.md` |

### 2. Cross-Reference Files

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `_cross-reference/feature-dependency-matrix.md` | `5-uml-components/general/feature-dependency-matrix.md` |
| `_cross-reference/api-integration-map.md` | `3-high-level-design/online-model/api-integration-map.md` |
| `_cross-reference/data-structure-index.md` | `4-data-modeling/data-schema/` (split) |
| `_cross-reference/component-interaction-map.md` | `5-uml-components/diagrams/component-interaction-map.md` |

### 3. Feature Requirements → 2-features-userstories/

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `features/car-physics/requirements/*` | `2-features-userstories/car-physics/` |
| `features/car-customization/requirements/*` | `2-features-userstories/car-customization/` |
| `features/progression-system/requirements/*` | `2-features-userstories/progression-system/` |
| `features/profiles-inventory/requirements/*` | `2-features-userstories/profiles-inventory/` |
| `features/multiplayer/requirements/*` | `2-features-userstories/multiplayer/` |
| `features/shop-system/requirements/*` | `2-features-userstories/shop-system/` |
| `features/race-modes/requirements/*` | `2-features-userstories/race-modes/` |
| `features/racer-ai/requirements/*` | `2-features-userstories/racer-ai/` |
| `features/minimap-system/requirements/*` | `2-features-userstories/minimap-system/` |
| `features/setting-system/requirements/*` | `2-features-userstories/setting-system/` |
| `features/tutorials/requirements/*` | `2-features-userstories/tutorials/` |
| `features/ui-ux/requirements/*` | `2-features-userstories/ui-ux/` |

### 4. Feature Designs → 5-uml-components/modules/

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `features/*/design/*` | `5-uml-components/modules/[feature]/` |

### 5. Templates → 7-context-system/templates/

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `_templates/design/*` | `7-context-system/templates/design/` |
| `_templates/implementation/*` | `7-context-system/templates/implementation/` |
| `_templates/planning/*` | `7-context-system/templates/planning/` |
| `_templates/requirements/*` | `7-context-system/templates/requirements/` |
| `_templates/testing/*` | `7-context-system/templates/testing/` |

### 6. Archive (planning, testing, implementation)

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `features/*/planning/*` | `_archive/features/[feature]/planning/` |
| `features/*/testing/*` | `_archive/features/[feature]/testing/` |
| `features/*/implementation/*` | `_archive/features/[feature]/implementation/` |

### 7. Non-Markdown Files → _archive/assets/

| Đường Dẫn Cũ | Đường Dẫn Mới |
|--------------|---------------|
| `*.pdf` | `_archive/assets/` |
| `*.docx` | `_archive/assets/` |
| `*.png` | `_archive/assets/` |
| `*.csv` | `_archive/assets/` |

---

## Regex Patterns cho Find & Replace

### Pattern 1: Architecture Links

```regex
Find: \](\(_architecture/([^)]+)\))
Replace: ](3-high-level-design/general-diagram/$2)
```

### Pattern 2: Cross-Reference Links

```regex
Find: \](\(_cross-reference/([^)]+)\))
Replace: ](5-uml-components/diagrams/$2)
```

### Pattern 3: Feature Requirements Links

```regex
Find: \](features/([^/]+)/requirements/([^)]+)\)
Replace: ](2-features-userstories/$1/$2)
```

### Pattern 4: Feature Design Links

```regex
Find: \](features/([^/]+)/design/([^)]+)\)
Replace: ](5-uml-components/modules/$1/$2)
```

---

## Validation Checklist

Sau khi migration, kiểm tra:

- [ ] Tất cả internal links hoạt động
- [ ] Breadcrumbs được cập nhật
- [ ] Relative paths chính xác
- [ ] Không có broken links
- [ ] Images và assets được tham chiếu đúng

---

## Script Hỗ Trợ

Script PowerShell để tìm và thay thế links sẽ được tạo trong Phase 7:

```powershell
# Placeholder - Script sẽ được tạo trong Phase 7
# .\scripts\update-links.ps1 -MappingFile "Docs/link-mapping.md"
```

---

**Cập nhật lần cuối**: 2026-02-02

