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
│   ├── portal-template/           # Mirror của docs-portal-template (dogfooding)
│   ├── c4/                        # C4 model cũ
│   ├── audit/                     # Audit source docs
│   ├── ld/                        # Low-level design docs
│   └── structurizr/               # Structurizr workspace (workspace.dsl + docs + adrs)
├── .github/workflows/
│   └── docs.yml                   # CI/CD: build Docs/portal → GitHub Pages
├── .gitignore
└── README.md
```

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

## Docs Portal Template

`Docs/portal-template/` là bản mirror của template portal tài liệu dùng chung cho các dự án Click Game Studio. Nguồn chính thức: [Click-Game-Studio/docs-portal-template](https://github.com/Click-Game-Studio/docs-portal-template) — sửa upstream trước, sau đó port về đây.

## Quy tắc

1. **Không sửa file trong `v1/`** — snapshot lịch sử
2. **Sidebar config** trong `astro.config.mjs` — không tự động
3. **Build trước push** — `npm run build` phải OK
4. **Branch + PR** — không push thẳng main
