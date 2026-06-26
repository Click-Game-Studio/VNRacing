# VNRacing — Kế hoạch triển khai chi tiết Progression

**Team:** 4 Devs core progression · **Thời lượng:** 15 ngày làm việc  
**Sprint 1:** Ngày 1-5 · **Sprint 2:** Ngày 6-10 · **Sprint 3:** Ngày 11-15  
**Scope chính:** vertical slice progression backend-authoritative, ưu tiên chạy end-to-end ổn định  
**Scope tách riêng:** Shop / IAP / Commerce không nằm trong critical path 15 ngày core progression.

---

## Mục tiêu

Triển khai một vertical slice đủ rõ để team có thể kiểm thử toàn bộ luồng progression mới từ backend đến UI:

```text
Login / Restore
   → Load player snapshot từ Nakama
   → Start PvE race session
   → Client chạy race
   → Submit race result
   → Backend validate sanity + resolve reward
   → Backend grant wallet/inventory/progression qua ledger
   → Client sync authoritative delta/snapshot
   → UI hiển thị reward + inventory/progression mới
```

Nguyên tắc triển khai:

- **Nakama là source of truth** cho wallet, inventory, progression, garage-lite state và rewards.
- **Local save chỉ đóng vai trò cache, migration input hoặc fallback display**; sau khi backend snapshot load thành công, local save không còn là authority.
- **PvE trong 15 ngày dùng Hybrid Authority**: client chạy race, backend validate session/result ở mức sanity check và chịu trách nhiệm cấp reward. Chưa làm deterministic replay anti-cheat đầy đủ.
- **Reward grant bắt buộc idempotent** bằng ledger `event_id`; retry không được grant trùng.
- **Config/economy phải có version rõ ràng**; race session pin `config_version` tại thời điểm start.
- **Shop/IAP tách thành stream riêng**, chỉ giữ boundary để sau này nối commerce mà không phải refactor lớn core progression.

---

## Trạng thái hiện tại của codebase

### Đã có sẵn

- Nakama auth + realtime/match base ở `Racing/Source/PrototypeRacing/Public/BackendSubsystem/Online/NakamaServiceSubsystem.h`.
- Progression city/area/track/goals ở `Racing/Source/PrototypeRacing/Public/BackendSubsystem/Progression/ProgressionSubsystem.h`.
- Race completion/progression orchestration ở `Racing/Source/PrototypeRacing/Private/BackendSubsystem/Progression/ProgressionCenterSubsystem.cpp`.
- Inventory local subsystem ở `Racing/Source/PrototypeRacing/Public/InventorySystem/InventoryManager.h`.
- Garage/customization local subsystem ở `Racing/Source/PrototypeRacing/Public/CarCustomizationSystem/CarCustomizationManager.h`.
- Local save domains tách rời qua `CarSaveGameManager.cpp`.
- Design data nguồn trong `Docs/VNRacing_Item_Car_Master_v1.3.xlsx`.

### Chưa có / chưa đủ

- Chưa có authoritative backend snapshot cho wallet/inventory/progression/garage.
- Chưa có reward ledger chống duplicate grant.
- Chưa có canonical schema nối item master → inventory → garage → rewards.
- Chưa có data import/validation pipeline Excel → Unreal/Nakama config.
- Chưa có config versioning cho item/loot/goal/reward formulas.
- Chưa có PvE race session + result submit + backend reward authority.
- Chưa có UI/error-state contract cho command backend timeout/fail.
- Chưa có checklist DevOps backend cho local/staging Nakama, migration script, config publish và logging phục vụ debug.
- Shop/IAP chưa nên đưa vào critical path core progression vì Apple dev account chưa sẵn sàng quyền IAP.

---

## Scope 15 ngày

### In-scope core progression

- Player bootstrap snapshot trên Nakama.
- Snapshot read API + Unreal snapshot adapter.
- Wallet/inventory/progression/garage-lite canonical state.
- Config import tối thiểu từ workbook/docs và publish kèm `config_version`.
- Local/staging Nakama setup đủ để test RPC, storage object, config publish và reward ledger.
- PvE race session creation.
- PvE result submit contract.
- Sanity validation: session validity, expiry, duplicate submit, track/car validity, impossible range cơ bản.
- Backend reward resolver cho race reward vertical slice.
- Reward ledger + idempotent grant.
- Client result screen dùng server reward payload.
- UI state: loading, synced, sync-failed, offline-cache, retry.
- Local save migration dry-run tối thiểu cho account có save cũ.
- Goal/city unlock ở mức vertical slice: update progress/reward cho 1-2 luồng đại diện, chưa full random pool polish.
- Inventory mutation tối thiểu: add/equip/use hoặc add/equip tùy item type cần cho slice.
- Garage-lite authoritative state: owned car + selected loadout/performance summary đủ để race reward/progression chạy.

