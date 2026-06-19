import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/scenario_deck.dart';
import '../../state/deck_scope.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/panel_card.dart';
import '../../widgets/throttle_button.dart';

class FailureDrillView extends StatefulWidget {
  const FailureDrillView({super.key});

  @override
  State<FailureDrillView> createState() => _FailureDrillViewState();
}

class _FailureDrillViewState extends State<FailureDrillView> {
  int _index = 0;
  int? _picked;
  bool _logged = false;

  Scenario get _scenario => ScenarioDeck.drills[_index];

  void _pick(int i) {
    if (_picked != null) return;
    final opt = _scenario.options[i];
    if (opt.correct) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    setState(() => _picked = i);
    if (!_logged) {
      _logged = true;
      DeckScope.read(context).record(
        kind: 'DRILL',
        reference: _scenario.id,
        label: _scenario.callout,
        passed: opt.correct,
      );
    }
  }

  void _next() {
    setState(() {
      _index = (_index + 1) % ScenarioDeck.drills.length;
      _picked = null;
      _logged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = _scenario;
    final answered = _picked != null;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
      children: [
        PanelCard(
          glow: PanelPalette.alert.withValues(alpha: 0.18),
          border: Border.all(color: PanelPalette.alert, width: 1.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: PanelPalette.alert, size: 20),
                  const SizedBox(width: 8),
                  Text(s.phase,
                      style: PanelType.label(color: PanelPalette.alert)),
                ],
              ),
              const SizedBox(height: 12),
              Text(s.callout,
                  style: PanelType.instrument(18, color: PanelPalette.alert)),
              const SizedBox(height: 12),
              Text(s.situation, style: PanelType.body()),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('SELECT THE CHECKLIST',
            style: PanelType.label(color: PanelPalette.readoutSoft)),
        const SizedBox(height: 12),
        ...List.generate(s.options.length, (i) => _optionTile(i, answered)),
        if (answered) ...[
          const SizedBox(height: 6),
          _debrief(),
          const SizedBox(height: 16),
          ThrottleButton(
            label: 'Next drill',
            icon: Icons.skip_next_rounded,
            onPressed: _next,
          ),
        ],
      ],
    );
  }

  Widget _optionTile(int i, bool answered) {
    final opt = _scenario.options[i];
    Color border = PanelPalette.hairline;
    Color tone = PanelPalette.readout;
    IconData? mark;
    if (answered) {
      if (opt.correct) {
        border = PanelPalette.green;
        tone = PanelPalette.green;
        mark = Icons.check_circle_rounded;
      } else if (i == _picked) {
        border = PanelPalette.alert;
        tone = PanelPalette.alert;
        mark = Icons.cancel_rounded;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PanelCard(
        onTap: answered ? null : () => _pick(i),
        border: Border.all(color: border, width: 1.2),
        child: Row(
          children: [
            Expanded(
              child: Text(opt.label, style: PanelType.bodyStrong(color: tone)),
            ),
            if (mark != null) Icon(mark, color: tone, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _debrief() {
    final opt = _scenario.options[_picked!];
    final ok = opt.correct;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ok ? PanelPalette.greenGlow : PanelPalette.amberGlow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: ok ? PanelPalette.green : PanelPalette.caution, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ok ? Icons.verified_rounded : Icons.info_outline_rounded,
              size: 18,
              color: ok ? PanelPalette.green : PanelPalette.caution),
          const SizedBox(width: 10),
          Expanded(
            child: Text(opt.debrief, style: PanelType.body()),
          ),
        ],
      ),
    );
  }
}
