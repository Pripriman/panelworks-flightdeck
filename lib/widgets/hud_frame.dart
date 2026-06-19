import 'package:flutter/material.dart';
import '../theme/panel_palette.dart';

class HudGrid extends StatelessWidget {
  final Color color;
  final double spacing;
  const HudGrid({super.key, this.color = PanelPalette.bezel, this.spacing = 26});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _GridPainter(color, spacing)),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  _GridPainter(this.color, this.spacing);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.16)
      ..strokeWidth = 0.6;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.color != color || old.spacing != spacing;
}

class HudCorners extends StatelessWidget {
  final Color color;
  final double inset;
  const HudCorners({super.key, this.color = PanelPalette.amber, this.inset = 0});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _CornerPainter(color, inset)),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double inset;
  _CornerPainter(this.color, this.inset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    const len = 16.0;
    final r = Rect.fromLTRB(
        inset, inset, size.width - inset, size.height - inset);
    canvas.drawLine(r.topLeft, r.topLeft + const Offset(len, 0), paint);
    canvas.drawLine(r.topLeft, r.topLeft + const Offset(0, len), paint);
    canvas.drawLine(r.topRight, r.topRight + const Offset(-len, 0), paint);
    canvas.drawLine(r.topRight, r.topRight + const Offset(0, len), paint);
    canvas.drawLine(r.bottomLeft, r.bottomLeft + const Offset(len, 0), paint);
    canvas.drawLine(r.bottomLeft, r.bottomLeft + const Offset(0, -len), paint);
    canvas.drawLine(r.bottomRight, r.bottomRight + const Offset(-len, 0), paint);
    canvas.drawLine(r.bottomRight, r.bottomRight + const Offset(0, -len), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) =>
      old.color != color || old.inset != inset;
}
