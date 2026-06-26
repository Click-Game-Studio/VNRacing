---
title: "CU-MENU — Main menu_Theme Change"
description: "Level và UI shell main menu: cổng vào Customize Room, Game Mode, VN Tour và Settings."
---

> OpenProject: #320.

> Sơ đồ: xem trang [Architecture](/architecture/) (view LikeC4 `cuMenu`).

## Tổng quan

🎨 **Trạng thái: content.** CU-MENU là level main menu và UI shell — asset level/content, không phải subsystem C++. Nó sở hữu UMG/Blueprint UI shell làm điểm vào của game và Unreal level phục vụ như hub scene.

## Phạm vi

CU-MENU không sở hữu subsystem backend, logic progression hay dữ liệu xe. Nó điều hướng vào:
- **CU-ROOM** (#299) — Customize Room.
- **GM-MP** (#273) — Multiplayer matchmaking.
- **GM-DC** (#274) — Daily Challenge.
- **VT-CITY** (#329) — VN Tour.
- **DM-SET** (#338) — Settings.

## Thành phần

| Component | Loại | Vai trò |
|---|---|---|
| Main Menu Level | Unreal level asset | Hub scene; load khi khởi động game; chứa UI menu. |
| Main Menu UMG widget(s) | Blueprint/UMG | Shell điều hướng: định tuyến player đến CU-ROOM, GM-*, VT-*, DM-SET. |
| Level streaming / transitions | Blueprint | Load/unload sub-level hoặc chuyển cảnh sang level đua/tour. |

## Điểm nóng hiệu năng

Không có hotspot C++ để báo cáo. Nếu có vấn đề hiệu năng, chúng sẽ lộ ra dưới dạng Blueprint Tick hoặc level-streaming hitch — cần profiler editor để chẩn đoán.

## Phần chưa kiểm chứng

Không có entry point C++ nào. Tiến độ theo dõi ở OpenProject (team Level/2D/3D), không phải tài liệu kiến trúc.

## Tham chiếu

- LD: `Docs/ld/CU-MENU_main_menu.md`
- Cross-ref: CU-ROOM (#299), GM-MP (#273), GM-DC (#274), VT-CITY (#329), DM-SET (#338)
