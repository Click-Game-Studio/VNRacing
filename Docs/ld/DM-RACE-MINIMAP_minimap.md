# DM-RACE-MINIMAP — Minimap — Low-Level Design

> Source: Context-engine verification (no implementation found). OpenProject: #371.

## Feature summary and boundaries

🆕 since 2026-06-23. DM-RACE-MINIMAP defines a minimap or race-track overview feature for in-race use — showing car position, track layout, opponent positions, and checkpoint progress.

❌ **Gap: feature requested but unimplemented.** OpenProject #371 defines an in-race minimap. A full search of `PrototypeRacing/` via CodeGraph and context-engine finds **no minimap widget, no minimap rendering system, no track overview UI**. The game currently has no in-race minimap — players navigate by visual track layout and checkpoint markers.

This document records the gap and proposes what needs to be built.

## Layer 1 — Implementation map

No implementation exists. The table below describes the components that **need to be built**.

| Component (proposed) | Responsibility |
|---|---|
| Minimap widget (UMG) | Small corner HUD widget showing a top-down track overview. |
| Track map data asset | Per-track minimap texture or procedural track footprint. |
| Player/enemy position markers | Real-time position blips on the minimap. |
| Checkpoint progress | Visual markers showing next checkpoint, completed checkpoints. |

## Layer 2 — Contract surface

No verified entry points exist. Proposed integration points:
- Minimap should be rendered as a UMG overlay (not a 3D in-world element).
- Track map data could be authored per-track by the Level Design team as a simple texture.
- Player position comes from `ASimulatePhysicsCar` transform; opponent positions from replicated car states.
- Checkpoint progress from `ARaceTrackManager` checkpoint state.

## Links

- Portal: `Docs/portal/src/content/docs/features/dm-race.md`
- Cross-ref: DM-RACE (race lifecycle), DM-CAM (camera)
