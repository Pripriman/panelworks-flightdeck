import 'package:flutter/material.dart';

import '../../domain/scenario_deck.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/panel_card.dart';

class CasebookView extends StatefulWidget {
  const CasebookView({super.key});

  @override
  State<CasebookView> createState() => _CasebookViewState();
}

class _CasebookViewState extends State<CasebookView> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
      children: [
        PanelCard(
          color: PanelPalette.panel,
          border: Border.all(color: PanelPalette.cyan, width: 1),
          child: Row(
            children: [
              const Icon(Icons.school_rounded, color: PanelPalette.cyan),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'PRO MODE — step into real cockpits. Read the situation, then reveal the captain decision that wrote aviation history.',
                  style: PanelType.bodyStrong(color: PanelPalette.readout),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...ScenarioDeck.casebook.map(_caseCard),
      ],
    );
  }

  Widget _caseCard(HistoricalCase c) {
    final open = _openId == c.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PanelCard(
        onTap: () => setState(() => _openId = open ? null : c.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(c.name.toUpperCase(),
                      style: PanelType.heading(color: PanelPalette.amber)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: PanelPalette.bezel,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(c.year,
                      style: PanelType.readout(12, color: PanelPalette.cyan)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(c.summary, style: PanelType.body()),
            if (open) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PanelPalette.greenGlow,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: PanelPalette.green, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flag_rounded,
                        size: 18, color: PanelPalette.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(c.decision,
                          style: PanelType.bodyStrong(
                              color: PanelPalette.readout)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(open ? 'HIDE DECISION' : 'REVEAL DECISION',
                    style: PanelType.caption(color: PanelPalette.amber)),
                Icon(
                    open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: PanelPalette.amber),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
