# CU-THEME — Theme Change — Low-Level Design

> Source: Context-engine verification. OpenProject: #400.
> Subs: CU-ROOM #299 (Customize Room_Theme Change), CU-MENU #320 (Main menu_Theme Change).

## Feature summary and boundaries

🆕 since 2026-06-23. CU-THEME consolidates the Customize Room and Main Menu into a "Theme Change" feature umbrella. Previously these were standalone features (#299 Customize Room, #320 Main menu_Level). The CSV 2026-06-23 re-parents both under Theme Change (#400).

CU-THEME owns the visual/performance customization room (CU-ROOM) and the main menu/UI shell (CU-MENU). This is a **content+UI** feature — the subsystems are existing (`UCarCustomizationManager`, `UCustomizeCarSubsystem`) but the feature grouping is new.

### CU-ROOM Customize Room_Theme Change (#299)

See `Docs/ld/CU-ROOM_customize_room.md` for the full implementation map. This sub-feature covers the visual/performance customization experience.

Status: ✅ impl (existing code through CarCustomizationManager).

### CU-MENU Main menu_Theme Change (#320)

See `Docs/ld/CU-MENU_main_menu.md` for the full content map. This sub-feature covers the main menu UI shell.

Status: 🎨 content (UI/level asset, not subsystem code).

**Note about the rename:** Work-package #320 was renamed from "Main menu_Level" to "Main menu_Theme Change" in CSV 2026-06-23. The code Mã CU-MENU is unchanged because the underlying concept (Customize-related UI shell) is the same.

## Layer 1 — Implementation map

No new code to map. Both sub-features are documented in their respective ld files:
- CU-ROOM: `Docs/ld/CU-ROOM_customize_room.md`
- CU-MENU: `Docs/ld/CU-MENU_main_menu.md`

## Links

- Portal: `Docs/portal/src/content/docs/features/cu-theme.md`
- Cross-ref: CU-ROOM, CU-MENU
