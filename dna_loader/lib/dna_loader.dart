import 'dart:math' as math show pi, sin, Random, cos;
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

class _DNALoaderState extends State<DNALoader> with TickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;
  // List<Animation<double>> _animationList = [];
  late List<Color> _colorsList;
  late Animation<double> _animation;
  // late List<AnimationController> _animationControllers;
  final _kAnimationDuration = const Duration(seconds: 3);
  double cnt = 8.000000;

  int lengthOfBoxes = 10;

  double dist = 15.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // for (int i = 1; i <= lengthOfBoxes; i++) {
    //   final controller = AnimationController(
    //     vsync: this,
    //     duration: _kAnimationDuration,
    //   );
    //   _animationControllers.add(controller);
    // }

    // setState(() {});

    _colorsList = List.generate(lengthOfBoxes, (index) {
      return Colors.primaries[math.Random().nextInt(lengthOfBoxes)];
    });

    // for (int i = 1; i <= lengthOfBoxes; i++) {
    //   int delay = (math.sin((i / lengthOfBoxes) * (math.pi / 4)) * 2).toInt();
    //   Timer(Duration(seconds: delay), () {
    //     _animationControllers[i - 1]
    //       ..forward()
    //       ..repeat();
    //   });
    // }

    // for (int i = 1; i <= lengthOfBoxes; i++) {
    //   // calculate delay.
    //   double delay = math.sin(((i - 1) / lengthOfBoxes) * (math.pi / 4));
    //   double end = math.sin((i / lengthOfBoxes) * (math.pi));
    //   "delay: $delay,end: $end".log();
    //   final animation = Tween(begin: -math.pi, end: math.pi).animate(
    //     CurvedAnimation(
    //       parent: _controller,
    //       curve: Interval(
    //         delay,
    //         1.0,
    //         curve: Curves.easeInOut,
    //       ),
    //     ),
    // )
    // _animationList.add(animation);
    // }

    _controller
      ..forward()
      ..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: 300,
      width: size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            50.0,
                            -40 * math.sin((math.pi * 2 * _controller.value) + (index / 5 + 10)),
                            _controller.value * 20,
                          ),
                        child: child,
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            50.0,
                            40 * math.sin((math.pi * 2 * _controller.value) + (index / 5 + 10)),
                            (1 - _controller.value) * 20,
                          ),
                        child: child,
                      ),
                    ],
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.primaries[math.Random().nextInt(Colors.primaries.length)]),
                  height: 15,
                  width: 15,
                ),
              ),
            ],
          );
        },
        itemCount: lengthOfBoxes + 3,
      ),
    );
  }
}
