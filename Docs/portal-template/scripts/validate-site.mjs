import assert from 'node:assert/strict';
import { access, mkdir, mkdtemp, readFile, readdir, rm, stat, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dist = path.join(root, 'dist');
const rawBase = process.env.BASE_PATH || '/';
const base = rawBase === '/' ? '/' : `/${rawBase.replace(/^\/+|\/+$/g, '')}`;
const requiredRoutes = [
  '/',
  '/architecture/',
  '/features/example-feature/',
  '/decisions/0001-static-documentation/',
  '/v1/',
  '/v1/architecture/',
  '/v1/features/example-feature/',
  '/v1/decisions/0001-static-documentation/',
  '/preview/',
  '/preview/architecture/',
  '/preview/features/example-feature/',
  '/preview/decisions/0001-static-documentation/',
];
const failures = [];

async function exists(file) {
  try {
    await access(file);
    return true;
  } catch {
    return false;
  }
}

async function filesUnder(directory) {
  const entries = await readdir(directory, { withFileTypes: true });
  const nested = await Promise.all(entries.map((entry) => {
    const target = path.join(directory, entry.name);
    return entry.isDirectory() ? filesUnder(target) : [target];
  }));
  return nested.flat();
}

function outputPath(route) {
  const clean = route.replace(/^\/+|\/+$/g, '');
  return path.join(dist, clean, 'index.html');
}

function stripBase(pathname) {
  if (base === '/') return pathname;
  if (pathname === base) return '/';
  if (pathname.startsWith(`${base}/`)) return pathname.slice(base.length);
  return null;
}

async function isFile(file) {
  try {
    return (await stat(file)).isFile();
  } catch {
    return false;
  }
}

async function resolveOutput(pathname, outputDirectory = dist, deploymentBase = base) {
  const local = deploymentBase === '/'
    ? pathname
    : pathname === deploymentBase
      ? '/'
      : pathname.startsWith(`${deploymentBase}/`)
        ? pathname.slice(deploymentBase.length)
        : null;
  if (local === null) return null;
  let decoded;
  try {
    decoded = decodeURIComponent(local);
  } catch {
    return null;
  }
  const safe = path.normalize(decoded).replace(/^(\.\.(?:[\\/]|$))+/, '');
  const direct = path.join(outputDirectory, safe);
  const candidates = pathname.endsWith('/')
    ? [path.join(direct, 'index.html')]
    : [direct, `${direct}.html`, path.join(direct, 'index.html')];
  for (const candidate of candidates) if (await isFile(candidate)) return candidate;
  return null;
}

function attributes(html, name) {
  const pattern = new RegExp(`\\b${name}\\s*=\\s*(?:"([^"]*)"|'([^']*)')`, 'gi');
  return [...html.matchAll(pattern)].map((match) => match[1] ?? match[2]);
}

function ids(html) {
  return new Set(attributes(html, 'id'));
}

async function fragmentExists(targetFile, fragment) {
  return ids(await readFile(targetFile, 'utf8')).has(fragment);
}

async function runSelfCheck() {
  const fixture = await mkdtemp(path.join(tmpdir(), 'docs-validator-'));
  try {
    const routeDirectory = path.join(fixture, 'guide');
    await mkdir(routeDirectory);
    await writeFile(path.join(routeDirectory, 'index.html'), '<main id="valid-fragment"></main>');

    const target = await resolveOutput('/guide/', fixture, '/');
    assert.equal(target, path.join(routeDirectory, 'index.html'), 'pretty route must resolve to index.html');
    assert.equal(await fragmentExists(target, 'valid-fragment'), true, 'existing fragment must pass');
    assert.equal(await fragmentExists(target, 'missing-fragment'), false, 'missing fragment must fail');
    console.log('Validator self-check passed: pretty route fragments accept existing IDs and reject missing IDs');
  } finally {
    await rm(fixture, { recursive: true, force: true });
  }
}

await runSelfCheck();

if (!process.argv.includes('--self-check')) {
for (const route of requiredRoutes) {
  if (!(await exists(outputPath(route)))) failures.push(`Missing required route: ${route}`);
}

const pagefind = path.join(dist, 'pagefind', 'pagefind.js');
if (!(await exists(pagefind))) failures.push('Missing Pagefind search entry: dist/pagefind/pagefind.js');

if (await exists(dist)) {
  const htmlFiles = (await filesUnder(dist)).filter((file) => file.endsWith('.html'));
  for (const source of htmlFiles) {
    const html = await readFile(source, 'utf8');
    const sourceRoute = `/${path.relative(dist, source).replaceAll('\\', '/').replace(/index\.html$/, '')}`;
    const targets = [...attributes(html, 'href'), ...attributes(html, 'src')];

    for (const rawTarget of targets) {
      if (!rawTarget || rawTarget.startsWith('//')) continue;
      if (/^[a-z][a-z\d+.-]*:/i.test(rawTarget)) continue;

      let url;
      try {
        url = new URL(rawTarget, `https://validator.invalid${base === '/' ? '' : base}${sourceRoute}`);
      } catch {
        failures.push(`${sourceRoute}: malformed local target ${rawTarget}`);
        continue;
      }
      if (url.origin !== 'https://validator.invalid') continue;
      if (rawTarget.startsWith('/') && stripBase(url.pathname) === null) {
        failures.push(`${sourceRoute}: root-absolute target escapes BASE_PATH ${rawTarget}`);
        continue;
      }

      const targetFile = await resolveOutput(url.pathname);
      if (!targetFile) {
        failures.push(`${sourceRoute}: missing local target ${rawTarget}`);
        continue;
      }
      if (url.hash && targetFile.endsWith('.html')) {
        const targetHtml = targetFile === source ? html : await readFile(targetFile, 'utf8');
        let fragment;
        try {
          fragment = decodeURIComponent(url.hash.slice(1));
        } catch {
          failures.push(`${sourceRoute}: malformed fragment ${rawTarget}`);
          continue;
        }
        if (fragment && !ids(targetHtml).has(fragment)) {
          failures.push(`${sourceRoute}: missing fragment target ${rawTarget}`);
        }
      }
    }
  }
}

if (failures.length) {
  console.error(`Generated-site validation failed (${failures.length}):`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exitCode = 1;
} else {
  console.log(`Validated ${requiredRoutes.length} routes, Pagefind, local links, assets, and fragments for BASE_PATH=${base}`);
}
}
