import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/panel_palette.dart';
import '../theme/panel_type.dart';

class ThrottleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final bool expand;
  final IconData? icon;
  final Color tone;

  const ThrottleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.expand = true,
    this.icon,
    this.tone = PanelPalette.amber,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final btn = AnimatedOpacity(
      opacity: enabled ? 1 : 0.5,
      duration: const Duration(milliseconds: 140),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: enabled
              ? () {
                  HapticFeedback.mediumImpact();
                  onPressed!();
                }
              : null,
          child: Ink(
            decoration: BoxDecoration(
              color: PanelPalette.panelRaised,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: tone, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: tone.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: busy
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: tone,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: tone, size: 19),
                          const SizedBox(width: 10),
                        ],
                        Text(label.toUpperCase(),
                            style: PanelType.label(color: tone)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class PanelLink extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PanelLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: PanelPalette.amber,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 7),
          ],
          Text(label.toUpperCase(),
              style: PanelType.label(color: PanelPalette.amber)),
        ],
      ),
    );
  }
}
