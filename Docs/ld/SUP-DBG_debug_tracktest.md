# SUP-DBG — Debug & Track Test (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-DBG_debug_tracktest.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_DBG_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-DBG owns debug modules, batch simulation, track-test mistake detection and race data collection. It must remain a development/test support boundary rather than a hidden shipping dependency.

![SUP-DBG components](../structurizr/embed/SUP_DBG_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UDebugToolsSubsystem` | debug source | Hosts DebugModule_* for camera, cheat, gameplay, overlay, progression, rendering, test maps, track logic, tutorial and vehicle. |
| `UBatchSimulationManager` | batch source | State-machine batch AI/track simulation; cheap while idle. |
| `UMistakeDetector` | `MistakeDetector.cpp:113,126` | Per-frame mistake detection and boundary spline lookup in test mode. |
| `URaceDataCollector` | collector source | Per-frame data capture during test runs. |

Runtime flow: debug subsystem exposes modules; batch simulation drives race/test runs; mistake detector and data collector sample car/track state during active test sessions.

Hotspots: mistake detector ticks and uses `GetAllActorsOfClassWithTag`; acceptable only when isolated to test/debug flows.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: debug module registration/hosting, batch simulation state machine, mistake detector sampling, race data collector capture/export path.

Evidence gap: shipping-build exclusion policy should be verified in build configuration before release.

## Links

- Audit: `Docs/audit/SUP-DBG_debug_tracktest.md`
- Structurizr: `SUP_DBG_Components`
