import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FuckAroundWithPaths extends CustomPainter {
  final Paint _paint;
  final Color color;
  final double dist;
  final AnimationController _controller;
  FuckAroundWithPaths(this._controller, this.color, this.dist)
      : _paint = Paint()
          ..color = color.withOpacity(.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
        super(repaint: _controller);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    Path path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 200, height: 200),
        const Radius.circular(30),
      ),
    );
    // canvas.drawPath(path, _paint);
    final metrices = path.computeMetrics().toList();
    final Path p2 = Path();
    for (PathMetric mat in metrices) {
      double len = mat.length;
      final start = (len) * _controller.value + dist;
      final gap = len / 2;
      final end = start + gap;
      final p1 = mat.extractPath(start, end);
      p2.addPath(p1, Offset.zero);
      if (end > len) {
        p2.addPath(mat.extractPath(start - len, end - len), Offset.zero);
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

  _angleToRadian(double angle) => angle * pi / 180.0;

  _buildLowerTransformOrange(Vector3 shifts, double dist) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_angleToRadian(45))
        ..rotateY(_angleToRadian(0))
        ..rotateZ(_angleToRadian(-45))
        ..translate(shifts),
      child: _buildChildElement(
        angles: [0.0, -pi / 4, pi / 4],
        color: Colors.orange,
        dist: dist,
        alignemtAxis: Alignment.center,
        translate: Vector3(0.0, 0.0, 0.0),
      ),
    );
  }

  _buildLowerTransformBlue(Vector3 shifts, double dist) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_angleToRadian(45))
        ..rotateY(_angleToRadian(45))
        ..rotateZ(_angleToRadian(0))
        ..translate(shifts),
      child: _buildChildElement(
        angles: [0.0, -pi / 4, pi / 4],
        color: Colors.blue,
        dist: dist,
        alignemtAxis: Alignment.center,
        translate: Vector3(0.0, 0.0, 0.0),
      ),
    );
  }

  _buildLowerTransformRed(Vector3 shifts, dist) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_angleToRadian(-45))
        ..rotateY(_angleToRadian(45))
        ..rotateZ(_angleToRadian(0))
        ..translate(shifts),
      child: _buildChildElement(
        angles: [0, pi / 4, -pi / 4],
        color: Colors.red,
        dist: dist,
        alignemtAxis: Alignment.center,
        translate: Vector3(0.0, 0.0, 0.0),
      ),
    );
  }

  _buildChildElements() {
    double distGap = 20.0;
    return Stack(
      children: [
        // we need 3 rectangles
        _buildLowerTransformBlue(Vector3(0.0, 0.0, -60.0), 7 * distGap),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, -40.0), 6 * distGap),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, -20.0), 5 * distGap),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 0.0), 4 * distGap),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 20.0), 3 * distGap),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 40.0), 2 * distGap),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 60.0), 1 * distGap),

        _buildLowerTransformOrange(Vector3(0.0, 0.0, -60.0), 7 * distGap),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, -40.0), 6 * distGap),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, -20.0), 4 * distGap),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 0.0), 4 * distGap),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 20.0), 3 * distGap),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 40.0), 2 * distGap),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 60.0), 1 * distGap),

        _buildLowerTransformRed(Vector3(0.0, 0.0, -60.0), 7 * distGap),
        _buildLowerTransformRed(Vector3(0.0, 0.0, -40.0), 6 * distGap),
        _buildLowerTransformRed(Vector3(0.0, 0.0, -20.0), 5 * distGap),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 0.0), 4 * distGap),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 20.0), 3 * distGap),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 40.0), 2 * distGap),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 60.0), 1 * distGap),
      ],
    );
  }

  _buildChildElement({
    required List<double> angles,
    required Color color,
    required double dist,
    required Vector3 translate,
    required Alignment alignemtAxis,
  }) {
    return Container(
      // transform: Matrix4.identity()..translate(vector),
      // transform: Matrix4.identity()
      //   ..rotateX(angles[0])
      //   ..rotateY(angles[1])
      //   ..rotateZ(angles[2])
      //   ..translate(translate),
      // transformAlignment: alignemtAxis,
      decoration: BoxDecoration(
        // color: color.withOpacity(.4),
        // border: Border.all(color: Colors.pink),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: FuckAroundWithPaths(_controller, color, dist),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildChildElements();
  }
}
