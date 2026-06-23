# SUP-AI — Racer AI (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-AI_racer_ai.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_AI_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-AI owns AI scheduling and driving decisions: when AI cars update, how they choose lanes/NOS/racing line, and how they query guide-line data. Vehicle physics is DM-PHYS; race lifecycle/difficulty application is DM-RACE; stat calculation comes from CU-ROOM/VT-CITY.

![SUP-AI components](../structurizr/embed/SUP_AI_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UAIManagerSubsystem` | `AIManagerSubsystem.cpp:165-190,219-225` | Round-robin scheduler; at most one AI car ticks per frame. Registration configures AI car performance and scans scheduled ticks for duplicates. |
| `UAIDecisionComponent` | AI decision source | Per-car driving decision, racing-line and NOS checks. Audit marks per-car TickComponent as hotspot. |
| `UGuideLineSubsystem` | guide-line source | Lane/contender resolution; initializes closest track mark from world actors. |

Runtime flow: DM-RACE creates/configures AI cars and applies difficulty tuning; `UAIManagerSubsystem` schedules `AutoDrive(dt)` work; `UAIDecisionComponent` queries `UGuideLineSubsystem` for lanes and state; car stat tuning can call CU-ROOM customization/stat calculation.

Hotspots: `ConfigAiCarPerformance` calls `CalculatePerformanceStats`; `RegisterAICar` scans `AIScheduledTicks`; decision components can still run per-car Tick work. See audit for exact source references.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: AI car registration/scheduling in `UAIManagerSubsystem`, per-car decision component `UAIDecisionComponent`, lane/query provider `UGuideLineSubsystem`, DM-RACE relationship `ApplyAIDifficultyTuning`, and DM-PHYS vehicle `AutoDrive(dt)` target.

Evidence gap: exact public method list should be read from headers before refactor; this LD records stable ownership and call boundaries only.

## Links

- Audit: `Docs/audit/SUP-AI_racer_ai.md`
- Structurizr: `SUP_AI_Components`