### Out-of-scope core 15 ngày

- Full deterministic anti-cheat replay.
- Full loot crate polish: same-batch reroll đầy đủ, reward reveal animation polish, mọi duplicate edge case nâng cao.
- Full customization shop/purchase flow.
- Real Apple StoreKit / Google Play Billing end-to-end.
- Production BI/ops dashboard.
- Migration toàn bộ mọi save domain cũ nếu phát sinh dữ liệu không map được.
- Dedicated UE server authority cho PvE.

### Mảng tách riêng: Shop / IAP / Commerce

Shop/IAP được thiết kế như stream riêng, không chặn vertical slice progression 15 ngày.

- Core progression chỉ cần **commerce boundary**: reward bundle/entitlement có thể đi qua ledger như một `source_type` sau này.
- Shop/IAP stream riêng sẽ xử lý:
  - product catalog.
  - purchase provider abstraction.
  - mock purchase provider.
  - entitlement mapping.
  - restore/retry/idempotency cho transaction.
  - Apple sandbox checklist khi account/product/IAP entitlement sẵn sàng.
- Trong 15 ngày core progression, chỉ cần tránh thiết kế wallet/inventory/reward ledger theo cách khiến Shop/IAP phải refactor lớn.

---

## Kiến trúc đích cho vertical slice

```text
Unreal Client
   │
   ├─ Login / Restore Session
   │        │
   │        ▼
   │     Nakama
   │
   ├─ Read Player Snapshot ─────────────▶ wallet / inventory / garage-lite / progression
   │                                      └─ current_config_version
   │
   ├─ Start PvE Race Session ───────────▶ race_session_id + config_version + allowed car/track
   │
   ├─ Submit PvE Race Result ───────────▶ validation + reward resolve
   │                                      ├─ validate session/config_version
   │                                      ├─ reject duplicate/impossible result
   │                                      ├─ create/update reward ledger
   │                                      ├─ update wallet
   │                                      ├─ update inventory
   │                                      ├─ update progression/goals-lite
   │                                      └─ return authoritative delta
   │
   ◀───────────────────────────────────── snapshot delta / command result
   │
   └─ UI Sync ───────────────────────────▶ reward reveal + wallet/inventory/progression refresh
```

---

## Data contract đích

### Nakama collections tối thiểu cho 15 ngày

- `player / snapshot_meta`
- `wallet / balances`
- `inventory / items`
- `garage / cars`
- `garage / loadouts`
- `progression / tour`
- `progression / goals`
- `race / sessions/<race_session_id>`
- `rewards / ledger/<event_id>`
- `config / active_version`
- `config / item_master_<version>`
- `config / car_registry_<version>`
- `config / reward_table_<version>`

### Nakama collections để dành cho Shop/IAP stream

- `commerce / entitlements`
- `commerce / purchase_history/<tx_id>`
- `commerce / product_catalog_<version>`

### Canonical wallet

- Cash
- Fuel
- Click / Coin nếu hiện tại game đang dùng
- Các balance phục vụ commerce để dành field mở rộng, nhưng không implement Store/IAP trong core slice.

### Canonical inventory state

Mỗi item tối thiểu cần:

- `item_id`
- `quantity`
- `ownership_state` = locked/unlocked/purchased/equipped/consumed
- `acquisition_source`
- `rarity`
- `city_origin`
- `usage_count`
- `is_favorite`
- `last_granted_at`
- `duplicate_policy`
- `reward_eligible`

### Garage-lite state

Mỗi xe tối thiểu cần:

- `car_id`
- `owned`
- `selected`
- `performance_summary`
- `equipped_visual_slots`

Full customize/material/decal state có thể mở rộng sau vertical slice.

### Reward ledger

Mỗi grant event cần:

- `event_id`
- `source_type` = race/goal/city_unlock/migration/commerce_future
- `source_ref`
- `player_id`
- `config_version`
- `grant_status` = pending/committed/failed
- `payload_hash`
- `resolved_rewards`
- `created_at`
- `committed_at`

Mục tiêu: retry-safe, idempotent, audit được. Trong 15 ngày phải chốt write order và partial-failure behavior đủ rõ để QA verify.

