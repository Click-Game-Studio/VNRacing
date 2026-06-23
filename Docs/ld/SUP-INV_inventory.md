# SUP-INV — Inventory (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-INV_inventory.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_INV_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-INV owns item ownership, equip/favorite state, definition lookup and persistence hand-off. Rewards grant items through inventory; customization checks required items through inventory.

![SUP-INV components](../structurizr/embed/SUP_INV_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UInventoryManager` | inventory manager source | Add/remove/equip/favorite item state; backend-authority lock gate; saves on mutation. |
| `UItemDatabase` | `ItemDatabase.cpp:36-44` | Item definition database backed by DataTable/cache. |

Runtime flow: reward/customization/UI calls inventory manager; manager resolves item definition, mutates ownership/equip state and persists through save manager.

Hotspot: audit reports `UItemDatabase::GetItemDefinition` bypasses `ItemCache`, calls `FindRow` directly and lacks a null-check on `ItemDefinitionsTable`.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: item add/remove/equip/favorite APIs on `UInventoryManager`, definition lookup on `UItemDatabase::GetItemDefinition`, save hand-off through `UCarSaveGameManager`.

Evidence gap: full item row schema and mutation event/delegate list should be read from headers before API changes.

## Links

- Audit: `Docs/audit/SUP-INV_inventory.md`
- Structurizr: `SUP_INV_Components`
