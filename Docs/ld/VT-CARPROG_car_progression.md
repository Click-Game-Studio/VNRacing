# VT-CARPROG — Car-Progression — Low-Level Design

> Source: `Docs/audit/VT-CARPROG_car_progression.md`, `Docs/c4/model.c4`. Structurizr view: `VT_CARPROG_Components`.
> OpenProject: #344.

## Feature summary and boundaries

VT-CARPROG owns the car-rating (CR) progression system: how a player's starting CR is determined by their current city index, how CR scales with upgrades, and how AI opponent CR is configured per city and difficulty tier. It also covers the Dummy Car mechanic — the placeholder car entry used before a real car is unlocked.

VT-CARPROG is consumed by VT-TRACK (track difficulty calculation) and by CU-ROOM (upgrade cost gating). It does **not** own the upgrade UI or inventory — those belong to CU-ROOM and SUP-INV respectively.

![VT-CARPROG components](../structurizr/embed/VT_CARPROG_Components)

## Layer 1 — Implementation map and hotspots

| Component | Source mapping | Responsibility |
|---|---|---|
| `UCarRatingSubsystem` | `CarRatingSubsystem.cpp` | CR tables, starting CR resolution, AI CR by city/difficulty, track difficulty gate. |
| `ResolveStartingCarRatingLevelByCityIndex(int32)` | `CarRatingSubsystem.cpp:212` | Returns `CityIndex * 3` — linear CR baseline for a newly-unlocked city. Called by `GetStartingCarRatingStatsByCityPosition` and `ResolveCarRatingLevelByUpgradeIndex`. |
| `ResolveCarRatingLevelByUpgradeIndex` | `CarRatingSubsystem.cpp:224` | Combines starting CR and upgrade level; consumed by `UCarCustomizationManager::GetCarRating` (`CarCustomizationManager.cpp:1054`). |
| `FCityAICarRating` | `CarRatingSubsystem.h:158` | DataTable row: `CityIndex`, `EasyCarRatingLevel`, `MediumCarRatingLevel`, `HardCarRatingLevel`; drives AI CR per city/difficulty. |
| `GetTrackDifficultyByPerformance` | `CarRatingSubsystem.cpp:189` | Compares player CR to `PerformanceGates`; returns `ETrackDifficulty`; tolerance band configurable. |
| `GetGlobalCR` / `GetCityByCarId` | `ProgressionDebugManager.cpp:1055` / `1396` | Debug utilities; read CR without side-effects. |

Runtime flow: on city unlock, `ResolveStartingCarRatingLevelByCityIndex(newCityIndex)` sets the CR floor for the Dummy Car. On car upgrade, `UCarCustomizationManager::GetCarRating` calls `ResolveCarRatingLevelByUpgradeIndex` → result flows into `RecalculateTrackDifficulty` (VT-TRACK).

AI flow: `ARacingCarGameMode` reads `FCityAICarRating` row for the active city + selected difficulty → sets AI car CR before race start.

Hotspot: `ResolveStartingCarRatingLevelByCityIndex` is a pure arithmetic formula (`CityIndex * 3`). Simple now, but any non-linear CR scaling will require a table-driven replacement.

## Layer 2 — Contract surface

- `ResolveStartingCarRatingLevelByCityIndex(int32 CityIndex) → int32` — starting CR for Dummy Car; called on city unlock.
- `ResolveCarRatingLevelByUpgradeIndex(int32 CityPosition, int32 UpgradeLevel) → float` — live player CR; called by car customisation.
- `GetTrackDifficultyByPerformance(int32 PlayerPerformance, int32 TrackPerformanceRequire, float PercentTolerance) → ETrackDifficulty` — difficulty gate; called by VT-TRACK.
- `FCityAICarRating` DataTable — content-driven AI CR; no code change to tune per city/difficulty.

Evidence gap: Dummy Car definition (which `UCarConfiguration` entry acts as placeholder) is not confirmed in code. Verify in `ProgressionData` DataTable and `EnsureGarageCarsFromProgression` logic.

## Links

- Audit: `Docs/audit/VT-CARPROG_car_progression.md`
- Structurizr: `VT_CARPROG_Components`
- Portal: `Docs/portal/src/content/docs/features/vt-carprog.md`
- Related: VT-TRACK (consumes CR for difficulty), CU-ROOM (upgrade source), VT-CITY (triggers city index change)
