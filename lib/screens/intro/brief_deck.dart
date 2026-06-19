import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/panel_palette.dart';
import '../../theme/panel_type.dart';
import '../../widgets/hud_frame.dart';
import '../../widgets/throttle_button.dart';

class _Brief {
  final IconData icon;
  final String tag;
  final String title;
  final String body;
  final Color tone;
  const _Brief(this.icon, this.tag, this.title, this.body, this.tone);
}

class BriefDeck extends StatefulWidget {
  final VoidCallback onDone;
  const BriefDeck({super.key, required this.onDone});

  @override
  State<BriefDeck> createState() => _BriefDeckState();
}

class _BriefDeckState extends State<BriefDeck> {
  final _controller = PageController();
  int _index = 0;

  static const _briefs = [
    _Brief(
      Icons.flight_takeoff_rounded,
      'PHASE 01',
      'Fly along with the deck',
      'Turn your seat into a flight deck. The app reads your phone sensors and walks the real phases of flight — taxi, rotate, climb, cruise and approach.',
      PanelPalette.green,
    ),
    _Brief(
      Icons.warning_amber_rounded,
      'PHASE 02',
      'Run the emergency',
      'A failure is called out at altitude. You pick the right checklist from three — reject, continue or hold — and the deck debriefs your decision.',
      PanelPalette.amber,
    ),
    _Brief(
      Icons.menu_book_rounded,
      'PHASE 03',
      'Learn from the legends',
      'Step into the seat of Gimli Glider and the Hudson. Real incidents, real call-outs, and the captain decision that saved the day.',
      PanelPalette.cyan,
    ),
    _Brief(
      Icons.vibration_rounded,
      'PHASE 04',
      'Feel every cue',
      'Haptic feedback simulates the buffet of a high angle of attack, so the rumble in the cabin stops being scary and starts making sense.',
      PanelPalette.amber,
    ),
  ];

  bool get _last => _index == _briefs.length - 1;

  void _next() {
    HapticFeedback.selectionClick();
    if (_last) {
      widget.onDone();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PanelPalette.cockpitGlow),
        child: Stack(
          children: [
            const HudGrid(),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: AnimatedOpacity(
                        opacity: _last ? 0 : 1,
                        duration: const Duration(milliseconds: 180),
                        child: PanelLink(
                          label: 'Skip brief',
                          onPressed: _last ? null : widget.onDone,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _briefs.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (context, i) => _page(_briefs[i]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_briefs.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 24 : 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? PanelPalette.amber
                              : PanelPalette.bezel,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 22, 28, 26),
                    child: ThrottleButton(
                      label: _last ? 'Take the controls' : 'Next',
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _page(_Brief b) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              color: PanelPalette.panel,
              shape: BoxShape.circle,
              border: Border.all(color: b.tone, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: b.tone.withValues(alpha: 0.22),
                  blurRadius: 30,
                  spreadRadius: -6,
                ),
              ],
            ),
            child: Icon(b.icon, size: 60, color: b.tone),
          ),
          const SizedBox(height: 34),
          Text(b.tag, style: PanelType.label(color: b.tone)),
          const SizedBox(height: 12),
          Text(b.title,
              style: PanelType.title(), textAlign: TextAlign.center),
          const SizedBox(height: 14),
          Text(b.body, style: PanelType.body(), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
