# CDN — Content Download — Low-Level Design

> Source: `Docs/audit/CDN_content_download.md`, `Docs/c4/model.c4`.
> Structurizr view: `CDN_Components`.
> OpenProject: #250.

## Feature summary and boundaries

CDN owns on-demand pak/chunk patch lifecycle, mount status and patch/download UI. It does not own CDN infrastructure operations, AWS bucket management or map content authoring. Related work: chunk splitting + AWS upload + k6 load testing lives in **PC** (#148 Project Config, infra).

![CDN components](../structurizr/embed/CDN_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UChunkDownloaderSubsystem` | `ChunkDownloaderSubsystem.cpp` | Patch lifecycle, chunk mount, retry guard and re-entrant protection. |
| `UChunkDownloaderController` | `ChunkDownloaderController.cpp:21` | Patch widget spawn; currently uses synchronous widget class load. |
| `UChunkDownloaderWidget` | `ChunkDownloaderWidget.cpp:133-186` | Progress UI and downloadable map open flow. |

Runtime flow: controller spawns patch UI; widget/subsystem starts or retries patch; subsystem downloads/mounts chunks; widget opens downloaded content/map.

Hotspots:
- `UChunkDownloaderController.cpp:21` — `LoadSynchronous` for widget class on patch UI open. Single blocking load; low impact but should migrate to async.
- `ChunkDownloaderWidget.cpp:139` — `GetAllActorsOfClass(..., APlayerStart, PlayerStarts)` scans all PlayerStart actors, then loops for tag "Spawn" (lines 147-157). One-shot on map open; acceptable today but will slow down with more actors.
- `ChunkDownloaderWidget.cpp:169` — `StaticLoadClass` blocks when opening downloaded map. Single-shot; can hitch for large assets.
- `ChunkDownloaderWidget.cpp:180,185` — `GEngine->AddOnScreenDebugMessage` (debug strings "SUCCESS: Spawned BP_ChunkAsset..." / "ERROR: Could not load...") leaks into non-dev builds. Must be wrapped in `#if !UE_BUILD_SHIPPING`.
- Variable named `BallClass` for a generic actor class — leftover from ChunkDownloader demo; misleading.

## Layer 2 — Contract surface

Verified entry points:
- `UChunkDownloaderSubsystem` — patch start/retry/mount state; re-entrant guard.
- `UChunkDownloaderController` — widget spawn trigger.
- `UChunkDownloaderWidget` — progress/open-map flow.

Evidence gap: CDN manifest/versioning strategy and production packaging policy (chunk split sizes, AWS distribution config) are outside verified source in this LD. Those live in PC infra.

## Links

- Audit: `Docs/audit/CDN_content_download.md`
- Structurizr: `CDN_Components`
- Portal: `Docs/portal/src/content/docs/features/cdn.md`
- Cross-ref: PC (#148) — chunk splitting, AWS upload, k6 load test (infra side of CDN)
- Carried from: `ld/F13_content_download.md`