---

## Team 4 Devs

| Dev | Chuyên môn chính | Scope 15 ngày |
| :---- | :---- | :---- |
| **Nam Sơn — Backend/Nakama/DevOps** | RPC, Nakama storage, local/staging backend, config publish, logging | snapshot, config storage, race session, result submit, reward ledger, idempotency, backend deploy/test environment |
| **Duy — UI** | UI implement, reward/result screens, wallet/inventory visual state | reward UI, wallet Spend/Earn feedback, token/loot result UI, sync/error state UI |
| **Thịnh — Integration** | Unreal integration, UI/meta binding, inventory/garage interaction | snapshot adapter, replace local authority reads, inventory use/equip flow, VN Tour and garage integration |
| **Đời — Data/Economy/Progression** | item/car/reward mapping, progression logic, QC data | config validation, reward tables, goal/city unlock slice, performance rule mapping, test matrix |

### Capacity guideline

- 4 dev × 15 ngày = 60 dev-days.
- Scope vẫn cần giữ chặt: ưu tiên ít luồng nhưng chạy end-to-end chắc, có backend authority và QC rõ ràng.
- Mỗi sprint phải có QC gate cuối sprint, không dồn toàn bộ test vào ngày 15.
- Nam Sơn cần có thời gian riêng cho DevOps backend/local-staging setup; không gom toàn bộ backend task vào phần gameplay reward.

---

## Phase 1 — Contract, Config, Snapshot Foundation (Ngày 1-5)

### Mục tiêu

Khóa contract, chuẩn hóa dữ liệu và dựng nền để client load được authoritative snapshot từ Nakama.

| ID | Owner | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---- | :---: | :---- | :---- |
| P1-01A | Nam Sơn | Định nghĩa RPC/error contract backend v1 | 4h | P0 | — | **Deliv:** Chốt endpoint, request/response, error code và storage touchpoints cho snapshot, race session, submit result, inventory command và reward command. |
| P1-01B | Thịnh | Định nghĩa integration contract Unreal ↔ backend | 4h | P0 | P1-01A | **Deliv:** Chốt payload client gửi/nhận, callback, retry hook và điểm thay local authority trong Unreal. |
| P1-01C | Duy | Định nghĩa UI command-state/error mapping | 4h | P0 | P1-01A | **Deliv:** Chốt cách UI hiển thị loading, success, retry, duplicate, stale version, invalid config và backend timeout. |
| P1-01D | Đời | Định nghĩa economy/reward contract đầu vào cho backend | 4h | P0 | P1-01A | **Deliv:** Chốt reward source, reward payload, duplicate policy, config version và các field economy bắt buộc. |
| P1-02 | Thịnh | Chuẩn hóa bộ dữ liệu item, reward pool và customize để thống nhất mapping client/backend | 12h | P0 | P1-01B, P1-01D | **Deliv:** Có schema dữ liệu rõ cho item, reward pool, customize và các điểm dùng trong UI/meta. |
| P1-03 | Đời | Thiết kế contract dữ liệu cho Reward System | 8h | P0 | P1-01D, P1-02 | **Deliv:** Có contract cho race reward, goal reward, city unlock, token/loot MVP và duplicate policy. |
| P1-04 | Đời | Triển khai Reward System core | 16h | P0 | P1-03 | **Deliv:** Các nguồn thưởng chính đi qua một resolver thống nhất, không còn logic grant rời rạc. |
| P1-05 | Đời | Xây bộ kiểm tra dữ liệu Reward | 12h | P0 | P1-02, P1-03 | **Deliv:** Duplicate item, invalid ref, rarity/pool lỗi được phát hiện trước runtime. |
| P1-06 | Nam Sơn | Setup local/staging Nakama cho progression RPC và storage | 8h | P0 | P1-01A | **Deliv:** Backend environment chạy được, có collection/key tối thiểu và account test để gọi RPC. |
| P1-07 | Nam Sơn | Thiết kế snapshot schema và bootstrap player objects | 16h | P0 | P1-01A, P1-03, P1-06 | **Deliv:** Account mới có wallet/inventory/garage-lite/progression mặc định trên Nakama. |
| P1-08 | Nam Sơn | Triển khai Snapshot read API kèm `current_config_version` | 8h | P0 | P1-07 | **Deliv:** Client đọc được snapshot authoritative và biết config version hiện hành. |
| P1-09 | Nam Sơn | Thiết kế config publish MVP từ validated data lên Nakama storage | 12h | P0 | P1-05, P1-06 | **Deliv:** Có `active_version`, `item_master_<version>`, `car_registry_<version>`, `reward_table_<version>`. |
| P1-10 | Nam Sơn | Implement object versioning/optimistic write guard MVP | 8h | P0 | P1-07 | **Deliv:** Mutation wallet/inventory/progression có version guard, không overwrite stale state. |
| P1-11 | Thịnh | Dựng snapshot adapter skeleton trong Unreal | 16h | P0 | P1-01B, P1-08 | **Deliv:** Unreal nhận snapshot backend và expose data cho UI/meta system theo contract mới. |
| P1-12 | Duy | Thiết kế UI state contract cho backend command | 8h | P0 | P1-01C, P1-11 | **Deliv:** Loading/synced/sync-failed/offline-cache/retry/error reason có mapping rõ với command result. |
| P1-13 | Duy | Rà soát và hoàn thiện UI cho các flow reward mới | 12h | P1 | P1-04, P1-11, P1-12 | **Deliv:** UI có cấu trúc đủ để hiển thị reward từ server payload ở các flow chính. |
| P1-14 | Thịnh | Cập nhật VN Tour UI logic theo snapshot/progression mới | 12h | P1 | P1-11 | **Deliv:** VN Tour hiển thị đúng dữ liệu progression authoritative thay vì local-only. |
| P1-15 | Thịnh | Rà soát và khóa các điểm truy cập Inventory | 8h | P1 | P1-11 | **Deliv:** Inventory chỉ được mutate qua flow được phép, chuẩn bị thay local authority bằng backend command. |
| P1-16 | Duy | Triển khai UI Goal unlock city ở mức representative slice | 12h | P1 | P1-11, P1-12 | **Deliv:** UI goal/city unlock sẵn sàng nhận dữ liệu thật từ progression slice. |

