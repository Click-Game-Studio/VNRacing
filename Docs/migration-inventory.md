---
title: "Migration Inventory"
description: "Danh sách tất cả file cần di chuyển trong quá trình tái cấu trúc"
version: "1.1.0"
last_updated: "2026-02-02"
status: "active"
migration_phase: "Phase 1 - Foundation"
---

# Migration Inventory

**Breadcrumbs:** [Docs](./README.md) > migration-inventory

## Tổng Quan

Tài liệu này liệt kê tất cả các file trong `Docs/` cần được di chuyển trong quá trình tái cấu trúc documentation.

### Thống Kê

| Loại | Số Lượng | Trạng Thái |
|------|----------|------------|
| Markdown Files (.md) | 142 | ⏳ Pending |
| PDF Files (.pdf) | 6 | ⏳ Pending |
| CSV Files (.csv) | 4 | ⏳ Pending |
| HTML Files (.html) | 2 | ⏳ Pending |
| Image Files (.png, .docx) | 4 | ⏳ Pending |
| **Tổng Cộng** | **158** | |

---

## 1. Root Level Files

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 1 | `Docs/README.md` | Giữ nguyên (root README) | ⏳ Pending |
| 2 | `Docs/CHANGELOG.md` | Giữ nguyên (root CHANGELOG) | ⏳ Pending |

---

## 2. _architecture/ → 3-high-level-design/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 3 | `_architecture/system-overview.md` | `3-high-level-design/general-diagram/` | ⏳ Pending |
| 4 | `_architecture/data-flow.md` | `3-high-level-design/general-diagram/` | ⏳ Pending |
| 5 | `_architecture/integration-patterns.md` | `3-high-level-design/general-diagram/` | ⏳ Pending |
| 6 | `_architecture/technology-stack.md` | `3-high-level-design/tech-requirements/` | ⏳ Pending |
| 7 | `_architecture/mobile-optimization.md` | `3-high-level-design/tech-requirements/` | ⏳ Pending |
| 8 | `_architecture/performance-targets.md` | `3-high-level-design/tech-requirements/` | ⏳ Pending |
| 9 | `_architecture/security-architecture.md` | `3-high-level-design/tech-requirements/` | ⏳ Pending |
| 10 | `_architecture/README.md` | `_archive/features/` | ⏳ Pending |

---

## 3. _standards/ (KEEP - không migrate)

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 11 | `_standards/*` | Giữ nguyên tại `_standards/` | ✅ Keep |

---

## 4. _cross-reference/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 12 | `_cross-reference/feature-dependency-matrix.md` | `5-uml-components/general/` | ⏳ Pending |
| 13 | `_cross-reference/api-integration-map.md` | `3-high-level-design/online-model/` | ⏳ Pending |
| 14 | `_cross-reference/data-structure-index.md` | `4-data-modeling/data-schema/` | ⏳ Pending |
| 15 | `_cross-reference/component-interaction-map.md` | `5-uml-components/diagrams/` | ⏳ Pending |

---

## 5. _templates/ → 7-context-system/templates/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 16 | `_templates/requirements/*` | `7-context-system/templates/requirements/` | ⏳ Pending |
| 17 | `_templates/design/*` | `7-context-system/templates/design/` | ⏳ Pending |
| 18 | `_templates/planning/*` | `7-context-system/templates/planning/` | ⏳ Pending |
| 19 | `_templates/implementation/*` | `7-context-system/templates/implementation/` | ⏳ Pending |
| 20 | `_templates/testing/*` | `7-context-system/templates/testing/` | ⏳ Pending |
| 21 | `_templates/README.md` | `_archive/_templates/` | ⏳ Pending |

---

## 6. _reports/ → _archive/_reports/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 22 | `_reports/source-documentation-sync-report.md` | `_archive/_reports/` | ⏳ Pending |

---

## 7. features/car-physics/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 23 | `features/car-physics/README.md` | `_archive/features/car-physics/` | ⏳ Pending |
| 24 | `features/car-physics/design/*` | `5-uml-components/modules/car-physics/` | ⏳ Pending |
| 25 | `features/car-physics/requirements/*` | `2-features-userstories/car-physics/` | ⏳ Pending |
| 26 | `features/car-physics/planning/*` | `_archive/features/car-physics/planning/` | ⏳ Pending |
| 27 | `features/car-physics/implementation/*` | `_archive/features/car-physics/implementation/` | ⏳ Pending |
| 28 | `features/car-physics/testing/*` | `_archive/features/car-physics/testing/` | ⏳ Pending |
| 29 | `features/car-physics/**/*.pdf` | `_archive/assets/` | ⏳ Pending |
| 30 | `features/car-physics/**/*.docx` | `_archive/assets/` | ⏳ Pending |

---

