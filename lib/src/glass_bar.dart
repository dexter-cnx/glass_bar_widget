import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'glass_bar_item.dart';
import 'glass_bar_theme.dart';

@immutable
class GlassBar extends StatefulWidget {
  const GlassBar({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onTabChanged,
    this.orientation = Axis.horizontal,
    this.rotateLabelInVertical = true,
    this.iconAfterLabel = false,
    this.maxExtent,
    this.theme,
    this.itemAnimationDuration = const Duration(milliseconds: 300),
    this.itemAnimationCurve = Curves.easeInOut,
    this.panelShowDuration = const Duration(milliseconds: 450),
    this.panelHideDuration = const Duration(milliseconds: 250),
    this.panelAutoHideDuration,
    this.panelAnimationCurve = Curves.easeOutCubic,
    this.initialIndex,
    this.deselectOnTapWhenSelected = true,
    this.expandSelectedItem = true,
    this.verticalPanelMaxWidth = 240,
  })  : assert(items.length > 0, 'items must not be empty'),
        assert(
          selectedIndex == null ||
              (selectedIndex >= 0 && selectedIndex < items.length),
          'selectedIndex is out of range',
        ),
        assert(
          initialIndex == null ||
              (initialIndex >= 0 && initialIndex < items.length),
          'initialIndex is out of range',
        );

  final int? selectedIndex;
  final List<GlassBarItem> items;
  final ValueChanged<int?>? onTabChanged;
  final Axis orientation;
  final bool rotateLabelInVertical;
  final bool iconAfterLabel;
  final double? maxExtent;
  final GlassBarThemeData? theme;
  final Duration itemAnimationDuration;
  final Curve itemAnimationCurve;
  final Duration panelShowDuration;
  final Duration panelHideDuration;
  final Duration? panelAutoHideDuration;
  final Curve panelAnimationCurve;
  final int? initialIndex;
  final bool deselectOnTapWhenSelected;
  final bool expandSelectedItem;
  final double? verticalPanelMaxWidth;

  bool get isControlled => onTabChanged != null;

  @override
  State<GlassBar> createState() => _GlassBarState();
}

