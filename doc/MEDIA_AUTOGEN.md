# Media auto-generation

This repository includes media tooling for generating:

- `doc/media/glass_bar_demo.png`
- `doc/media/glass_bar_demo.gif`

## How it works

1. Build the Android example app.
2. Boot an Android emulator with `adb` access.
3. Install and launch the app on the emulator.
4. Capture frames directly from the emulator screen with `adb shell screencap -p` plus `adb pull`.
5. Use `ffmpeg` to convert the frames into a GIF.
6. Save the generated assets in `doc/media/`.

## Local run

For the web demo, use the browser capture tool:

```bash
make media-web-browser
```

In interactive mode:

- press `Space` to capture the current frame
- press `Esc` to finish and build the GIF

For the Android example:

The Android-emulator capture script expects an Android emulator with `adb` access.
In interactive mode, it uses the same key workflow:

- press `Space` to capture the current frame
- press `Esc` to finish and build the GIF

```sh
bash tool/media/capture_android_emulator.sh
```

## Notes

- If the emulator image or app layout changes, adjust the tap percentages in `tool/media/capture_android_emulator.sh`.
- Regenerated media is not currently automated in GitHub Actions.
