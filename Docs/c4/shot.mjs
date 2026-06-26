import puppeteer from 'file:///c:/Users/phtan/AppData/Local/npm-cache/_npx/ab5cd9f6d13a2312/node_modules/puppeteer-core/lib/esm/puppeteer/puppeteer-core.js';
const BASE = process.env.BASE || 'http://127.0.0.1:42777';
const CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const sleep = ms => new Promise(r=>setTimeout(r,ms));
let browser;
try {
  browser = await puppeteer.launch({ executablePath: CHROME, headless: 'new', args:['--no-sandbox','--disable-dev-shm-usage','--window-size=1600,1000'] });
  const page = await browser.newPage();
  await page.setViewport({width:1600,height:1000});

  // 1) landing
  await page.goto(BASE, {waitUntil:'networkidle0', timeout:30000});
  await sleep(1500);
  await page.screenshot({path:'shot_landing.png'});

  // 2) go straight to f02 view via hash route
  await page.goto(BASE + '/#/view/f02', {waitUntil:'networkidle0', timeout:30000});
  await sleep(1800);
  await page.screenshot({path:'shot_f02.png'});

  // 3) enumerate all clickable chrome (buttons/links with labels)
  const chrome = await page.evaluate(() => {
    const out = [];
    document.querySelectorAll('button,[role=button],a,[aria-label],[title]').forEach(el=>{
      const label = el.getAttribute('aria-label') || el.getAttribute('title') || (el.textContent||'').trim().slice(0,40);
      if (label) out.push((el.tagName.toLowerCase()) + ': ' + label);
    });
    return [...new Set(out)];
  });
  console.log('--- UI chrome (buttons/links/labelled) on f02 view ---');
  console.log(chrome.join('\n'));

  // 4) try clicking the center node (subject) then screenshot to see if details/toolbar appears
  const box = await page.evaluate(() => {
    // react-flow nodes
    const n = document.querySelector('.react-flow__node');
    if (!n) return null;
    const r = n.getBoundingClientRect();
    return {x:r.x+r.width/2, y:r.y+r.height/2, count: document.querySelectorAll('.react-flow__node').length};
  });
  console.log('--- node info ---', JSON.stringify(box));
  if (box) {
    await page.mouse.click(box.x, box.y);
    await sleep(1200);
    await page.screenshot({path:'shot_f02_clicked.png'});
    const after = await page.evaluate(()=>{
      const out=[];
      document.querySelectorAll('button,[role=button],a[href]').forEach(el=>{
        const label = el.getAttribute('aria-label')||el.getAttribute('title')||(el.textContent||'').trim().slice(0,40);
        const href = el.getAttribute('href')||'';
        if(label||href) out.push(el.tagName.toLowerCase()+': '+label+(href?(' [href='+href+']'):''));
      });
      return [...new Set(out)];
    });
    console.log('--- chrome AFTER clicking node ---');
    console.log(after.join('\n'));
  }
  await browser.close();
} catch(e){ console.error('ERR', e.message); if(browser) await browser.close(); process.exit(1);}
