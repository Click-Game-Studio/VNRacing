# Docs Portal

Trang tài liệu kiến trúc PrototypeRacing — xây dựng bằng [Astro](https://astro.build/) + [Starlight](https://starlight.astro.build/), diagram bằng [LikeC4](https://likec4.dev/).

> Bắt đầu một portal tài liệu mới? Dùng template dùng chung: [Click-Game-Studio/docs-portal-template](https://github.com/Click-Game-Studio/docs-portal-template).

## Quick start

```bash
# Portal trong Docs/portal/
cd Docs/portal
npm install
npm run dev      # dev server tại http://localhost:4321/VNRacing/
npm run build    # build static ra dist/
npm run preview  # preview bản build
```

## Cấu trúc thư mục

```
Docs/portal/
├── astro.config.mjs       # Cấu hình Astro + Starlight + LikeC4 plugin
├── src/
│   ├── content/
│   │   ├── docs/          # Nội dung .md / .mdx
│   │   │   ├── architecture/   # arc42 architecture docs
│   │   │   ├── features/       # Feature docs
│   │   │   ├── multiplayer/    # Multiplayer Preview version
│   │   │   └── decisions/      # ADRs
│   │   └── versions/      # Định nghĩa version (v1.json, multiplayer.json)
│   ├── components/
│   │   └── DiagramView.tsx # React component cho LikeC4 interactive diagram
│   └── content.config.ts
├── likec4/                # C4 model source (specification.c4, model.c4, views.c4)
└── public/
```

## Versioning

3 versions, quản lý bằng plugin `starlight-versions`:

| Version | Slug | Nội dung |
|---|---|---|
| **Latest** | (mặc định) | Bản hiện tại, cập nhật liên tục |
| **v1** | `v1/` | Snapshot lịch sử — KHÔNG sửa |
| **Multiplayer Preview 🆕** | `multiplayer/` | Tính năng multiplayer đang phát triển |

### Nguyên tắc

- **KHÔNG sửa file trong `src/content/docs/v1/`** — đó là bản snapshot lịch sử.
- Sửa file trong `src/content/docs/` (Latest) → tự động ảnh hưởng Latest.
- Thêm/sửa trong `src/content/docs/multiplayer/` → ảnh hưởng Multiplayer Preview.
- Sidebar config ở `astro.config.mjs` + `src/content/versions/*.json`.

## Sidebar

Sidebar được định nghĩa trong `astro.config.mjs` theo cấu trúc:

```js
sidebar: [
  { label: 'Tổng quan', slug: 'index' },
  { label: 'Kiến trúc', items: [
    { label: 'System Context', slug: 'architecture/system-context' },
    // ...
  ]},
]
```

Mỗi version có thể có sidebar riêng (file JSON trong `src/content/versions/`).

## LikeC4

Diagram C4 dùng LikeC4, source ở `likec4/`:

```
likec4/
├── specification.c4   # Định nghĩa tác nhân, hệ thống, container
├── model.c4           # Quan hệ và ràng buộc giữa các thành phần
└── views.c4           # Các góc nhìn (System Context, Container, Component)
```

Để embed diagram vào trang .mdx:

```mdx
import DiagramView from '../../components/DiagramView.astro';

<DiagramView viewId="containerView" client:only="react" />
```

## Build & Deploy

- Build tĩnh hoàn toàn — output ra `dist/`.
- GitHub Actions workflow (`.github/` gốc repo) tự động build + deploy lên GitHub Pages.
- **Luôn chạy `npm run build` trước khi push** để phát hiện lỗi sớm.

## Quy tắc chung

1. Không sửa file trong `v1/`
2. Thêm slug vào sidebar config khi tạo trang mới
3. `npm run build` OK trước khi commit
4. Dùng branch riêng, tạo PR, review trước merge
5. Build logs (build_*.log) không commit — đã có .gitignore
