import 'package:flutter/material.dart';
import 'dart:math' as math show pi, min;

import 'package:rolly_ball/extensions.dart';

class OuterCircle extends CustomPainter {
  final Paint _paint, _innerPaint;
  final Paint _strokePaint;
  final double shift;

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
          ..strokeWidth = 30;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final rect = Rect.fromCenter(center: center, width: w * .7, height: w * .7);
    final path = Path();
    path.addArc(
      rect,
      3 * math.pi / 4,
      3 * math.pi / 2,
    );
    final metrics = path.computeMetrics().first;
    final length = metrics.length;
    final wLen = length * shift;
    final tangent = metrics.getTangentForOffset(wLen);
    final point = tangent!.position;
    // canvas.drawCircle(center, w / 2 * .55, _innerPaint);
    canvas.drawPath(path, _paint);
    final p = metrics.extractPath(0, wLen);
    canvas.drawPath(p, _strokePaint);
    _innerPaint.color = Colors.white;
    canvas.drawCircle(point, _paint.strokeWidth / 2, _innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class InnerCircle extends CustomPainter {
  final Paint _paint;
  final double parts = 5;
  InnerCircle() : _paint = Paint()..color = Colors.grey;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = math.min(w, h) / 2 * .5;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final path = Path();
    final r1 = Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height * .3);
    canvas.drawArc(r1, math.pi, math.pi, false, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
