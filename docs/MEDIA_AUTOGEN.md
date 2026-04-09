# Media auto-generation

This repository includes a workflow that automatically builds the Flutter web demo and generates:

- `docs/media/glass_bar_demo.png`
- `docs/media/glass_bar_demo.gif`

## How it works

1. Build `example/` for Flutter Web.
2. Serve the generated site locally in GitHub Actions.
3. Use Playwright to open the demo, take a screenshot, and capture a short frame sequence.
4. Use `ffmpeg` to convert the frames into a GIF.
5. Upload artifacts and commit refreshed media back to the repository.

## Trigger

- Automatic on pushes that touch `lib/`, `example/`, media tooling, or the workflow itself.
- Manual via **Actions → media-assets → Run workflow**.

## Notes

- The click coordinates in `tool/media/capture_web_demo.mjs` are tuned for the included example app.
- If the example layout changes significantly, update those coordinates.
- The workflow commits regenerated media only when the files actually change.
