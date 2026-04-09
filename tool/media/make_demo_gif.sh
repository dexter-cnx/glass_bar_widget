#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p doc/media
ffmpeg -y \
  -framerate 8 \
  -pattern_type glob -i 'doc/media/frames/frame_*.png' \
  -vf 'fps=8,scale=960:-1:flags=lanczos' \
  doc/media/glass_bar_demo.gif
