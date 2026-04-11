# Web Demo Setup

## GitHub Pages

1. Push this repository to GitHub.
2. Open repository settings.
3. Go to **Pages**.
4. Set source to **GitHub Actions**.
5. Push to the default branch.
6. Wait for the `Web Demo` workflow to finish.

## Base href

The current workflow uses:

```bash
--base-href /glass_bar_widget/
```

If your repository name is different, update `.github/workflows/web-demo.yml`.

## Browser screenshot capture

After serving the built web demo locally, you can capture screenshots with:

```bash
make media-web-browser
```

The Playwright script (`tool/media/capture_web_demo.mjs`) now uses a manual key-driven workflow:
- press `Space` to capture the current frame
- press `Esc` to finish and build the GIF

It outputs:
- `doc/media/glass_bar_demo.png`
- interaction frames under `doc/media/frames/`
- `doc/media/glass_bar_demo.gif`

Useful environment variables:
- `DEMO_URL` (default: `http://127.0.0.1:8080`)
- `MANUAL` (`true`/`false`)
- `HEADLESS` (`true`/`false`)
- `MAX_FRAMES` (default: `30`)
- `AUTO_GIF` (`true`/`false`)
