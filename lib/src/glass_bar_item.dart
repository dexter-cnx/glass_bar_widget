import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@immutable
class GlassBarItem {
  const GlassBarItem({
    this.icon,
    this.activeIcon,
    this.iconData,
    this.activeIconData,
    this.svgAssetPath,
    this.activeSvgAssetPath,
    this.label,
    this.labelText,
    this.panelContent,
    this.tooltip,
    this.semanticLabel,
    this.longPressHint,
    this.badgeText,
    this.badgeColor,
    this.labelStyle,
    this.activeLabelStyle,
  })  : assert(
          icon != null || iconData != null || svgAssetPath != null,
          'Either icon, iconData, or svgAssetPath must be provided',
        ),
        assert(
          label != null || labelText != null,
          'Either label or labelText must be provided',
        );

  final Widget? icon;
  final Widget? activeIcon;
  final IconData? iconData;
  final IconData? activeIconData;
  final String? svgAssetPath;
  final String? activeSvgAssetPath;
  final Widget? label;
  final String? labelText;
  final Widget? panelContent;
  final String? tooltip;
  final String? semanticLabel;
  final String? longPressHint;
  final String? badgeText;
  final Color? badgeColor;
  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;

  Widget effectiveIcon({required bool isSelected}) {
    if (isSelected && activeIcon != null) {
      return activeIcon!;
    }
    if (isSelected && activeIconData != null) {
      return Icon(activeIconData);
    }
    if (isSelected && activeSvgAssetPath != null) {
      return SvgPicture.asset(activeSvgAssetPath!);
    }
    if (iconData != null) {
      return Icon(iconData);
    }
    if (svgAssetPath != null) {
      return SvgPicture.asset(svgAssetPath!);
    }
    return icon!;
  }

  Widget get effectiveLabel => labelText != null ? Text(labelText!) : label!;
  String get effectiveSemanticLabel =>
      semanticLabel ?? tooltip ?? labelText ?? 'Navigation item';
  String get effectiveTooltip => tooltip ?? labelText ?? 'Navigation item';
}
