# CDN — Content Download

## Phạm vi
Tải pak/chunk theo yêu cầu, mount, widget patch. Không vận hành CDN infrastructure, quản lý AWS bucket hay tạo nội dung map. Phần chia chunk + upload AWS + k6 load test thuộc **PC** (#148 Project Config, infra).

## Module/class C++ liên quan (file thật, `ChunkDownloader/`)
- `ChunkDownloaderSubsystem.cpp` — `UChunkDownloaderSubsystem` (patch lifecycle, mount chunk, retry, chống re-entrant).
- `ChunkDownloaderController.cpp` — `UChunkDownloaderController` (spawn patch widget).
- `ChunkDownloaderWidget.cpp` — `UChunkDownloaderWidget` (UI tiến trình + mở map tải về).

## Blueprint liên quan
- WBP patch progress (`/Game`), spawn từ controller. Event-driven; không cần kiểm tra editor.

## Điểm nóng hiệu năng cụ thể (đã đọc file)
1. **`LoadSynchronous` class widget patch** — `ChunkDownloaderController.cpp:21`: `ResolvedPatchWidgetClass = TSoftClassPtr<UUserWidget>(FSoftClassPath(ConfigPatchWidgetClassPath)).LoadSynchronous()`. Blocking load 1 lần khi mở patch UI. Tác động nhỏ, nhưng nên async.
2. **`OpenDownloadableMap` quét toàn bộ PlayerStart + `StaticLoadClass` blocking** — `ChunkDownloaderWidget.cpp:139` `GetAllActorsOfClass(..., APlayerStart, PlayerStarts)` rồi loop tìm tag "Spawn" (dòng 147-157), sau đó `:169` `StaticLoadClass` blocking load class actor từ chunk vừa mount. Một lần khi mở map tải về; chấp nhận được, nhưng có thể hitch nếu asset lớn.
3. **`GEngine->AddOnScreenDebugMessage` còn trong code** — `ChunkDownloaderWidget.cpp:180, 185`: "SUCCESS: Spawned BP_ChunkAsset...", "ERROR: Could not load...". Cần bọc `#if !UE_BUILD_SHIPPING`.

## Nợ kỹ thuật cụ thể
- Tên biến `BallClass` (`ChunkDownloaderWidget.cpp:169`) cho class actor tổng quát — leftover từ demo; gây hiểu nhầm.
- `DownloadableAssetName` là magic string truyền vào `StaticLoadClass` — thiếu fallback nếu mount fail (chỉ có nhánh else in debug).
- Subsystem có chống re-entrant patch request (tốt).

## Mức ưu tiên: **P2**
Lý do: chỉ chạy lúc tải nội dung (không phải đường nóng gameplay). Cần dọn debug on-screen message + async load trước khi ship.
