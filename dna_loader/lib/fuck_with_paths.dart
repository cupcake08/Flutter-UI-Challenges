import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FuckAroundWithPaths extends CustomPainter {
  final Paint _paint;
  final Color color;
  final double dist;
  final AnimationController _controller;
  FuckAroundWithPaths(
    this._controller,
    this.color,
    this.dist,
  )   : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..blendMode = BlendMode.screen
          ..strokeCap = StrokeCap.butt,
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
    final metrices = path.computeMetrics().toList();
    final Path p2 = Path();
    for (PathMetric mat in metrices) {
      double len = mat.length;
      final start = (len) * _controller.value + dist;
      final gap = len / 2.5;
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
      duration: const Duration(milliseconds: 4500),
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

  _buildLowerTransformOrange(Vector3 shifts, double dist, Color color) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_angleToRadian(45))
        ..rotateY(_angleToRadian(0))
        ..rotateZ(_angleToRadian(-45))
        ..translate(shifts),
      child: _buildChildElement(
        angles: [0.0, -pi / 4, pi / 4],
        color: color,
        dist: dist,
        alignemtAxis: Alignment.center,
        translate: Vector3(0.0, 0.0, 0.0),
      ),
    );
  }

  _buildLowerTransformBlue(Vector3 shifts, double dist, Color color) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_angleToRadian(45))
        ..rotateY(_angleToRadian(45))
        ..rotateZ(_angleToRadian(0))
        ..translate(shifts),
      child: _buildChildElement(
        angles: [0.0, -pi / 4, pi / 4],
        color: color,
        dist: dist,
        alignemtAxis: Alignment.center,
        translate: Vector3(0.0, 0.0, 0.0),
      ),
    );
  }

  _buildLowerTransformRed(Vector3 shifts, dist, Color lineColor) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..rotateX(_angleToRadian(-45))
        ..rotateY(_angleToRadian(45))
        ..rotateZ(_angleToRadian(0))
        ..translate(shifts),
      child: _buildChildElement(
        angles: [0, pi / 4, -pi / 4],
        dist: dist,
        color: lineColor,
        alignemtAxis: Alignment.center,
        translate: Vector3(0.0, 0.0, 0.0),
      ),
    );
  }

  _buildChildElements() {
    double distGap = 15.0;
    return Stack(
      children: [
        // we need 3 rectangles

        _buildLowerTransformRed(Vector3(0.0, 0.0, -65.0), 6 * distGap, Colors.red),
        _buildLowerTransformRed(Vector3(0.0, 0.0, -45.0), 5 * distGap, const Color.fromARGB(255, 244, 67, 54)),
        _buildLowerTransformRed(Vector3(0.0, 0.0, -25.0), 4 * distGap, const Color.fromARGB(255, 197, 69, 46)),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 0.0), 3 * distGap, const Color.fromARGB(255, 188, 60, 18)),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 25.0), 2 * distGap, const Color.fromARGB(255, 196, 149, 67)),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 45.0), 1 * distGap, const Color.fromARGB(255, 195, 214, 54)),
        _buildLowerTransformRed(Vector3(0.0, 0.0, 65.0), 0 * distGap, const Color.fromARGB(255, 202, 215, 100)),

        _buildLowerTransformBlue(Vector3(0.0, 0.0, -65.0), 0 * distGap, const Color.fromARGB(255, 187, 33, 243)),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, -45.0), 1 * distGap, const Color.fromARGB(255, 209, 45, 224)),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, -25.0), 2 * distGap, const Color.fromARGB(255, 139, 40, 238)),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 0.0), 3 * distGap, const Color.fromARGB(255, 120, 36, 230)),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 25.0), 4 * distGap, const Color.fromARGB(255, 33, 90, 240)),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 45.0), 5 * distGap, const Color.fromARGB(255, 33, 107, 240)),
        _buildLowerTransformBlue(Vector3(0.0, 0.0, 65.0), 6 * distGap, Colors.blue),

        _buildLowerTransformOrange(Vector3(0.0, 0.0, -65.0), 6 * distGap, const Color.fromARGB(255, 111, 220, 115)),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, -45.0), 5 * distGap, const Color.fromARGB(255, 76, 175, 107)),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, -25.0), 4 * distGap, const Color.fromARGB(255, 76, 175, 112)),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 0.0), 3 * distGap, const Color.fromARGB(255, 76, 175, 140)),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 25.0), 2 * distGap, const Color.fromARGB(255, 76, 175, 147)),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 45.0), 1 * distGap, const Color.fromARGB(255, 76, 175, 168)),
        _buildLowerTransformOrange(Vector3(0.0, 0.0, 65.0), 0 * distGap, const Color.fromARGB(255, 40, 192, 200)),
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
    return SizedBox(
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