### QC Gate Phase 1

| ID | Owner | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---- | :---: | :---- | :---- |
| P1-QC-NS | Nam Sơn | QC backend snapshot/config foundation | 2h | P0 | P1-06, P1-07, P1-08, P1-09, P1-10 | **Pass:** Account mới bootstrap được từ backend, snapshot trả về `current_config_version`, local/staging Nakama chạy lại được cho dev khác. |
| P1-QC-TH | Thịnh | QC Unreal snapshot adapter và local authority boundary | 2h | P0 | P1-11, P1-14, P1-15 | **Pass:** Client load snapshot từ Nakama thành công, VN Tour/Inventory không còn coi local save là source of truth sau khi snapshot backend load. |
| P1-QC-DU | Duy | QC UI sync/error foundation | 2h | P0 | P1-12, P1-13, P1-16 | **Pass:** UI/debug nhìn được trạng thái sync và có mapping loading/synced/sync-failed/offline-cache/retry. |
| P1-QC-DO | Đời | QC reward/config data foundation | 2h | P0 | P1-03, P1-04, P1-05 | **Pass:** Reward contract rõ, config/reward data reject được duplicate/invalid item/car/ref cơ bản. |

---

## Phase 2 — Race Session, Reward Authority, Idempotent Grant (Ngày 6-10)

### Mục tiêu

Chạy được luồng race → submit result → backend grant reward đúng 1 lần → client hiển thị reward server.

