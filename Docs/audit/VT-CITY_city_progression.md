# VT-CITY — City Progression

## Phạm vi
Hệ thống tiến trình city trong VN Tour: phân cấp city/area/track, pool mục tiêu theo tier, giao mục tiêu cho city mới, kiểm tra hoàn thành mục tiêu và mở khóa city tiếp theo, điều phối phần thưởng city và goal. Bao gồm Car Unlock (#337) và Map Scene Unlock (#339).

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/ProgressionCenterSubsystem.cpp` — `UProgressionCenterSubsystem`: facade nhận kết quả đua, gọi `HandleRecordRaceResult` (dòng 94) dẫn vào chuỗi kiểm tra goal.
- `Source/PrototypeRacing/Private/BackendSubsystem/Progression/ProgressionSubsystem.cpp` — `UProgressionSubsystem` (**2641 dòng**): sở hữu `VNTourProgressionData`, toàn bộ logic goal pool và unlock chain.
  - `SetupCityGoalPoolTable` (dòng 2150): parse DataTable `CityGoalPool` → `GoalsByTier`.
  - `BuildAssignedGoalsForNewCity` (dòng 2192): chọn ngẫu nhiên 1 goal mỗi tier (Tier1/Tier2/Tier3) → trả 3 `FCityAssignedGoalState`.
  - `GetRandomGoalByTier` (dòng 2179): random index trong bucket tier.
  - `AssignGoalsToCityUnlockData` (dòng 2222): ghi assigned goals vào `FCityUnlockData`.
  - `CheckCityGoalsAndUnlockNextCity` (dòng 1352): kiểm tra `CanUnlockNextCity()`, gọi `HandleUnlockNextCity` nếu đủ điều kiện.
  - `HandleUnlockNextCity` (dòng 1299): gọi `UnlockNextCity`, grant rewards city, assign goals, `SetCurrentCityPosition`, broadcast `OnCityUnlocked`.
  - `GrantRewardsForCompletedGoal` (dòng 1336): gọi `RewardCenterSubsystem::GrantGoalCompletionRewards`.
  - `UnlockAllLocations` (dòng 2109): debug — mở khóa toàn bộ địa điểm.
- `Source/PrototypeRacing/Private/DebugSystem/ProgressionDebugManager.cpp`:
  - `EnsureGarageCarsFromProgression` (dòng 476 / 2163): đồng bộ xe garage sau unlock city.
  - `JumpToCity` (dòng 1681 / 2097): debug — nhảy thẳng đến city chỉ định.
- `Source/PrototypeRacing/Private/CarCustomizationSystem/CarSaveGameManager.cpp` — `SaveProgressionData` (dòng 97): lưu state sau mỗi thay đổi progression.

## Blueprint liên quan
- WBP VN Tour map screen, city-select, goal-list (nhóm `/Game/UI`): đăng ký delegate `OnCityUnlocked` để trigger introduce-scene và refresh UI mục tiêu.

## Điểm nóng hiệu năng cụ thể
1. **`ProgressionCenterSubsystem.cpp:489` — `LoadSynchronous` icon city/track**: block game thread khi mở màn VN Tour. Càng nhiều city/area thêm vào (như Huế) thì càng nhiều load đồng bộ. Cần migrate sang `FStreamableManager::RequestAsyncLoad`.
2. **`UProgressionSubsystem` god-object 2641 dòng**: ôm cả data lẫn orchestration; khởi tạo parse nhiều DataTable đồng thời. Rủi ro bảo trì cao; không phải hotspot per-frame nhưng là nợ kiến trúc P1.
3. **`ProgressionSubsystem.cpp:1813` — magic string `"ProgressionData"`**: tra DataTable bằng key chuỗi cứng; nên đổi thành hằng `FName` tĩnh.

## Nợ kỹ thuật cụ thể
- God-object `UProgressionSubsystem`: trộn lẫn data ownership và orchestration; lẽ ra orchestration thuộc `UProgressionCenterSubsystem`.
- `LoadSynchronous` rải rác (icon) thay vì async streaming.
- Magic string DataTable key (`"ProgressionData"`, dòng 1813).
- `HandleUnlockNextCity` gọi `GrantRewardsForUnlockedCity` chưa null-check `OutCityProgress` ở nhánh `!bUnlockResult` — đã có guard nhưng cần review khi thêm city mới.

## Mức ưu tiên: **P1**
Lý do: `LoadSynchronous` icon gây hitch UI rõ ràng khi mở màn VN Tour có nhiều city. God-object là nợ bảo trì dài hạn, đặc biệt khi team mở rộng VN Tour thêm nhiều city/area.

## Cần kiểm tra thủ công
- Mở màn VN Tour sau khi unlock Huế City: đo thời gian hitch, xác nhận icon load.
- Hoàn thành 3 goal tier → kiểm tra city unlock chain và introduce-scene trigger.
- `JumpToCity` / `UnlockAllLocations` trong debug build: xác nhận không crash khi city index ngoài range.
- `EnsureGarageCarsFromProgression` sau unlock city: xác nhận xe đúng xuất hiện trong garage.
