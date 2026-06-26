# VT-MAP — VN Tour-Map Đua / Huế City — Low-Level Design

> Source: `Docs/traceability.md`. LikeC4 view: `vtMap`.
> OpenProject: #168 / #169.

## Feature summary and boundaries

VT-MAP is a **content feature**, not a runtime subsystem. It covers the level art, layout geometry and DataTable rows that represent the three Huế City race locations: Đại Nội, Quốc Học and Hồ Thuỷ Tiên. Ownership belongs to the Level/2D/3D content team; architecture code only provides the DataTable schema (`FMapDataRow`, `FAreaDataRow`, `FTrackDataRow`) that the content must conform to.

VT-MAP does **not** own unlock logic (→ VT-CITY), track difficulty (→ VT-TRACK), or car-rating gates (→ VT-CARPROG). It supplies the *data* those features read.

## Layer 1 — Content map

| Asset type | Path convention | Responsibility |
|---|---|---|
| `FMapDataRow` row | `ProgressionData` DataTable | Top-level map entry; referenced by `UProgressionSubsystem` via key `"ProgressionData"` (`ProgressionSubsystem.cpp:1813`) |
| `FAreaDataRow` rows | child of map row | Area entries for Huế City (Đại Nội / Quốc Học / Hồ Thuỷ Tiên) |
| `FTrackDataRow` rows | child of area row | Per-track metadata: `PerformanceGates`, `LocationInfo`, unlock prerequisites |
| Level assets (`.umap`) | `/Game/Levels/HueCity/` (convention) | Playable geometry; streamed by Unreal level streaming |
| Minimap / icon textures | `/Game/UI/Icons/` (convention) | Soft-object refs in DataTable rows; loaded async by `UProgressionCenterSubsystem` |

Hotspot: `ProgressionCenterSubsystem.cpp:489` calls `LoadSynchronous` on city/track icon soft-refs. Adding new areas increases the number of blocking loads triggered when the VN Tour map screen opens. Icons should be migrated to `FStreamableManager::RequestAsyncLoad`.

## Layer 2 — Schema contract (data entry points)

Content team must populate:
- `FMapDataRow.ID` — integer key matching city unlock chain.
- `FAreaDataRow` entries nested under the Huế map row.
- `FTrackDataRow.PerformanceGates` — integer CR threshold read by `UCarRatingSubsystem::GetTrackDifficultyByPerformance`.
- `FTrackUnlockData.RequiredTopRank` (default `3`) — vị thứ required to unlock the next track (`ProgressionData.h:801`).

No C++ changes are required for VT-MAP content delivery; schema changes to `FMapDataRow` / `FAreaDataRow` / `FTrackDataRow` require coordination with VT-CITY and VT-TRACK owners.

## Links

- Traceability: `Docs/traceability.md` — VT-MAP row
- Portal: `Docs/portal/src/content/docs/features/vt-map.md`
- LikeC4 view: `vtMap`
