// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import react from '@astrojs/react';
import mdx from '@astrojs/mdx';
import { LikeC4VitePlugin } from 'likec4/vite-plugin';
import starlightVersions from 'starlight-versions';
import rehypeBaseLinks from './src/rehype-base-links.mjs';

// Base the site is served from. GitHub Pages project site lives under /VNRacing.
const BASE = '/VNRacing';

// The portal is fully static. LikeC4 diagrams are embedded as client-only React
// islands; the LikeC4 Vite plugin compiles the copied `.c4` model files into the
// `likec4:react` virtual module at build time (no JVM / server at view time).
export default defineConfig({
  site: 'https://click-game-studio.github.io',
  base: BASE,
  // Root-absolute content links (/features/..., /architecture/...) are made
  // base-aware at build time so they resolve under the GitHub Pages sub-path.
  markdown: {
    rehypePlugins: [[rehypeBaseLinks, { base: BASE }]],
  },
  integrations: [
    react(),
    starlight({
      title: 'Portal Kiến trúc VNRacing',
      description:
        'Sơ đồ C4 tương tác + thiết kế chi tiết (Low-Level Design) cho client game đua xe mobile VNRacing trên UE5.6.',
      // Versioned docs temporarily disabled during review stage.
      // Re-enable with: plugins: [starlightVersions({ versions: [{ slug: 'v1' }] })]
      plugins: [],
      // Pagefind full-text search is enabled by default on `astro build`.
      sidebar: [
        {
          label: 'Tổng quan',
          items: [
            { label: 'Bắt đầu tại đây', slug: 'index' },
            { label: 'Kiến trúc (sơ đồ tương tác)', slug: 'architecture' },
          ],
        },
        {
          label: 'Kiến trúc (arc42)',
          items: [
            { label: '01. Giới thiệu', slug: 'architecture/introduction' },
            { label: '02. System Context', slug: 'architecture/system-context' },
            { label: '03. Sơ đồ Container', slug: 'architecture/container-view' },
            { label: '04. Danh mục tính năng', slug: 'architecture/feature-catalog' },
            { label: '05. Sơ đồ Runtime', slug: 'architecture/runtime-view' },
            { label: '06. Chất lượng & Rủi ro', slug: 'architecture/quality-and-risks' },
            { label: '07. Quyết định & Liên kết', slug: 'architecture/decisions-and-links' },
          ],
        },
        // TEMP-HIDDEN (review stage)
        // {
        //   label: 'Tính năng (Thiết kế chi tiết)',
        //   items: [
        //     { label: 'Drive Mode — DM-PHYS Physics', slug: 'features/dm-phys' },
        //     { label: 'Drive Mode — DM-RACE Basic Racing', slug: 'features/dm-race' },
        //     { label: 'Drive Mode — DM-NOS NOS', slug: 'features/dm-nos' },
        //     { label: 'Drive Mode — DM-RAMP RAMP', slug: 'features/dm-ramp' },
        //     { label: 'Drive Mode — DM-CAM CAMERA', slug: 'features/dm-cam' },
        //     { label: 'Drive Mode — DM-SET SETTING', slug: 'features/dm-set' },
        //     { label: 'VNTour — VT-MAP Map Đua', slug: 'features/vt-map' },
        //     { label: 'VNTour — VT-CITY City Progression', slug: 'features/vt-city' },
        //     { label: 'VNTour — VT-TRACK Area-Track Unlock', slug: 'features/vt-track' },
        //     { label: 'VNTour — VT-CARPROG Car-Progression', slug: 'features/vt-carprog' },
        //     { label: 'VNTour — VT-REWARD Reward', slug: 'features/vt-reward' },
        //     { label: 'Game Mode — GM-MP MULTIPLAYER', slug: 'features/gm-mp' },
        //     { label: 'Game Mode — GM-DC DAILY CHALLENGE ❌', slug: 'features/gm-dc' },
        //     { label: 'Customize — CU-THEME Theme Change 🆕', slug: 'features/cu-theme' },
        //     { label: 'Customize — CU-ROOM Customize Room', slug: 'features/cu-room' },
        //     { label: 'Customize — CU-MENU Main menu (Theme Change)', slug: 'features/cu-menu' },
        //     { label: 'Customize — CU-VIS Car Customize Visual 🆕', slug: 'features/cu-vis' },
        //     { label: 'Customize — CU-PERF Car Customize Performance 🆕', slug: 'features/cu-perf' },
        //     { label: 'Customize — CU-SEL Car Selection 🆕', slug: 'features/cu-sel' },
        //     { label: 'CDN Content Download', slug: 'features/cdn' },
        //     { label: 'PC Project Config 🔧', slug: 'features/pc' },
        //   ],
        // },
        // {
        //   label: 'Shop & IAP 🆕',
        //   items: [
        //     { label: 'SH-DISP Shop Display 🆕', slug: 'features/sh-disp' },
        //     { label: 'SH-FLOW Purchase Flow 🆕', slug: 'features/sh-flow' },
        //   ],
        // },
        // {
        //   label: 'Hệ thống nền (Support — ngoài CSV)',
        //   items: [
        //     { label: 'SUP-AI Racer AI', slug: 'features/sup-ai' },
        //     { label: 'SUP-POOL Object Pooling', slug: 'features/sup-pool' },
        //     { label: 'SUP-INV Inventory', slug: 'features/sup-inv' },
        //     { label: 'SUP-PROF User Profile / Economy', slug: 'features/sup-prof' },
        //     { label: 'SUP-SHOP Shop / IAP / Ads', slug: 'features/sup-shop' },
        //     { label: 'SUP-TUT Tutorial / Onboarding', slug: 'features/sup-tut' },
        //     { label: 'SUP-DBG Debug & Track Test', slug: 'features/sup-dbg' },
        //     { label: 'SUP-PERF Performance & PSO', slug: 'features/sup-perf' },
        //   ],
        // },
        // {
        //   label: 'Quyết định (ADR)',
        //   items: [
        //     { label: 'ADR-0001 Chuyển cập nhật ranking ra khỏi Tick', slug: 'decisions/0001-ranking-update-off-tick' },
        //     { label: 'ADR-0002 Chế độ review Structurizr', slug: 'decisions/0002-canonical-structurizr-review-mode' },
        //   ],
        // },
      ],
    }),
    // MDX must come AFTER starlight so Starlight's internal expressive-code
    // integration is registered before MDX (Astro enforces this order).
    mdx(),
  ],
  vite: {
    plugins: [
      // Compile the copied LikeC4 model (specification.c4 + model.c4 + views.c4).
      LikeC4VitePlugin({
        workspace: './likec4',
        throwIfInvalid: true,
      }),
    ],
    server: {
      allowedHosts: ['.trycloudflare.com'],
    },
    preview: {
      allowedHosts: ['.trycloudflare.com'],
    },
  },
});
