# CU-PERF — Car Customize Performance — Low-Level Design

> Source: Context-engine verification (no implementation found). OpenProject: #402.
> Subs: CU-PERF-CORE #563, CU-PERF-CR #564, CU-PERF-DRIVE #565.

## Feature summary and boundaries

🆕 since 2026-06-23. CU-PERF defines a Performance Car Customization feature — separate from CU-ROOM's general garage. This feature would own the performance-tuning experience: core upgrades (engine, tires, suspension), CR/car-rating calculations display, and a performance test drive.

The existing `UCarCustomizationManager::CalculatePerformanceStats` already calculates CR from equipped parts, and `UCarRatingSubsystem` handles CR tables and performance gates. However, there is no dedicated performance-tuning UI or tuning-part system. This feature is a **gap**.

### CU-PERF-CORE Core Upgrades (#563)

🆕 since 2026-06-23. Sub-feature of CU-PERF.

❌ **Gap: not yet implemented.** Work-package #563 defines core performance upgrades (engine, transmission, tires, suspension parts). The existing part system in `UCarCustomizationManager` handles visual parts; performance parts with stat modifications would need a new slot/part type and stat-application logic.

### CU-PERF-CR Car CR Calculations (#564)

🆕 since 2026-06-23. Sub-feature of CU-PERF.

❌ **Gap: not yet implemented.** Work-package #564 defines a dedicated CR/building-points display and calculation screen. `UCarCustomizationManager::CalculatePerformanceStats` and `UCarRatingSubsystem::ResolveStartingCarRatingLevelByCityIndex` already calculate CR, but no UI shows the breakdown.

### CU-PERF-DRIVE Performance Test Drive (#565)

🆕 since 2026-06-23. Sub-feature of CU-PERF.

❌ **Gap: not yet implemented.** Work-package #565 defines a test drive specifically for performance tuning — exiting to a track to test the tuned performance stats.

## Layer 1 — Implementation map

No implementation exists for CU-PERF. Existing infrastructure that could be reused:
- `UCarCustomizationManager::CalculatePerformanceStats` — CR/stat calculation from equipped parts.
- `UCarRatingSubsystem` — CR tables and performance gates.
- `UCarSettingSubsystem` — car gameplay settings (steering sensitivity, etc. — could expand to tuning presets).

## Layer 2 — Contract surface

No verified entry points. Proposed integration:
- Performance parts should be a new `EPartCategory` value in the existing part DataTable.
- CR breakdown UI should read from `UCarCustomizationManager::CalculatePerformanceStats` and display per-stat values.
- Test drive should reuse DM-RACE track loading with a no-AI free-drive mode.

## Links

- Portal: `Docs/portal/src/content/docs/features/cu-perf.md`
- Cross-ref: CU-ROOM (existing customization code), DM-RACE (test drive tracks)
