# SUP-PERF — Performance & PSO (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-PERF_performance_pso.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_PERF_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-PERF is cross-cutting support for runtime performance instrumentation, distance/significance culling and PSO/shader warmup. It observes and assists gameplay but should not own gameplay state.

![SUP-PERF components](../structurizr/embed/SUP_PERF_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UPerformanceMonitorSubsystem` | performance monitor source | Runtime FPS/performance instrumentation. |
| `ULiteSignificanceManager` | `LiteSignificanceManager.cpp:58,77-82` | Timer-driven actor/Niagara distance culling. |
| `APSOEffectManager` | PSO source | PSO warmup VFX spawn; Tick enabled but body empty. |
| `ARestLevelManager` | rest level source | FPS-stability gate before travel; tracks frame times while checking. |

Runtime flow: gameplay registers relevant actors with significance/performance helpers; PSO/rest-level flows warm content and travel when stable; monitor records runtime health.

Hotspots: `ULiteSignificanceManager` has inconsistent actor vs Niagara state idioms and `operator[]` access risk; PSO effect manager has empty Tick.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: performance monitor subsystem, significance registration/timer handling, PSO effect manager spawn/warmup flow, rest-level stability/travel gate.

Evidence gap: final PSO coverage and platform-specific shader warmup validation require device/profiling review, not just source read.

## Links

- Audit: `Docs/audit/SUP-PERF_performance_pso.md`
- Structurizr: `SUP_PERF_Components`
