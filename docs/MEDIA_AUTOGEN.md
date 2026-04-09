# Media auto-generation

This repository includes a workflow that automatically builds the Android example app and generates:

- `docs/media/glass_bar_demo.png`
- `docs/media/glass_bar_demo.gif`

## How it works

1. Build the Android example app.
2. Boot an Android emulator automatically in the workflow.
3. Install and launch the app on the emulator.
4. Capture frames directly from the emulator screen with `adb exec-out screencap -p`.
5. Use `ffmpeg` to convert the frames into a GIF.
6. Upload artifacts and commit refreshed media back to the repository.

## Trigger

- Automatic on pushes that touch `lib/`, `example/`, media tooling, or the workflow itself.
- Manual via **Actions → media-assets → Run workflow**.

## Local run

The Android-emulator capture script expects an Android emulator with `adb` access.

```sh
bash tool/media/capture_android_emulator.sh
```

## Notes

- If the emulator image or app layout changes, adjust the tap percentages in `tool/media/capture_android_emulator.sh`.
- The workflow commits regenerated media only when the files actually change.
