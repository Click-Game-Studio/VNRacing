# SUP-SHOP — Shop / IAP / Ads

## Phạm vi
Cửa hàng sản phẩm, orchestration mua hàng, abstraction provider.

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/IAPSystem/CommerceSubsystem.cpp` — `UCommerceSubsystem` (orchestration mua).
- `IAPSystem/MockCommerceProvider.cpp` — `FMockCommerceProvider` (provider giả lập dev).

## Blueprint liên quan
- WBP_Shop, WBP_Popup_Shopping, WBP_Card_DLC, WBP_Card_BoosterBundles, WBP_Play_Rewards_WatchAds (`/Game/UI`). Event-driven theo delegate `OnQueryFinished`/`OnPurchaseFinished`.

## Điểm nóng hiệu năng cụ thể (đã đọc file)
Không có per-frame hotspot — toàn bộ là event/delegate. CommerceSubsystem nhẹ.

## Nợ kỹ thuật cụ thể (đã đọc `CommerceSubsystem.cpp` toàn bộ 87 dòng)
1. **`#include` nằm GIỮA thân hàm** — `CommerceSubsystem.cpp:13` `#include "HAL/PlatformProperties.h"` đặt bên trong `Initialize()` (sau dòng 12). Hợp lệ về cú pháp nhưng là code smell nghiêm trọng; include phải ở đầu file.
2. **Provider thật bị comment, chỉ Mock được wire** — dòng 14-23: nhánh `PLATFORM_ANDROID`/`PLATFORM_IOS` đều `ActiveProvider = MakeShared<FMockCommerceProvider>();` còn `FAndroidCommerceProvider`/`FIOSCommerceProvider` bị comment. Tức là **trên mọi nền tảng (kể cả shipping) đều chạy Mock** → mua hàng không bao giờ chạm store thật. Đây là rủi ro chức năng/doanh thu, không phải perf.
3. **Không có server verification** — `HandleProviderPurchaseComplete` (dòng 75-86) có comment TODO "Gửi receipt lên server" nhưng nhánh `Success` rỗng, broadcast thẳng `OnPurchaseFinished`. Không chống gian lận IAP. (Khớp tag `#backend-target` trong C4.)
4. **`bIsProcessingTransaction` là khóa toàn cục 1 giao dịch** — đúng để chống double-buy, nhưng nếu provider không bao giờ callback (timeout) thì cờ kẹt `true` vĩnh viễn, chặn mọi mua hàng sau. Thiếu timeout/reset.

## Audit Blueprint
WBP shop event-driven; không cần kiểm tra editor.

## Mức ưu tiên: **P1** (rủi ro chức năng/doanh thu, không phải perf)
Lý do: provider thật chưa wire + không verify server là chặn doanh thu khi ship. Về hiệu năng thì P2 (nhẹ). Xếp P1 do tác động kinh doanh.