## 8. features/car-customization/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 31 | `features/car-customization/README.md` | `_archive/features/car-customization/` | ⏳ Pending |
| 32 | `features/car-customization/design/*` | `5-uml-components/modules/car-customization/` | ⏳ Pending |
| 33 | `features/car-customization/requirements/*` | `2-features-userstories/car-customization/` | ⏳ Pending |
| 34 | `features/car-customization/planning/*` | `_archive/features/car-customization/planning/` | ⏳ Pending |
| 35 | `features/car-customization/implementation/*` | `_archive/features/car-customization/implementation/` | ⏳ Pending |
| 36 | `features/car-customization/testing/*` | `_archive/features/car-customization/testing/` | ⏳ Pending |
| 37 | `features/car-customization/**/*.pdf` | `_archive/assets/` | ⏳ Pending |
| 38 | `features/car-customization/**/*.csv` | `_archive/assets/` | ⏳ Pending |
| 39 | `features/car-customization/**/*.html` | `_archive/assets/` | ⏳ Pending |

---

## 9. features/progression-system/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 40 | `features/progression-system/README.md` | `_archive/features/progression-system/` | ⏳ Pending |
| 41 | `features/progression-system/design/*` | `5-uml-components/modules/progression-system/` | ⏳ Pending |
| 42 | `features/progression-system/requirements/*` | `2-features-userstories/progression-system/` | ⏳ Pending |
| 43 | `features/progression-system/planning/*` | `_archive/features/progression-system/planning/` | ⏳ Pending |
| 44 | `features/progression-system/implementation/*` | `_archive/features/progression-system/implementation/` | ⏳ Pending |
| 45 | `features/progression-system/testing/*` | `_archive/features/progression-system/testing/` | ⏳ Pending |
| 46 | `features/progression-system/**/*.pdf` | `_archive/assets/` | ⏳ Pending |
| 47 | `features/progression-system/**/*.csv` | `_archive/assets/` | ⏳ Pending |
| 48 | `features/progression-system/**/*.png` | `_archive/assets/` | ⏳ Pending |

---

## 10. features/profiles-inventory/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 49 | `features/profiles-inventory/README.md` | `_archive/features/profiles-inventory/` | ⏳ Pending |
| 50 | `features/profiles-inventory/design/*` | `5-uml-components/modules/profiles-inventory/` | ⏳ Pending |
| 51 | `features/profiles-inventory/requirements/*` | `2-features-userstories/profiles-inventory/` | ⏳ Pending |
| 52 | `features/profiles-inventory/planning/*` | `_archive/features/profiles-inventory/planning/` | ⏳ Pending |
| 53 | `features/profiles-inventory/implementation/*` | `_archive/features/profiles-inventory/implementation/` | ⏳ Pending |
| 54 | `features/profiles-inventory/testing/*` | `_archive/features/profiles-inventory/testing/` | ⏳ Pending |
| 55 | `features/profiles-inventory/**/*.pdf` | `_archive/assets/` | ⏳ Pending |
| 56 | `features/profiles-inventory/**/*.csv` | `_archive/assets/` | ⏳ Pending |

---

## 11. features/multiplayer/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 57 | `features/multiplayer/README.md` | `_archive/features/multiplayer/` | ⏳ Pending |
| 58 | `features/multiplayer/design/*` | `5-uml-components/modules/multiplayer/` | ⏳ Pending |
| 59 | `features/multiplayer/requirements/*` | `2-features-userstories/multiplayer/` | ⏳ Pending |
| 60 | `features/multiplayer/planning/*` | `_archive/features/multiplayer/planning/` | ⏳ Pending |
| 61 | `features/multiplayer/implementation/*` | `_archive/features/multiplayer/implementation/` | ⏳ Pending |
| 62 | `features/multiplayer/testing/*` | `_archive/features/multiplayer/testing/` | ⏳ Pending |
| 63 | `features/multiplayer/**/*.pdf` | `_archive/assets/` | ⏳ Pending |

---

## 12. features/shop-system/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 64 | `features/shop-system/README.md` | `_archive/features/shop-system/` | ⏳ Pending |
| 65 | `features/shop-system/design/*` | `5-uml-components/modules/shop-system/` | ⏳ Pending |
| 66 | `features/shop-system/requirements/*` | `2-features-userstories/shop-system/` | ⏳ Pending |
| 67 | `features/shop-system/planning/*` | `_archive/features/shop-system/planning/` | ⏳ Pending |
| 68 | `features/shop-system/implementation/*` | `_archive/features/shop-system/implementation/` | ⏳ Pending |
| 69 | `features/shop-system/testing/*` | `_archive/features/shop-system/testing/` | ⏳ Pending |

---

