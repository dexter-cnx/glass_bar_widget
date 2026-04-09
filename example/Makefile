SHELL := /bin/sh

.PHONY: help get build-web clean

help:
	@printf '%s\n' \
		'Available targets:' \
		'  make get         Install example app dependencies' \
		'  make build-web   Build the Flutter web demo' \
		'  make clean       Remove example build artifacts'

get:
	flutter pub get

build-web:
	flutter build web --release --base-href /glass_bar_widget/

clean:
	flutter clean

