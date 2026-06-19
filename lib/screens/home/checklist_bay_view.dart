import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/checklist_models.dart';
import '../../domain/drill_log.dart';
import '../../state/deck_scope.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/efis_gauge.dart';
import '../../widgets/panel_card.dart';
import '../../widgets/throttle_button.dart';

class ChecklistBayView extends StatelessWidget {
  const ChecklistBayView({super.key});

  @override
  Widget build(BuildContext context) {
    final log = DeckScope.of(context);
    final cleared = log.clearedReferences;
    final ratio =
        (cleared.length / ChecklistLibrary.all.length).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
      children: [
        _summary(log, cleared.length, ratio),
        const SizedBox(height: 16),
        Text('CHECKLIST LIBRARY',
            style: PanelType.label(color: PanelPalette.readoutSoft)),
        const SizedBox(height: 12),
        ...ChecklistLibrary.all.map((c) => _checklistTile(context, c,
            cleared.contains(c.id))),
        const SizedBox(height: 14),
        Text(
          'Checklists are simplified training references inspired by airline procedures and are not approved for real-world operation.',
          style: PanelType.caption(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _summary(DrillLog log, int cleared, double ratio) {
    return PanelCard(
      child: Row(
        children: [
          EfisGauge(
            size: 92,
            value: ratio,
            arc: PanelPalette.green,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$cleared',
                    style: PanelType.readout(22, color: PanelPalette.green)),
                Text('CLEARED', style: PanelType.caption()),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FLIGHT DECK STATUS', style: PanelType.heading()),
                const SizedBox(height: 8),
                _stat('${log.totalDrills} drills run',
                    Icons.timeline_rounded, PanelPalette.cyan),
                const SizedBox(height: 4),
                _stat('${log.passedDrills} decisions correct',
                    Icons.verified_rounded, PanelPalette.green),
                const SizedBox(height: 4),
                _stat('${ChecklistLibrary.all.length} checklists on file',
                    Icons.checklist_rounded, PanelPalette.amber),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 7),
        Flexible(
          child: Text(text,
              style: PanelType.bodyStrong(color: PanelPalette.readout),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _checklistTile(BuildContext context, Checklist c, bool cleared) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PanelCard(
        onTap: () => _runChecklist(context, c),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PanelPalette.panel,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: c.memoryItem
                        ? PanelPalette.alert
                        : PanelPalette.hairline,
                    width: 1.2),
              ),
              child: Icon(
                  c.memoryItem
                      ? Icons.priority_high_rounded
                      : Icons.list_alt_rounded,
                  color:
                      c.memoryItem ? PanelPalette.alert : PanelPalette.amber,
                  size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title,
                      style: PanelType.bodyStrong(color: PanelPalette.readout)),
                  const SizedBox(height: 3),
                  Text(
                      '${c.phase} · ${c.steps.length} items${c.memoryItem ? ' · MEMORY' : ''}',
                      style: PanelType.caption()),
                ],
              ),
            ),
            Icon(
                cleared
                    ? Icons.task_alt_rounded
                    : Icons.chevron_right_rounded,
                color: cleared
                    ? PanelPalette.green
                    : PanelPalette.readoutFaint),
          ],
        ),
      ),
    );
  }

  void _runChecklist(BuildContext context, Checklist c) {
    final log = DeckScope.read(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: PanelPalette.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) => _ChecklistRunner(checklist: c, log: log),
    );
  }
}

class _ChecklistRunner extends StatefulWidget {
  final Checklist checklist;
  final DrillLog log;
  const _ChecklistRunner({required this.checklist, required this.log});

  @override
  State<_ChecklistRunner> createState() => _ChecklistRunnerState();
}

class _ChecklistRunnerState extends State<_ChecklistRunner> {
  final Set<int> _done = {};
  bool _recorded = false;

  void _toggle(int i) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_done.contains(i)) {
        _done.remove(i);
      } else {
        _done.add(i);
      }
    });
  }

  Future<void> _complete() async {
    HapticFeedback.mediumImpact();
    if (!_recorded) {
      _recorded = true;
      await widget.log.record(
        kind: 'CHECKLIST',
        reference: widget.checklist.id,
        label: widget.checklist.title,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.checklist;
    final allDone = _done.length == c.steps.length;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PanelPalette.bezel,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(c.title,
                        style: PanelType.title(color: PanelPalette.amber)),
                  ),
                  if (c.memoryItem)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: PanelPalette.alertGlow,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: PanelPalette.alert, width: 1),
                      ),
                      child: Text('MEMORY',
                          style:
                              PanelType.caption(color: PanelPalette.alert)),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              ...List.generate(c.steps.length, (i) => _stepRow(i, c.steps[i])),
              const SizedBox(height: 18),
              ThrottleButton(
                label: allDone ? 'Checklist complete' : 'Confirm all items',
                tone:
                    allDone ? PanelPalette.green : PanelPalette.readoutFaint,
                onPressed: allDone ? _complete : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepRow(int i, ChecklistStep step) {
    final done = _done.contains(i);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _toggle(i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: done ? PanelPalette.greenGlow : PanelPalette.panelRaised,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
                color: done ? PanelPalette.green : PanelPalette.hairline,
                width: 1),
          ),
          child: Row(
            children: [
              Icon(
                  done
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color:
                      done ? PanelPalette.green : PanelPalette.readoutFaint,
                  size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(step.call,
                    style: PanelType.bodyStrong(color: PanelPalette.readout)),
              ),
              Text(step.response,
                  style: PanelType.readout(12, color: PanelPalette.amber)),
            ],
          ),
        ),
      ),
    );
  }
}
