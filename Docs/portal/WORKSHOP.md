# Workshop: Docs Portal — Xem, Sửa, Deploy

**Đối tượng:** Nội bộ team dev
**Thời lượng:** 2 tiếng
**Format:** Slide + hands-on coding

---

## Mục tiêu

Sau workshop, học viên có thể:

1. **Xem** — đọc portal, tra cứu architecture bằng LikeC4 diagram
2. **Sử dụng** — navigation giữa các version, hiểu cấu trúc tài liệu arc42
3. **Chỉnh sửa** — sửa nội dung .mdx, cập nhật sidebar
4. **Upload** — build local, push code, deploy lên GitHub Pages

---

## Chuẩn bị trước workshop

- [ ] Node.js 18+ đã cài
- [ ] Git đã clone repo
- [ ] Chạy `cd Docs/portal && npm install`
- [ ] Chạy `npm run dev` xem portal chạy được chưa
- [ ] Có tài khoản GitHub + đã add SSH key

---

## Nội dung

### Phần 1: Tổng quan (10')

| Mục | Thời gian |
|---|---|
| Tại sao có docs portal? | 3' |
| Stack: Astro + Starlight + LikeC4 | 3' |
| 3 versions: Latest / v1 / Multiplayer Preview | 2' |
| Portal live ở GitHub Pages | 2' |

**Slide gợi ý:**

- **Slide 1**: Title — tên workshop, mục tiêu
- **Slide 2**: Vấn đề trước đây — docs rải rác trong audit, khó tìm, khó review
- **Slide 3**: Giải pháp — portal tập trung, arc42, C4 diagram, versioning
- **Slide 4**: Stack diagram

```
┌─────────────────────┐
│  GitHub Pages       │ ← static host
├─────────────────────┤
│  Astro + Starlight  │ ← SSG framework
├─────────────────────┤
│  LikeC4 + React     │ ← interactive diagrams
├─────────────────────┤
│  MDX content        │ ← nguồn docs
└─────────────────────┘
```

- **Slide 5**: 3 versions minh họa

---

### Phần 2: Xem & Sử dụng (30')

