# SUP-AI — Racer AI

## Phạm vi
Lập lịch AI (scheduling) + quyết định lái mỗi xe, racing-line + hành vi NOS.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/AISystem/AIManagerSubsystem.cpp` — `UAIManagerSubsystem` (241 dòng, TickableGameObject).
- `Source/SimpleCarPhysics/Private/PhysicsSimulateCar/AIDecisionComponent.cpp` — `UAIDecisionComponent` (per-car).
- `Source/SimpleCarPhysics/Private/GuideLineSubsystem.cpp` — `UGuideLineSubsystem` (lane/contender resolution).

## Điểm nóng hiệu năng cụ thể
1. **`UAIDecisionComponent::TickComponent` chạy 30Hz trên MỖI xe AI** (`AIDecisionComponent.cpp:50-91`). Lưu ý: tick được throttle bằng `PrimaryComponentTick.TickInterval = 1.f/30.f` (constructor dòng 20) — **KHÔNG phải mỗi frame** (đính chính so với mô tả C4 model). Mỗi tick (30Hz):
   - `EvaluateDrivingDecision()` (dòng 53) → bên trong gọi `GuideLineSubsystem->GetAllContenders()` + `FindClosestCarAhead` (dòng 140) → quét danh sách contender mỗi lần.
   - Check racing-line interval (dòng 55-70): có thể gọi `GuideLineSubsystem->GetLaneClosestToThisPositionAndLeastContenderForMachine` (dòng 65) — quét lane.
   - Check NOS (dòng 73-87).
   → Chi phí = 30Hz × (số xe AI) × (quét contender + quét lane). Với 7 xe AI ≈ 210 lần/giây quét contender. Đây là điểm nóng AI thật, nhưng đã có throttle 30Hz nên mức P1 chứ không P0.
2. **`UAIManagerSubsystem::Tick` round-robin — TỐT** (`AIManagerSubsystem.cpp:44-149`): chỉ tick **tối đa 1 AI mỗi frame** (vòng for có `break` dòng 134), phase-offset khi register (dòng 186-187). Đây là pattern tối ưu, KHÔNG phải hotspot. Giữ nguyên.

## Nợ kỹ thuật cụ thể
- **Hai cơ chế lập lịch chồng nhau**: `UAIManagerSubsystem` có round-robin riêng (`AutoDrive`), NHƯNG `UAIDecisionComponent` lại tự tick 30Hz độc lập. Hai nhịp khác nhau cho cùng một xe AI → khó suy luận, dễ lệch pha.
- `ConfigAiCarPerformance` (`AIManagerSubsystem.cpp:219-225`) gọi `CarCustomizationManager->CalculatePerformanceStats(...)` **mỗi lần register một xe AI**. `CalculatePerformanceStats` là hàm nặng (xem CU-ROOM: nhiều `FindRow`). Register N xe = N lần tính lại stat của xe **người chơi** (không đổi giữa các lần) → nên cache 1 lần.
- `ConfigAiCarPerformance` dòng 222-223 dùng `AICarsManager.Num() * DeltaPerformance` để giảm tốc xe AI theo thứ tự register — magic scaling, phụ thuộc thứ tự register (fragile).
- Debug static cục bộ trong `Tick` (`AIManagerSubsystem.cpp:63-66` `static double SecondStartTime...`) — biến static trong hàm tick của subsystem, không reset khi đổi level, có thể giữ state cũ qua các session PIE.
- `AIDecisionComponent.cpp` `ActiveCoolDownGlobal`/`EndCoolDownGlobal` (dòng 93-131) duplicate gần như nguyên khối vòng lặp `GetAllContenders` + `UpdateStatusCar` — nên gộp.

## Mức ưu tiên: **P1**
Lý do: scheduling tổng (`AIManagerSubsystem`) đã tối ưu tốt (round-robin). Điểm nóng còn lại là `AIDecisionComponent` 30Hz/xe quét contender+lane và `CalculatePerformanceStats` lặp khi register. Ảnh hưởng vừa, đã có throttle. Tối ưu = cache stat + thống nhất một nhịp tick.
