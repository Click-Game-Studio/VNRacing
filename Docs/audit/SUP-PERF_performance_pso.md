# SUP-PERF — Performance & PSO (cross-cutting)

## Phạm vi
Instrumentation hiệu năng runtime, culling theo significance, warmup PSO/shader.

## Module/class C++ liên quan (file thật)
- `PerformanceMonitorSubsystem/PerformanceMonitorSubsystem.cpp` — `UPerformanceMonitorSubsystem` (FPS/perf instrumentation).
- `PerformanceMonitorSubsystem/LiteSignificanceManager.cpp` — `ULiteSignificanceManager` (culling theo khoảng cách, timer 0.25s).
- `LiteSignificanceAutoRegister.cpp`, `LiteSignificanceSettings.cpp`, `LiteSignificanceStation.cpp`.
- `PSO/PSOEffectManager.cpp` — `APSOEffectManager` (spawn VFX warmup PSO).
- `PSO/RestLevelManager.cpp` — `ARestLevelManager` (gate ổn định FPS trước khi travel).
- `PSO/PSOPrecacheSaveGame.cpp`.

## Điểm nóng hiệu năng & lỗi logic CỤ THỂ (đã đọc code)

1. **LỖI LOGIC: hai nhánh state-tracking khác nhau trong `ULiteSignificanceManager::HandleTick`** — `LiteSignificanceManager.cpp:39-92`:
   - Nhánh **Actor** (`:58`): `if (bShouldDisable xor ActiveStateChecker[Actor])` rồi `ActiveStateChecker[Actor] = bShouldDisable;` → set trực tiếp. Đúng.
   - Nhánh **Niagara** (`:77`): `if (bShouldDisable == bActiveState)` rồi `ActiveStateChecker[Niagara] = !ActiveStateChecker[Niagara];` → dùng `==` và toggle phủ định.
   - Hai idiom theo dõi state KHÁC NHAU trong cùng một hàm. Ngữ nghĩa `ActiveStateChecker` không nhất quán giữa actor (lưu "đã disable chưa") và niagara (lưu trạng thái ngược). Đây là **mầm bug**: rất dễ sai khi sửa, và logic niagara `bShouldDisable == bActiveState` cộng toggle có khả năng kẹt trạng thái. Cần thống nhất một quy ước.

2. **`HandleTick` chạy mỗi 0.25s, quét tuyến tính toàn bộ actor + niagara đăng ký** — `:14` timer 0.25s, `:49-64` loop O(n) actor, `:67-91` loop O(n) niagara. Mỗi phần tử gọi `FVector::DistSquaredXY` + `GetCameraLocation`. Với số actor/niagara lớn thì 4 lần/giây quét toàn bộ. Chấp nhận được ở quy mô vừa, nhưng là chi phí cố định nền.

3. **`ActiveStateChecker[Actor]` / `[Niagara]` truy cập map không guard** — `:58`, `:76`: dùng `operator[]` trên `TMap` với key actor/niagara. Nếu key chưa có (đăng ký lệch) sẽ tạo entry mặc định hoặc crash tùy đường. RegisterActor/RegisterNiagara có add nên thường ổn, nhưng thiếu `Contains` ở boundary.

4. **`APSOEffectManager::Tick` rỗng nhưng `bCanEverTick=true`** — `PSOEffectManager.cpp:16` bật tick, `:50-53` thân `Tick` chỉ gọi `Super::Tick`. Đăng ký tick thừa cho actor warmup. Nên tắt `bCanEverTick`.

5. **`ARestLevelManager` theo dõi frame-time per-frame khi đang check** — gate ổn định FPS trước travel; track frame-time mỗi frame trong lúc kiểm tra (theo C4, đúng mục đích, chỉ chạy ngắn trước travel).

## Nợ kỹ thuật cụ thể
- Lỗi logic nhánh niagara (#1) là nợ nghiêm trọng nhất — sửa để cùng quy ước với nhánh actor.
- `APSOEffectManager` tick rỗng (#4) — tắt tick.
- Thiếu `Contains` guard khi index `ActiveStateChecker` (#3).

## Audit Blueprint
PSO drone/effect chủ yếu C++ + Niagara asset. Không có BP gameplay tick cần soi thêm ở feature này.

## Mức ưu tiên: **P1**
Lý do: lỗi logic state niagara trong `LiteSignificanceManager` có thể làm hệ thống culling sai (ẩn/hiện nhầm, kẹt trạng thái) → ảnh hưởng trực tiếp hiệu năng vì culling là cơ chế giữ FPS. Không phải crash tức thì nên không P0, nhưng cần sửa sớm. Tick rỗng PSO là cleanup nhỏ.
