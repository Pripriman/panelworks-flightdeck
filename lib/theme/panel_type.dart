import 'package:flutter/material.dart';
import 'panel_palette.dart';

class PanelType {
  static TextStyle _t(
    FontWeight weight,
    double size, {
    double? height,
    double? spacing,
    Color? color,
  }) {
    return TextStyle(
      fontWeight: weight,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      color: color ?? PanelPalette.readout,
    );
  }

  static TextStyle display({Color? color}) =>
      _t(FontWeight.w800, 28, height: 1.05, spacing: 1.5, color: color);
  static TextStyle title({Color? color}) =>
      _t(FontWeight.w700, 20, height: 1.12, spacing: 1.2, color: color);
  static TextStyle heading({Color? color}) =>
      _t(FontWeight.w700, 16, height: 1.18, spacing: 0.6, color: color);
  static TextStyle body({Color? color}) => _t(FontWeight.w400, 14.5,
      height: 1.45, color: color ?? PanelPalette.readoutSoft);
  static TextStyle bodyStrong({Color? color}) =>
      _t(FontWeight.w600, 14.5, height: 1.45, color: color);
  static TextStyle label({Color? color}) => _t(FontWeight.w700, 11.5,
      spacing: 1.8, color: color ?? PanelPalette.readoutSoft);
  static TextStyle caption({Color? color}) => _t(FontWeight.w600, 11.5,
      spacing: 0.8, color: color ?? PanelPalette.readoutFaint);

  static TextStyle readout(double size, {Color? color, FontWeight? weight}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: weight ?? FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: 1.0,
        color: color ?? PanelPalette.green,
      );
  static TextStyle instrument(double size,
          {Color? color, double spacing = 3.0}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: spacing,
        color: color ?? PanelPalette.amber,
      );
}
