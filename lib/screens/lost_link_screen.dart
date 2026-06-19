import 'package:flutter/material.dart';
import '../theme/panel_palette.dart';
import '../theme/panel_type.dart';
import '../widgets/throttle_button.dart';

class LostLinkScreen extends StatelessWidget {
  final VoidCallback onRetry;
  const LostLinkScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PanelPalette.cockpitGlow),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: PanelPalette.alertGlow,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: PanelPalette.alert, width: 1.6),
                  ),
                  child: const Icon(Icons.wifi_off_rounded,
                      size: 36, color: PanelPalette.alert),
                ),
                const SizedBox(height: 24),
                Text('DATALINK LOST',
                    style: PanelType.title(color: PanelPalette.alert),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(
                  'The flight deck could not reach the data uplink. Check the network and re-establish the link.',
                  style: PanelType.body(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                ThrottleButton(
                  label: 'Re-establish',
                  icon: Icons.refresh_rounded,
                  expand: false,
                  tone: PanelPalette.amber,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
