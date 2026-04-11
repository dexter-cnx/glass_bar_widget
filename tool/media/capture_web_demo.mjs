import fs from 'node:fs';
import { execFileSync } from 'node:child_process';
import path from 'node:path';
import { chromium } from 'playwright';

const outDir = path.resolve('doc/media');
const framesDir = path.join(outDir, 'frames');
const demoUrl = process.env.DEMO_URL ?? 'http://127.0.0.1:8080';
const headless = (process.env.HEADLESS ?? 'false').toLowerCase() === 'true';
const manual = (process.env.MANUAL ?? 'true').toLowerCase() !== 'false';
const appMode = (process.env.APP_MODE ?? 'true').toLowerCase() !== 'false';
const maxFrames = Number(process.env.MAX_FRAMES ?? 30);
const autoGif = (process.env.AUTO_GIF ?? 'true').toLowerCase() !== 'false';
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
let stopRequested = false;
let isCapturing = false;
let finishRequested = false;
const canReadTerminalKeys = process.stdin.isTTY;

async function captureFrame() {
  if (stopRequested || isCapturing || frame >= maxFrames) {
    return;
  }
  isCapturing = true;
  try {
    await page.waitForTimeout(180);
    const frameName = `frame_${String(frame).padStart(3, '0')}.png`;
    await page.screenshot({ path: path.join(framesDir, frameName) });
    frame += 1;
    console.log(`Captured ${frameName}`);
  } finally {
    isCapturing = false;
  }
}

function requestStop(reason) {
  if (stopRequested) {
    return;
  }
  stopRequested = true;
  console.log(`Stopping capture (${reason}).`);
}

function requestFinish(reason) {
  if (finishRequested) {
    return;
  }
  finishRequested = true;
  requestStop(reason);
}

if (manual) {
  if (!canReadTerminalKeys) {
    console.log('stdin is not a TTY; falling back to automated capture mode.');
  }
}

if (manual && canReadTerminalKeys) {
  console.log('Interactive capture mode is on.');
  console.log('Press Space to record a frame.');
  console.log('Press Esc to finish and build the GIF.');
  console.log(`Frames will be written to ${framesDir}`);
  console.log('You can press keys in this terminal or while the browser window is focused.');

  await page.exposeFunction('recordCaptureFrame', async () => {
    await captureFrame();
  });
  await page.exposeFunction('finishCapture', async () => {
    requestFinish('escape key');
  });

  await page.evaluate(() => {
    document.addEventListener(
      'keydown',
      (event) => {
        if (event.code === 'Space') {
          event.preventDefault();
          // @ts-ignore
          globalThis.recordCaptureFrame();
        }
        if (event.code === 'Escape') {
          event.preventDefault();
          // @ts-ignore
          globalThis.finishCapture();
        }
      },
      true,
    );
  });

  process.stdin.setRawMode(true);
  process.stdin.resume();
  process.stdin.on('data', async (chunk) => {
    if (stopRequested) {
      return;
    }
    if (chunk.length === 1 && chunk[0] === 32) {
      await captureFrame();
      return;
    }
    if (chunk.length === 1 && chunk[0] === 27) {
      requestFinish('escape key');
      return;
    }
    if (chunk.length === 1 && chunk[0] === 3) {
      requestFinish('ctrl+c');
    }
  });

  while (!stopRequested && frame < maxFrames) {
    await page.waitForTimeout(250);
  }
  process.stdin.setRawMode(false);
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

if (autoGif) {
  const hasFrames = frame > 0;
  if (hasFrames) {
    console.log('Building GIF from captured frames...');
    execFileSync('bash', ['tool/media/make_demo_gif.sh'], { stdio: 'inherit' });
  } else {
    console.log('No frames captured, skipping GIF build.');
  }
}

if (finishRequested) {
  console.log('Capture finished.');
}
