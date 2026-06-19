import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/panel_palette.dart';

class EfisGauge extends StatelessWidget {
  final double size;
  final double value;
  final Color arc;
  final double stroke;
  final Widget? center;

  const EfisGauge({
    super.key,
    required this.size,
    required this.value,
    this.arc = PanelPalette.green,
    this.stroke = 10,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(value.clamp(0, 1).toDouble(), arc, stroke),
        child: Center(child: center),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color arc;
  final double stroke;
  _GaugePainter(this.value, this.arc, this.stroke);

  static const _start = math.pi * 0.75;
  static const _sweep = math.pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = PanelPalette.bezel;
    canvas.drawArc(rect, _start, _sweep, false, track);

    final tickPaint = Paint()
      ..color = PanelPalette.readoutFaint
      ..strokeWidth = 1.4;
    for (var i = 0; i <= 10; i++) {
      final a = _start + _sweep * (i / 10);
      final outer = center + Offset(math.cos(a), math.sin(a)) * (radius + 2);
      final inner = center + Offset(math.cos(a), math.sin(a)) * (radius - 5);
      canvas.drawLine(inner, outer, tickPaint);
    }

    if (value > 0) {
      final live = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = arc;
      canvas.drawArc(rect, _start, _sweep * value, false, live);

      final glow = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke + 6
        ..strokeCap = StrokeCap.round
        ..color = arc.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(rect, _start, _sweep * value, false, glow);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.value != value || old.arc != arc || old.stroke != stroke;
}
