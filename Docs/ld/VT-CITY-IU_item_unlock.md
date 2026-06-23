# VT-CITY-IU — Item Unlock — Low-Level Design

> Source: Context-engine verification (no implementation found). OpenProject: #386.

## Feature summary and boundaries

🆕 since 2026-06-23. VT-CITY-IU defines an Item Unlock feature within City Progression — unlocking new items (visual parts, consumables, currency) as rewards for city progression milestones.

❌ **Gap: feature requested but unimplemented.** OpenProject #386 defines item unlock as part of city progression. A full search of `PrototypeRacing/` via CodeGraph and context-engine finds **no dedicated item unlock system** keyed to city progression. The existing `UProgressionSubsystem` handles city/area/track unlock and goal rewards, but there is no item-unlock milestone giving specific items at specific city stages.

This document records the gap and proposes what needs to be built.

## Layer 1 — Implementation map

No implementation exists. Proposed integration:
- Item unlock data could be added to the `FCityUnlockData` or a new city milestone DataTable row.
- When a new city is unlocked (via `HandleUnlockNextCity`), check the milestone table and grant items.
- Item grant should delegate to `UInventoryManager::AddItem` for inventory management.

## Layer 2 — Contract surface

No verified entry points exist. Proposed:
- Extend `FCityUnlockData` with `TArray<FItemGrant> ItemsToUnlock`.
- In `HandleUnlockNextCity`, after unlocking the city, iterate ItemsToUnlock and call inventory grant.

## Links

- Portal: `Docs/portal/src/content/docs/features/vt-city.md`
- Cross-ref: VT-CITY (city progression), VT-REWARD (reward pipeline), SUP-INV (inventory)
