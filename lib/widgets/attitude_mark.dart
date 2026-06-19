import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/panel_palette.dart';

class AttitudeMark extends StatelessWidget {
  final double size;
  final Color color;
  final double bank;

  const AttitudeMark({
    super.key,
    this.size = 48,
    this.color = PanelPalette.green,
    this.bank = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: bank * math.pi / 180,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _MarkPainter(color)),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final Color color;
  _MarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final line = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final cx = w * 0.5;
    final cy = h * 0.5;

    canvas.drawCircle(Offset(cx, cy), w * 0.10, line);
    canvas.drawLine(Offset(w * 0.16, cy), Offset(w * 0.36, cy), line);
    canvas.drawLine(Offset(w * 0.64, cy), Offset(w * 0.84, cy), line);
    canvas.drawLine(Offset(cx, h * 0.16), Offset(cx, h * 0.30), line);

    final wedge = Paint()..color = color;
    final path = Path()
      ..moveTo(cx, h * 0.34)
      ..lineTo(cx - w * 0.06, h * 0.46)
      ..lineTo(cx + w * 0.06, h * 0.46)
      ..close();
    canvas.drawPath(path, wedge);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter old) => old.color != color;
}
