import 'package:flutter/material.dart';
import '../theme/panel_palette.dart';

class PanelCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final Border? border;
  final Color glow;

  const PanelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.onTap,
    this.border,
    this.glow = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? PanelPalette.panelRaised,
        borderRadius: BorderRadius.circular(8),
        border: border ?? Border.all(color: PanelPalette.hairline, width: 1),
        boxShadow: glow == Colors.transparent
            ? null
            : [
                BoxShadow(
                  color: glow,
                  blurRadius: 18,
                  spreadRadius: -2,
                ),
              ],
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
