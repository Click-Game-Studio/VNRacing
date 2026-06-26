# 01. Introduction

## Purpose

This Structurizr workspace is the canonical architecture hub for VNRacing / PrototypeRacing. It combines C4 maps, arc42-style documentation, ADRs, source-grounded audit links and lightweight low-level feature design notes.

The rollout is keyed to the OpenProject 2026-06-15 product taxonomy (Epic > Feature). Inputs are `Docs/traceability.md` (the id↔code↔status master), `Docs/audit`, `Docs/c4/model.c4`, `Docs/ld/DM-RACE_basic_racing.md`, `Docs/VNRacing_HLD.md`, `Docs/VNRacing_LLD.md` and read-only source evidence under `PrototypeRacing/Source`.

## Documentation rules

1. Source evidence wins over older documents when class names, ownership or runtime behavior conflict.
2. Displayed component names remove Unreal prefixes such as `A`, `U`, `F`, `E`, `I`, `T` and `BP_` for readability. UE type is preserved in technology, description and source mappings.
3. C4 diagrams are maps/navigation. LD documents and audits carry implementation detail.
4. Blueprint behavior is only claimed where audit evidence or already-available metadata exists. Wider Blueprint graph review remains an evidence gap.
5. Generated/build/package folders are not documentation sources.
6. This rollout changes documentation/tooling only; it does not modify game code or Blueprint assets.

## Primary diagrams

![System context](embed:SystemContext)

![Container view](embed:Containers)

## Feature view keys

Dedicated component views exist per product feature, named `<CODE>_Components` — Drive Mode (`DM_PHYS`, `DM_RACE`, `DM_NOS`, `DM_RAMP`, `DM_CAM`, `DM_SET`), VNTour (`VT_CITY`, `VT_TRACK`, `VT_CARPROG`, `VT_REWARD`), Game Mode (`GM_MP`), Customize (`CU_ROOM`), `CDN`, plus support systems (`SUP_AI`, `SUP_POOL`, `SUP_INV`, `SUP_PROF`, `SUP_SHOP`, `SUP_TUT`, `SUP_DBG`, `SUP_PERF`). Container-level overview views also exist for gameplay, meta, backend and tooling. See `Docs/traceability.md` and `Docs/_legacy_F-map.md`.