class _GlassBarState extends State<GlassBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _panelController;
  late Animation<double> _panelAnimation;
  Timer? _autoHideTimer;
  int? _internalIndex;
  int? _lastValidIndex;

  int? get _effectiveIndex => widget.selectedIndex ?? _internalIndex;
  bool get _isHorizontal => widget.orientation == Axis.horizontal;
  GlassBarThemeData get _theme => widget.theme ?? const GlassBarThemeData();

  @override
  void initState() {
    super.initState();
    _internalIndex = widget.selectedIndex == null ? widget.initialIndex : null;
    _lastValidIndex = _effectiveIndex;

    _panelController = AnimationController(
      vsync: this,
      duration: widget.panelShowDuration,
      reverseDuration: widget.panelHideDuration,
      value: _effectiveIndex != null ? 1 : 0,
    );
    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: widget.panelAnimationCurve,
      reverseCurve: Curves.easeInCubic,
    );

    if (_effectiveIndex != null) {
      _scheduleAutoHideIfNeeded();
    }
  }

  @override
  void didUpdateWidget(covariant GlassBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.panelShowDuration != widget.panelShowDuration ||
        oldWidget.panelHideDuration != widget.panelHideDuration) {
      _panelController
        ..duration = widget.panelShowDuration
        ..reverseDuration = widget.panelHideDuration;
    }

    if (oldWidget.panelAnimationCurve != widget.panelAnimationCurve) {
      _panelAnimation = CurvedAnimation(
        parent: _panelController,
        curve: widget.panelAnimationCurve,
        reverseCurve: Curves.easeInCubic,
      );
    }

    final index = _effectiveIndex;
    final oldIndex = oldWidget.selectedIndex ?? _internalIndex;
    if (index != oldIndex) {
      _syncPanelWithIndex(index);
    }
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _panelController.dispose();
    super.dispose();
  }

  void _syncPanelWithIndex(int? index) {
    _autoHideTimer?.cancel();
    if (index != null) {
      _lastValidIndex = index;
      _panelController.forward();
      _scheduleAutoHideIfNeeded();
    } else {
      _panelController.reverse();
    }
  }

  void _scheduleAutoHideIfNeeded() {
    final autoHide = widget.panelAutoHideDuration;
    if (autoHide == null) {
      return;
    }
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(autoHide, () {
      _setSelectedIndex(null);
    });
  }

  void _handleTap(int index) {
    final current = _effectiveIndex;
    final next =
        (widget.deselectOnTapWhenSelected && current == index) ? null : index;
    _setSelectedIndex(next);
  }

  void _setSelectedIndex(int? index) {
    if (widget.selectedIndex == null) {
      setState(() {
        _internalIndex = index;
      });
      _syncPanelWithIndex(index);
    } else {
      _syncPanelWithIndex(index);
    }
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: _isHorizontal ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          _isHorizontal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: _isHorizontal
          ? <Widget>[_buildPanel(), _buildBar()]
          : <Widget>[_buildBar(), _buildPanel()],
    );
  }

  Widget _buildPanel() {
    return AnimatedBuilder(
      animation: _panelAnimation,
      builder: (context, _) {
        final displayIndex = _effectiveIndex ?? _lastValidIndex;
        final content = displayIndex == null
            ? null
            : widget.items[displayIndex].panelContent;
        if (content == null || _panelAnimation.value == 0) {
          return const SizedBox.shrink();
        }

        return Transform.translate(
          offset: _isHorizontal
              ? Offset(0, 20 * (1 - _panelAnimation.value))
              : Offset(20 * (1 - _panelAnimation.value), 0),
          child: Opacity(
            opacity: _panelAnimation.value,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: _isHorizontal ? 16 : 0,
                left: _isHorizontal ? 0 : 16,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_theme.panelBorderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _theme.panelBlur,
                    sigmaY: _theme.panelBlur,
                  ),
                  child: Container(
                    constraints: _isHorizontal
                        ? null
                        : BoxConstraints(
                            maxWidth: widget.verticalPanelMaxWidth ?? 240),
                    decoration: BoxDecoration(
                      color: _theme.panelBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(_theme.panelBorderRadius),
                      border: Border.fromBorderSide(_theme.panelBorderSide),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  _theme.panelBorderRadius,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Colors.white.withValues(alpha: 0.18),
                                    Colors.white.withValues(alpha: 0.06),
                                    Colors.white.withValues(alpha: 0.015),
                                  ],
                                  stops: const <double>[0, 0.42, 1],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: _theme.panelPadding,
                          child: content,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBar() {
    Widget barBody = Container(
      padding: _theme.barPadding,
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: BorderRadius.circular(_theme.borderRadius),
        border: Border.fromBorderSide(_theme.borderSide),
        boxShadow: _isHorizontal
            ? _theme.boxShadows
            : _theme.boxShadows
                .map(
                  (shadow) => shadow.copyWith(
                    offset: const Offset(10, 0),
                  ),
                )
                .toList(),
      ),
      child: Flex(
        direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
        mainAxisSize:
            widget.maxExtent != null ? MainAxisSize.max : MainAxisSize.min,
        children: List<Widget>.generate(widget.items.length, (index) {
          final isSelected = _effectiveIndex == index;
          Widget itemWidget = _buildInteractiveItem(index, isSelected);

          if (widget.maxExtent != null) {
            return Expanded(
              flex: isSelected && widget.expandSelectedItem ? 2 : 1,
              child: itemWidget,
            );
          }
          return itemWidget;
        }),
      ),
    );

    if (widget.maxExtent != null) {
      barBody = ConstrainedBox(
        constraints: _isHorizontal
            ? BoxConstraints(maxWidth: widget.maxExtent!)
            : BoxConstraints(maxHeight: widget.maxExtent!),
        child: barBody,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(_theme.borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _theme.blur, sigmaY: _theme.blur),
        child: Material(
          color: Colors.transparent,
          child: barBody,
        ),
      ),
    );
  }

  Widget _buildInteractiveItem(int index, bool isSelected) {
    final item = widget.items[index];

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.effectiveSemanticLabel,
      hint: item.longPressHint,
      child: Tooltip(
        message: item.effectiveTooltip,
        child: InkWell(
          onTap: () => _handleTap(index),
          borderRadius: BorderRadius.circular(_theme.borderRadius - 10),
          child: Center(
            child: AnimatedContainer(
              duration: widget.itemAnimationDuration,
              curve: widget.itemAnimationCurve,
              padding: EdgeInsets.symmetric(
                horizontal: _isHorizontal ? (isSelected ? 16 : 8) : 8,
                vertical: _isHorizontal ? 8 : (isSelected ? 16 : 8),
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? _theme.selectedItemBackgroundColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(_theme.borderRadius - 10),
              ),
              child: AnimatedSize(
                duration: widget.itemAnimationDuration,
                curve: widget.itemAnimationCurve,
                child: Flex(
                  direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
                  mainAxisSize: (widget.maxExtent != null && isSelected)
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  children: _buildItemContent(
                    index,
                    isSelected,
                    useExpanded: widget.maxExtent != null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItemContent(
    int index,
    bool isSelected, {
    bool useExpanded = false,
  }) {
    final item = widget.items[index];
    final color =
        isSelected ? _theme.selectedItemColor : _theme.unselectedItemColor;
    final iconWidget = IconTheme(
      data: IconThemeData(color: color, size: 24),
      child: item.effectiveIcon,
    );

    if (!isSelected) {
      return <Widget>[iconWidget];
    }

    final labelChild = DefaultTextStyle(
      style: _theme.labelStyle.copyWith(color: color),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      child: (!_isHorizontal && widget.rotateLabelInVertical)
          ? RotatedBox(quarterTurns: 3, child: item.effectiveLabel)
          : item.effectiveLabel,
    );
    final labelWidget = useExpanded
        ? Expanded(child: labelChild)
        : Flexible(child: labelChild);

    final spacing =
        SizedBox(width: _isHorizontal ? 8 : 0, height: _isHorizontal ? 0 : 8);
    return widget.iconAfterLabel
        ? <Widget>[labelWidget, spacing, iconWidget]
        : <Widget>[iconWidget, spacing, labelWidget];
  }
}
