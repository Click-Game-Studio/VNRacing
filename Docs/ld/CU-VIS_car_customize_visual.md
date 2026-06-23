# CU-VIS — Car Customize Visual — Low-Level Design

> Source: Context-engine verification (no implementation found). OpenProject: #401.
> Subs: CU-VIS-BODY #555, CU-VIS-PAINT #556, CU-VIS-PREV #557, CU-VIS-CAM #558, CU-VIS-TEST #559.

## Feature summary and boundaries

🆕 since 2026-06-23. CU-VIS defines a Visual Car Customization feature — separate from the existing CU-ROOM (Customize Room) which handles the garage/customization UI and CR calculation. CU-VIS would own the visual-only customization flow: body parts, paints/decals, preview, camera functions, and test drive.

The existing `UCarCustomizationManager` does handle mesh/material application by part name, but there is no dedicated "visual customization" subsystem or screen distinct from the general garage/customize flow. This feature is a **gap**.

### CU-VIS-BODY Customize Body Parts (#555)

🆕 since 2026-06-23. Sub-feature of CU-VIS.

❌ **Gap: not yet implemented.** Work-package #555 defines per-part body customization (bumpers, skirts, spoilers, wheels, etc.). The existing `UCustomizeCarSubsystem` applies mesh/material by part name, but there is no dedicated body-parts selection UI or part-swap workflow.

### CU-VIS-PAINT Customize Paints & Decals (#556)

🆕 since 2026-06-23. Sub-feature of CU-VIS.

❌ **Gap: not yet implemented.** Work-package #556 defines paint color selection, decal application, and material customization. No dedicated paint/decal system exists beyond basic material overrides in `UCarCustomizationManager`.

### CU-VIS-PREV Customize Preview (#557)

🆕 since 2026-06-23. Sub-feature of CU-VIS.

❌ **Gap: not yet implemented.** Work-package #557 defines a preview/viewport for the customized car showing changes in real-time. No dedicated preview system exists.

### CU-VIS-CAM Camera Functions (#558)

🆕 since 2026-06-23. Sub-feature of CU-VIS.

❌ **Gap: not yet implemented.** Work-package #558 defines camera controls in the customization preview (orbit, zoom, rotation). The existing `AFollowCarCamera` is a race chase-cam, not a preview camera.

### CU-VIS-TEST Car Test (#559)

🆕 since 2026-06-23. Sub-feature of CU-VIS.

❌ **Gap: not yet implemented.** Work-package #559 defines a test-drive button from the customization screen — entering a short track to test the customized car's feel.

## Layer 1 — Implementation map

No implementation exists for CU-VIS or any of its sub-features. The existing code in `UCarCustomizationManager` and `UCustomizeCarSubsystem` handles mesh/material application within the CU-ROOM context; they would be the foundation for building CU-VIS but currently lack a dedicated visual-customization UX.

## Layer 2 — Contract surface

No verified entry points. Proposed integration:
- CU-VIS should reuse `UCustomizeCarSubsystem::ApplyPartMesh/Material` for the actual part application.
- Preview viewport should be a separate UMG widget with a SceneCapture2D or in-level camera actor.
- Paint/Decal system could extend the existing material slot system in `UCustomizableCar`.

## Links

- Portal: `Docs/portal/src/content/docs/features/cu-vis.md`
- Cross-ref: CU-ROOM (existing customization code), DM-CAM (camera integration)
