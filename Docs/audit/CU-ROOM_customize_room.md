# CU-ROOM — Customize Room

## Phạm vi
Tùy biến hình ảnh + hiệu năng xe, tính CR, save/load, resolve asset (mesh/material/decal) trong Customize Room. **Lưu ý: "Car Unlock thưởng sau khi mở City" thuộc VT-CITY (#337 VT-CITY-CU), không phải CU-ROOM.**

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/CarCustomizationSystem/CarCustomizationManager.cpp` — `UCarCustomizationManager` (**2078 dòng**).
- `CustomizeCarSubsystem.cpp` (`Source/PrototypeRacing/Private/`) — `UCustomizeCarSubsystem` (apply mesh/material nhẹ theo tên part).
- `CarCustomizationSystem/CarSaveGameManager.cpp` — `UCarSaveGameManager`.
- `CarCustomizationSystem/CarConfigurationJsonSerializer.cpp` — serialize config sang JSON (chuẩn bị sync backend).
- `CarCustomizationSystem/CustomizableCar.cpp`, `CarDataProvider.cpp`.

## Blueprint liên quan
- `WBP_PerformanceStat` (`/Game/CarCustomize/UI/WBP_PerformanceStat`) — **41 node**.
- WBP_UI491/493/496_CarCustomize, nút CarCustomize (nhóm `/Game/CarCustomize/UI`).

## Điểm nóng hiệu năng cụ thể (đã đọc toàn file)
1. **`LoadSynchronous` hàng loạt khi build mesh xe** — `CarCustomizationManager.cpp` các dòng **372, 383, 414, 425, 484, 495, 524, 535, 1983, 1997**: mỗi base mesh, vật liệu, part mesh, decal đều `LoadSynchronous()` (block luồng game). Một lần dựng xe full custom = hàng chục lần load đồng bộ → hitch rõ khi mở garage hoặc spawn xe AI (`UAIManagerSubsystem::ConfigAiCarPerformance` → `CalculatePerformanceStats` → N xe AI = N lần quét).
2. **`CalculatePerformanceStats` (`CarCustomizationManager.cpp:287`)** quét `Config.CustomParts` và mỗi part gọi `CarPartsDataTable->FindRow<FCarPartDefinition>` (dòng **315**) — được gọi khi setup đua cho từng xe AI.
3. **`FindRow` dày đặc toàn file** (≥30 lần: 177, 211, 301, 315, 363, 402, 449, 473, 512, 551, 620, 716, 782, 880, 1101, 1220, 1234, 1304, 1347, 1506, 1514, 1655, 1730, 1751, 1775, 1803, 1822, 1847, 1978, 1992, 2009...) — DataTable FindRow hash, không có cache nội bộ.

## Nợ kỹ thuật cụ thể
- **God-object 2078 dòng**: trộn resolve asset + tính stats + save + apply visual.
- Blocking load thay vì async (`RequestAsyncLoad`).
- Tra DataTable lặp lại cùng row nhiều lần thay vì cache kết quả per-config.
- Trùng lặp logic dựng mesh: hai khối gần giống nhau ở dòng **363-455** và **473-555** (GetCarMeshes biến thể).

## Audit Blueprint (qua VibeUE — dữ liệu thật)
- **`WBP_PerformanceStat`: có node `Event Tick` nhưng KHÔNG nối đi đâu** (Event Tick drives: rỗng). Node tick "chết" — không gây tải runtime, nhưng nên xóa.

## Mức ưu tiên: **P0**
Lý do: `LoadSynchronous` hàng loạt là nguyên nhân hitch nặng nhất phía meta, khuếch đại bởi đường AI setup. Ứng viên tối ưu async-load có ROI cao nhất ngoài gameplay tick.
