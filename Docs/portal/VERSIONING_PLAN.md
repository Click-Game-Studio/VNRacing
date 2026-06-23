# Kế hoạch: thêm versioning vào portal Astro/LikeC4 (Cách A — snapshot đông cứng)

## Mục tiêu
Trên branch portal cũ (Astro + Starlight + LikeC4 tương tác), cho phép:
- Chọn version tài liệu qua dropdown (như docs có version).
- **Xem lại sơ đồ C4 của từng version** — kiến trúc thay đổi qua mỗi bản.
- Giữ nguyên trải nghiệm hiện tại: zoom/pan + click ô nhảy tới trang LD.

## Hai lớp phải version riêng
1. **Tài liệu (md/mdx + assets)** → dùng plugin `starlight-versions@0.9.0`
   (peer dep `@astrojs/starlight >=0.39`; portal đang 0.40 → OK).
2. **Sơ đồ C4 (compile từ `.c4`)** → dùng cơ chế **multi-project** của LikeC4:
   mỗi version là một "project" với bộ `.c4` riêng, gọi qua
   `likec4:react/<tên-project>`.

## Bước thực hiện

### A. Cài + cấu hình starlight-versions
1. `npm i starlight-versions` trong `Docs/portal`.
2. `astro.config.mjs`: thêm vào mảng `plugins` của `starlight({...})`:
   `starlightVersions({ versions: [{ slug: 'v1' }] })`.
3. `src/content.config.ts`: thêm collection `versions` dùng `docsVersionsLoader()`.
4. Chạy `astro dev` một lần → plugin tự chụp toàn bộ docs hiện tại thành
   `src/content/docs/v1/...` và bản hiện hành thành "current/latest".

### B. Tách model LikeC4 thành multi-project
Hiện tại: `likec4/` chứa 1 bộ (`specification.c4`, `model.c4`, `views.c4`) =
1 project mặc định → virtual module `likec4:react`.

Đổi thành cấu trúc thư mục con, mỗi version 1 project:
```
likec4/
  current/
    likec4.config.json   ← { "name": "current" }
    specification.c4  model.c4  views.c4   (bản đang phát triển)
  v1/
    likec4.config.json   ← { "name": "v1" }
    specification.c4  model.c4  views.c4   (snapshot bản v1 — copy từ bản hiện tại)
```
- Cập nhật `LikeC4VitePlugin({ workspace: './likec4' })` để quét cả thư mục
  (multi-project tự nhận diện qua `likec4.config.json`).
- Sinh ra 2 virtual module: `likec4:react/current`, `likec4:react/v1`.

### C. Cho DiagramView nhận tham số version/project
`DiagramView.tsx` đang `import('likec4:react')` cứng. Sửa:
- Thêm prop `project` (vd `'current'` | `'v1'`).
- Vì Vite không phân tích được `import()` đường dẫn động hoàn toàn, dùng **map
  tường minh các thunk import**:
  ```ts
  const ENGINES = {
    current: () => import('likec4:react/current'),
    v1:      () => import('likec4:react/v1'),
  };
  ```
- Giữ nguyên toàn bộ logic lazy-load (IntersectionObserver) + click→LD hiện có.
- Mặc định `project='current'` để các trang cũ không phải sửa.

### D. Gắn project vào trang kiến trúc theo version
- `src/content/docs/architecture.mdx` (bản current): truyền `project="current"`
  vào 26 island `<DiagramView>`.
- Bản snapshot `src/content/docs/v1/architecture.mdx` (plugin tạo ở bước A4):
  sửa 26 island thành `project="v1"`.
  → Đây là việc thủ công 1 lần mỗi khi cắt version (đúng tinh thần "đông cứng").

### E. Kiểm chứng
1. `astro dev` → mở `/VNRacing`:
   - Dropdown version hiện `current` + `v1`.
   - Trang Kiến trúc bản current: sơ đồ chạy, zoom + click ô → trang LD OK.
   - Chuyển sang `v1`: vẫn xem được sơ đồ (từ project `v1`), click vẫn chạy.
2. `astro build` → bảo đảm build tĩnh không lỗi, kiểm tra kích thước chunk
   (mỗi project thêm phần layout-data riêng; engine react-flow vẫn share).
3. Báo cáo: chunk tăng bao nhiêu, có cảnh báo gì không.

## Tradeoff đã chấp nhận (Cách A)
- Mỗi version thêm 1 project LikeC4 → tăng dung lượng (layout data của bản đó).
  Lazy-load nên không chặn first paint, nhưng tổng bundle lớn dần theo số version.
- Cắt version = thao tác thủ công nhỏ: copy `.c4` vào folder version + đổi
  `project=` trong mdx snapshot.

## Phạm vi file đụng tới
- `package.json` (thêm dep)
- `astro.config.mjs` (plugin + có thể chỉnh workspace)
- `src/content.config.ts` (collection versions)
- `likec4/` → tái cấu trúc thành `likec4/current/` + `likec4/v1/` (+ 2 config.json)
- `src/components/DiagramView.tsx` (prop project + map engine)
- `src/content/docs/architecture.mdx` + bản snapshot `v1/architecture.mdx`

## Làm thử trước (giảm rủi ro)
Làm **chỉ 1 version v1 + 2-3 sơ đồ** để xác nhận chuỗi multi-project chạy thật
(dropdown + đổi project + click), rồi mới áp cho cả 26 island và build full.
