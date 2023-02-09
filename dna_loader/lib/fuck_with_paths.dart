import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FuckAroundWithPaths extends CustomPainter {
  final Paint _paint;
  final Color color;
  final AnimationController _controller;
  FuckAroundWithPaths(this._controller, this.color)
      : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5,
        super(repaint: _controller);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    Path path = Path();
    final center = Offset(size.width / 2 - 25, size.height / 2 - 100);
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 200, height: 200),
        const Radius.circular(10),
      ),
    );
    final metrices = path.computeMetrics().toList();
    final Path p2 = Path();
    for (PathMetric mat in metrices) {
      final len = mat.length;
      final start = len * _controller.value;
      final gap = len / 2.5;
      final end = start + gap;
      final p1 = mat.extractPath(start, end);
      p2.addPath(p1, Offset.zero);
      if (end > len) {
        p2.addPath(mat.extractPath(0.0, end - len), Offset.zero);
      }
    }
    canvas.drawPath(p2, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PathFuckAround extends StatefulWidget {
  const PathFuckAround({super.key});

  @override
  State<PathFuckAround> createState() => _PathFuckAroundState();
}

class _PathFuckAroundState extends State<PathFuckAround> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int cnt = 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller
      ..forward()
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _buildChildElements() {
    return Stack(
      children: [
        _buildChildElement(Vector3(-10.0, -10.0, 10.0), Colors.pink),
        _buildChildElement(Vector3(-20.0, -20.0, 30.0), Colors.blue),
        _buildChildElement(Vector3(-30.0, -30.0, 50.0), Colors.orange),
        _buildChildElement(Vector3(-40.0, -40.0, 70.0), Colors.purple),
      ],
    );
  }

  _buildChildElement(Vector3 vector, Color color) {
    return Container(
      transform: Matrix4.identity()..translate(vector),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomPaint(
        painter: FuckAroundWithPaths(_controller, color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Transform(
          transform: Matrix4.identity()
            ..rotateZ(0)
            ..rotateX(pi / 6)
            ..rotateY(-pi / 6)
            ..translate(80.0, 150),
          child: _buildChildElements(),
        ),
        // more work to do..
      ],
    );
  }
}
