# Compatibility Page: Decisions, Hotspots and Audit Links

> Compatibility page only. This older DM-RACE (ex-F02) sample decisions/audit page is not the canonical all-feature decisions and links page.
>
> Use the canonical page instead: [07. Decisions and Links](07-decisions-and-links.md).

## Legacy DM-RACE (ex-F02) Decisions, Hotspots and Audit Links

> arc42 §9 Architecture Decisions + cross-references. DM-RACE sample round.

### Architecture Decision Records

- **ADR-0001** — Move ranking update off per-frame Tick onto a timer, and drop the world scan in the client relay. See the ADR section of this workspace.

### Performance hotspots (from audit)

| # | Priority | Hotspot | Location |
|---|----------|---------|----------|
| 1 | P0 | `Tick -> HandleUpdateRanking()` runs unconditionally every frame (distance loop + copy + O(n log n) sort + broadcast); dead code at line 876. | `RaceTrackManager.cpp:207-221`, `834-877` |
| 2 | P0 | `HandleRankingUpdateCallToClient` does `GetAllActorsOfClass` + nested loop = O(n^2) per update; `State.Vehicle` pointer already available. | `RacingCarController.cpp:286-308` |
| 3 | P1 | `RaceComponent` enables tick (`bCanEverTick=true`) with an empty `TickComponent` body. | `RaceComponent.cpp:12`, `29-34` |
| 4 | P1 | BP checkpoints (`BP_CheckPoint`, `BP_BoostCheckPoint`, `BP_DriftZone_Child`) have Event Tick; editor-only fix. | Blueprint (audit-only) |

### Technical debt (from audit)

- **God class / SRP violation** — `RaceTrackManager` is 1869 lines: race orchestration + AI setup + car styling + intro/outro sequence + checkpoint visibility + reward hand-off.
- **Magic-string map names** — `EnabledMapNames` hardcoded at `RaceTrackManager.cpp:113-116`.
- **Missing null-check** — `MarkFinished` (`RaceTrackManager.cpp:~1533`) calls `GetFirstPlayerController()->GetPawn()` without guarding the intermediate before Cast.
- **Debug code in shipping file** — `EndRaceDebug` (`RaceTrackManager.cpp:751-831`) mixed into a shipping translation unit.

### Source documents

- Low-Level Design (full DM-RACE contract + API): `Docs/ld/DM-RACE_basic_racing.md`
- Hotspot audit (file:line evidence): `Docs/audit/DM-RACE_basic_racing.md`
- System overview: `Docs/VNRacing_HLD.md` §3, `Docs/VNRacing_LLD.md`
