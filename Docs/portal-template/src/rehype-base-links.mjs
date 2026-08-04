/** Prefix root-absolute authored links with Astro's deployment base. */
export default function rehypeBaseLinks({ base = '/' } = {}) {
  const prefix = base === '/' ? '' : base.replace(/\/$/, '');
  if (!prefix) return () => {};

  return (tree) => {
    const visit = (node) => {
      if (node?.type === 'element' && node.tagName === 'a') {
        const href = node.properties?.href;
        if (
          typeof href === 'string' &&
          href.startsWith('/') &&
          !href.startsWith('//') &&
          href !== prefix &&
          !href.startsWith(`${prefix}/`)
        ) {
          node.properties.href = `${prefix}${href}`;
        }
      }
      for (const child of node?.children ?? []) visit(child);
    };
    visit(tree);
  };
}
