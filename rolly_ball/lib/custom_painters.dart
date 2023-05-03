import 'package:flutter/material.dart';
import 'dart:math' as math show pi, min, cos, sin, atan2;

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

  List<Offset> calculateTrianglePoints(Offset center, Offset target) {
    const double radius = 15;
    final double angle = math.atan2(target.dy - center.dy, target.dx - center.dx);
    final double x1 = center.dx + radius * math.cos(angle - math.pi / 6);
    final double y1 = center.dy + radius * math.sin(angle - math.pi / 6);
    final double x2 = center.dx + radius * math.cos(angle + math.pi / 6);
    final double y2 = center.dy + radius * math.sin(angle + math.pi / 6);

    return [
      center,
      Offset(x1, y1),
      Offset(x2, y2),
      // Offset(x1, y1),
      // center,
      // Offset(x2, y2),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

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
    final wLen = length * .4;
    final tangent = metrics.getTangentForOffset(wLen);
    final point = tangent!.position;
    point.log();
    canvas.drawPath(path, _paint);
    final p = metrics.extractPath(0, wLen);
    canvas.drawPath(p, _strokePaint);
    _innerPaint.color = Colors.white;
    canvas.drawCircle(point, _paint.strokeWidth / 2, _innerPaint);

    // _paint.color = Colors.purpleAccent;
    // _paint.strokeWidth = 5;
    // final sw = _paint.strokeWidth;
    // final a = (sw + 30) * math.cos(tangent.angle);
    // final b = (sw + 30) * math.sin(tangent.angle);
    // final workPoint = point + Offset(a, b);
    // workPoint.log();
    // final offset = Offset(point.dx + 15, point.dy + 30);
    // final List<Offset> points = calculateTrianglePoints(point, workPoint);
    // // final List<Offset> points = [offset];
    // canvas.drawPoints(
    //   PointMode.points,
    //   points,
    //   _paint,
    // );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class InnerCircle extends CustomPainter {
  final Paint _paint;
  InnerCircle() : _paint = Paint()..color = Colors.grey;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final w = size.width;
    final h = size.height;
    final majorRadius = math.min(w, h) / 2 * .5;
    final center = Offset(w / 2, h / 2);
    final radius = math.min(w, h) * .5;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final path = Path();
    path.addOval(rect);
    canvas.drawShadow(path, Colors.white, 10, false);
    canvas.drawPath(path, _paint);
    _paint.color = Colors.black;
    canvas.drawCircle(center, radius * .2, _paint);
    _paint
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius / 3, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