**Nội dung (demo — 20')**

- Navigation: sidebar, search (`Ctrl+K`)
- arc42: System Context → Container View → Component View
- LikeC4 diagram: zoom, pan, click component → detail
- Version switcher: so sánh nội dung giữa Latest / v1 / Multiplayer

**Hands-on #1: Khám phá portal (10')**

1. Mở browser, vào portal local (`http://localhost:4321/VNRacing/`)
2. Tìm câu trả lời: "Hệ thống CR rating nằm ớ feature nào?"
3. Gợi ý: sidebar → Features → [tìm] → đọc nội dung → ghi lại tên feature
4. Chuyển sang Multiplayer Preview → mở Roadmap → đọc 7 Phase
5. Quay lại Latest → vào Kiến trúc → mở System Context

**Kết quả mong đợi:** Học viên biết cách tra cứu portal, chuyển version, đọc diagram.

---

### Phần 3: Cấu trúc nội dung (25')

**Nội dung (demo — 15')**

- Cây thư mục `Docs/portal/` — file nào làm gì
- `src/content/docs/` — tổ chức section
- Frontmatter YAML + MDX syntax
- `astro.config.mjs`: sidebar config
- `src/content/versions/*.json`: định nghĩa version

**Hands-on #2: Sửa 1 dòng nội dung (10')**

**Bài toán:** Trong trang `architecture/system-context.md`, dòng mô tả Nakama chưa chính xác, cần thêm 1 bullet "Nakama realtime socket là kênh chính cho matchmaking".

1. Mở `src/content/docs/architecture/system-context.md`
2. Tìm dòng có "Nakama"
3. Thêm: `| Nakama | ... + realtime socket là kênh chính cho matchmaking`
4. Lưu file → browser tự reload (HMR) → xem thay đổi
5. `git diff` để xem thay đổi

**Kết quả mong đợi:** Học viên hiểu file path ánh xạ URL thế nào, biết sửa nội dung và thấy kết quả ngay.

---

### Phần 4: Thêm mới & LikeC4 (30')

**Nội dung (demo — 15')**

- Thêm 1 trang .mdx mới → đăng ký sidebar → kiểm tra
- LikeC4: `specification.c4` (tác nhân), `model.c4` (quan hệ), `views.c4` (góc nhìn)
- Thêm node vào model.c4
- Embed `DiagramView` vào trang .mdx
- Versioning: copy trang sang `multiplayer/`

**Hands-on #3: Tạo trang hello-dev (15')**

**Bài toán:** Team cần 1 trang test đơn giản để kiểm tra portal — tạo trang "hello-dev" với nội dụng giới thiệu docs portal.

**Bước 1 — Tạo file:**

```bash
touch Docs/portal/src/content/docs/features/hello-dev.md
```

**Bước 2 — Nội dung:**

```markdown
---
title: Hello Dev
description: Trang test cho workshop
---

## Chào dev 👋

Trang này được tạo trong buổi workshop docs portal.

**Kiến trúc hiện tại** có:

- 3 versions: Latest, v1, Multiplayer Preview
- ~35 trang nội dung arc42
- 32 biểu đồ C4 (LikeC4)
- Build -> GitHub Pages tự động

## Diagram thử nghiệm

import DiagramView from '../../components/DiagramView.astro';

<DiagramView viewId="containers" client:only="react" />
```

**Bước 3 — Đăng ký sidebar:**

Trong `astro.config.mjs`, tìm mảng sidebar → thêm:

```js
{ label: 'Hello Dev', slug: 'features/hello-dev' },
```

(Thêm vào nhánh Features, trong phần không bị comment hiện tại, hoặc thêm tạm ở cuối sidebar để dễ thấy.)

**Bước 4 — Kiểm tra:**

```bash
npm run dev
# Mở http://localhost:4321/VNRacing/features/hello-dev/
```

**Bước 5 — Copy sang Multiplayer (bonus):**

```bash
mkdir -p src/content/docs/multiplayer/features
cp src/content/docs/features/hello-dev.md src/content/docs/multiplayer/features/hello-dev.md
```

Cập nhật `sidebarMultiplayer` trong config.

**Kết quả mong đợi:** Học viên tự tạo được 1 trang mới, đăng ký sidebar, hiểu cách LikeC4 hoạt động.

---

### Phần 5: Build, Deploy & Quy tắc (20')

**Build (7')**

- `npm run build` → `dist/`
- Lỗi thường gặp:
  - Sidebar slug sai → page not found
  - Thiếu import component → build error
  - Trùng đường dẫn giữa 2 version
- Build logs: kiểm tra `build_*.log` nếu có lỗi

**Deploy (5')**

- GitHub Actions workflow (tại `.github/` gốc repo)
- Workflow: push → build → deploy GitHub Pages
- Kiểm tra status: GitHub repo → Actions tab

**Quy tắc (8')**

1. **KHÔNG sửa `v1/`** — snapshot lịch sử
2. **Sidebar config** — không tự động, phải đăng ký thủ công
3. **Build trước push** — `npm run build` không lỗi mới commit
4. **Branch + PR** — không push thẳng main
5. **Build logs** — không commit (đã ignore)

**Q&A (nếu còn thời gian)**

---

## Tài liệu tham khảo

- Astro docs: https://docs.astro.build
- Starlight docs: https://starlight.astro.build
- LikeC4: https://likec4.dev
- starlight-versions plugin: https://github.com/HiDeoo/starlight-versions
- arc42 template: https://arc42.org

---

## Cheat Sheet cho dev

### Lệnh thường dùng

```bash
# Dev
npm run dev

# Build
npm run build

# Thêm trang mới
touch src/content/docs/<section>/<page>.md
# + sửa sidebar trong astro.config.mjs

# Thêm version mới
# 1. Tạo src/content/docs/<version>/
# 2. Copy nội dung từ current
# 3. Tạo src/content/versions/<version>.json
# 4. Thêm vào plugins.starlightVersions.versions

# Kiểm tra build
npm run build 2>&1 | head -50
```

### Cấu trúc frontmatter

```yaml
---
title: "Tên trang"
description: "Mô tả ngắn cho SEO và search"
---
```

### Import diagram

```mdx
import DiagramView from '../../components/DiagramView.astro';

<DiagramView viewId="containers" client:only="react" />
```
