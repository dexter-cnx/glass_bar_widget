import 'package:flutter/material.dart';

@immutable
class GlassBarThemeData {
  const GlassBarThemeData({
    this.backgroundColor = const Color(0x1F9E9E9E),
    this.backgroundGradient,
    this.selectedItemBackgroundColor = const Color(0x33FFFFFF),
    this.selectedItemGradient,
    this.selectedItemColor = Colors.white,
    this.unselectedItemColor = Colors.white70,
    this.blur = 20,
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
  final Gradient? backgroundGradient;
  final Color selectedItemBackgroundColor;
  final Gradient? selectedItemGradient;
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
    Gradient? backgroundGradient,
    Color? selectedItemBackgroundColor,
    Gradient? selectedItemGradient,
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
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      selectedItemBackgroundColor:
          selectedItemBackgroundColor ?? this.selectedItemBackgroundColor,
      selectedItemGradient: selectedItemGradient ?? this.selectedItemGradient,
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
