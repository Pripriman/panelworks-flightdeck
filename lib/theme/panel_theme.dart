import 'package:flutter/material.dart';
import 'panel_palette.dart';
import 'panel_type.dart';

class PanelTheme {
  static ThemeData build() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PanelPalette.amber,
      primary: PanelPalette.amber,
      secondary: PanelPalette.green,
      surface: PanelPalette.panel,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: PanelPalette.voidBlack,
      splashFactory: NoSplash.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: PanelPalette.readout,
      ),
      cardTheme: CardThemeData(
        color: PanelPalette.panelRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: PanelPalette.hairline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PanelPalette.panel,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: PanelType.body(color: PanelPalette.readoutFaint),
        prefixIconColor: PanelPalette.readoutSoft,
        border: _border(PanelPalette.hairline),
        enabledBorder: _border(PanelPalette.hairline),
        focusedBorder: _border(PanelPalette.amber),
        errorBorder: _border(PanelPalette.alert),
        focusedErrorBorder: _border(PanelPalette.alert),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: PanelPalette.bezel,
        contentTextStyle: PanelType.bodyStrong(color: PanelPalette.readout),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  static OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: c, width: 1.3),
      );
}
