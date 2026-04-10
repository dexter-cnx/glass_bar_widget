import 'package:flutter/material.dart';

@immutable
class GlassBarThemeData {
  const GlassBarThemeData({
    this.backgroundColor = const Color(0x28FFFFFF),
    this.selectedItemBackgroundColor = const Color(0x26E8F2FF),
    this.selectedItemColor = const Color(0xFF213042),
    this.unselectedItemColor = const Color(0xFF607085),
    this.blur = 34,
    this.borderRadius = 30,
    this.borderSide = const BorderSide(color: Color(0x24FFFFFF), width: 1.2),
    this.labelStyle = const TextStyle(
      color: Color(0xFF243040),
      fontWeight: FontWeight.w600,
    ),
    this.panelBackgroundColor = const Color(0x18FFFFFF),
    this.panelBlur = 42,
    this.panelBorderRadius = 28,
    this.panelBorderSide = const BorderSide(color: Color(0x1EFFFFFF)),
    this.barPadding = const EdgeInsets.all(10),
    this.panelPadding = const EdgeInsets.all(20),
    this.boxShadows = const [
      BoxShadow(
        color: Color(0x12000000),
        blurRadius: 22,
        offset: Offset(0, 10),
      ),
    ],
  });

  final Color backgroundColor;
  final Color selectedItemBackgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final double blur;
  final double borderRadius;
  final BorderSide borderSide;
  final TextStyle labelStyle;
  final Color panelBackgroundColor;
  final double panelBlur;
  final double panelBorderRadius;
  final BorderSide panelBorderSide;
  final EdgeInsetsGeometry barPadding;
  final EdgeInsetsGeometry panelPadding;
  final List<BoxShadow> boxShadows;

  GlassBarThemeData copyWith({
    Color? backgroundColor,
    Color? selectedItemBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    double? blur,
    double? borderRadius,
    BorderSide? borderSide,
    TextStyle? labelStyle,
    Color? panelBackgroundColor,
    double? panelBlur,
    double? panelBorderRadius,
    BorderSide? panelBorderSide,
    EdgeInsetsGeometry? barPadding,
    EdgeInsetsGeometry? panelPadding,
    List<BoxShadow>? boxShadows,
  }) {
    return GlassBarThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedItemBackgroundColor:
          selectedItemBackgroundColor ?? this.selectedItemBackgroundColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      blur: blur ?? this.blur,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      labelStyle: labelStyle ?? this.labelStyle,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      panelBlur: panelBlur ?? this.panelBlur,
      panelBorderRadius: panelBorderRadius ?? this.panelBorderRadius,
      panelBorderSide: panelBorderSide ?? this.panelBorderSide,
      barPadding: barPadding ?? this.barPadding,
      panelPadding: panelPadding ?? this.panelPadding,
      boxShadows: boxShadows ?? this.boxShadows,
    );
  }
}
