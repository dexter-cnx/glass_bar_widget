SHELL := /bin/sh

.PHONY: help get format analyze test check publish-dry-run demo-get demo-build-web media-android media-web-browser clean

help:
	@printf '%s\n' \
		'Available targets:' \
		'  make get              Install package dependencies' \
		'  make format           Format Dart code' \
		'  make analyze          Run static analysis' \
		'  make test             Run tests' \
		'  make check            Run format, analyze, and test' \
		'  make publish-dry-run  Validate pub publish metadata' \
		'  make demo-get         Install example app dependencies' \
		'  make demo-build-web   Build the Flutter web demo' \
		'  make media-android    Capture media using Android emulator' \
		'  make media-web-browser Capture frames via browser Playwright tool and build GIF' \
		'  make clean            Remove build artifacts'

get:
	flutter pub get

format:
	dart format --output=none --set-exit-if-changed .

analyze:
	flutter analyze

test:
	flutter test

check: format analyze test

publish-dry-run:
	flutter pub publish --dry-run

demo-get:
	$(MAKE) -C example get

demo-build-web:
	$(MAKE) -C example build-web

media-android:
	bash tool/media/capture_android_emulator.sh

media-web-browser:
	node tool/media/capture_web_demo.mjs

clean:
	flutter clean
	$(MAKE) -C example clean