| ID | Owner | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---- | :---: | :---- | :---- |
| P2-01 | Nam Sơn | Triển khai PvE race session creation RPC | 8h | P0 | P1-08, P1-09 | **Deliv:** Backend tạo `race_session_id`, pin `config_version`, validate car/track hợp lệ. |
| P2-02 | Đời | Triển khai reward theo kết quả race | 12h | P0 | P1-04, P1-05, P1-09, P2-01 | **Deliv:** Sau race nhận đúng reward theo cấu hình mới và theo `config_version` đã pin. |
| P2-03 | Nam Sơn | Triển khai PvE result submit RPC và sanity validation | 16h | P0 | P2-01, P2-02 | **Deliv:** Reject duplicate/expired/invalid/impossible result với reason rõ ràng. |
| P2-04 | Nam Sơn | Triển khai reward ledger và idempotent grant | 20h | P0 | P1-10, P2-03 | **Deliv:** Retry cùng `event_id` không grant trùng; ledger có trạng thái pending/committed/failed. |
| P2-05 | Thịnh | Tích hợp submit race result từ Unreal lên backend | 12h | P0 | P1-11, P2-03 | **Deliv:** End-race gửi payload đúng contract, nhận command result và không tự grant local. |
| P2-06 | Duy | Triển khai race result/reward sync UI | 12h | P0 | P1-12, P1-13, P2-04, P2-05 | **Deliv:** Result screen hiển thị reward server payload, duplicate/error reason và trạng thái retry rõ ràng. |
| P2-07 | Đời | Triển khai reward theo goal ở mức representative slice | 8h | P1 | P1-04, P1-16 | **Deliv:** Một luồng goal có thể complete/claim/grant đúng 1 lần qua reward resolver. |
| P2-08 | Đời | Triển khai Token/Loot Crate reward MVP | 8h | P1 | P1-04, P1-05 | **Deliv:** Token/Loot Crate sinh reward MVP đúng config; full duplicate/batch polish để Post-MVP. |
| P2-09 | Đời | Triển khai xử lý duplicate visual item ở mức MVP | 8h | P1 | P2-08 | **Deliv:** Visual item trùng có rule xử lý tối thiểu, không làm sai inventory state. |
| P2-10 | Thịnh | Triển khai flow use/equip item trong Inventory | 16h | P1 | P1-15, P2-04 | **Deliv:** Item được use/equip đúng tác dụng và đi qua command path chuẩn bị backend sync. |
| P2-11 | Duy | Triển khai giao diện kết quả mở Token và Loot Crate MVP | 8h | P1 | P2-08, P2-09 | **Deliv:** UI hiển thị reward cuối cùng theo payload đã resolve, chưa cần full reveal polish. |
| P2-12 | Duy | Rà soát và hoàn thiện UI Goal unlock city | 8h | P1 | P1-16, P2-07 | **Deliv:** UI goal hiển thị và update đúng dữ liệu thực tế. |
| P2-13 | Duy | Rà soát dữ liệu UI cần mapping với Nakama Storage | 8h | P1 | P1-11, P1-12 | **Deliv:** Có danh sách field UI đọc/ghi để backend và integration đối chiếu. |
| P2-14 | Nam Sơn | Bổ sung backend logging/debug payload cho race reward flow | 8h | P1 | P2-04 | **Deliv:** Có log đủ để trace session, config version, reward resolve và ledger status khi QA báo lỗi. |

### QC Gate Phase 2

| ID | Owner | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---- | :---: | :---- | :---- |
| P2-QC-NS | Nam Sơn | QC race session/result submit/ledger backend | 2h | P0 | P2-01, P2-03, P2-04, P2-14 | **Pass:** Race valid grant đúng 1 lần, retry không grant trùng, duplicate/expired/invalid race bị reject đúng lý do, backend log trace được session → ledger. |
| P2-QC-TH | Thịnh | QC Unreal race submit integration | 2h | P0 | P2-05, P2-10 | **Pass:** Client gửi payload đúng contract, không tự cộng currency local trước backend committed, inventory command path không bypass backend flow. |
| P2-QC-DU | Duy | QC result/reward UI | 2h | P0 | P2-06, P2-11, P2-12, P2-13 | **Pass:** Reward payload server khớp UI end-race, duplicate/error/retry hiển thị rõ, UI field mapping đã bàn giao cho backend/integration. |
| P2-QC-DO | Đời | QC race/goal/token reward rules | 2h | P0 | P2-02, P2-07, P2-08, P2-09 | **Pass:** Race reward dùng đúng `config_version`, goal reward grant đúng 1 lần, Token/Loot MVP và duplicate visual MVP không làm sai inventory state. |

---

## Phase 3 — Inventory/Garage/Progression Slice, Migration Dry-run, Hardening (Ngày 11-15)

### Mục tiêu

Hoàn thiện vertical slice để reward ảnh hưởng đúng wallet/inventory/progression/garage-lite, có fallback/migration dry-run và đủ QC để bàn giao dev tiếp theo.

