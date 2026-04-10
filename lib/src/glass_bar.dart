import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'glass_bar_item.dart';
import 'glass_bar_theme.dart';

enum ShowLabelMode { always, onSelected, never }

typedef LetIndexChange = bool Function(int? currentIndex, int? nextIndex);
typedef GlassBarIndicatorBuilder = Widget Function(
  BuildContext context,
  bool isSelected,
  Widget child,
);

@immutable
class GlassBar extends StatefulWidget {
  const GlassBar({
    super.key,
    required this.items,
    this.selectedIndex,
    this.onTabChanged,
    this.letIndexChange,
    this.orientation = Axis.horizontal,
    this.rotateLabelInVertical = true,
    this.iconAfterLabel = false,
    this.showLabelMode = ShowLabelMode.onSelected,
    this.selectedIconScale = 1.2,
    this.maxExtent,
    this.theme,
    this.glassBlur,
    this.glassOpacity,
    this.borderRadius,
    this.borderWidth,
    this.animationCurve,
    this.animationDuration,
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
    this.enableBlur = true,
    this.useSafeArea = true,
    this.enableHapticFeedback = true,
    this.enableDragToChangeTab = false,
    this.indicatorBuilder,
    this.elevation = 0,
    this.rippleColor,
    this.rippleRadius,
  })  : assert(items.length >= 2, 'items must contain at least 2 entries'),
        assert(
          selectedIndex == null ||
              (selectedIndex >= 0 && selectedIndex < items.length),
          'selectedIndex is out of range',
        ),
        assert(
          initialIndex == null ||
              (initialIndex >= 0 && initialIndex < items.length),
          'initialIndex is out of range',
        ),
        assert(selectedIconScale > 0, 'selectedIconScale must be > 0');

  final int? selectedIndex;
  final List<GlassBarItem> items;
  final ValueChanged<int?>? onTabChanged;
  final LetIndexChange? letIndexChange;
  final Axis orientation;
  final bool rotateLabelInVertical;
  final bool iconAfterLabel;
  final ShowLabelMode showLabelMode;
  final double selectedIconScale;
  final double? maxExtent;
  final GlassBarThemeData? theme;
  final double? glassBlur;
  final double? glassOpacity;
  final double? borderRadius;
  final double? borderWidth;
  final Curve? animationCurve;
  final Duration? animationDuration;
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
  final bool enableBlur;
  final bool useSafeArea;
  final bool enableHapticFeedback;
  final bool enableDragToChangeTab;
  final GlassBarIndicatorBuilder? indicatorBuilder;
  final double elevation;
  final Color? rippleColor;
  final double? rippleRadius;

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
  late ImageFilter _barBlurFilter;
  late ImageFilter _panelBlurFilter;

  int? get _effectiveIndex => widget.selectedIndex ?? _internalIndex;
  bool get _isHorizontal => widget.orientation == Axis.horizontal;
  GlassBarThemeData get _theme {
    final base = widget.theme ?? const GlassBarThemeData();
    final backgroundColor = widget.glassOpacity == null
        ? base.backgroundColor
        : base.backgroundColor.withValues(alpha: widget.glassOpacity!);
    return base.copyWith(
      blur: widget.glassBlur,
      borderRadius: widget.borderRadius,
      borderSide: widget.borderWidth == null
          ? base.borderSide
          : base.borderSide.copyWith(width: widget.borderWidth),
      backgroundColor: backgroundColor,
    );
  }

  Duration get _itemDuration =>
      widget.animationDuration ?? widget.itemAnimationDuration;
  Curve get _itemCurve => widget.animationCurve ?? widget.itemAnimationCurve;