## 13. features/race-modes/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 70 | `features/race-modes/README.md` | `_archive/features/race-modes/` | ⏳ Pending |
| 71 | `features/race-modes/design/*` | `5-uml-components/modules/race-modes/` | ⏳ Pending |
| 72 | `features/race-modes/requirements/*` | `2-features-userstories/race-modes/` | ⏳ Pending |
| 73 | `features/race-modes/planning/*` | `_archive/features/race-modes/planning/` | ⏳ Pending |
| 74 | `features/race-modes/implementation/*` | `_archive/features/race-modes/implementation/` | ⏳ Pending |
| 75 | `features/race-modes/testing/*` | `_archive/features/race-modes/testing/` | ⏳ Pending |
| 76 | `features/race-modes/**/*.docx` | `_archive/assets/` | ⏳ Pending |

---

## 14. features/racer-ai/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 77 | `features/racer-ai/README.md` | `_archive/features/racer-ai/` | ⏳ Pending |
| 78 | `features/racer-ai/design/*` | `5-uml-components/modules/racer-ai/` | ⏳ Pending |
| 79 | `features/racer-ai/requirements/*` | `2-features-userstories/racer-ai/` | ⏳ Pending |
| 80 | `features/racer-ai/planning/*` | `_archive/features/racer-ai/planning/` | ⏳ Pending |
| 81 | `features/racer-ai/implementation/*` | `_archive/features/racer-ai/implementation/` | ⏳ Pending |
| 82 | `features/racer-ai/testing/*` | `_archive/features/racer-ai/testing/` | ⏳ Pending |
| 83 | `features/racer-ai/**/*.pdf` | `_archive/assets/` | ⏳ Pending |

---

## 15. features/minimap-system/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 84 | `features/minimap-system/README.md` | `_archive/features/minimap-system/` | ⏳ Pending |
| 85 | `features/minimap-system/design/*` | `5-uml-components/modules/minimap-system/` | ⏳ Pending |
| 86 | `features/minimap-system/requirements/*` | `2-features-userstories/minimap-system/` | ⏳ Pending |
| 87 | `features/minimap-system/planning/*` | `_archive/features/minimap-system/planning/` | ⏳ Pending |
| 88 | `features/minimap-system/implementation/*` | `_archive/features/minimap-system/implementation/` | ⏳ Pending |
| 89 | `features/minimap-system/testing/*` | `_archive/features/minimap-system/testing/` | ⏳ Pending |

---

## 16. features/setting-system/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 90 | `features/setting-system/README.md` | `_archive/features/setting-system/` | ⏳ Pending |
| 91 | `features/setting-system/design/*` | `5-uml-components/modules/setting-system/` | ⏳ Pending |
| 92 | `features/setting-system/requirements/*` | `2-features-userstories/setting-system/` | ⏳ Pending |

---

## 17. features/tutorials/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 93 | `features/tutorials/README.md` | `_archive/features/tutorials/` | ⏳ Pending |
| 94 | `features/tutorials/design/*` | `5-uml-components/modules/tutorials/` | ⏳ Pending |
| 95 | `features/tutorials/requirements/*` | `2-features-userstories/tutorials/` | ⏳ Pending |
| 96 | `features/tutorials/planning/*` | `_archive/features/tutorials/planning/` | ⏳ Pending |
| 97 | `features/tutorials/implementation/*` | `_archive/features/tutorials/implementation/` | ⏳ Pending |
| 98 | `features/tutorials/testing/*` | `_archive/features/tutorials/testing/` | ⏳ Pending |

---

## 18. features/ui-ux/

| # | File Hiện Tại | Đích Đến | Trạng Thái |
|---|---------------|----------|------------|
| 99 | `features/ui-ux/README.md` | `_archive/features/ui-ux/` | ⏳ Pending |
| 100 | `features/ui-ux/design/*` | `5-uml-components/modules/ui-ux/` | ⏳ Pending |
| 101 | `features/ui-ux/requirements/*` | `2-features-userstories/ui-ux/` | ⏳ Pending |
| 102 | `features/ui-ux/implementation/*` | `_archive/features/ui-ux/implementation/` | ⏳ Pending |

---

## Ghi Chú Migration

### Quy Tắc Di Chuyển

1. **Giữ nguyên nội dung file** - Chỉ thay đổi đường dẫn
2. **Cập nhật breadcrumbs** - Sau khi di chuyển
3. **Cập nhật cross-references** - Trong Phase 7
4. **Archive file gốc** - Không xóa cho đến khi hoàn tất

### Trạng Thái

| Icon | Ý Nghĩa |
|------|---------|
| ⏳ | Pending - Chưa di chuyển |
| 🔄 | In Progress - Đang di chuyển |
| ✅ | Complete - Đã hoàn tất |
| ⚠️ | Issue - Có vấn đề cần xử lý |

---

**Tổng số file**: 154 files (142 markdown + 12 non-markdown)

**Cập nhật lần cuối**: 2026-02-02

