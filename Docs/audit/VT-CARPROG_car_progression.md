# VT-CARPROG — Car-Progression

## Phạm vi
Hệ thống Car Rating (CR): CR khởi đầu theo city index, scale CR theo upgrade, CR của AI theo city/độ khó, Dummy Car, và tính độ khó track từ CR người chơi.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/CarRatingSubsystem.cpp` — `UCarRatingSubsystem`:
  - `ResolveStartingCarRatingLevelByCityIndex(int32 CityIndex)` (dòng 212): trả `CityIndex * 3` — công thức tuyến tính đơn giản cho CR khởi đầu Dummy Car.
  - `GetStartingCarRatingStatsByCityPosition` (dòng 218): gọi `ResolveStartingCarRatingLevelByCityIndex` để lấy stats ban đầu.
  - `ResolveCarRatingLevelByUpgradeIndex(int32 CityPosition, int32 UpgradeLevel)` (dòng 224): kết hợp CR khởi đầu và mức nâng cấp; kết quả dùng bởi `UCarCustomizationManager::GetCarRating`.
  - `GetTrackDifficultyByPerformance(int32, int32, float)` (dòng 189): so sánh CR người chơi với `PerformanceGates` track (dải tolerance); dùng bởi `RecalculateTrackDifficulty` trong VT-TRACK.
- `Source/PrototypeRacing/Public/BackendSubsystem/Progression/CarRatingSubsystem.h`:
  - `FCityAICarRating` (dòng 158): DataTable row với `CityIndex`, `EasyCarRatingLevel`, `MediumCarRatingLevel`, `HardCarRatingLevel` — CR của AI theo city/độ khó.
- `Source/PrototypeRacing/Private/CarCustomizationSystem/CarCustomizationManager.cpp`:
  - `GetCarRating` (dòng 1054): gọi `ResolveCarRatingLevelByUpgradeIndex` rồi `FMath::RoundToFloat` — đây là CR sống của xe người chơi.
- `Source/PrototypeRacing/Private/DebugSystem/ProgressionDebugManager.cpp`:
  - `GetGlobalCR` (dòng 1055): đọc CR toàn cục, debug only.
  - `GetCityByCarId` (dòng 1396): tra city theo car ID, dùng trong debug tools.

## Blueprint liên quan
- Không có Blueprint gameplay. CR được đọc thuần C++ từ customisation manager và race setup.

## Điểm nóng hiệu năng cụ thể
1. **`ResolveStartingCarRatingLevelByCityIndex` — công thức cứng `CityIndex * 3`**: đơn giản và nhanh hiện tại. Nếu cần CR phi tuyến (tuning bởi designer) thì phải chuyển sang DataTable lookup — ghi nhận để không bị bỏ qua khi balance tuning.

## Nợ kỹ thuật cụ thể
- Công thức `CityIndex * 3` hardcode trong C++ — designer không thể tune không cần build. Nên drive bằng DataTable tương tự `FCityAICarRating`.
- Dummy Car definition (entry nào trong `UCarConfiguration` / `ProgressionData` đóng vai Dummy) chưa xác nhận trong codegraph — cần review `ProgressionData` DataTable và `EnsureGarageCarsFromProgression`.
- `GetTrackDifficultyByPerformance` nhận tham số `InPercentTolerance` nhưng caller từ `RecalculateTrackDifficulty` dùng giá trị default — xác nhận default tolerance phù hợp với balance thực tế.

## Mức ưu tiên: **P2**
Lý do: Hệ thống CR đang hoạt động đúng; rủi ro chính là công thức hardcode gây khó balance. Dummy Car definition cần xác minh trước khi thêm city mới.

## Cần kiểm tra thủ công
- Unlock city mới: xác nhận Dummy Car xuất hiện đúng trong garage với CR = `CityIndex * 3`.
- Nâng cấp xe city 0 lên max level: kiểm tra CR tính đúng và không vượt ngưỡng city tiếp theo quá sớm.
- Chạy đua với AI ở 3 độ khó (Easy/Medium/Hard) trên một city: xác nhận AI CR theo `FCityAICarRating` đúng.
- `GetTrackDifficultyByPerformance`: test với CR người chơi đúng bằng `PerformanceGates` (edge case biên tolerance).
