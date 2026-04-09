import fs from 'node:fs';
import path from 'node:path';
import { chromium } from 'playwright';

const outDir = path.resolve('docs/media');
const framesDir = path.join(outDir, 'frames');
const demoUrl = process.env.DEMO_URL ?? 'http://127.0.0.1:8080';
const headless = (process.env.HEADLESS ?? 'false').toLowerCase() === 'true';
const manual = (process.env.MANUAL ?? 'true').toLowerCase() !== 'false';
const appMode = (process.env.APP_MODE ?? 'true').toLowerCase() !== 'false';
const maxFrames = Number(process.env.MAX_FRAMES ?? 30);
const viewport = { width: 390, height: 844 };
fs.mkdirSync(framesDir, { recursive: true });

try {
  const response = await fetch(demoUrl, { method: 'HEAD' });
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}`);
  }
} catch (error) {
  console.error(`Unable to reach the demo at ${demoUrl}.`);
  console.error('Start the Flutter web demo first, for example:');
  console.error('  cd example');
  console.error('  flutter build web --release');
  console.error('  python3 -m http.server 8080 --directory build/web');
  console.error(`Details: ${error instanceof Error ? error.message : String(error)}`);
  process.exit(1);
}

const browser = await chromium.launch({
  headless,
  args: headless
    ? []
    : [
        `--window-size=${viewport.width},${viewport.height}`,
        ...(appMode ? [`--app=${demoUrl}`] : []),
      ],
});
const context = await browser.newContext({
  viewport,
  deviceScaleFactor: 3,
  isMobile: true,
  hasTouch: true,
});
const page = await context.newPage();

await page.goto(demoUrl, { waitUntil: 'networkidle' });
await page.waitForTimeout(2500);

await page.screenshot({ path: path.join(outDir, 'glass_bar_demo.png'), fullPage: true });

let frame = 0;
if (manual) {
  console.log('Interactive capture mode is on.');
  console.log('Click buttons in the browser to record frames.');
  console.log(`Frames will be written to ${framesDir}`);
  console.log('Press Enter in this terminal to stop recording.');

  let stop = false;
  process.stdin.setEncoding('utf8');
  process.stdin.resume();
  process.stdin.once('data', () => {
    stop = true;
  });

  await page.exposeFunction('recordCaptureFrame', async () => {
    if (stop || frame >= maxFrames) {
      return;
    }
    await page.waitForTimeout(180);
    const frameName = `frame_${String(frame).padStart(3, '0')}.png`;
    await page.screenshot({ path: path.join(framesDir, frameName) });
    frame += 1;
    console.log(`Captured ${frameName}`);
  });

  await page.evaluate(() => {
    document.addEventListener(
      'click',
      () => {
        // @ts-ignore
        globalThis.recordCaptureFrame();
      },
      true,
    );
  });

  while (!stop && frame < maxFrames) {
    await page.waitForTimeout(250);
  }
  process.stdin.pause();
} else {
  // Fallback automated sequence for non-interactive runs.
  const clicks = [
    { x: 540, y: 940 },
    { x: 720, y: 940 },
    { x: 900, y: 940 },
    { x: 720, y: 940 },
    { x: 540, y: 940 },
  ];

  for (const click of clicks) {
    await page.mouse.click(click.x, click.y);
    for (let i = 0; i < 5; i += 1) {
      await page.waitForTimeout(140);
      const frameName = `frame_${String(frame).padStart(3, '0')}.png`;
      await page.screenshot({ path: path.join(framesDir, frameName) });
      frame += 1;
    }
  }
}

await browser.close();
