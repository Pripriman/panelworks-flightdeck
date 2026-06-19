import 'package:flutter/material.dart';

import 'domain/drill_log.dart';
import 'screens/preflight_gate_screen.dart';
import 'state/deck_scope.dart';
import 'theme/panel_theme.dart';

class FlightDeckApp extends StatelessWidget {
  final DrillLog drills;
  const FlightDeckApp({super.key, required this.drills});

  @override
  Widget build(BuildContext context) {
    return DeckScope(
      drills: drills,
      child: MaterialApp(
        title: 'Mayday Flight Engineer',
        debugShowCheckedModeBanner: false,
        theme: PanelTheme.build(),
        home: const PreflightGateScreen(),
      ),
    );
  }
}
