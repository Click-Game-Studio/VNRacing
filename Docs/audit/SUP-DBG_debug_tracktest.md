# SUP-DBG — Debug & Track Test

## Phạm vi
Framework module debug + batch sim AI/track + export dữ liệu.

## Module/class C++ liên quan (file thật)
- `DebugSystem/DebugToolsSubsystem.cpp` — `UDebugToolsSubsystem` host 10 `DebugModule_*` (Camera/Cheat/Gameplay/Overlay/Progression/Rendering/TestMaps/TrackLogic/Tutorial/Vehicle, trong `DebugSystem/Modules/`).
- `TrackTestSystem/BatchSimulationManager.cpp` — `UBatchSimulationManager` (state-machine batch sim).
- `TrackTestSystem/MistakeDetector.cpp` — `UMistakeDetector` (phát hiện đi sai làn).
- `DebugSystem/RaceDataCollector.cpp` — `URaceDataCollector` (thu data per-frame khi test).

## Blueprint liên quan
- BP debug panel, WBP_DebugPanel, StateOverlayWidget. Chỉ dùng trong dev build.

## Điểm nóng hiệu năng cụ thể (đã đọc/grep)
1. **`UMistakeDetector` TickComponent + `GetAllActorsOfClassWithTag` mỗi lần quét biên** — `MistakeDetector.cpp:113` `GetAllActorsOfClassWithTag(World, ACollisionSplineTool, "BoundaryLeft", LeftActors)` và `:126` tương tự "BoundaryRight". Quét toàn world theo tag để lấy spline biên. Nếu gọi trong/định kỳ theo tick test thì tốn. Là **tool test** (không vào build shipping), nhưng vẫn là hotspot trong phiên test.
2. **`URaceDataCollector` thu data per-frame** — TickComponent capture dữ liệu mỗi frame trong lúc chạy test. Đúng mục đích (thu telemetry), nhưng nặng — chỉ nên bật khi đang record.
3. **`StaticLoadClass` panel debug** — `DebugToolsSubsystem.cpp:267` `StaticLoadClass(UDebugPanelWidget::StaticClass(), nullptr, PanelWidgetClassPath)` blocking load khi mở panel. Dev-only.
4. **`LoadSynchronous` overlay** — `DebugModule_Overlay.cpp:184` `StatsOverlaySoftClass_TrackTest.LoadSynchronous()`. Dev-only.
5. **`UBatchSimulationManager` tick theo state** — dispatch theo state machine, rẻ khi idle (mô tả C4). Tốt.

## Nợ kỹ thuật cụ thể
- **Quan trọng: phải đảm bảo DebugSystem/TrackTestSystem KHÔNG là dependency shipping.** `RacingCarController.cpp:5-7` đã bọc `#if (!UE_BUILD_SHIPPING) #include "DebugSystem/DebugGestureSubsystem.h" #endif` → tốt, có ý thức tách. Cần audit toàn bộ include debug ở các module gameplay khác để chắc chắn không leak.
- `MistakeDetector` + `RaceDataCollector` là TickComponent — nếu component này vô tình gắn vào xe trong build thường sẽ tick thừa. Cần xác nhận chỉ spawn trong TrackTest GameMode.

## Audit Blueprint
BP debug dev-only; không cần kiểm tra editor cho shipping.

## Mức ưu tiên: **P2** (dev-only) — nhưng **P1 cho việc xác minh không leak vào shipping**
Lý do: bản thân là tooling không ảnh hưởng người chơi. Rủi ro thật là leak dependency/Tick component vào build thường — cần kiểm tra biên giới build.
