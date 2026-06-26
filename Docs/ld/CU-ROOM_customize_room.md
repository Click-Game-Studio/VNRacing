# CU-ROOM — Customize Room — Low-Level Design

> Source: `Docs/audit/CU-ROOM_customize_room.md`, `Docs/c4/model.c4`.
> Structurizr view: `CU_ROOM_Components`.
> OpenProject: #299.

## Feature summary and boundaries

CU-ROOM owns visual and performance customization, car configuration persistence, CR/stat calculation and asset resolution for the Customize Room. It consumes profile currency and inventory items; it does not own profile wallet or item database definitions.

**Note:** "Car Unlock thưởng sau khi mở City" (granting a new garage car when a city unlocks) belongs to **VT-CITY** (#337 VT-CITY-CU) — not CU-ROOM. CU-ROOM is about player-driven in-room customization; VT-CITY-CU is about the progression system granting unlock entitlements.

![CU-ROOM components](../structurizr/embed/CU_ROOM_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UCarCustomizationManager` | `CarCustomizationManager.cpp:372,383,414,425,484,495,524,535,1983,1997` | Main customization subsystem (2078 lines); visual/performance parts, CR calculation, save/load and asset lookup. |
| `UCustomizeCarSubsystem` | `CustomizeCarSubsystem.cpp` | Lighter mesh/material application by part name. |
| `UCarSaveGameManager` | `CarCustomizationSystem/CarSaveGameManager.cpp` | Persists car configs, inventory, profile and progression slots. |
| `CarConfigurationJsonSerializer` | `CarCustomizationSystem/CarConfigurationJsonSerializer.cpp` | JSON serialization for backend-sync preparation. |
| `UCustomizableCar` / `UCarDataProvider` | `CustomizableCar.cpp`, `CarDataProvider.cpp` | Per-car customization state and data lookup helpers. |
| Customize UI BPs | `WBP_PerformanceStat`, WBP_UI491/493/496_CarCustomize (`/Game/CarCustomize/UI`) | Garage/customization UI widgets (41 nodes in `WBP_PerformanceStat`). |

Runtime flow: UI selects part/style/material; customization manager checks profile/inventory as needed, resolves DataTables/assets (`FindRow` ≥30 call sites across the file), applies visual/performance stats, recalculates CR and saves configuration via `UCarSaveGameManager`.

Hotspots:
- Multiple `LoadSynchronous()` calls for mesh/material paths (`CarCustomizationManager.cpp:372,383,414,425,484,495,524,535,1983,1997`) block the game thread during garage open and AI car spawn flows. `UAIManagerSubsystem::ConfigAiCarPerformance` calls into `CalculatePerformanceStats` for each AI car registration, amplifying the cost.
- `CalculatePerformanceStats` (`CarCustomizationManager.cpp:287`) scans `Config.CustomParts` and calls `FindRow<FCarPartDefinition>` (`dòng 315`) per part — called N times at race setup.
- God-object: 2078 lines mix asset resolution, stat calculation, save and visual application.
- `WBP_PerformanceStat` has an Event Tick node that is **dead/unconnected** — not an active tick hotspot, but should be removed to avoid confusion.

## Layer 2 — Contract surface

Verified entry points:
- `CalculatePerformanceStats` — called by AI setup and customization UI.
- `UCarSaveGameManager` — save/load car config, inventory, profile and progression slots.
- `CarConfigurationJsonSerializer` — JSON serialization for backend-sync.
- Profile currency spend checks and inventory required-item checks.

Evidence gap: exact function signatures and all DataTable row structs should be read from headers before reimplementation; this LD records ownership and stable collaborators.

## Links

- Audit: `Docs/audit/CU-ROOM_customize_room.md`
- Structurizr: `CU_ROOM_Components`
- Portal: `Docs/portal/src/content/docs/features/cu-room.md`
- Cross-ref: VT-CITY (Car Unlock #337 — belongs there, not here)
- Carried from: `ld/F06_car_customization.md`
