---
phase: planning
title: Detailed Implementation Plan - Car Customization
description: Detailed task breakdown and resource allocation for car customization
feature_id: car-customization
status: development
last_updated: 2026-01-20
---

# Detailed Implementation Plan - Car Customization

**Feature ID**: `car-customization`
**Status**: 🔄 Development
**Version**: 1.1.0
**Last Updated**: 2026-01-26

## UE5 Mobile - Sử dụng Asset Dummy

### Tổng quan

Kế hoạch triển khai prototype hệ thống Car Customization trên Unreal Engine 5 Mobile sử dụng asset dummy (mô hình đơn giản phục vụ kiểm thử chức năng). Mục tiêu là xây dựng hệ thống hoàn chỉnh với kiến trúc mở rộng, đảm bảo tất cả workflow và logic hoạt động ổn định trước khi tích hợp vào project chính.

**Thời gian ước lượng:** 12-15 ngày làm việc (96-120 giờ) cho 2 developer có kinh nghiệm tương đối với Unreal Engine.

***

## Bảng kế hoạch chi tiết

### Phase 1: Asset Dummy Creation (28 giờ)

| Task ID | Mô tả công việc | Thời gian | Developer | Mốc quan trọng |
| :-- | :-- | :-- | :-- | :-- |
| 1.1 | Tạo base car model dummy (box modeling approach) | 8 giờ | DevB | 1 xe cơ bản với tỷ lệ đúng, import UE5 thành công |
| 1.2 | Tạo các loại car parts dummy (mỗi loại 2-3 variants) | 16 giờ | DevB | Các parts đơn giản (bumper, wheels, spoiler, etc.) |
| 1.3 | Basic materials và textures cho tất cả asset dummy | 4 giờ | DevA | Có thể tận dụng các materials có sẵn |

**Milestone Phase 1:** Asset library dummy hoàn chỉnh, kiểm tra import UE5 thành công

***

### Phase 2: Data Structure \& Core Logic (20 giờ)

| Task ID | Mô tả công việc | Thời gian | Developer | Mốc quan trọng |
| :-- | :-- | :-- | :-- | :-- |
| 2.1 | Tạo Enum, Struct và Data Tables structure | 6 giờ | DevA | Compile thành công với data structure |
| 2.2 | Setup Data Tables với asset dummy references | 8 giờ | DevA | Data Tables hoàn chỉnh với TSoftObjectPtr |
| 2.3 | Performance calculation engine (BaseStats + Modifiers) | 4 giờ | DevA | Logic tính toán BaseStats + Modifiers |
| 2.4 | Configuration management system (Save/Load USaveGame) | 2 giờ | DevA | USaveGame system hoạt động ổn định |

**Milestone Phase 2:** Core logic hoạt động với asset dummy, performance calculation chính xác

***

### Phase 3: Asset Loading \& Visual System (20 giờ)

| Task ID | Mô tả công việc | Thời gian | Developer | Mốc quan trọng |
| :-- | :-- | :-- | :-- | :-- |
| 3.1 | Asset loading system với dummy assets (TSoftObjectPtr, async loading) | 6 giờ | DevB | Loading không lag, error handling tốt |
| 3.2 | Car assembly logic (gắn parts vào socket, component management) | 6 giờ | DevA | Parts gắn đúng vị trí socket, component management |
| 3.3 | Material system \& color customization (Dynamic Material Instances) | 8 giờ | DevB | Dynamic Material Instances, real-time color change |

**Milestone Phase 3:** Visual customization hoạt động với asset dummy

***

### Phase 4: UI Integration \& Polish (16 giờ)

| Task ID | Mô tả công việc | Thời gian | Developer | Mốc quan trọng |
| :-- | :-- | :-- | :-- | :-- |
| 4.1 | Car preview system (camera controls, orbit, zoom) | 4 giờ | DevB | 360° preview mượt mà với orbit/zoom |
| 4.2 | Customization UI workflow (UMG Widget, part selection, color picker) | 8 giờ | DevA | UI functional cho tất cả features |
| 4.3 | Performance stats integration (real-time display) | 4 giờ | DevA | Real-time stats display với UI |

**Milestone Phase 4:** Complete workflow end-to-end với asset dummy

***

### Phase 5: Testing \& Optimization (12 giờ)

| Task ID | Mô tả công việc | Thời gian | Developer | Mốc quan trọng |
| :-- | :-- | :-- | :-- | :-- |
| 5.1 | Performance testing và optimization | 6 giờ | DevA | Duy trì 30+ FPS trên mobile |
| 5.2 | Bug fixes và end-to-end testing | 4 giờ | DevA + DevB | System ổn định, không crash, không lag |
| 5.3 | Documentation \& handover preparation | 2 giờ | DevB | Ready for main project integration |

**Milestone Phase 5:** Production-ready prototype system

***

## Phân bổ thời gian \& lịch trình

### Tổng hợp

| Developer | Tổng thời gian | Asset Creation | Logic Development | Testing \& Polish |
| :-- | :-- | :-- | :-- | :-- |
| DevA | 48 giờ | 4 giờ | 36 giờ | 8 giờ |
| DevB | 48 giờ | 24 giờ | 18 giờ | 6 giờ |
| **Tổng** | **96 giờ** | **28 giờ** | **54 giờ** | **14 giờ** |

### Lịch làm việc 12 ngày

| TT | Developer | Tuần 1 (Ngày 1-5) | Tuần 2 (Ngày 6-10) | Tuần 3 (Ngày 11-12) |
| :-- | :-- | :-- | :-- | :-- |
| 1 | DevA | Task 1.3, Task 2.1, Task 2.2 | Task 2.3, Task 2.4, Task 3.2 | Task 4.2, Task 4.3, Task 5.1 |
| 2 | DevB | Task 1.1, Task 1.2 | Task 3.1, Task 3.3, Task 4.1 | Task 5.2, Task 5.3 |


***

## Advantages Asset Dummy Approach

- Consistent art style
- Optimized for purpose
- No licensing issues
- Easier iteration
- Faster development

***

## Integration timeline

### Post-Prototype Phase

1. **Asset quality upgrade** (nếu cần): 2-3 ngày
2. **Main project integration**: 2-3 ngày
3. **Final testing** trong main project: 1-2 ngày

**Total timeline:** 17-20 ngày

***

## Kết luận

Việc sử dụng asset dummy sẽ tạo ra foundation solid cho việc nâng cấp sau này khi tích hợp vào dự án chính, đồng thời cho phép team tập trung 100% vào việc phát triển và kiểm thử logic hệ thống. Toàn bộ workflow, cấu trúc dữ liệu, và quy trình customization được thiết kế theo tài liệu kỹ thuật, đảm bảo khả năng mở rộng và tích hợp liền mạch.
<span style="display:none">[^1]</span>

<div style="text-align: center">⁂</div>

[^1]: PlainningCarCustomization.pdf

