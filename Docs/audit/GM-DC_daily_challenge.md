# GM-DC — Daily Challenge — Audit

> **Mã:** GM-DC · **OP ID:** #274 · **Epic:** GAME MODE (#272)
> **Trạng thái:** ❌ gap — chưa có code product.
> **Subs:** GM-DC-UN #426 (Challenge Unlock), GM-DC-CFG #431 (Challenge Config)

## Missing — code chưa impl

Daily Challenge (#274) là Feature trong OpenProject CSV 2026-06-23 nhưng chưa có C++ subsystem nào hiện thực. `UFanServiceSubsystem` chỉ chứa challenge trong-race (thu thập NOS, drift), không phải hệ thống nhiệm vụ hằng ngày độc lập.

Không phát hiện code thật cho các User Story:
- #427: Nhiệm vụ mới khi đăng nhập lần đầu trong ngày
- #432: Nhiệm vụ Daily Challenge nhiều thể loại
- #426: Challenge Unlock
- #431: Challenge Config

Hai sub-Feature GM-DC-UN và GM-DC-CFG cùng trạng thái ❌ gap.

**Cần xây mới:** Subsystem Daily Challenge riêng: Pool nhiệm vụ, Reset theo ngày, UI/UX. Xem `Docs/ld/GM-DC_daily_challenge.md` và các sub-section GM-DC-UN, GM-DC-CFG trong cùng file.