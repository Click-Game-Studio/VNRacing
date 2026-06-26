# SUP-POOL — Object Pooling (Hệ thống nền — ngoài CSV) — Low-Level Design

> Source: `Docs/audit/SUP-POOL_object_pooling.md`, `Docs/c4/model.c4`. Structurizr view: `SUP_POOL_Components`.
> Ngoài danh sách feature OpenProject 2026-06-15 — hệ thống nền, ứng viên refactor.

## Feature summary and boundaries

SUP-POOL provides a world-scoped reusable actor pool and an interface contract for pooled actors. It is a support feature consumed by gameplay spawners; it should not own race rules or actor-specific behavior.

![SUP-POOL components](../structurizr/embed/SUP_POOL_Components)

# Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UActorObjectPoolSubsystem` | `ActorObjectPoolSubsystem.cpp:8-59` | Acquire/release pooled actors; tracks availability arrays and actor-class dictionary. |
| `IPoolObjectInterface` | Pool interface source | Pooled actor lifecycle callbacks. |

Runtime flow: consumer asks pool for an actor; pool returns an available instance or creates/activates one; consumer releases actor; lifecycle callbacks notify actor of create/get/release.

Hotspots: audit reports linear scan on acquire/release and `ReleaseActor` indexing `ActorClassDict[ActorToRelease]` without a guard, creating crash risk for unknown/non-pooled actors.

# Layer 2 — Contract surface (verified entry points)

Verified contract: `GetActor`/`ReleaseActor` on `UActorObjectPoolSubsystem`, and interface callbacks `OnCreate`, `OnGetFromPool`, `OnReleaseToPool` on `IPoolObjectInterface`.

Reimplementation rule: release must be idempotent/guarded for unknown actors, and pool availability lookup should avoid O(n) scans on hot paths.

## Links

- Audit: `Docs/audit/SUP-POOL_object_pooling.md`
- Structurizr: `SUP_POOL_Components`
