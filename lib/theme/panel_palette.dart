import 'package:flutter/material.dart';

class PanelPalette {
  static const Color voidBlack = Color(0xFF05070A);
  static const Color panel = Color(0xFF0D1218);
  static const Color panelRaised = Color(0xFF141C26);
  static const Color bezel = Color(0xFF1E2A38);
  static const Color hairline = Color(0xFF2A3A4C);

  static const Color readout = Color(0xFFE6F0F4);
  static const Color readoutSoft = Color(0xFF8FA6B4);
  static const Color readoutFaint = Color(0xFF566977);

  static const Color amber = Color(0xFFFFB02E);
  static const Color amberGlow = Color(0xFF3A2A0A);
  static const Color green = Color(0xFF35E08A);
  static const Color greenGlow = Color(0xFF0C2A1C);
  static const Color cyan = Color(0xFF38D6E0);

  static const Color alert = Color(0xFFFF4D43);
  static const Color alertGlow = Color(0xFF3A1110);
  static const Color caution = Color(0xFFFFC247);

  static const RadialGradient cockpitGlow = RadialGradient(
    center: Alignment(0, -0.35),
    radius: 1.25,
    colors: [Color(0xFF101822), Color(0xFF05070A)],
  );
}
