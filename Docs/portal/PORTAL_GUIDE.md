# Portal Kiến trúc VNRacing — Hướng dẫn nhanh

> 1 trang — đủ để đọc, sửa, tạo nội dung mới.

---

## 3 câu về portal

1. **Astro + Starlight** — portal tĩnh, viết bằng Markdown, search được, có sidebar
2. **LikeC4** — diagram kiến trúc C4 tương tác (zoom/pan/click), code sinh diagram
3. **3 version** — Latest (hiện tại), v1 (snapshot), Multiplayer Preview (tính năng mới)

---

## Cách xem

```
cd Docs/portal
npm run dev        # Mở http://localhost:4321/VNRacing/
```

- **Sidebar trái** — duyệt mục lục
- **Search Ctrl+K** — tìm nhanh
- **Version switcher** (góc phải trên) — chuyển đổi version
- **Diagram** — click box để xem chi tiết, scroll để zoom

---

## Cách sửa nội dung

```bash
# Sửa file trong src/content/docs/
# Lưu → HMR reload tự động (không cần restart)

# Kiểm tra sau khi sửa
npm run build
```

---

## Cách thêm trang mới

```bash
# 1. Tạo file .md
touch src/content/docs/<section>/<ten-trang>.md

# 2. Mở file, thêm frontmatter
# ---
# title: "Tiêu đề"
# description: "Mô tả ngắn"
# ---

# 3. Đăng ký sidebar
# Sửa astro.config.mjs (Latest) hoặc src/content/versions/<version>.json
# Thêm slug tương ứng

# 4. Kiểm tra
npm run dev
```

---

## Quy tắc

| # | Quy tắc | Nếu vi phạm |
|---|---------|-------------|
| 1 | Không sửa `v1/` | Snapshot lịch sử, không sửa |
| 2 | Sidebar thủ công | Trang không hiện nếu chưa đăng ký slug |
| 3 | Build trước push | Lỗi build = lỗi trên GitHub Pages |
| 4 | Branch + PR | Không push thẳng main |
| 5 | Build logs không commit | File rác trong git |

---

## Cheat sheet

```bash
npm run dev       # Dev server
npm run build     # Build tĩnh
npm run preview   # Xem bản build

# Xem diagram LikeC4
# Mở likec4/<version>/views.c4
```

---

## Tài liệu tham khảo

- `Docs/portal/MAINTENANCE.md` — hướng dẫn chi tiết cho người bảo trì
- `Docs/portal/README.md` — quick start + cấu trúc
- https://c4model.com — Tư duy C4: vẽ diagram từ tổng quan đến chi tiết
- https://likec4.dev — Cách viết `.c4`, CLI, cấu hình
- https://likec4.dev/docs/specification/ — Cú pháp element, tag, style
- https://likec4.dev/docs/model/ — Khai báo actor, system, relationship
- https://likec4.dev/docs/views/ — Tạo góc nhìn context, container, component
- https://docs.astro.build — Astro docs
- https://starlight.astro.build — Starlight theme docs
- https://arc42.org — Template kiến trúc arc42
