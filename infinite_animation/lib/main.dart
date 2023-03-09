import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;
import 'dart:math' show pi, sin, cos, sqrt;

void main() {
  runApp(const MyApp());
}

extension Log on Object {
  void log() => dev.log(toString());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFECDAC3),
      body: InfiniteAnimation(),
    );
  }
}

class InfiniteAnimation extends StatefulWidget {
  const InfiniteAnimation({super.key});

  @override
  State<InfiniteAnimation> createState() => _InfiniteAnimationState();
}

class InfinitePath extends CustomPainter {
  final Paint _paint;
  final List<Offset> _points = [];
  final double centerShift;
  final bool reverse;
  final Color color;
  final double amp;
  final double dist;
  final AnimationController controller;
  final double sz1;
  final double sz2;

  InfinitePath(
    this.controller, {
    required this.color,
    required this.centerShift,
    required this.reverse,
    required this.sz1,
    required this.sz2,
  })  : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 10,
        amp = 100.0,
        dist = 200.0,
        super(repaint: controller);

  Offset leftandright(double t, double sz) {
    return Offset(g(t) * sz + (centerShift * (reverse ? -1 : 1)), f(t, sz));
  }

  double g(double t) {
    // (shift + size) or (only shift)
    return (amp * sqrt(2) * cos(t)) / s(t);
  }

  double s(double t) {
    return sin(t) * sin(t) + 1;
  }

  double f(double t, double sz) {
    // (only change when (shift + size) changes)
    return (amp * sqrt(2) * cos(t) * sin(t) * sz) / s(t);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final path = Path();
    if (_points.isEmpty) {
      for (double i = -(3 * pi / 2); i <= pi / 2; i += 0.01) {
        // -pi - 0
        //    -> case 1. shift + size
        //    -> case2. size
        // 0 - pi
        if (i >= -pi / 2 && i <= pi / 2) {
          // case: 0 -> pi
          _points.add(leftandright(i, sz2));
        } else {
          // case: -pi -> 0
          _points.add(leftandright(i, sz1));
        }
      }
    }

    path.addPolygon(_points, true);
    final pathMetric = path.computeMetrics().first;
    final start = pathMetric.length * controller.value;
    final len = pathMetric.length / 3;
    final end = start + len;
    var workingPath = pathMetric.extractPath(start, end);
    if (end > pathMetric.length) {
      workingPath.addPath(pathMetric.extractPath(start - pathMetric.length, end - pathMetric.length), Offset.zero);
    }
    canvas.drawPath(workingPath, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InfiniteAnimationState extends State<InfiniteAnimation> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(4, (index) {
      final duration = Duration(seconds: ((index + 1) * 1.5).toInt());
      "speed: ${duration.inSeconds}".log();
      final AnimationController controller = AnimationController(
        vsync: this,
        duration: duration,
      );
      return controller;
    });

    for (var controller in _controllers) {
      controller
        ..forward()
        ..repeat();
    }
  }

  // maintain speed ratio -> 5:4:3:2:1

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 200,
        child: RepaintBoundary(
          child: Stack(
            children: [
              CustomPaint(
                painter: InfinitePath(
                  _controllers[2],
                  reverse: true,
                  color: const Color(0xFF086A9A),
                  centerShift: 0.0,
                  sz1: 1.0,
                  sz2: 1.175,
                ),
              ),
              CustomPaint(
                painter: InfinitePath(
                  _controllers[1],
                  color: const Color(0xFFD8523B),
                  reverse: false,
                  centerShift: 14.5,
                  sz1: 1.175,
                  sz2: 1.0,
                ),
              ),
              CustomPaint(
                painter: InfinitePath(
                  _controllers[3],
                  reverse: true,
                  color: const Color(0xFFF8B023),
                  centerShift: 14.5,
                  sz1: 0.827,
                  sz2: 1.35,
                ),
              ),
              // CustomPaint(
              //   painter: InfinitePath(
              //     _controllers[1],
              //     reverse: false,
              //     color: const Color(0xFF086A9A),
              //     centerShift: 14.5 * 2,
              //     sz1: 1.35,
              //     sz2: 0.827,
              //   ),
              // ),
              // CustomPaint(
              //   painter: InfinitePath(
              //     _controllers[5],
              //     reverse: true,
              //     color: const Color(0xFFD8523B),
              //     centerShift: 14.5 * 2,
              //     sz1: 0.655,
              //     sz2: 1.52,
              //   ),
              // ),
              // CustomPaint(
              //   painter: InfinitePath(
              //     _controllers[0],
              //     reverse: false,
              //     color: const Color(0xFFF8B023),
              //     centerShift: 14.5 * 3,
              //     shift: 0,
              //     sz1: 1.52,
              //     sz2: 0.655,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
