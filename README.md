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
- Active/inactive icon support, badges, and label style overrides
- Optional haptic feedback, safe area toggle, and configurable selected icon scale
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
| `letIndexChange` | `bool Function(int?, int?)?` | `null` | Intercept/deny tab changes |
| `selectedIndex` | `int?` | `null` | Controlled mode when provided |
| `onTabChanged` | `ValueChanged<int?>?` | `null` | Callback for selection changes |
| `orientation` | `Axis` | `Axis.horizontal` | Horizontal or vertical |
| `showLabelMode` | `ShowLabelMode` | `onSelected` | Label visibility mode |
| `selectedIconScale` | `double` | `1.2` | Active icon scale |
| `enableHapticFeedback` | `bool` | `true` | Light haptic on tap |
| `enableDragToChangeTab` | `bool` | `false` | Swipe to switch tabs (horizontal mode) |
| `useSafeArea` | `bool` | `true` | Wrap bar in SafeArea |
| `enableBlur` | `bool` | `true` | Disable blur for low-end devices |
| `elevation` | `double` | `0` | Material elevation/shadow |
| `rippleColor` | `Color?` | `null` | Custom tap ripple color |
| `rippleRadius` | `double?` | `null` | Custom tap ripple radius |
| `indicatorBuilder` | `GlassBarIndicatorBuilder?` | `null` | Provide custom selected indicator wrapper |
| `maxExtent` | `double?` | `null` | Constrains bar width or height |
| `panelShowDuration` | `Duration` | `450ms` | Show animation |
| `panelHideDuration` | `Duration` | `250ms` | Hide animation |
| `panelAutoHideDuration` | `Duration?` | `null` | Auto-hide delay |
| `rotateLabelInVertical` | `bool` | `true` | Rotate selected label in vertical mode |
| `iconAfterLabel` | `bool` | `false` | Place icon after label when selected |
| `itemAnimationDuration` | `Duration` | `300ms` | Item animation duration |
| `itemAnimationCurve` | `Curve` | `easeInOut` | Item animation curve |
| `initialIndex` | `int?` | `null` | Initial selected index in uncontrolled mode |
| `deselectOnTapWhenSelected` | `bool` | `true` | Tap selected item again to deselect |
| `expandSelectedItem` | `bool` | `true` | Expands selected item when `maxExtent` is used |
| `verticalPanelMaxWidth` | `double?` | `240` | Max panel width in vertical orientation |
| `theme` | `GlassBarThemeData?` | default theme | Styling |

### GlassBarItem API

`GlassBarItem` supports:

- `icon`, `iconData`, `svgAssetPath`
- `activeIcon`, `activeIconData`, `activeSvgAssetPath`
- `badgeText`, `badgeColor`
- `labelStyle`, `activeLabelStyle`
- `tooltip`, `semanticLabel`, `longPressHint`

> Minimum recommended item count is **2**.

## Troubleshooting

- **Blur not visible**: Use `Scaffold(extendBody: true)` and ensure there is content behind the bar.
- **Low performance on some devices**: Set `enableBlur: false` or reduce blur values in theme.
- **Android Impeller icon color issues**: test with/without blur and consider fallback icon rendering strategy for affected devices.
- **Hot restart quirks while tuning animations**: do a full restart when changing theme/blur-heavy visual settings.

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

Manual capture workflow:

1. Open the demo and navigate to the mode you want.
2. Press `Space` to capture the current frame.
3. Press `Esc` to finish.
4. The script will combine all captured frames into `doc/media/glass_bar_demo.gif`.

## Publish checklist

See [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md).

## Branch protection

See [doc/BRANCH_PROTECTION_CHECKLIST.md](doc/BRANCH_PROTECTION_CHECKLIST.md).

## Improvement plan

See [doc/PHASED_IMPROVEMENT_PLAN.md](doc/PHASED_IMPROVEMENT_PLAN.md).