  @override
  void initState() {
    super.initState();
    _internalIndex = widget.selectedIndex == null ? widget.initialIndex : null;
    _lastValidIndex = _effectiveIndex;
    _rebuildFilters();

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

    if (oldWidget.enableBlur != widget.enableBlur ||
        oldWidget.theme?.blur != widget.theme?.blur ||
        oldWidget.theme?.panelBlur != widget.theme?.panelBlur) {
      _rebuildFilters();
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

  void _rebuildFilters() {
    _barBlurFilter = ImageFilter.blur(sigmaX: _theme.blur, sigmaY: _theme.blur);
    _panelBlurFilter =
        ImageFilter.blur(sigmaX: _theme.panelBlur, sigmaY: _theme.panelBlur);
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
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    final current = _effectiveIndex;
    final next =
        (widget.deselectOnTapWhenSelected && current == index) ? null : index;
    _setSelectedIndex(next);
  }

  void _setSelectedIndex(int? index) {
    final current = _effectiveIndex;
    if (widget.letIndexChange != null &&
        !widget.letIndexChange!(current, index)) {
      return;
    }

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

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.enableDragToChangeTab || !_isHorizontal) {
      return;
    }
    if (details.delta.dx.abs() < 10) {
      return;
    }

    final current = _effectiveIndex ?? 0;
    final next = details.delta.dx < 0 ? current + 1 : current - 1;
    if (next < 0 || next >= widget.items.length) {
      return;
    }
    _setSelectedIndex(next);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Flex(
      direction: _isHorizontal ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          _isHorizontal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: _isHorizontal
          ? <Widget>[_buildPanel(), _buildBar(context)]
          : <Widget>[_buildBar(context), _buildPanel()],
    );

    if (widget.useSafeArea) {
      child = SafeArea(top: false, left: false, right: false, child: child);
    }

    return child;
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

        Widget panel = Container(
          constraints: _isHorizontal
              ? null
              : BoxConstraints(maxWidth: widget.verticalPanelMaxWidth ?? 240),
          padding: _theme.panelPadding,
          decoration: BoxDecoration(
            color: _theme.panelBackgroundColor,
            borderRadius: BorderRadius.circular(_theme.panelBorderRadius),
            border: Border.fromBorderSide(_theme.panelBorderSide),
          ),
          child: content,
        );

        if (widget.enableBlur) {
          panel = ClipRRect(
            borderRadius: BorderRadius.circular(_theme.panelBorderRadius),
            child: BackdropFilter(filter: _panelBlurFilter, child: panel),
          );
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
              child: panel,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    final platform = Theme.of(context).platform;
    final minMainExtent = _isHorizontal
        ? (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS
            ? 80.0
            : 70.0)
        : 70.0;

    Widget barBody = GestureDetector(
      onHorizontalDragUpdate:
          widget.enableDragToChangeTab ? _handleHorizontalDragUpdate : null,
      child: ConstrainedBox(
        constraints: _isHorizontal
            ? BoxConstraints(minHeight: minMainExtent)
            : BoxConstraints(minWidth: minMainExtent),
        child: Container(
          padding: _theme.barPadding,
          decoration: BoxDecoration(
            color: _theme.backgroundGradient == null
                ? _theme.backgroundColor
                : null,
            gradient: _theme.backgroundGradient,
            borderRadius: BorderRadius.circular(_theme.borderRadius),
            border: Border.fromBorderSide(_theme.borderSide),
            boxShadow: _isHorizontal
                ? _theme.boxShadows
                : _theme.boxShadows
                    .map((shadow) =>
                        shadow.copyWith(offset: const Offset(10, 0)))
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
        ),
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

    Widget decorated = Material(
      elevation: widget.elevation,
      color: Colors.transparent,
      child: barBody,
    );

    if (widget.enableBlur) {
      decorated = ClipRRect(
        borderRadius: BorderRadius.circular(_theme.borderRadius),
        child: BackdropFilter(filter: _barBlurFilter, child: decorated),
      );
    }

    return decorated;
  }

  Widget _buildInteractiveItem(int index, bool isSelected) {
    final item = widget.items[index];

    Widget itemChild = Center(
      child: AnimatedContainer(
        duration: _itemDuration,
        curve: _itemCurve,
        padding: EdgeInsets.symmetric(
          horizontal: _isHorizontal ? (isSelected ? 16 : 8) : 8,
          vertical: _isHorizontal ? 8 : (isSelected ? 16 : 8),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (_theme.selectedItemGradient == null
                  ? _theme.selectedItemBackgroundColor
                  : null)
              : Colors.transparent,
          gradient: isSelected ? _theme.selectedItemGradient : null,
          borderRadius: BorderRadius.circular(_theme.borderRadius - 10),
        ),
        child: AnimatedSize(
          duration: _itemDuration,
          curve: _itemCurve,
          child: Flex(
            direction: _isHorizontal ? Axis.horizontal : Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: _buildItemContent(index, isSelected),
          ),
        ),
      ),
    );

    if (widget.indicatorBuilder != null) {
      itemChild = widget.indicatorBuilder!(context, isSelected, itemChild);
    }

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.tooltip ?? item.effectiveSemanticLabel,
      hint: item.longPressHint,
      child: Tooltip(
        message: item.effectiveTooltip,
        child: InkWell(
          onTap: () => _handleTap(index),
          borderRadius: BorderRadius.circular(_theme.borderRadius - 10),
          splashColor: widget.rippleColor,
          radius: widget.rippleRadius,
          child: itemChild,
        ),
      ),
    );
  }

  List<Widget> _buildItemContent(int index, bool isSelected) {
    final item = widget.items[index];
    final color =
        isSelected ? _theme.selectedItemColor : _theme.unselectedItemColor;

    final iconWidget = Transform.scale(
      scale: isSelected ? widget.selectedIconScale : 1,
      child: IconTheme(
        data: IconThemeData(color: color, size: 24),
        child: _buildIconWithBadge(item, isSelected),
      ),
    );

    final shouldShowLabel = switch (widget.showLabelMode) {
      ShowLabelMode.always => true,
      ShowLabelMode.onSelected => isSelected,
      ShowLabelMode.never => false,
    };

    if (!shouldShowLabel) {
      return <Widget>[iconWidget];
    }

    final baseStyle = isSelected
        ? (item.activeLabelStyle ?? item.labelStyle ?? _theme.labelStyle)
        : (item.labelStyle ?? _theme.labelStyle);

    final labelWidget = Flexible(
      child: DefaultTextStyle(
        style: baseStyle.copyWith(color: color),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        child: (!_isHorizontal && widget.rotateLabelInVertical)
            ? RotatedBox(quarterTurns: 3, child: item.effectiveLabel)
            : item.effectiveLabel,
      ),
    );

    final spacing =
        SizedBox(width: _isHorizontal ? 8 : 0, height: _isHorizontal ? 0 : 8);
    return widget.iconAfterLabel
        ? <Widget>[labelWidget, spacing, iconWidget]
        : <Widget>[iconWidget, spacing, labelWidget];
  }

  Widget _buildIconWithBadge(GlassBarItem item, bool isSelected) {
    final icon = item.effectiveIcon(isSelected: isSelected);
    final badgeText = item.badgeText;
    if (badgeText == null || badgeText.isEmpty) {
      return icon;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        icon,
        Positioned(
          right: -10,
          top: -8,
          child: AnimatedSwitcher(
            duration: _itemDuration,
            child: Container(
              key: ValueKey<String>(badgeText),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: item.badgeColor ?? Colors.redAccent,
                borderRadius: BorderRadius.circular(999),
              ),
              constraints: const BoxConstraints(minWidth: 16),
              child: Text(
                badgeText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
