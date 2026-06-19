import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../domain/flight_phase.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/attitude_mark.dart';
import '../../widgets/efis_gauge.dart';
import '../../widgets/panel_card.dart';
import '../../widgets/throttle_button.dart';

class FlightModeView extends StatefulWidget {
  const FlightModeView({super.key});

  @override
  State<FlightModeView> createState() => _FlightModeViewState();
}

class _FlightModeViewState extends State<FlightModeView> {
  static const _phases = [
    FlightPhase.ground,
    FlightPhase.takeoff,
    FlightPhase.climb,
    FlightPhase.cruise,
    FlightPhase.turbulence,
    FlightPhase.descent,
    FlightPhase.landing,
  ];

  StreamSubscription<AccelerometerEvent>? _sub;
  bool _flying = false;
  int _idx = 0;
  double _buffet = 0;
  double _bank = 0;
  Timer? _advance;

  @override
  void dispose() {
    _sub?.cancel();
    _advance?.cancel();
    super.dispose();
  }

  PhaseSnapshot get _snapshot {
    final phase = _phases[_idx];
    final r = math.Random(_idx + 7);
    final alt = switch (phase) {
      FlightPhase.ground => 0,
      FlightPhase.takeoff => 1200,
      FlightPhase.climb => 14000,
      FlightPhase.cruise => 36000,
      FlightPhase.turbulence => 35200,
      FlightPhase.descent => 12000,
      FlightPhase.landing => 800,
    };
    final spd = switch (phase) {
      FlightPhase.ground => 0,
      FlightPhase.takeoff => 165,
      FlightPhase.climb => 290,
      FlightPhase.cruise => 470,
      FlightPhase.turbulence => 455,
      FlightPhase.descent => 320,
      FlightPhase.landing => 145,
    };
    return PhaseSnapshot(
      phase: phase,
      altFt: alt + r.nextInt(60),
      spdKts: spd,
      load: 1.0 + _buffet,
      headingDeg: 80 + _idx * 9,
    );
  }

  void _toggle() {
    if (_flying) {
      _stop();
    } else {
      _start();
    }
  }

  void _start() {
    setState(() {
      _flying = true;
      _idx = 0;
    });
    _sub = accelerometerEventStream(
            samplingPeriod: const Duration(milliseconds: 200))
        .listen(_onSample);
    _advance = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() {
        _idx = (_idx + 1) % _phases.length;
      });
      HapticFeedback.selectionClick();
      if (_phases[_idx] == FlightPhase.turbulence) {
        _buffetBurst();
      }
    });
  }

  void _stop() {
    _sub?.cancel();
    _advance?.cancel();
    setState(() {
      _flying = false;
      _buffet = 0;
      _bank = 0;
    });
  }

  void _onSample(AccelerometerEvent e) {
    final mag = (e.x.abs() + e.y.abs()) / 9.8;
    if (!mounted) return;
    setState(() {
      _buffet = (mag * 0.4).clamp(0, 1.6);
      _bank = (e.x * 3).clamp(-25, 25);
    });
  }

  Future<void> _buffetBurst() async {
    for (var i = 0; i < 5; i++) {
      HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 110));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _snapshot;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
      children: [
        PanelCard(
          glow: s.phase.tint.withValues(alpha: 0.16),
          border: Border.all(color: s.phase.tint, width: 1.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: s.phase.tint,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(s.phase.tag,
                      style: PanelType.instrument(20, color: s.phase.tint)),
                  const Spacer(),
                  Text(_flying ? 'LIVE' : 'STBY',
                      style: PanelType.label(
                          color: _flying
                              ? PanelPalette.green
                              : PanelPalette.readoutFaint)),
                ],
              ),
              const SizedBox(height: 12),
              Text(s.phase.crewLine, style: PanelType.body()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _gaugeTile('ALT', '${s.altFt}', 'FT',
                s.altFt / 40000, PanelPalette.cyan)),
            const SizedBox(width: 12),
            Expanded(child: _gaugeTile('SPD', '${s.spdKts}', 'KTS',
                s.spdKts / 500, PanelPalette.green)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PanelCard(
                child: Column(
                  children: [
                    Text('ATTITUDE',
                        style: PanelType.label(
                            color: PanelPalette.readoutFaint)),
                    const SizedBox(height: 12),
                    AttitudeMark(size: 84, bank: _bank, color: s.phase.tint),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _gaugeTile(
                  'LOAD',
                  s.load.toStringAsFixed(1),
                  'G',
                  (s.load - 0.5).clamp(0, 1),
                  s.load > 1.5 ? PanelPalette.alert : PanelPalette.amber),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ThrottleButton(
          label: _flying ? 'End flight' : 'Begin flight',
          icon: _flying ? Icons.stop_rounded : Icons.play_arrow_rounded,
          tone: _flying ? PanelPalette.alert : PanelPalette.amber,
          onPressed: _toggle,
        ),
        const SizedBox(height: 14),
        Text(
          'Phases are simulated from your device motion sensors for orientation and learning only — this is not a navigation or flight instrument.',
          style: PanelType.caption(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _gaugeTile(
      String label, String value, String unit, double frac, Color tone) {
    return PanelCard(
      child: Column(
        children: [
          Text(label,
              style: PanelType.label(color: PanelPalette.readoutFaint)),
          const SizedBox(height: 12),
          EfisGauge(
            size: 96,
            value: frac,
            arc: tone,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: PanelType.readout(20, color: tone)),
                Text(unit, style: PanelType.caption()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
