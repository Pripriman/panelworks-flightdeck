import 'package:flutter/material.dart';

import '../../domain/scenario_deck.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/panel_card.dart';

class CabinGuideView extends StatelessWidget {
  const CabinGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final cues = ScenarioDeck.cabinGuide;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
      itemCount: cues.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (i == cues.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'A calm passenger reads the flight. Match the sound or sensation to the phase and you will know exactly what the crew is doing.',
              style: PanelType.caption(),
              textAlign: TextAlign.center,
            ),
          );
        }
        return _cueCard(cues[i], i);
      },
    );
  }

  Widget _cueCard(PassengerCue cue, int i) {
    return PanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: PanelPalette.panel,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: PanelPalette.cyan, width: 1),
                ),
                child: Text('${i + 1}',
                    style: PanelType.readout(14, color: PanelPalette.cyan)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(cue.phase,
                    style:
                        PanelType.heading(color: PanelPalette.readout)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.hearing_rounded,
                  size: 16, color: PanelPalette.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(cue.feeling,
                    style: PanelType.bodyStrong(color: PanelPalette.amber)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(cue.deck, style: PanelType.body()),
        ],
      ),
    );
  }
}
