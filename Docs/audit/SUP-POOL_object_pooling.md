# SUP-POOL — Object Pooling

## Phạm vi
Pool actor tái sử dụng phạm vi world (world subsystem).

## Module/class C++ liên quan (file thật)
- `Source/PrototypeRacing/Private/ObjectPool/ActorObjectPoolSubsystem.cpp` — `UActorObjectPoolSubsystem` (59 dòng).
- `Source/PrototypeRacing/Private/ObjectPool/PoolObjectInterface.cpp` — `IPoolObjectInterface` (OnCreate / OnGetFromPool / OnReleaseToPool).

## Điểm nóng hiệu năng cụ thể
1. **`GetActor` quét tuyến tính mảng `Availability` mỗi lần acquire** (`ActorObjectPoolSubsystem.cpp:14-22`): `for (i in PoolCount) if (!Availability[i]) continue;` — O(n) theo kích thước pool mỗi lần lấy actor. Không có free-list/stack các index rảnh → khi pool lớn và gọi acquire dồn dập (vd spawn nhiều VFX cùng lúc), chi phí cộng dồn.
2. **`ReleaseActor` cũng quét tuyến tính** để tìm actor cần trả (`ActorObjectPoolSubsystem.cpp:50-58`): `for (i in PoolCount) if (ActorList[i] == ActorToRelease)` — O(n) mỗi lần release. Cặp acquire+release đều O(n) → O(n) trên mỗi vòng đời actor pool.

## Nợ kỹ thuật cụ thể
- **Thiếu null/contains-check ở boundary — RỦI RO CRASH**: `ReleaseActor` dòng 47 truy cập `ActorClassDict[ActorToRelease]` trực tiếp bằng `operator[]` mà KHÔNG kiểm tra `Contains`. Nếu truyền vào actor không thuộc pool (hoặc đã bị GC) → crash/undefined. `PoolPtr` (dòng 48) sau đó cũng không null-check trước khi `->Availability` (dòng 49).
- `GetActor` không kiểm tra kết quả `GetWorld()->SpawnActor` trả về null (dòng 23, 34) trước khi `IPoolObjectInterface::Execute_OnCreate(Actor)` → nếu spawn fail (class invalid) sẽ gọi interface trên null.
- Không có cơ chế giới hạn kích thước pool (max cap) — pool chỉ tăng, không co lại; actor xấu (invalid) không bị dọn khỏi `ActorList`.
- Dùng `auto` dày đặc (dòng 12, 19, 23, 33...) làm giảm khả năng đọc kiểu ở boundary subsystem công khai.

## Mức ưu tiên: **P1**
Lý do: thuật toán O(n) acquire+release là nợ thật nhưng pool gameplay thường nhỏ nên tác động runtime hạn chế. Điểm đáng lo hơn là **thiếu Contains-check trong `ReleaseActor` (rủi ro crash)** — nên xếp P1 và xử lý cùng lúc khi refactor pool sang free-list + thêm guard.
