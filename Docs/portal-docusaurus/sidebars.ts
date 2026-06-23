import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// Mirrors the Starlight portal sidebar (astro.config.mjs) so the two stacks can
// be compared page-for-page. Doc IDs are the file paths under docs/ minus the
// extension.
const sidebars: SidebarsConfig = {
  docsSidebar: [
    {
      type: 'category',
      label: 'Tổng quan',
      collapsed: false,
      items: [
        {type: 'doc', id: 'index', label: 'Bắt đầu tại đây'},
        {type: 'doc', id: 'architecture', label: 'Kiến trúc (sơ đồ)'},
      ],
    },
    {
      type: 'category',
      label: 'Kiến trúc (arc42)',
      items: [
        {type: 'doc', id: 'architecture/introduction', label: '01. Giới thiệu'},
        {type: 'doc', id: 'architecture/system-context', label: '02. System Context'},
        {type: 'doc', id: 'architecture/container-view', label: '03. Sơ đồ Container'},
        {type: 'doc', id: 'architecture/feature-catalog', label: '04. Danh mục tính năng'},
        {type: 'doc', id: 'architecture/runtime-view', label: '05. Sơ đồ Runtime'},
        {type: 'doc', id: 'architecture/quality-and-risks', label: '06. Chất lượng & Rủi ro'},
        {type: 'doc', id: 'architecture/decisions-and-links', label: '07. Quyết định & Liên kết'},
      ],
    },
    {
      type: 'category',
      label: 'Tính năng (Thiết kế chi tiết)',
      items: [
        {type: 'doc', id: 'features/dm-phys', label: 'DM-PHYS Physics'},
        {type: 'doc', id: 'features/dm-race', label: 'DM-RACE Basic Racing'},
        {type: 'doc', id: 'features/dm-nos', label: 'DM-NOS NOS'},
        {type: 'doc', id: 'features/dm-ramp', label: 'DM-RAMP RAMP'},
        {type: 'doc', id: 'features/dm-cam', label: 'DM-CAM CAMERA'},
        {type: 'doc', id: 'features/dm-set', label: 'DM-SET SETTING'},
        {type: 'doc', id: 'features/vt-map', label: 'VT-MAP Map Đua'},
        {type: 'doc', id: 'features/vt-city', label: 'VT-CITY City Progression'},
        {type: 'doc', id: 'features/vt-track', label: 'VT-TRACK Area-Track Unlock'},
        {type: 'doc', id: 'features/vt-carprog', label: 'VT-CARPROG Car-Progression'},
        {type: 'doc', id: 'features/vt-reward', label: 'VT-REWARD Reward'},
        {type: 'doc', id: 'features/gm-mp', label: 'GM-MP MULTIPLAYER'},
        {type: 'doc', id: 'features/gm-dc', label: 'GM-DC DAILY CHALLENGE ❌'},
        {type: 'doc', id: 'features/cu-room', label: 'CU-ROOM Customize Room'},
        {type: 'doc', id: 'features/cu-menu', label: 'CU-MENU Main menu'},
        {type: 'doc', id: 'features/cdn', label: 'CDN Content Download'},
        {type: 'doc', id: 'features/pc', label: 'PC Project Config 🔧'},
      ],
    },
    {
      type: 'category',
      label: 'Hệ thống nền (Support — ngoài CSV)',
      items: [
        {type: 'doc', id: 'features/sup-ai', label: 'SUP-AI Racer AI'},
        {type: 'doc', id: 'features/sup-pool', label: 'SUP-POOL Object Pooling'},
        {type: 'doc', id: 'features/sup-inv', label: 'SUP-INV Inventory'},
        {type: 'doc', id: 'features/sup-prof', label: 'SUP-PROF User Profile / Economy'},
        {type: 'doc', id: 'features/sup-shop', label: 'SUP-SHOP Shop / IAP / Ads'},
        {type: 'doc', id: 'features/sup-tut', label: 'SUP-TUT Tutorial / Onboarding'},
        {type: 'doc', id: 'features/sup-dbg', label: 'SUP-DBG Debug & Track Test'},
        {type: 'doc', id: 'features/sup-perf', label: 'SUP-PERF Performance & PSO'},
      ],
    },
    {
      type: 'category',
      label: 'Quyết định (ADR)',
      items: [
        {type: 'doc', id: 'decisions/ranking-update-off-tick', label: 'ADR-0001 Ranking off-tick'},
        {type: 'doc', id: 'decisions/canonical-structurizr-review-mode', label: 'ADR-0002 Structurizr review'},
      ],
    },
  ],
};

export default sidebars;