| ID | Owner | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---- | :---: | :---- | :---- |
| P3-01 | Nam Sơn | Triển khai đồng bộ Profile/Wallet lên Nakama Storage | 8h | P0 | P2-04, P2-13 | **Deliv:** Profile/wallet canonical được đọc/ghi qua backend storage theo version guard. |
| P3-02 | Nam Sơn | Triển khai đồng bộ Inventory lên Nakama Storage | 16h | P0 | P2-04, P2-10, P2-13 | **Deliv:** Inventory canonical sync được các mutation MVP và không lệch với reward grant. |
| P3-03 | Nam Sơn | Triển khai progression storage + migration dry-run endpoint/checklist | 16h | P0 | P1-07, P2-07, P3-01 | **Deliv:** Save cũ có thể dry-run mapping sang backend snapshot, duplicate migration không grant trùng. |
| P3-04 | Đời | Cập nhật điều kiện nâng cấp Performance theo cấu hình mới | 8h | P1 | P1-02, P1-05 | **Deliv:** Rule nâng cấp performance khớp cấu hình mới, chưa cần full upgrade command. |
| P3-05 | Đời | Rà soát reward/progression data với snapshot backend | 8h | P1 | P3-01, P3-02, P3-03 | **Deliv:** Data progression, inventory, garage-lite và reward không còn field mơ hồ trước final test. |
| P3-06 | Thịnh | Rà soát và hoàn thiện interaction UI với các hệ thống | 12h | P1 | P1-11, P2-05, P2-10 | **Deliv:** UI tương tác ổn định với reward, inventory, garage-lite và progression snapshot. |
| P3-07 | Duy | Rà soát và hoàn thiện UI các phase trước | 12h | P1 | P2-06, P2-11, P2-12 | **Deliv:** UI chính đạt trạng thái đủ demo, không còn text/debug tạm ở luồng người chơi. |
| P3-08 | Nam Sơn | Chuẩn hóa backend deployment notes, env config và handover checklist | 8h | P1 | P3-01, P3-02, P3-03 | **Deliv:** Dev khác có thể dựng lại local/staging backend và chạy smoke test theo tài liệu bàn giao. |
| P3-09 | Thịnh | Viết checklist kiểm thử integration và gameplay interaction | 4h | P1 | P3-06 | **Deliv:** Có checklist rõ cho inventory use/equip, race submit, reward sync, goal/city unlock. |
| P3-10 | Duy | Viết checklist kiểm thử UI và UI flow | 4h | P1 | P3-07 | **Deliv:** Có checklist rõ cho loading/synced/sync-failed/offline-cache/retry và reward reveal. |
| P3-11 | Nam Sơn | Viết checklist smoke test backend/Nakama | 4h | P1 | P3-08 | **Deliv:** Có checklist cho bootstrap, snapshot read, race session, submit result, ledger và migration dry-run. |
| P3-12 | Thịnh | Build test local/staging Nakama và ghi nhận lỗi integration | 4h | P1 | P3-09, P3-11 | **Deliv:** Có log lỗi integration từ bản build test kết nối backend. |
| P3-13 | Duy | Build test local/staging Nakama và ghi nhận lỗi UI | 4h | P1 | P3-10, P3-11 | **Deliv:** Có log lỗi UI từ bản build test kết nối backend. |
| P3-14 | Đời | Fix bug core logic/data | 12h | P1 | P3-12, P3-13 | **Deliv:** Fix các lỗi core logic/data phát sinh trong quá trình test. |
| P3-15 | Thịnh | Fix bug UI interaction/integration | 12h | P1 | P3-12, P3-13 | **Deliv:** Fix các lỗi binding, interaction và flow giữa UI với subsystem. |
| P3-16 | Duy | Fix bug UI visual/flow | 12h | P1 | P3-12, P3-13 | **Deliv:** Fix các lỗi UI, layout, trạng thái hiển thị và flow người chơi. |
| P3-17 | Nam Sơn | Fix bug backend/storage/RPC | 8h | P1 | P3-11, P3-12, P3-13 | **Deliv:** Fix lỗi backend phát sinh từ smoke test, RPC và storage sync. |
| P3-18 | Thịnh | Chuẩn bị demo integration trên build kết nối Nakama | 4h | P1 | P3-14, P3-15, P3-16, P3-17 | **Deliv:** Bản demo chạy được luồng integration chính. |
| P3-19 | Duy | Chuẩn bị demo UI trên build kết nối Nakama | 4h | P1 | P3-14, P3-15, P3-16, P3-17 | **Deliv:** UI demo ổn định cho các luồng reward/progression chính. |
| P3-20 | Đời | Check toàn bộ hệ thống theo scope hiện tại và bàn giao | 12h | P1 | P3-18, P3-19 | **Deliv:** Bàn giao tổng thể kèm danh sách pass/fail, known issues và Post-MVP backlog. |

### QC Gate Phase 3 / Final Acceptance

