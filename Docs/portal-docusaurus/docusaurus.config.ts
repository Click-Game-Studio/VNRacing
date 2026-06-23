import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

// SPIKE: Docusaurus alternative to the Astro/Starlight + LikeC4 portal.
// Goal of this branch (docs/versioned-c4-spike): compare native doc versioning
// + build-time static C4 diagrams (instant load) against the current client-side
// LikeC4 engine (~2.3 MB, slow first paint). Served under /VNRacing like the
// existing portal so both can deploy to the same GitHub Pages project site.
const config: Config = {
  title: 'Portal Kiến trúc VNRacing (Docusaurus spike)',
  tagline:
    'Sơ đồ C4 tĩnh (render tại build) + thiết kế chi tiết, có versioning native — client game đua xe mobile VNRacing trên UE5.6.',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://click-game-studio.github.io',
  baseUrl: '/VNRacing/',

  organizationName: 'click-game-studio',
  projectName: 'VNRacing',

  // Spike: don't fail the build on legacy root-absolute cross-links while we
  // evaluate. Tighten to 'throw' if this stack is chosen.
  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'vi',
    locales: ['vi'],
  },

  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          // Serve docs at the site root (no /docs prefix) to mirror the
          // Starlight portal's URLs (/architecture, /features/dm-phys, ...).
          routeBasePath: '/',
          // Native versioning: the hard requirement. Lets readers see how the
          // architecture (incl. diagrams) changed across releases.
          // v1.0 is the released default (served at root); 'current' is the
          // in-progress working copy, served under /next.
          lastVersion: 'v1.0',
          versions: {
            current: {
              label: 'Đang phát triển (next)',
              path: 'next',
            },
          },
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'VNRacing',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Tài liệu',
        },
        // Native version dropdown — the feature this spike is evaluating.
        {
          type: 'docsVersionDropdown',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      copyright: `Portal Kiến trúc VNRacing · Docusaurus spike (nhánh docs/versioned-c4-spike).`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
