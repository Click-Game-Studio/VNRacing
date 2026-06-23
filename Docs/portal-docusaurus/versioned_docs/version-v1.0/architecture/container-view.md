---
title: 03. Sơ đồ Container
description: Sáu container chuẩn bên trong client VNRacing.
---

Sơ đồ container tương tác (bấm vào `client` trên sơ đồ System Context ở trang [Kiến trúc](/architecture) để drill vào, hoặc mở thẳng container view) cho thấy sáu container liên hệ với nhau ra sao.

## Sáu container chuẩn

| Container | Vai trò | Tính năng chính |
|---|---|---|
| UI / UMG Layer | Widget, HUD và các màn hình Blueprint. Đọc trạng thái subsystem qua delegate và gọi API của tính năng. | DM-PHYS car BPs, CU-ROOM customize UI, SUP-SHOP shop UI, CDN patch UI, SUP-TUT tutorial UI. |
| Gameplay Runtime | Gameplay gắn với level: vehicle physics, vòng đời race, AI, pooling và lối vào waiting-room multiplayer. | DM-PHYS, DM-RACE, DM-NOS, DM-RAMP, DM-CAM, SUP-AI, SUP-POOL, GM-MP (waiting room). |
| Meta / Economy Subsystems | Các GameInstance subsystem sống lâu cho VN Tour, customization, inventory, profile, rewards, commerce, tutorial và settings. | VT-CITY, VT-TRACK, VT-CARPROG, VT-REWARD, CU-ROOM, DM-SET, SUP-INV, SUP-PROF, SUP-SHOP, SUP-TUT. |
| Backend Communication | Các dịch vụ Nakama client/session/realtime/match và các kiểu contract backend dùng chung. | GM-MP (Nakama/match), hỗ trợ snapshot cho SUP-PROF và join-token cho waiting room. |
| Local Data / SaveGame | Registry DataTable trên GameInstance và các slot SaveGame. Nguồn sự thật cục bộ cho luồng offline/prototype. | Hỗ trợ xuyên suốt cho VT-*/CU-ROOM/SUP-INV/SUP-PROF/SUP-SHOP/SUP-TUT/DM-SET và dữ liệu thiết lập race. |
| Debug / Tooling | Các module debug, batch simulation track-test, giám sát hiệu năng runtime, significance và các helper PSO. | SUP-DBG, SUP-PERF. |

## Sơ đồ tổng quan component

Các sơ đồ tổng quan component theo từng container (gameplay, meta, backend, tooling) có sẵn dưới dạng view tương tác trên trang [Kiến trúc](/architecture). Bấm vào bất kỳ ô tính năng nào để mở trang Thiết kế chi tiết (Low-Level Design) của nó.
