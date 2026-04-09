import 'package:flutter/material.dart';

@immutable
class GlassBarItem {
  final Widget? icon;
  final IconData? iconData;
  final Widget? label;
  final String? labelText;
  final Widget? panelContent;
  final String? tooltip;
  final String? semanticLabel;
  final String? longPressHint;

  const GlassBarItem({
    this.icon,
    this.iconData,
    this.label,
    this.labelText,
    this.panelContent,
    this.tooltip,
    this.semanticLabel,
    this.longPressHint,
  })  : assert(
          icon != null || iconData != null,
          'Either icon or iconData must be provided',
        ),
        assert(
          label != null || labelText != null,
          'Either label or labelText must be provided',
        );

  Widget get effectiveIcon => iconData != null ? Icon(iconData) : icon!;
  Widget get effectiveLabel => labelText != null ? Text(labelText!) : label!;
  String get effectiveSemanticLabel => semanticLabel ?? labelText ?? 'Navigation item';
  String get effectiveTooltip => tooltip ?? labelText ?? 'Navigation item';
}
