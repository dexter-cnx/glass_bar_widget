#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

OUT_DIR="docs/media"
FRAMES_DIR="$OUT_DIR/frames"
APK_PATH="example/build/app/outputs/flutter-apk/app-debug.apk"
PACKAGE_NAME="${PACKAGE_NAME:-com.example.glass_bar_example}"
ACTIVITY_NAME="${ACTIVITY_NAME:-.MainActivity}"
SCREENSHOT_DELAY_MS="${SCREENSHOT_DELAY_MS:-180}"
FRAME_PAUSE_MS="${FRAME_PAUSE_MS:-900}"
SKIP_BUILD_INSTALL="${SKIP_BUILD_INSTALL:-false}"
START_DELAY_SECONDS="${START_DELAY_SECONDS:-10}"

mkdir -p "$FRAMES_DIR"
find "$FRAMES_DIR" -maxdepth 1 -type f -name 'frame_*.png' -delete

log() {
  printf '%s\n' "$*"
}

wait_for_boot() {
  adb wait-for-device
  until [ "$(adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; do
    sleep 1
  done
}

screen_size() {
  local raw_size size
  raw_size="$(adb shell wm size | tr -d '\r')"
  size="$(printf '%s\n' "$raw_size" | sed -n 's/^Physical size: //p')"
  if [ -z "$size" ]; then
    printf 'Unable to read emulator screen size.\n' >&2
    exit 1
  fi
  printf '%s\n' "$size"
}

screen_width() {
  screen_size | cut -dx -f1
}

screen_height() {
  screen_size | cut -dx -f2
}

tap_pct() {
  local x_pct="$1"
  local y_pct="$2"
  local width height x y
  width="$(screen_width)"
  height="$(screen_height)"
  x=$((width * x_pct / 100))
  y=$((height * y_pct / 100))
  adb shell input tap "$x" "$y" >/dev/null
}

capture_frame() {
  local frame_index="$1"
  local final_file="$FRAMES_DIR/frame_${frame_index}.png"
  local remote_file="/sdcard/frame_${frame_index}.png"

  adb shell screencap -p "$remote_file" >/dev/null
  adb pull "$remote_file" "$final_file" >/dev/null
  adb shell rm -f "$remote_file" >/dev/null
  log "Captured $final_file"
}

build_app() {
  if [ ! -f "$APK_PATH" ]; then
    log "Building Android app..."
    (cd example && flutter pub get && flutter build apk --debug)
  fi
}

install_app() {
  log "Installing APK..."
  adb install -r "$APK_PATH" >/dev/null
}

launch_app() {
  log "Launching app..."
  adb shell am start -n "$PACKAGE_NAME/$ACTIVITY_NAME" >/dev/null
}

main() {
  if [ "$SKIP_BUILD_INSTALL" != "true" ]; then
    build_app
  else
    log "Skipping build and install."
  fi

  log "Waiting for Android emulator..."
  wait_for_boot
  adb shell input keyevent 82 >/dev/null || true

  if [ "$SKIP_BUILD_INSTALL" != "true" ]; then
    install_app
    launch_app
  fi

  log "Waiting ${START_DELAY_SECONDS}s before capture..."
  sleep "$START_DELAY_SECONDS"

  local frame=0
  capture_frame "$(printf '%03d' "$frame")"
  frame=$((frame + 1))

  local -a taps=(
    "25 28"
    "50 28"
    "75 28"
    "25 70"
    "50 70"
    "75 70"
  )

  for tap in "${taps[@]}"; do
    tap_pct "${tap%% *}" "${tap##* }"
    sleep "$(awk "BEGIN { printf \"%.3f\", $SCREENSHOT_DELAY_MS / 1000 }")"
    capture_frame "$(printf '%03d' "$frame")"
    frame=$((frame + 1))
    sleep "$(awk "BEGIN { printf \"%.3f\", $FRAME_PAUSE_MS / 1000 }")"
    capture_frame "$(printf '%03d' "$frame")"
    frame=$((frame + 1))
  done

  log "Frames saved to $FRAMES_DIR"
}

main "$@"