| ID | Owner | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---- | :---: | :---- | :---- |
| P3-QC-NS | Nam Sơn | Final QC backend storage/migration/ledger | 2h | P0 | P3-01, P3-02, P3-03, P3-08, P3-11, P3-17 | **Pass:** Account mới bootstrap đầy đủ, migration dry-run không grant trùng, reward ledger audit được committed/failed, backend handover checklist đầy đủ. |
| P3-QC-TH | Thịnh | Final QC integration/local authority boundary | 2h | P0 | P3-06, P3-09, P3-12, P3-15, P3-18 | **Pass:** Snapshot load/reload ổn định, local/backend không lệch sau race reward, command fail/timeout không mutate local authority. |
| P3-QC-DU | Duy | Final QC UI flow/error/retry | 2h | P0 | P3-07, P3-10, P3-13, P3-16, P3-19 | **Pass:** UI hiển thị loading/synced/sync-failed/offline-cache/retry rõ ràng và demo reward/progression flow ổn định. |
| P3-QC-DO | Đời | Final QC data/reward/progression acceptance | 2h | P0 | P3-04, P3-05, P3-14, P3-20 | **Pass:** Race result grant đúng wallet/inventory/progression delta, config invalid bị reject, inventory/garage-lite/goal/city unlock đủ cho representative slice. |

---

## Stream riêng — Shop / IAP / Commerce

Phần này không nằm trong timeline core 15 ngày, nhưng nên tạo backlog riêng để làm song song nếu có người rảnh hoặc sau khi vertical slice ổn định.

### Mục tiêu riêng

- Tách commerce khỏi gameplay progression để không phụ thuộc Apple entitlement hiện tại.
- Chuẩn bị kiến trúc để khi Apple account/IAP product sẵn sàng có thể nối StoreKit mà không refactor wallet/inventory/reward ledger.

| ID | Task | Est | Priority | Dep | QC |
| :---- | :---- | :---- | :---: | :---- | :---- |
| C-IAP-1 | Purchase provider abstraction | 1d | P1 | Core reward ledger design | **Deliv:** Interface chung cho mock / Apple / Google provider. |
| C-IAP-2 | Mock purchase provider | 1d | P1 | C-IAP-1 | **Deliv:** Internal sandbox purchase flow chạy end-to-end ngoài core progression. |
| C-IAP-3 | Entitlement mapping + reward bundle bridge | 1d | P1 | C-IAP-1 | **Deliv:** Product → entitlement → reward bundle → ledger source `commerce_future`. |
| C-IAP-4 | Restore / retry / idempotency design | 1d | P1 | C-IAP-3 | **Deliv:** Duplicate transaction không grant trùng, restore không phá state. |
| C-IAP-5 | Apple sandbox prep checklist | 1d | P2 | C-IAP-1 | **Deliv:** Việc cần bật khi Apple account/product/IAP entitlement sẵn sàng. |
| C-IAP-6 | StoreKit scope boundary | 0.5d | P2 | C-IAP-5 | **Deliv:** Ghi rõ real StoreKit end-to-end chỉ làm khi account/product đủ quyền. |

### QC riêng cho Shop/IAP

- [ ] Mock purchase flow không ảnh hưởng race reward flow.
- [ ] Commerce grant dùng chung ledger/idempotency pattern.
- [ ] Store layer không phụ thuộc trực tiếp gameplay subsystem.
- [ ] Chưa yêu cầu pass real Apple StoreKit nếu Apple account chưa đủ quyền.

---

## Timeline tổng quan 15 ngày

```text
Ngày 1       2       3       4       5       6       7       8       9       10      11      12      13      14      15
│──────────── Sprint 1: Contract + Config + Snapshot ────────────│
                                                │──────── Sprint 2: Race + Reward Authority ────────│
                                                                                        │──── Sprint 3: Inventory/Garage/Progression + Hardening ────│
```

### Critical path

```text
Schema/Contract
   → Backend/DevOps Environment
   → Config Version
   → Backend Snapshot
   → Unreal Snapshot Adapter
   → Race Session
   → Submit Result
   → Reward Resolver
   → Ledger Grant
   → Client Reward UI
   → Inventory/Garage/Progression Sync
```

Nếu bất kỳ node nào trong critical path trễ hơn 1 ngày, phải cắt bớt Post-MVP scope thay vì giảm chất lượng ledger/idempotency.

---

## Rủi ro chính

