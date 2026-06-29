# Bảo trì Docs Portal — Hướng dẫn cho người tiếp quản

Tài liệu này dành cho người duy trì Docs Portal sau buổi workshop. Mọi quy trình đều được ghi lại để team tự thao tác được mà không cần hỏi lại người cũ.

---

## 1. Tổng quan stack

| Layer | Công nghệ | Ghi chú |
|-------|-----------|---------|
| SSG | Astro 6.4 | Static site, Markdown-first |
| Theme | Starlight 0.40 | Tích hợp search (Pagefind), sidebar |
| Diagram | LikeC4 1.58 | C4 model → SVG tương tác |
| Versioning | starlight-versions 0.9 | Switcher UI |
| Deploy | GitHub Actions → GitHub Pages | Tự động |

---

## 2. Cấu trúc thư mục

```
Docs/portal/
├── astro.config.mjs            # Cấu hình chính + sidebar (Latest)
├── src/
│   ├── content/
│   │   ├── docs/               # Nội dung .md / .mdx
│   │   │   ├── architecture/   # arc42
│   │   │   ├── features/       # Feature docs
│   │   │   ├── multiplayer/    # Multiplayer Preview
│   │   │   ├── decisions/      # ADR
│   │   │   └── v1/             # Snapshot — không sửa
│   │   └── versions/           # Cấu hình version + sidebar riêng
│   │       ├── v1.json
│   │       └── multiplayer.json
│   ├── components/
│   │   └── DiagramView.tsx     # React island cho LikeC4
│   └── rehype-base-links.mjs   # Rewrite links cho GitHub Pages
├── likec4/                     # C4 model source
│   ├── current/                # Latest version
│   ├── multiplayer/            # Multiplayer version
│   ├── v1/                     # v1 snapshot
│   └── demo/                   # Demo workshop (xem rồi xoá)
└── package.json
```

---

## 3. Quy trình thường dùng

### 3a. Thêm trang mới

```bash
# 1. Tạo file
touch src/content/docs/<section>/<trang-moi>.md

# 2. Viết frontmatter
cat > src/content/docs/<section>/<trang-moi>.md << 'EOF'
---
title: "Tiêu đề trang"
description: "Mô tả ngắn"
---
EOF

# 3. Thêm sidebar
# Sửa astro.config.mjs (cho Latest) hoặc src/content/versions/<version>.json
# Thêm slug tương ứng vào mảng sidebar

# 4. Kiểm tra
npm run dev
# Mở http://localhost:4321/VNRacing/<section>/<trang-moi>/
```

### 3b. Sửa nội dung

Sửa trực tiếp file `.md` / `.mdx` trong `src/content/docs/`. HMR tự động reload (dev server). Build lại trước push:

```bash
npm run build   # Không lỗi mới push
```

### 3c. Xoá trang

```bash
git rm src/content/docs/<section>/<trang>.md
# Xoá slug khỏi sidebar trong astro.config.mjs hoặc version JSON
```

---

## 4. Quản lý version

### Kiến trúc

Mỗi version là một **thư mục độc lập** trong `src/content/docs/` + **1 file JSON** trong `src/content/versions/`.

| Version | Thư mục doc | File JSON | Sidebar |
|---------|-------------|-----------|---------|
| Latest | `docs/` | (mặc định) | `astro.config.mjs` |
| v1 | `docs/v1/` | `versions/v1.json` | `v1.json` |
| Multiplayer Preview 🆕 | `docs/multiplayer/` | `versions/multiplayer.json` | `multiplayer.json` |

### Thêm version mới

```bash
# 1. Tạo thư mục
mkdir -p src/content/docs/<version-moi>

# 2. Copy nội dung từ version hiện tại
cp -r src/content/docs/architecture src/content/docs/<version-moi>/
cp -r src/content/docs/features src/content/docs/<version-moi>/
# ... (copy các thư mục cần thiết)

# 3. Tạo file cấu hình
cat > src/content/versions/<version-moi>.json << 'EOF'
{
  "sidebar": [
    { "label": "Section", "items": [ { "label": "Trang", "slug": "index" } ] }
  ]
}
EOF

# 4. Đăng ký trong astro.config.mjs
plugins: [starlightVersions({
  current: { label: 'Latest' },
  versions: [
    { slug: 'v1' },
    { slug: 'multiplayer', label: 'Multiplayer Preview 🆕' },
    { slug: '<version-moi>', label: '<Tên hiển thị>' },
  ],
})]
```

