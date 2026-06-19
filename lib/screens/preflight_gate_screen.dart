import 'package:flutter/material.dart';

import '../runtime/phase_gate.dart';
import '../runtime/pulse_beacon.dart';
import '../theme/panel_palette.dart';
import '../theme/panel_type.dart';
import '../widgets/efis_gauge.dart';
import '../widgets/hud_frame.dart';
import 'content/flight_deck_view.dart';
import 'lost_link_screen.dart';
import 'native_root.dart';

class PreflightGateScreen extends StatefulWidget {
  const PreflightGateScreen({super.key});

  @override
  State<PreflightGateScreen> createState() => _PreflightGateScreenState();
}

class _PreflightGateScreenState extends State<PreflightGateScreen>
    with SingleTickerProviderStateMixin {
  late Future<GateVerdict> _verdict;
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _verdict = PhaseGate.resolve();
  }

  void _retry() {
    setState(() {
      _verdict = PhaseGate.resolve();
    });
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GateVerdict>(
      future: _verdict,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return _boot();
        }
        final result = snap.data ?? const GateVerdict(GateState.native);
        switch (result.state) {
          case GateState.lostLink:
            return LostLinkScreen(onRetry: _retry);
          case GateState.content:
            PulseBeacon.contentOpen();
            return FlightDeckView(endpoint: result.endpoint!);
          case GateState.native:
            return const NativeRoot();
        }
      },
    );
  }

  Widget _boot() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PanelPalette.cockpitGlow),
        child: Stack(
          children: [
            const HudGrid(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _spin,
                    builder: (context, _) {
                      return EfisGauge(
                        size: 120,
                        value: _spin.value,
                        arc: PanelPalette.amber,
                        center: Text('SYS',
                            style: PanelType.readout(18,
                                color: PanelPalette.amber)),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  Text('RUNNING SELF-TEST',
                      style: PanelType.label(color: PanelPalette.readoutSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
