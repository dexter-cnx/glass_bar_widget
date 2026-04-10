# GlassBar

![Pub Version](https://img.shields.io/pub/v/glass_bar)
![Flutter](https://img.shields.io/badge/flutter-package-02569B)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![CI](https://github.com/dexter-cnx/glass_bar_widget/actions/workflows/ci.yml/badge.svg)
![Web Demo](https://github.com/dexter-cnx/glass_bar_widget/actions/workflows/web-demo.yml/badge.svg)

GlassBar is a Flutter navigation bar package with glassmorphism styling, horizontal and vertical layouts, pinned panels by default, optional auto-hide, and flexible theming.

![GlassBar demo animation](https://raw.githubusercontent.com/dexter-cnx/glass_bar_widget/main/doc/media/glass_bar_demo.gif)

## Features

- Horizontal bottom bar and vertical sidebar layouts
- Pinned panel behavior by default
- Optional `panelAutoHideDuration`
- Controlled and uncontrolled selection modes
- Flexible theming via `GlassBarThemeData`
- Accessibility support with tooltips and semantics
- GitHub Actions CI and a GitHub Pages demo

## Install

```yaml
dependencies:
  glass_bar: ^1.0.0
```

## Quick start

```dart
GlassBar(
  items: const [
    GlassBarItem(
      iconData: Icons.home_rounded,
      labelText: 'Home',
      panelContent: Text('Home panel'),
    ),
    GlassBarItem(
      iconData: Icons.settings_rounded,
      labelText: 'Settings',
      panelContent: Text('Settings panel'),
    ),
  ],
)
```

## Controlled example

```dart
int? selectedIndex;

GlassBar(
  selectedIndex: selectedIndex,
  onTabChanged: (index) {
    setState(() => selectedIndex = index);
  },
  items: items,
)
```

## Important behavior

By default, the panel stays visible until the item is unselected.

```dart
GlassBar(
  items: items,
  panelAutoHideDuration: null,
)
```

To enable temporary panels:

```dart
GlassBar(
  items: items,
  panelAutoHideDuration: const Duration(seconds: 2),
)
```

## Main API

| Property | Type | Default | Notes |
|---|---|---:|---|
| `items` | `List<GlassBarItem>` | required | Navigation items |
| `selectedIndex` | `int?` | `null` | Controlled mode when provided |
| `onTabChanged` | `ValueChanged<int?>?` | `null` | Callback for selection changes |
| `orientation` | `Axis` | `Axis.horizontal` | Horizontal or vertical |
| `maxExtent` | `double?` | `null` | Constrains bar width or height |
| `panelShowDuration` | `Duration` | `450ms` | Show animation |
| `panelHideDuration` | `Duration` | `250ms` | Hide animation |
| `panelAutoHideDuration` | `Duration?` | `null` | Auto-hide delay |
| `theme` | `GlassBarThemeData?` | default theme | Styling |

## Web demo

Use GitHub Actions Pages deployment from `example/`.

Repository name example:

```text
https://dexter-cnx.github.io/glass_bar_widget/
```

If your repo name differs from `glass_bar_widget`, update the `--base-href` value in `.github/workflows/web-demo.yml`.

## Browser screenshot tool

You can capture a web screenshot (and optional interaction frames) using the built-in Playwright script:

```bash
make media-web-browser
```

This command runs `tool/media/capture_web_demo.mjs` and writes output into `doc/media/`.
By default it expects a running web demo at `http://127.0.0.1:8080` and starts in manual capture mode.

## Publish checklist

See [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md).

## Branch protection

See [doc/BRANCH_PROTECTION_CHECKLIST.md](doc/BRANCH_PROTECTION_CHECKLIST.md).
