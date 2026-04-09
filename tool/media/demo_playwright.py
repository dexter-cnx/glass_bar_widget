import os
from pathlib import Path

try:
    from playwright.sync_api import sync_playwright
except ImportError as exc:
    raise SystemExit(
        "Python Playwright is not installed.\n"
        "Install it with:\n"
        "  python3 -m pip install playwright\n"
        "  python3 -m playwright install\n"
        "Or use the repo's Node script instead:\n"
        "  node tool/media/capture_web_demo.mjs"
    ) from exc


OUT_DIR = Path("docs/media")
FRAMES_DIR = OUT_DIR / "frames"
DEMO_URL = os.environ.get("DEMO_URL", "http://127.0.0.1:8080")
HEADLESS = os.environ.get("HEADLESS", "false").lower() in {"1", "true", "yes"}
MANUAL = os.environ.get("MANUAL", "true").lower() not in {"0", "false", "no"}
APP_MODE = os.environ.get("APP_MODE", "true").lower() not in {"0", "false", "no"}
MAX_FRAMES = int(os.environ.get("MAX_FRAMES", "30"))
VIEWPORT = {"width": 390, "height": 844}


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    FRAMES_DIR.mkdir(parents=True, exist_ok=True)

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(
            headless=HEADLESS,
            args=[]
            if HEADLESS
            else [
                f"--window-size={VIEWPORT['width']},{VIEWPORT['height']}",
                *([f"--app={DEMO_URL}"] if APP_MODE else []),
            ],
        )
        context = browser.new_context(
            viewport=VIEWPORT,
            device_scale_factor=3,
            is_mobile=True,
            has_touch=True,
        )
        page = context.new_page()

        try:
            page.goto(DEMO_URL, wait_until="networkidle")
        except Exception as exc:
            browser.close()
            raise SystemExit(
                f"Unable to reach the demo at {DEMO_URL}.\n"
                "Start the Flutter web demo first, for example:\n"
                "  cd example\n"
                "  flutter build web --release\n"
                "  python3 -m http.server 8080 --directory build/web"
            ) from exc

        page.wait_for_timeout(2500)
        page.screenshot(path=str(OUT_DIR / "glass_bar_demo.png"), full_page=True)

        frame = 0
        if MANUAL:
            print("Interactive capture mode is on.")
            print("Click buttons in the browser to record frames.")
            print(f"Frames will be written to {FRAMES_DIR}")
            print("Press Enter in this terminal to stop recording.")

            stop = {"value": False}

            def record_capture_frame() -> None:
                nonlocal frame
                if stop["value"] or frame >= MAX_FRAMES:
                    return
                page.wait_for_timeout(180)
                frame_name = f"frame_{frame:03d}.png"
                page.screenshot(path=str(FRAMES_DIR / frame_name))
                frame += 1
                print(f"Captured {frame_name}")

            page.expose_function("recordCaptureFrame", record_capture_frame)
            page.evaluate(
                """
                () => {
                  document.addEventListener(
                    'click',
                    () => {
                      globalThis.recordCaptureFrame();
                    },
                    true,
                  );
                }
                """
            )

            try:
                input()
            finally:
                stop["value"] = True
        else:
            clicks = [
                {"x": 540, "y": 940},
                {"x": 720, "y": 940},
                {"x": 900, "y": 940},
                {"x": 720, "y": 940},
                {"x": 540, "y": 940},
            ]

            for click in clicks:
                page.mouse.click(click["x"], click["y"])
                for _ in range(5):
                    page.wait_for_timeout(140)
                    frame_name = f"frame_{frame:03d}.png"
                    page.screenshot(path=str(FRAMES_DIR / frame_name))
                    frame += 1

        context.close()
        browser.close()

        print(f"Screenshot saved to {OUT_DIR / 'glass_bar_demo.png'}")
        print(f"Frames saved to {FRAMES_DIR}")


if __name__ == "__main__":
    main()
