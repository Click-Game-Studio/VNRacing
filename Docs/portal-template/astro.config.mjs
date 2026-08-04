// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import react from '@astrojs/react';
import starlight from '@astrojs/starlight';
import { LikeC4VitePlugin } from 'likec4/vite-plugin';
import starlightVersions from 'starlight-versions';
import rehypeBaseLinks from './src/rehype-base-links.mjs';

const site = process.env.SITE_URL || 'http://localhost:4321';
const rawBase = process.env.BASE_PATH || '/';
const base = rawBase === '/' ? '/' : `/${rawBase.replace(/^\/+|\/+$/g, '')}`;

const sidebar = [
  {
    label: 'Guide',
    items: [
      { label: 'Overview', slug: 'index' },
      { label: 'Architecture', slug: 'architecture' },
      { label: 'Example feature', slug: 'features/example-feature' },
      { label: 'ADR 0001', slug: 'decisions/0001-static-documentation' },
    ],
  },
];

export default defineConfig({
  site,
  base,
  output: 'static',
  markdown: { rehypePlugins: [[rehypeBaseLinks, { base }]] },
  integrations: [
    react(),
    starlight({
      title: 'Project Docs',
      description: 'Reusable versioned documentation portal template.',
      sidebar,
      plugins: [
        starlightVersions({
          current: { label: 'Latest' },
          versions: [
            { slug: 'v1', label: 'v1' },
            { slug: 'preview', label: 'Preview' },
          ],
        }),
      ],
    }),
    mdx(),
  ],
  vite: {
    plugins: [
      LikeC4VitePlugin({
        workspace: './likec4',
        throwIfInvalid: true,
      }),
    ],
  },
});
