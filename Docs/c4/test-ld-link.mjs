// Headless test: open the dmRace view, click the DM-RACE node to open the details
// panel, and read the REAL href of every link rendered there. This answers
// the only open question: does the in-app LD link use a relative path (good)
// or an absolute file:// path (bad / breaks on deploy)?
import puppeteer from 'file:///c:/Users/phtan/AppData/Local/npm-cache/_npx/ab5cd9f6d13a2312/node_modules/puppeteer-core/lib/esm/puppeteer/puppeteer-core.js';

const BASE = process.env.BASE || 'http://127.0.0.1:42777';
const CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const log = (...a) => console.log(...a);

let browser;
try {
  browser = await puppeteer.launch({
    executablePath: CHROME,
    headless: 'new',
    args: ['--no-sandbox', '--disable-dev-shm-usage'],
  });
  const page = await browser.newPage();
  const failed = [];
  page.on('requestfailed', (r) => failed.push(r.url()));

  // Go straight to the dmRace component view (hash history route).
  await page.goto(`${BASE}/#/view/dmRace`, { waitUntil: 'networkidle0' });
  await new Promise((r) => setTimeout(r, 1500));

  // Click the DM-RACE node inside the diagram to open the details panel.
  // LikeC4 nodes carry data-likec4-id; the feature node id is "dmRace".
  const clicked = await page.evaluate(() => {
    const candidates = Array.from(
      document.querySelectorAll('[data-likec4-id]')
    );
    const node = candidates.find(
      (el) => el.getAttribute('data-likec4-id') === 'dmRace'
    );
    if (node) {
      node.dispatchEvent(
        new MouseEvent('click', { bubbles: true, cancelable: true })
      );
      return true;
    }
    return false;
  });
  await new Promise((r) => setTimeout(r, 1200));

  // Some LikeC4 builds open details on double-click; try that too.
  await page.evaluate(() => {
    const node = Array.from(
      document.querySelectorAll('[data-likec4-id]')
    ).find((el) => el.getAttribute('data-likec4-id') === 'dmRace');
    if (node)
      node.dispatchEvent(
        new MouseEvent('dblclick', { bubbles: true, cancelable: true })
      );
  });
  await new Promise((r) => setTimeout(r, 1200));

  // Collect every anchor href anywhere in the document that points at the LD.
  const hrefs = await page.evaluate(() =>
    Array.from(document.querySelectorAll('a'))
      .map((a) => a.getAttribute('href'))
      .filter((h) => h && h.toLowerCase().includes('dm-race_basic_racing'))
  );

  log('node dmRace click dispatched:', clicked);
  log('LD anchors found in DOM   :', JSON.stringify(hrefs));
  log('any absolute file:// href :', hrefs.some((h) => h.startsWith('file:')));
  log('failed requests           :', failed.length ? failed.join(', ') : 'none');
} catch (e) {
  log('ERROR:', e.message);
} finally {
  if (browser) await browser.close();
}
