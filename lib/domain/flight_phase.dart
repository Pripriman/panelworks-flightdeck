import '../theme/panel_palette.dart';
import 'package:flutter/material.dart';

enum FlightPhase { ground, takeoff, climb, cruise, turbulence, descent, landing }

class PhaseSnapshot {
  final FlightPhase phase;
  final int altFt;
  final int spdKts;
  final double load;
  final int headingDeg;

  const PhaseSnapshot({
    required this.phase,
    required this.altFt,
    required this.spdKts,
    required this.load,
    required this.headingDeg,
  });
}

extension FlightPhaseInfo on FlightPhase {
  String get tag {
    switch (this) {
      case FlightPhase.ground:
        return 'GROUND';
      case FlightPhase.takeoff:
        return 'TAKEOFF';
      case FlightPhase.climb:
        return 'CLIMB';
      case FlightPhase.cruise:
        return 'CRUISE';
      case FlightPhase.turbulence:
        return 'TURBULENCE';
      case FlightPhase.descent:
        return 'DESCENT';
      case FlightPhase.landing:
        return 'LANDING';
    }
  }

  String get crewLine {
    switch (this) {
      case FlightPhase.ground:
        return 'Engines spooled, systems armed, awaiting clearance.';
      case FlightPhase.takeoff:
        return 'Thrust set. Monitoring for V1 and rotate.';
      case FlightPhase.climb:
        return 'Positive rate, gear up, climbing to cruise altitude.';
      case FlightPhase.cruise:
        return 'Level at altitude, autopilot engaged, fuel monitored.';
      case FlightPhase.turbulence:
        return 'Riding moving air. Seatbelt signs on, speed adjusted.';
      case FlightPhase.descent:
        return 'Power back, energy managed, briefing the approach.';
      case FlightPhase.landing:
        return 'Gear down, three greens, configured for touchdown.';
    }
  }

  Color get tint {
    switch (this) {
      case FlightPhase.takeoff:
      case FlightPhase.landing:
        return PanelPalette.amber;
      case FlightPhase.turbulence:
        return PanelPalette.alert;
      case FlightPhase.cruise:
      case FlightPhase.climb:
        return PanelPalette.green;
      default:
        return PanelPalette.cyan;
    }
  }
}