### Nguyên tắc

- **Không sửa `v1/`** — snapshot lịch sử, chỉ đọc
- Sidebar riêng cho từng version (file JSON)
- Latest = mặc định, không cần file JSON riêng

---

## 5. LikeC4 — C4 Model

3 file trong mỗi thư mục `likec4/<version>/`:

| File | Vai trò |
|------|---------|
| `specification.c4` | Định nghĩa tác nhân (actor, system, externalSystem) |
| `model.c4` | Khai báo các thực thể + quan hệ |
| `views.c4` | Định nghĩa góc nhìn (context, container, component) |

**Sửa diagram:** chỉnh 1 trong 3 file → `npm run build` → diagram cập nhật.

**Embed vào trang .mdx:**

```mdx
import DiagramView from '../../components/DiagramView.astro';

<DiagramView viewId="index" client:only="react" />
```

---

## 6. Deploy

Tự động qua GitHub Actions.

### Workflow

`.github/workflows/docs.yml`:
- **Trigger:** push vào `main` (hoặc branches trong danh sách), thay đổi trong `Docs/portal/**`
- **Job:** `npm ci` → `npm run build` → upload artifact → deploy GitHub Pages

### Thủ công

Vào GitHub → **Actions** → **Deploy Docs to GitHub Pages** → **Run workflow** → chọn branch.

### Kiểm tra sau deploy

```
https://click-game-studio.github.io/VNRacing/
```

---

## 7. Troubleshooting

| Lỗi | Nguyên nhân | Cách xử lý |
|-----|-------------|-------------|
| Build error: "Could not resolve reference to Tag" | `.c4` dùng tag/color không support | Bỏ tag `#external`, chỉ dùng `color primary/muted/secondary` |
| Sidebar không hiển thị | Slug sai hoặc thiếu trong config | Kiểm tra `astro.config.mjs` hoặc file JSON version |
| 404 trên GitHub Pages | Chưa deploy hoặc sai base path | Đợi Actions xong, kiểm tra URL có `/VNRacing/` chưa |
| HMR không reload | Lỗi Vite cache | `Ctrl+C` → `npm run dev` lại |
| `npm run build` chậm | Nhiều diagram LikeC4 | Bình thường, ~10-15s cho 127 pages |

---

## 8. Checklist maintenance định kỳ


- [ ] Kiểm tra các link trong portal còn hoạt động không
- [ ] Cập nhật nội dung khi có thay đổi kiến trúc
- [ ] `npm outdated` — kiểm tra bản mới của Astro/Starlight/LikeC4
- [ ] Xoá các file demo/workshop sau khi không còn dùng
- [ ] Kiểm tra GitHub Actions workflow có pass không

---

## 9. Tài liệu tham khảo chính thức

| Nền tảng | Link | Dùng để |
|----------|------|---------|
| **C4 model** | https://c4model.com | Tư duy C4: System Context → Container → Component → Code |
| **LikeC4** | https://likec4.dev | Cách viết `.c4`, CLI, cấu hình |
| **LikeC4 — Specification** | https://likec4.dev/docs/specification/ | Cú pháp element, tag, style |
| **LikeC4 — Model** | https://likec4.dev/docs/model/ | Khai báo actor, system, relationship |
| **LikeC4 — Views** | https://likec4.dev/docs/views/ | Tạo góc nhìn context, container, component |
| **Astro** | https://docs.astro.build | Static site, routing, build |
| **Starlight** | https://starlight.astro.build | Theme docs, sidebar, search, i18n |
| **starlight-versions** | https://github.com/HiDeoo/starlight-versions | Plugin versioning, config docs |
| **arc42** | https://arc42.org | Template kiến trúc 12 sections |
| **GitHub Actions** | https://docs.github.com/en/actions | CI/CD workflow cho deploy |
