# VT-TRACK — Area-Track Unlock

## Phạm vi
Mở khóa area/track trong city đã unlock: kiểm tra vị thứ (finishing rank), chọn track để đua, tính lại độ khó track khi CR xe thay đổi.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/ProgressionSubsystem.cpp` — `UProgressionSubsystem`:
  - `UnlockNext(int32 CurrentTrackID)` (dòng 20): hiện là stub — body `VNTourProgressionData.UnlockNextTrack(CurrentTrackID)` bị comment out. **Cần xác minh unlock track thật sự xảy ra ở đâu**.
  - `RecalculateTrackDifficulty(EPerformanceStatType, int32, bool)` (dòng 2127): vòng lặp 3 tầng city/area/track, gọi `GetTrackDifficultyByPerformance` cho từng track; broadcast `OnTrackDifficultyRecalculated` (dòng 2133); lưu progression.
- `Source/PrototypeRacing/Public/ProgressionSystem/DataStructures/ProgressionData.h`:
  - `FTrackUnlockData` (dòng 801): `RequiredTopRank = 3` mặc định — vị thứ tối thiểu để mở track tiếp theo.
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/CarRatingSubsystem.cpp`:
  - `GetTrackDifficultyByPerformance(int32, int32, float)` (dòng 189): so sánh CR người chơi với `PerformanceGates` của track (dải tolerance); trả `ETrackDifficulty` (Easy/Medium/Hard).
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/ProgressionCenterSubsystem.cpp` — `SetupRaceData`: đọc `LocationInfo` của track được chọn, thiết lập dữ liệu đua cho DM-RACE.

## Blueprint liên quan
- WBP track-select (nhóm `/Game/UI`): đăng ký `OnTrackDifficultyRecalculated` để refresh badge Easy/Medium/Hard. Không có gameplay tick.

## Điểm nóng hiệu năng cụ thể
1. **`RecalculateTrackDifficulty` — vòng lặp 3 tầng**: O(cities × areas × tracks) lần gọi `GetTrackDifficultyByPerformance`. Không phải per-frame (chỉ kích hoạt khi nâng cấp xe), nhưng sẽ tăng tuyến tính theo lượng content. Khi VN Tour có nhiều city hơn cần profiling lại.

## Nợ kỹ thuật cụ thể
- `UnlockNext` body bị comment out (dòng 20–22) — unlock track thực tế có thể đang xảy ra qua đường khác hoặc chưa implement đầy đủ. **Cần review trước sprint tới**.
- `FTrackUnlockData.RequiredTopRank` hardcode default = 3 trong struct; cần xác nhận DataTable có override per-track không.
- Không tìm thấy delegate `OnTrackUnlocked` trong codegraph — nếu UI cần thông báo unlock track cụ thể thì thiếu event này.

## Mức ưu tiên: **P2**
Lý do: `RecalculateTrackDifficulty` chưa gây hitch đo được (không per-frame), nhưng stub `UnlockNext` là rủi ro gameplay — cần xác minh track unlock có hoạt động đúng không.

## Cần kiểm tra thủ công
- Đua track đầu tiên Huế City, đạt vị thứ ≤ 3: xác nhận track tiếp theo mở khóa.
- Đua track đầu tiên Huế City, vị thứ > 3: xác nhận track tiếp **không** mở.
- Nâng cấp xe sau đó vào màn track-select: xác nhận badge Easy/Medium/Hard refresh đúng.
- `RecalculateTrackDifficulty` với nhiều city mock: đo thời gian với 5+ city để phát hiện scale issue sớm.
