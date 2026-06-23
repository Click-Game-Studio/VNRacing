# Legacy F-map — Crosswalk F01–F17 (cũ) → Mã sản phẩm (mới)

> Bộ tài liệu trước (session "test_mcp") đánh số **F01–F17** theo cụm kỹ thuật của code. Từ 2026-06-15, tài liệu được tái cấu trúc theo taxonomy sản phẩm của OpenProject (xem `Docs/traceability.md`). Bảng này giữ liên kết cũ→mới để link/PR/issue cũ vẫn tra được.

| F# cũ | Tên cũ | → Mã mới | Feature/Hệ thống mới |
|---|---|---|---|
| F01 | Drive Mode / Vehicle Physics | DM-PHYS (+ DM-RAMP, DM-CAM, DM-NOS) | DriveMode-Physics; phần RAMP/CAMERA/NOS tách ra feature riêng theo CSV |
| F02 | Race Mode & Game Flow | DM-RACE | Basic Racing |
| F03 | Racer AI | SUP-AI | Hệ thống nền — Racer AI |
| F04 | Object Pooling | SUP-POOL | Hệ thống nền — Object Pooling |
| F05 | Progression & VN Tour | VT-CITY (+ VT-TRACK, VT-CARPROG) | City Progression + Area-Track Unlock + Car-Progression (tách theo CSV) |
| F06 | Car Customization | CU-ROOM (+ VT-CITY-CU) | Customize Room; Car Unlock thuộc City Progression |
| F07 | Inventory | SUP-INV | Hệ thống nền — Inventory |
| F08 | User Profile / Economy | SUP-PROF | Hệ thống nền — User Profile / Economy |
| F09 | Rewards | VT-REWARD (+ VT-CITY-GR) | Reward; Goals Reward thuộc City Progression |
| F10 | Shop / IAP / Ads | SUP-SHOP | Hệ thống nền — Shop / IAP / Ads |
| F11 | Backend / Nakama | GM-MP | Gộp vào MULTIPLAYER |
| F12 | Multiplayer Race | GM-MP | MULTIPLAYER |
| F13 | Content Download | CDN | CDN |
| F14 | Tutorial / Onboarding | SUP-TUT | Hệ thống nền — Tutorial / Onboarding |
| F15 | Settings | DM-SET | SETTING |
| F16 | Debug & Track Test | SUP-DBG | Hệ thống nền — Debug & Track Test |
| F17 | Performance & PSO | SUP-PERF | Hệ thống nền — Performance & PSO |

## Lưu ý chia tách (1 cũ → nhiều mới)

- **F01** tách thành 4: code vehicle-physics lõi → **DM-PHYS**; `ARampZone`/Jump → **DM-RAMP**; `AFollowCarCamera` → **DM-CAM**; `BoostNitro`/AI-NOS → **DM-NOS**. (Theo CSV, RAMP/CAMERA/NOS là các Feature độc lập dưới Epic Drive Mode.)
- **F05** tách thành 3 feature VNTour: **VT-CITY** (city progression + goals + car/map unlock), **VT-TRACK** (area/track unlock + selection + config), **VT-CARPROG** (CR khởi đầu theo city). Cùng dùng `UProgressionSubsystem` nên các doc chéo-tham chiếu nhau.
- **F11 + F12** gộp thành **GM-MP** (MULTIPLAYER) — CSV coi backend Nakama là phần hạ tầng của tính năng multiplayer, không phải feature riêng.
- **F06** → **CU-ROOM**, nhưng phần "unlock xe thưởng sau khi mở City" thuộc **VT-CITY-CU** (Car Unlock).

> **Không có mã F01–F17 mới nào được thêm vào từ 2026-06-15.** Các Feature/Sub Feature mới trong CSV 2026-06-23 (CU-THEME, CU-VIS, CU-PERF, CU-SEL, SH-DISP, SH-FLOW, v.v.) được gán mã sản phẩm trực tiếp theo taxonomy OpenProject. Hệ thống F## hiện đã đóng và được thay thế hoàn toàn bởi mã sản phẩm.
