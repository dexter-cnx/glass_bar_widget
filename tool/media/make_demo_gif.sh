#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p docs/media
ffmpeg -y \
  -framerate 8 \
  -pattern_type glob -i 'docs/media/frames/frame_*.png' \
  -vf 'fps=8,scale=960:-1:flags=lanczos' \
  docs/media/glass_bar_demo.gif
