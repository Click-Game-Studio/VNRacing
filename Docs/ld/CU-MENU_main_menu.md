# CU-MENU — Main menu_Theme Change — Low-Level Design

> Source: `Docs/c4/model.c4`. Structurizr view: `cuMenu` (LikeC4).
> OpenProject: #320.

## Feature summary and boundaries

🎨 **Status: content.** CU-MENU is the main menu level and UI shell — a level/content asset, not a C++ subsystem. It owns the UMG/Blueprint UI shell that hosts the main menu experience and the Unreal level that serves as the game's entry/hub scene.

CU-MENU does not own any backend subsystem, progression logic or car data. It surfaces navigation into CU-ROOM (Customize Room), Game Mode selection (GM-MP, GM-DC), VN Tour (VT-*), and settings (DM-SET).

No hotspot table is applicable — this is a content/level feature with no C++ subsystem to map.

## Layer 1 — Implementation map

| Component | Type | Responsibility |
|---|---|---|
| Main Menu Level | Unreal level asset | Hub scene; loaded on game start; hosts the menu UI. |
| Main Menu UMG widget(s) | Blueprint/UMG | Navigation shell: routes player to CU-ROOM, GM-*, VT-*, DM-SET. |
| Level streaming / transitions | Blueprint | Loads and unloads sub-levels or transitions to race/tour levels. |

No C++ hotspots to report. If performance issues arise they will surface as Blueprint Tick or level-streaming hitches, which require editor profiling.

## Layer 2 — Contract surface

No C++ entry points verified. Navigation targets are the entry points of other features:
- CU-ROOM (#299) — Customize Room.
- GM-MP (#273) — Multiplayer matchmaking.
- VT-CITY (#329) — VN Tour city progression.
- DM-SET (#338) — Settings.

## Links

- Portal: `Docs/portal/src/content/docs/features/cu-menu.md`
- No audit file — content/level feature, no C++ code to audit.
- Cross-ref: CU-ROOM, GM-MP, GM-DC, VT-CITY, DM-SET
