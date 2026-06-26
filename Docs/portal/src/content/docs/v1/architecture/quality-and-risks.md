---
title: 06. Chất lượng và Rủi ro
description: Mục tiêu chất lượng, các điểm nóng P0/P1 từ audit, và các khoảng
  trống bằng chứng đã biết.
slug: v1/architecture/quality-and-risks
---

## Mục tiêu chất lượng

| Mục tiêu | Ý nghĩa |
|---|---|
| Ổn định frame-time trên mobile | Tránh quét world, sort, load asset blocking hay tick rỗng vô ích mỗi frame trên các hot path của race. |
| Phân vùng trách nhiệm rõ ràng | Race runtime giữ level-bound; dữ liệu meta lâu dài nằm trong subsystem; truy cập SaveGame đi qua manager. |
| Tài liệu bám sát nguồn | Tên và contract trong kiến trúc truy vết được tới bằng chứng source/audit, không suy diễn ý đồ thiết kế. |
| Sơ đồ dễ review | Component view của từng feature tách riêng theo feature thay vì gộp thành một mega-diagram khó đọc. |
| Trung thực về khoảng trống bằng chứng | Phần chưa phủ về Blueprint/full backend authority được ghi nhận tường minh. |

## Điểm nóng P0/P1 từ audit

| Khu vực | Rủi ro | Bằng chứng |
|---|---|---|
| DM-RACE Race ranking | `HandleUpdateRanking` mỗi frame tính lại và sort ranking trong mọi Tick. | `Docs/audit/DM-RACE_basic_racing.md`; `RaceTrackManager.cpp:207`, `834-877`. |
| DM-RACE Client relay | `GetAllActorsOfClass` + vòng lồng O(n²) match mỗi lần cập nhật ranking. | `Docs/audit/DM-RACE_basic_racing.md`; `RacingCarController.cpp:286-308`. |
| CU-ROOM Customization | `LoadSynchronous` blocking cho mesh/material khi dựng/preview xe. | `Docs/audit/CU-ROOM_customize_room.md`; `CarCustomizationManager.cpp:372,383,414,425,484,495,524,535`. |
| SUP-POOL Pooling | Release actor lạ có thể crash; acquire/release quét mảng tuyến tính. | `Docs/audit/SUP-POOL_object_pooling.md`; `ActorObjectPoolSubsystem.cpp:8-59`. |
| DM-PHYS Vehicle tick | Tick rỗng trên các component movement/race và các path Tick nặng theo từng xe. | `Docs/audit/DM-PHYS_drivemode_physics.md`; `CustomChaosWheeledVehicle.cpp:12,28-33`, `RaceComponent.cpp:12,29-34`. |
| SUP-INV Item database | Cache đã được dựng nhưng `GetItemDefinition` bỏ qua nó và thiếu null guard. | `Docs/audit/SUP-INV_inventory.md`; `ItemDatabase.cpp:36-44`. |
| SUP-SHOP Commerce | Chỉ có mock provider; chưa có production provider/receipt verification authority. | `Docs/audit/SUP-SHOP_shop_iap.md`; `CommerceSubsystem.cpp:14-23,80-85`. |
| GM-MP Backend | Phụ thuộc hai chiều giữa Nakama và match service. | `Docs/audit/GM-MP_multiplayer.md`; `NakamaServiceSubsystem.cpp:8,90,157-162`. |
| CDN Content download | Path mở widget dùng quét world/static load/debug message; controller static load widget class. | `Docs/audit/CDN_content_download.md`; `ChunkDownloaderWidget.cpp:133-186`, `ChunkDownloaderController.cpp:21`. |
| SUP-PERF Significance | Các nhánh trạng thái actor/Niagara dùng idiom cập nhật trạng thái không nhất quán; rủi ro truy cập `operator[]`. | `Docs/audit/SUP-PERF_performance_pso.md`; `LiteSignificanceManager.cpp:58,77-82`. |

## Phần chưa kiểm chứng

* Mức phủ về Blueprint graph còn cục bộ. Các audit đã kiểm chứng một số BP gameplay/UI chọn lọc, nhưng không phải mọi WidgetBlueprint và asset Blueprint.
* Luồng server-authoritative multiplayer race đầy đủ chưa có bằng chứng trong source; nên coi GM-MP là client/waiting-room cộng với kiến trúc mục tiêu.
* Commerce backend authority và việc wiring native mobile provider chưa hoàn chỉnh ở mức production trong bằng chứng source.
