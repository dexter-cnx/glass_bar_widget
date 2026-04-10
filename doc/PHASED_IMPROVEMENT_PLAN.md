# Phased Improvement Plan

This plan organizes the next enhancements for `glass_bar` into implementation phases (no calendar days), so progress can be tracked incrementally while keeping releases stable.

## Phase 1 — Quality Baseline (Tests First)

**Objective:** Reduce regression risk before adding new behavior.

### Scope
- Expand widget tests beyond the current core cases.
- Add scenarios for:
  - Vertical layout rendering and interaction.
  - `initialIndex` behavior.
  - `maxExtent` and `expandSelectedItem` layout behavior.
  - `iconAfterLabel` and `rotateLabelInVertical` label/icon order behavior.
  - `didUpdateWidget` transitions when controlled props change.
- Add negative and edge-case assertions where practical.

### Exit criteria
- Test suite validates both horizontal and vertical behavior.
- Controlled/uncontrolled transitions are covered.
- New tests run green in CI.

---

## Phase 2 — Documentation Completeness

**Objective:** Ensure package docs match the full API and expected behavior.

### Scope
- Update README API table to include currently missing public properties:
  - `rotateLabelInVertical`
  - `iconAfterLabel`
  - `itemAnimationDuration`
  - `itemAnimationCurve`
  - `initialIndex`
  - `deselectOnTapWhenSelected`
  - `expandSelectedItem`
  - `verticalPanelMaxWidth`
- Add focused examples for vertical mode and label/icon ordering.
- Add a concise section on controlled vs uncontrolled usage patterns.
- Add a detailed API reference table that documents every public property, defaults, and usage notes.
- Add a troubleshooting section for common issues (including black icon rendering and hot restart caveats).
- Clarify minimum supported item count behavior (recommended minimum 2 items) and expected behavior when below that threshold.

### Exit criteria
- Public constructor options are fully documented.
- README examples cover both common layout modes.

---

## Phase 3 — Accessibility & Desktop/Web UX

**Objective:** Improve non-touch usability and accessibility ergonomics.

### Scope
- Add optional keyboard navigation support (e.g., arrow keys to move focus/selection, enter/space to activate).
- Integrate `Focus`, `Shortcuts`, and `Actions` where appropriate.
- Review semantics behavior for selected state announcements and hints.
- Ensure semantics labels are explicit and consistently readable by screen readers.
- Define platform-specific default heights aligned with platform guidance (Android ~70, iOS ~80) while keeping overrides available.
- Add platform validation notes for Android Impeller rendering to catch color/visual shifts early.

### Exit criteria
- Keyboard-only interaction works in web/desktop contexts.
- Accessibility metadata remains accurate after interaction changes.
- Platform-default sizing and semantics behavior are documented and tested.

---

## Phase 4 — Performance Guidance and Tuning Controls

**Objective:** Help users manage blur-heavy rendering costs intentionally.

### Scope
- Document performance guidance for `BackdropFilter` usage.
- Provide practical tuning recommendations:
  - Reduce blur values.
  - Limit bar dimensions.
  - Prefer lighter visual presets on low-end devices.
- Consider adding optional “performance preset” theme samples in docs.
- Add an `enableBlur`-style configuration flag in API design so consumers can disable blur on low-end devices.
- Cache/reuse blur filter objects instead of recreating them during every build pass.
- Document required layout prerequisites for visible blur (e.g., using `Scaffold(extendBody: true)` and having background content behind the bar).

### Exit criteria
- README includes actionable performance tuning guidance.
- Users can quickly identify low/medium/high visual-cost configurations.

---

## Phase 5 — Release Readiness and Roadmap Hygiene

**Objective:** Keep project evolution visible and predictable after 1.0.0.

### Scope
- Add upcoming milestone notes to changelog/docs.
- Define a lightweight release checklist per phase completion.
- Clarify which items are backward-compatible vs behavior-changing.
- Add pub.dev readiness checklist into release flow:
  - `dart format .` and `flutter analyze` must pass with 0 warnings.
  - Ensure pubspec topics include: `glass`, `navigation-bar`, `flutter`, `glassmorphism`.
  - Keep `CHANGELOG.md` actively updated per release.
  - Track and maintain test coverage above 60%.
  - Validate icon input support matrix: `IconData`, SVG asset path, and custom `Widget`.

### Exit criteria
- Next-version goals are discoverable.
- Release process remains predictable as features expand.
- Pub.dev quality gates are defined and verifiable before publish.

---

## Phase 6 — API & Customization Flexibility

**Objective:** Make GlassBar more configurable for production apps that need fine-grained control.

### Scope
- Expand visual and motion customization options (e.g., blur, opacity, border radius, border width, curve, duration).
- Support gradients for both the bar container and active/selected item background (not only solid colors).
- Introduce a guard callback (e.g., `letIndexChange`) so app logic can approve/reject tab changes (useful for unsaved forms).
- Support separate active icon rendering (e.g., outline icon when inactive, filled icon when active) via `activeIcon`.
- Support badge metadata on items (e.g., `badgeText`, `badgeColor`) for notification counts.
- Expose item text styles (`labelStyle`, `activeLabelStyle`) so apps can provide typography without package-locked font choices.
- Ensure tooltip/semantics alignment for accessibility announcements (e.g., `Semantics(label: item.tooltip ?? item.label)` behavior).

### Exit criteria
- API supports deep customization without requiring forked widget code.
- Tab-change guard behavior is documented with controlled/uncontrolled examples.
- Item model supports active icon, badge, and label-style customization with clear API docs.

---

## Feature Expansion Track (Product Differentiation)

This track captures UI/interaction enhancements requested for making the component feel more premium and competitive.

### Phase 2 — Premium Interaction Features

**Scope**
- Add haptic feedback on tap interactions (e.g., `HapticFeedback.lightImpact()`).
- Add drag-to-change-tab interaction (e.g., via `GestureDetector` and horizontal drag updates).
- Animate badge number updates using `AnimatedSwitcher`.
- Expose `selectedIconScale` as configurable (default around `1.2`, app-tunable higher/lower).

**Exit criteria**
- Interaction polish features are configurable and covered by targeted widget tests.

### Phase 3 — Advanced Customization Features

**Scope**
- Support animated icon widgets (e.g., Lottie/Rive widget inputs that can play on active state).
- Add custom indicator slot so consumers can provide their own selected indicator widget.
- Add dynamic label-visibility modes (e.g., always/on-selected/never).
- Add customizable ripple behavior (color/size/shape tuning).

**Exit criteria**
- Advanced visual customization can be enabled without forking core widget logic.

### Phase 4 — DX & Platform-Specific Hardening

**Scope**
- Add SafeArea toggle (`useSafeArea`) for teams that want manual bottom padding control.
- Add Android Impeller mitigation guidance for black icon issue under blur (e.g., `ColorFiltered`, alternative filter composition strategies).
- Add elevation/shadow controls (`elevation`) so glass style can include depth as needed.

**Exit criteria**
- Platform-specific caveats and mitigations are documented and validated in example apps.

---

## Suggested Execution Order

1. Phase 1
2. Phase 2
3. Phase 3
4. Phase 4
5. Phase 6
6. Phase 5

This order prioritizes correctness first, then clarity, then capability growth and release discipline.
