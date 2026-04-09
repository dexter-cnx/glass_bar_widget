import fs from 'node:fs';
import path from 'node:path';
import { chromium } from 'playwright';

const outDir = path.resolve('docs/media');
const framesDir = path.join(outDir, 'frames');
fs.mkdirSync(framesDir, { recursive: true });

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1440, height: 1024 }, deviceScaleFactor: 1 });

await page.goto('http://127.0.0.1:8080', { waitUntil: 'networkidle' });
await page.waitForTimeout(2500);

await page.screenshot({ path: path.join(outDir, 'glass_bar_demo.png'), fullPage: true });

// Frame sequence for GIF. Flutter web is canvas-based, so use stable click coordinates.
const clicks = [
  { x: 540, y: 940 },
  { x: 720, y: 940 },
  { x: 900, y: 940 },
  { x: 720, y: 940 },
  { x: 540, y: 940 },
];

let frame = 0;
for (const click of clicks) {
  await page.mouse.click(click.x, click.y);
  for (let i = 0; i < 5; i += 1) {
    await page.waitForTimeout(140);
    const frameName = `frame_${String(frame).padStart(3, '0')}.png`;
    await page.screenshot({ path: path.join(framesDir, frameName) });
    frame += 1;
  }
}

await browser.close();
