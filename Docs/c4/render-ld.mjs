// Render every Docs/ld/*.md to a standalone HTML page in Docs/c4/public/ld/.
// Standalone = UTF-8 + minimal readable CSS so the LD opens cleanly from the
// LikeC4 static site's public dir (link target). No SPA routing involved —
// these are plain files copied verbatim into dist/ld/ by --public-dir.
import { readdirSync, readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join, basename } from 'node:path';
import { fileURLToPath } from 'node:url';
import { marked } from 'marked';

const here = dirname(fileURLToPath(import.meta.url));
const srcDir = join(here, '..', 'ld');           // Docs/ld
const outDir = join(here, 'public', 'ld');       // Docs/c4/public/ld
mkdirSync(outDir, { recursive: true });

const css = `
:root{color-scheme:light dark}
body{max-width:920px;margin:0 auto;padding:2rem 1.25rem;
  font:16px/1.6 -apple-system,Segoe UI,Roboto,sans-serif;
  background:#0d1117;color:#c9d1d9}
a{color:#58a6ff}
h1,h2,h3{line-height:1.25;margin-top:1.6em;border-bottom:1px solid #30363d;padding-bottom:.3em}
code{background:#161b22;padding:.15em .4em;border-radius:4px;font-size:.9em}
pre{background:#161b22;padding:1rem;border-radius:8px;overflow:auto}
pre code{background:none;padding:0}
table{border-collapse:collapse;width:100%;margin:1em 0}
th,td{border:1px solid #30363d;padding:.5em .75em;text-align:left}
th{background:#161b22}
blockquote{border-left:3px solid #30363d;margin:0;padding-left:1em;color:#8b949e}
`;

let n = 0;
for (const f of readdirSync(srcDir).filter(f => f.endsWith('.md'))) {
  const md = readFileSync(join(srcDir, f), 'utf8');
  const title = (md.match(/^#\s+(.+)$/m)?.[1] ?? basename(f, '.md')).trim();
  const html = `<!doctype html><html lang="vi"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>${title}</title><style>${css}</style></head>
<body>${marked.parse(md)}</body></html>`;
  writeFileSync(join(outDir, basename(f, '.md') + '.html'), html, 'utf8');
  n++;
}
console.log(`rendered ${n} LD file(s) -> ${outDir}`);
