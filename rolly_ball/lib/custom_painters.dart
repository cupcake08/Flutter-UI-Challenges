import 'package:flutter/material.dart';
import 'dart:math' as math show pi;

class OuterCircle extends CustomPainter {
  final Paint _paint, _innerPaint;
  final Paint _strokePaint;
  final ValueNotifier<double> shift;

  OuterCircle(this.shift)
      : _paint = Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 30,
        _innerPaint = Paint()..color = Colors.grey,
        _strokePaint = Paint()
          ..color = Colors.purpleAccent
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 30,
        super(repaint: shift);

  double lerp(double min, double max) => min + (max - min) * shift.value;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final rect = Rect.fromCenter(center: center, width: w * .7, height: w * .7);

    final paint = Paint()
      ..strokeWidth = 9.0
      ..shader = RadialGradient(
        radius: lerp(0.0, 2.0),
        colors: const [
          Colors.purple,
          Colors.transparent,
        ],
      ).createShader(rect);
    canvas.drawPaint(paint);
    final path = Path();
    path.addArc(
      rect,
      3 * math.pi / 4,
      3 * math.pi / 2,
    );

    final metrics = path.computeMetrics().first;
    final length = metrics.length;
    final wLen = length * shift.value;
    final tangent = metrics.getTangentForOffset(wLen);
    final point = tangent!.position;
    canvas.drawPath(path, _paint);
    final p = metrics.extractPath(0, wLen);
    canvas.drawPath(p, _strokePaint);
    _innerPaint.color = Colors.white;
    canvas.drawCircle(point, _paint.strokeWidth / 2, _innerPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
