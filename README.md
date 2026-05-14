# VNRacing Documentation

Tài liệu thiết kế chính thức cho project VNRacing.

Repository này hiện chỉ lưu hai tài liệu tổng hợp chính:

```text
Docs/
├── VNRacing_HLD.md
└── VNRacing_LLD.md
```

## Tài liệu

| File | Nội dung |
| --- | --- |
| [Docs/VNRacing_HLD.md](./Docs/VNRacing_HLD.md) | High Level Design: kiến trúc tổng quan, runtime architecture, gameplay systems, meta-game, online/backend, save/data boundary và technology stack. |
| [Docs/VNRacing_LLD.md](./Docs/VNRacing_LLD.md) | Low Level Design: class/subsystem ownership, data flow, lifecycle, delegate/API boundary, checklist kiểm chứng triển khai. |

## Quy tắc cập nhật

- Source code hiện tại của project Unreal là nguồn ưu tiên cho thông tin kỹ thuật.
- Các tài liệu design mới dùng làm nguồn tham chiếu cho gameplay, economy, progression, customization và rewards.
- Không đưa tài liệu mẫu hoặc tài liệu cũ vào nội dung chính thức nếu không còn phù hợp với source hiện tại.
- Khi có thay đổi lớn về kiến trúc, cập nhật HLD trước, sau đó cập nhật LLD tương ứng.

## Cấu trúc hiện tại

Repo này đã được rút gọn để phục vụ việc chuẩn hoá lại tài liệu. Các tài liệu cũ đã được thay bằng hai bản HLD/LLD tổng hợp ở thư mục `Docs/`.
