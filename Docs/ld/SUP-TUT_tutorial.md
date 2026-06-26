# SUP-TUT — Tutorial / Onboarding (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-TUT_tutorial.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_TUT_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-TUT owns scripted tutorial state, tooltip pool, trigger conditions and control lock/unlock. It reacts to gameplay/progression events but does not own race or progression state.

![SUP-TUT components](../structurizr/embed/SUP_TUT_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UTutorialManagerSubsystem` | audit reports 674-line file | Tutorial state, tooltip pool, trigger dispatch and control lock/unlock. |
| `UTriggerCondition` | trigger source | Base/subclasses such as checkpoint-passed condition. |
| Tutorial BPs | VibeUE/audit verified | `WBP_ScriptTutorial`, `WBP_TooltipTutorial`, checkpoint trigger BPs. |

Runtime flow: DM-RACE/VT-CITY emit tutorial-relevant events, tutorial manager evaluates trigger conditions, displays tooltips/script UI and locks/unlocks control where needed.

Hotspot status: tutorial BPs checked by audit did not have active Event Tick; current risk is maintainability/size rather than race-frame cost.

# Layer 2 — Contract surface (verified entry points)

Verified entry points: tutorial manager trigger dispatch/show tooltip/control lock APIs, `UTriggerCondition` evaluation classes, gameplay/progression event consumers.

Evidence gap: full script DataTable schema and every Blueprint tutorial asset are not enumerated here.

## Links

- Audit: `Docs/audit/SUP-TUT_tutorial.md`
- Structurizr: `SUP_TUT_Components`
