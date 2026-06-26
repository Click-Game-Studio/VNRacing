// Rehype plugin: make root-absolute internal links base-aware.
//
// Markdown/MDX content links are authored as site-root absolute paths, e.g.
// `/features/dm-phys`, `/architecture/`. When the site is served from a
// sub-path (GitHub Pages: https://<org>.github.io/VNRacing/), those links must
// be prefixed with the configured `base` or they 404. Starlight rewrites its
// own nav/sidebar links, but NOT raw links inside authored content — this
// plugin closes that gap in one place instead of editing every file.
//
// Only rewrites hrefs that:
//   - start with a single '/' (root-absolute), AND
//   - are not protocol-relative ('//...'), AND
//   - are not already prefixed with base.
// External URLs, anchors (#...), and relative links are left untouched.
import { visit } from 'unist-util-visit';

/** @param {{ base?: string }} [options] */
export default function rehypeBaseLinks(options = {}) {
  const rawBase = options.base ?? '/';
  const base = rawBase.endsWith('/') ? rawBase.slice(0, -1) : rawBase;

  // No base (served from root) → nothing to do.
  if (base === '') return () => {};

  return (tree) => {
    visit(tree, 'element', (node) => {
      if (node.tagName !== 'a') return;
      const href = node.properties?.href;
      if (typeof href !== 'string') return;
      if (!href.startsWith('/')) return; // relative / anchor / external
      if (href.startsWith('//')) return; // protocol-relative
      if (href === base || href.startsWith(base + '/')) return; // already based

      node.properties.href = base + href;
    });
  };
}
