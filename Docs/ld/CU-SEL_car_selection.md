# CU-SEL — Car Selection — Low-Level Design

> Source: Context-engine verification (no implementation found). OpenProject: #403.

## Feature summary and boundaries

🆕 since 2026-06-23. CU-SEL defines a Car Selection feature — the screen and logic for choosing which car to use before entering a race or mode. This is distinct from CU-ROOM (customization) and CU-VIS (visual customization).

❌ **Gap: feature requested but unimplemented.** OpenProject #403 defines a car selection flow. A full search of `PrototypeRacing/` via CodeGraph and context-engine finds **no dedicated car selection subsystem or screen**. The game currently has no multi-car selection UI — the player owns one car at a time in progression, and car unlock (VT-CITY-CU) adds cars to the garage without a selection screen.

This document records the gap and proposes what needs to be built.

## Layer 1 — Implementation map

No implementation exists. The table below describes the components that **need to be built**.

| Component (proposed) | Responsibility |
|---|---|
| Car Selection Screen (UMG) | Grid or list of owned cars with stats thumbnail, CR rating, visual preview. |
| `UCarSelectionSubsystem` | Manages which car is currently selected for the next race; syncs with garage/inventory. |
| Car stat comparison widget | Side-by-side stat comparison between owned cars. |

## Layer 2 — Contract surface

No verified entry points exist. Proposed integration points:
- Car selection should read from `UInventoryManager` / garage system to list owned cars.
- Selected car should be passed to `ARaceTrackManager` or `ARacingCarGameMode` at race start.
- Stats displayed should come from `UCarCustomizationManager::CalculatePerformanceStats`.

## Links

- Portal: `Docs/portal/src/content/docs/features/cu-sel.md`
- Cross-ref: CU-ROOM (car stats), VT-CITY-CU (car unlock)
