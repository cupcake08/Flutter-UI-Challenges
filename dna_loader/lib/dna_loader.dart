import 'dart:math' as math show pi, sin, pow;
import 'package:dna_loader/extension.dart';
import 'package:flutter/material.dart';

class DNALoader extends StatefulWidget {
  const DNALoader({super.key});

  @override
  State<DNALoader> createState() => _DNALoaderState();
}

class Circle extends CustomPainter {
  final AnimationController controller;
  // final Animation<double> animation;
  final Paint _paint;

  Circle(this.controller)
      : _paint = Paint()..color = Colors.purple,
        super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    // rotate it around x axis; and also z axis with scaling.
    final center = Offset(size.width, size.height / 2);
    final side = 20.0 * math.sin(controller.value * math.pi);
    canvas.drawRect(Rect.fromCenter(center: center, width: side, height: side), _paint);
    // canvas.drawCircle(center, 10 * controller.value, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DNALoaderState extends State<DNALoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;
  double cnt = 8.000000;

  late List<Animation<double>> _animations1, _animations2;

  @override
  void initState() {
    super.initState();
    double gap = cnt / 100.0;
    // "gap: $gap".log();
    double start = 0.0;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animations1 = List.generate(cnt.toInt() ~/ 2, (index) {
      // calc interval for this index.
      start += gap;
      double end = index < (cnt.toInt() / 2) ? 0.5 : 1.0;
      // end.log();
      // start.log();
      final Animation<double> animation = Tween<double>(begin: 0.0, end: math.pi * 2).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start,
            1.0,
          ),
        ),
      );
      return animation;
    });

    start = 0.0;
    _animations2 = List.generate(cnt.toInt() ~/ 2, (index) {
      // calc interval for this index.
      start += gap;
      double end = index < (cnt.toInt() / 2) ? 0.5 : 1.0;
      // end.log();
      // start.log();
      Animation<double> animation = Tween<double>(begin: 0.0, end: math.pi * 2).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start,
            1.0,
          ),
        ),
      );
      animation = ReverseAnimation(animation);
      return animation;
    });

    _animations1.length.log();
    _animations2.length.log();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller
      ..reset()
      ..repeat();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: cnt.toInt(),
            itemBuilder: (context, index) {
              return Transform(
                transform: Matrix4.identity()
                  ..translate(
                      0.0,
                      20 *
                          math.sin(cnt.toInt() ~/ 2 < index - 1
                              ? _animations1[index % (cnt.toInt() ~/ 2)].value
                              : _animations2[index % (cnt.toInt() ~/ 2)].value)),
                child: child,
              );
            });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: CustomPaint(
          painter: Circle(_controller),
          size: const Size(20, 20),
        ),
      ),
    );
  }
}