1. **Scope 15 ngày vẫn rất aggressive** → phải ưu tiên vertical slice chạy chắc, không cố full feature.
2. **State phân mảnh local save** → migration chỉ làm dry-run tối thiểu, không cam kết migrate mọi save domain trong 15 ngày.
3. **Inventory và garage chồng lấn ownership/equip state** → cần canonical hóa ngay Sprint 1.
4. **Reward duplication** → ledger/idempotency là non-negotiable từ Sprint 2.
5. **Config drift giữa Excel, client và backend** → config versioning phải có từ Sprint 1.
6. **Nakama multi-object mutation không được định nghĩa rõ** → cần write order + ledger status rõ trước atomic grant.
7. **PvE Hybrid Authority bị kỳ vọng quá mức** → ghi rõ không phải full deterministic anti-cheat.
8. **Shop/IAP chen vào core path** → đã tách riêng stream commerce để không block progression vertical slice.
9. **Backend/DevOps task bị ẩn trong gameplay task** → đã tách riêng owner Nam Sơn cho environment, RPC, storage, logging, smoke test và handover.

---

## Giả định đã khóa trong kế hoạch này

- Team core có 4 dev trong 15 ngày: 1 Backend/Nakama/DevOps, 1 UI, 1 Integration, 1 Data/Economy/Progression.
- Mục tiêu là vertical slice đủ chắc để demo và bàn giao, không phải full production progression 10 tuần.
- PvE authoritative phase dùng Nakama judge, chưa cần dedicated UE authority.
- PvE Hybrid Authority chỉ làm session validity + sanity validation + reward authority.
- Wallet canonical gồm các currency core ngay từ Sprint 1.
- Inventory canonical lưu full state nhưng chỉ implement mutation MVP cần cho slice.
- Garage dùng garage-lite state trước, full customize/material/decal polish để Post-MVP.
- Race session pin `config_version` tại thời điểm start; reward submit dùng đúng version đó.
- Local save còn tồn tại như cache/migration support, không còn là source of truth cuối cùng.
- Shop/IAP/commerce tách riêng khỏi core 15 ngày; mock/sandbox IAP là stream riêng sau hoặc song song nếu có thêm capacity.

---

## Các điểm còn cần chốt trong implementation kickoff

1. Fuel khi mất mạng/offline: hard-block theo backend hay cho chạy bằng cache rồi reconcile sau?
2. Race result invalid: chỉ reject và không grant, hay cho phép manual review queue?
3. Goal reward trong vertical slice: auto-grant khi complete hay manual claim?
4. Inventory mutation MVP cần hỗ trợ chính xác các command nào trong 15 ngày: add/equip hay thêm use/remove?
5. Garage-lite trong 15 ngày cần performance summary tới mức nào: chỉ CR tổng hay per-part level?
6. Migration dry-run áp dụng cho toàn bộ account cũ hay chỉ sample/test account?
7. Config compatibility policy: client cũ gặp backend config mới thì force update, warn, hay compatibility window?
8. Shop/IAP stream sẽ làm sau core 15 ngày hay chạy song song bởi người ngoài team 4 dev?
9. Backend environment mục tiêu cho demo là local-only, staging shared hay cả hai?
10. Log/debug backend cần lưu ở Nakama logger, external file, hay chỉ console trong giai đoạn 15 ngày?

---

## Post-MVP Backlog

- Full goal random pool assignment theo tier/weight/city.
- Full loot crate token roll pipeline.
- Duplicate owned visual compensation đầy đủ.
- Same-batch duplicate reroll 1 lần rồi convert cash.
- Full customize purchase/apply/equip commands.
- Performance upgrade command đầy đủ spend currency + consume item + update CR.
- Real StoreKit / Google Play Billing integration.
- Production purchase restore/retry/idempotency hardening.
- Deterministic replay anti-cheat hoặc dedicated server authority nếu cần.
- Analytics/ops dashboard cho suspicious result và economy audit.
- CI/CD backend hoàn chỉnh cho Nakama runtime nếu dự án yêu cầu production pipeline.

---

## Ready for Execution

Bước tiếp theo hợp lý nhất:

1. Chốt 10 câu hỏi kickoff ở trên.
2. Nam Sơn khóa backend environment, RPC contract v1 và storage key trong ngày 1.
3. Đời dựng config validation MVP ngay từ ngày 1-2.
4. Nam Sơn dựng bootstrap/snapshot trước khi làm race authority.
5. Thịnh chỉ replace local authority reads sau khi snapshot adapter ổn định.
6. Duy hoàn thiện UI theo server payload và các trạng thái sync/error đã thống nhất.
7. Không đưa Shop/IAP vào critical path core progression 15 ngày.
