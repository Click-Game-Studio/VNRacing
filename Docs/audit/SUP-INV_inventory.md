# SUP-INV — Inventory

## Phạm vi
Sở hữu item, equip/favorite, definition database, persistence.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/InventorySystem/InventoryManager.cpp` — `UInventoryManager` (451 dòng).
- `InventorySystem/ItemDatabase.cpp` — `UItemDatabase` (cache từ DataTable).

## Blueprint liên quan
- UI inventory/equip (nhóm `/Game/UI`), không phải gameplay tick.

## Điểm nóng hiệu năng cụ thể (đã đọc cả 2 file)
1. **`UItemDatabase::GetItemDefinition` (`ItemDatabase.cpp:36-44`) BỎ QUA cache** — đây là điểm nóng đã verify. Mọi hàm khác (`ItemExists`, `IsStackable`, `GetItemType`, `GetItemRarity`) đều đọc từ `ItemCache` (TMap, O(1)), riêng `GetItemDefinition` lại gọi `ItemDefinitionsTable->FindRow<FItemDefinition>(...)` trực tiếp. Hàm này là đường lấy full definition (icon, stats...) → bị gọi nhiều nhất nhưng lại chậm nhất, phá vỡ mục đích của cache.
2. **Thiếu null-check ở boundary**: `GetItemDefinition` dùng `ItemDefinitionsTable->FindRow` mà không kiểm tra `ItemDefinitionsTable` hợp lệ (các getter cache-based thì có check `ItemCache.Contains`). Nếu DB chưa `Initialize()` mà gọi `GetItemDefinition` → null-deref. `BuildItemCache` có check `IsValid` nhưng `GetItemDefinition` thì không.
3. **Save trên mỗi mutation**: `InventoryManager.cpp` gọi `SaveInventoryItemsToSaveGame()` ở **mọi** thao tác thay đổi (dòng 19, 160, 196, 209, 220, 231, 263). Nếu cấp nhiều item liên tiếp (ví dụ reward batch từ VT-REWARD) → ghi SaveGame nhiều lần liên tục, mỗi lần serialize toàn bộ inventory.

## Nợ kỹ thuật cụ thể
- Bất nhất pattern truy cập DB trong cùng class `UItemDatabase` (cache vs FindRow) — dễ gây bug "data lệch" giữa các getter.
- `GetItemsForCar` (`ItemDatabase.cpp:107-112`) là **stub**: tạo mảng rỗng rồi return ngay, không có logic. Đánh dấu rõ là chưa hoàn thiện.
- Save-on-every-mutation không gom batch → I/O dư thừa.
- Khóa backend-authority đã có (`bUseBackendAuthority`, `InventoryManager.cpp:136,167`) chặn mutation local khi ở chế độ backend — đúng hướng, không phải nợ.

## Audit Blueprint
Không có BP gameplay-tick thuộc feature này. Không cần kiểm tra editor thủ công.

## Mức ưu tiên: **P1**
Lý do: cache bypass + thiếu null-check là lỗi đúng-sai rõ ràng, dễ sửa, ảnh hưởng mọi nơi gọi `GetItemDefinition`. Không phải per-frame nên không P0, nhưng độ chắc chắn cao.
