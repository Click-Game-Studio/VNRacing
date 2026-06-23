# DM-RACE — Basic Racing

## Phạm vi
Vòng đời race: checkpoint/lap/ranking/timer, intro/outro sequence, setup AI, bàn giao kết quả. Không bao gồm physics xe (DM-PHYS), NOS (DM-NOS), ramp (DM-RAMP), camera (DM-CAM), hay chính sách AI (SUP-AI).

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/RaceMode/RaceTrackManager.cpp` — `ARaceTrackManager` (**1869 dòng**, orchestrator trung tâm, tick mỗi frame).
- `Source/PrototypeRacing/Private/RacingCarGameMode.cpp` — `ARacingCarGameMode`.
- `Source/PrototypeRacing/Private/RaceGameState.cpp` — `ARaceGameState`.
- `Source/PrototypeRacing/Private/RacingCarController.cpp` — `ARacingCarController` (365 dòng).
- `Source/PrototypeRacing/Private/RaceMode/RaceCheckpoint.cpp` — `ARaceCheckpoint`.
- `Source/PrototypeRacing/Private/RaceMode/RaceComponent.cpp` — `URaceComponent` (34 dòng, tick rỗng — xem điểm nóng #3).
- `Source/PrototypeRacing/BoostCheckPoint.cpp` — `ABoostCheckPoint` (Tick dòng 39–41 rỗng).

## Blueprint liên quan (verify VibeUE)
- `/Game/VehicleTemplate/Blueprints/BP_CheckPoint` — 3 node, **có `Event Tick`**.
- `/Game/VehicleTemplate/Blueprints/BP_BoostCheckPoint` — 3 node, **có `Event Tick`**.
- `/Game/VehicleTemplate/Blueprints/BP_DriftZone_Child` — 12 node, **có `Event Tick` + `Parent: Tick`**.

## Điểm nóng hiệu năng cụ thể
1. **`ARaceTrackManager::Tick` → `HandleUpdateRanking()` MỖI FRAME** (`RaceTrackManager.cpp:207–221` gọi `HandleUpdateRanking` dòng 210). Bên trong `HandleUpdateRanking` (dòng 834–877):
   - Lặp toàn bộ `ManagerPlayerInfo` tính `FVector::DistSquared` (dòng 836–864).
   - `GetPlayerRaceStates()` (dòng 865, định nghĩa dòng 583–630): `GenerateValueArray` copy + `Algo::Sort` O(n log n) + gán Ranking.
   - Lặp lại gọi `Vehicle->SetRaceRank` (dòng 866–874) và `OnRankingUpdate.Broadcast` (dòng 875).
   - Dòng 876: `GetWorld()->GetTimeSeconds()` tính xong **không dùng** — dead code.
   - **Hướng tối ưu:** `UpdateInterval = 0.3f` + `UpdateCheckpointTimerHandle` đã có sẵn (header dòng 641) — chuyển sang timer ~3–10 Hz.
2. **`ARacingCarController::HandleRankingUpdateCallToClient` — GetAllActorsOfClass + O(n²)** (`RacingCarController.cpp:286–308`): mỗi ranking update gọi `GetAllActorsOfClass(ASimulatePhysicsCar)` (dòng 291) rồi vòng lồng `for State : PlayerRaceState { for Actor : AllCars }` (dòng 293–307). `FPlayerRaceState::Vehicle` con trỏ đã có sẵn — thay bằng `State.Vehicle->CurrentRanking = State.Ranking` → O(n).
3. **`URaceComponent` tick rỗng** (`RaceComponent.cpp:12` bật `bCanEverTick=true`; `TickComponent` dòng 29–34 thân rỗng). Đặt `bCanEverTick = false`.
4. **BP checkpoint Event Tick** — `BP_CheckPoint` / `BP_BoostCheckPoint` có Event Tick; checkpoint nên thuần event-driven. Số checkpoint nhân theo mỗi track.

## Nợ kỹ thuật cụ thể
- `ARaceTrackManager` 1869 dòng — God class: race + spawn AI + style xe + sequence + visibility + reward handoff. Vi phạm SRP.
- `EnabledMapNames` (`RaceTrackManager.cpp:113–116`) — magic string tên map hardcode trong code.
- `MarkFinished` (dòng ~1533): `GetFirstPlayerController()->GetPawn()` không null-check con trỏ trung gian trước Cast.
- `EndRaceDebug` (dòng 751–831) — code debug lẫn trong file shipping, comment tiếng Việt; nên tách.

## Mức ưu tiên: **P0**
Lý do: cặp tick-ranking + `GetAllActorsOfClass` O(n²) ở controller là tổ hợp tệ nhất toàn project về "chạy 60Hz mà không cần". Tối ưu (timer + bỏ quét world) là đòn bẩy FPS lớn nhất trong race loop.
