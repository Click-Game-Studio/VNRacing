# VNRacing Documentation

Tài liệu kiến trúc và thiết kế cho dự án VNRacing.

## Quick start

Docs portal (Astro + Starlight + LikeC4):

```bash
cd Docs/portal
npm install   # one time
npm run dev   # http://localhost:4321/VNRacing/
npm run build # static site → dist/
```

## Cấu trúc repo

```
VNRacing/
├── Docs/
│   ├── portal/                    # ★ Docs portal chính (Astro/Starlight)
│   │   ├── src/content/docs/      #   Nội dung .md/.mdx
│   │   │   ├── architecture/      #     arc42 architecture docs
│   │   │   ├── features/          #     Feature docs
│   │   │   ├── multiplayer/       #     Multiplayer Preview version
│   │   │   ├── decisions/         #     ADR
│   │   │   └── v1/                #     Snapshot lịch sử
│   │   ├── src/content/versions/  #   Cấu hình version (Latest/v1/multiplayer)
│   │   └── likec4/                #   C4 model source
│   │       ├── current/           #     Latest version
│   │       ├── multiplayer/       #     Multiplayer version
│   │       └── v1/                #     v1 snapshot
│   ├── c4/                        # (local) C4 model cũ
│   ├── audit/                     # (local) Audit source docs
│   ├── ld/                        # (local) Low-level design docs
│   └── structurizr/               # Structurizr workspace (workspace.dsl + docs + adrs)
├── .github/workflows/
│   └── docs.yml                   # CI/CD: build Docs/portal → GitHub Pages
├── .gitignore
└── README.md
```

> **Ghi chú:** Các thư mục `audit/`, `ld/`, `c4/`, `progression-v8/` được giữ local để tham khảo, không track trên git. Chỉ `Docs/portal/` và `Docs/structurizr/` (source) được đẩy lên.

## Docs Portal

Trang tài liệu kiến trúc tương tác — deploy tại GitHub Pages.

**Stack:** Astro + Starlight + LikeC4 (diagram C4 tương tác)

**3 versions:**
| Version | URL prefix | Mô tả |
|---|---|---|
| Latest | (default) | Bản hiện tại, cập nhật liên tục |
| v1 | `v1/` | Snapshot lịch sử — KHÔNG chỉnh sửa |
| Multiplayer Preview 🆕 | `multiplayer/` | Tính năng multiplayer đang phát triển |

Chi tiết: xem [Docs/portal/README.md](Docs/portal/README.md)

## Quy tắc

1. **Không sửa file trong `v1/`** — snapshot lịch sử
2. **Sidebar config** trong `astro.config.mjs` — không tự động
3. **Build trước push** — `npm run build` phải OK
4. **Branch + PR** — không push thẳng main

## Tài liệu tham khảo (local)

Các tài liệu không track trên git nhưng vẫn còn trên đĩa:

| Thư mục | Nội dung |
|---|---|
| `Docs/audit/` | Audit source — nội dung đã chuyển vào portal |
| `Docs/ld/` | Low-level design chi tiết |
| `Docs/c4/` | C4 model cũ + LikeC4 render scripts |
| `Docs/progression-v8/` | Design planning progression |
| `Docs/VNRacing_HLD.md` | High Level Design tổng thể |
| `Docs/VNRacing_LLD.md` | Low Level Design tổng thể |
