import 'dart:math' as math show pi, sin, Random;
import 'package:flutter/material.dart';

class DNALoader extends StatefulWidget {
  const DNALoader({super.key});

  @override
  State<DNALoader> createState() => _DNALoaderState();
}

class _DNALoaderState extends State<DNALoader> with TickerProviderStateMixin {
  late AnimationController _controller;

  int lengthOfBoxes = 13;

  double dist = 15.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller
      ..forward()
      ..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        lengthOfBoxes,
        (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        0.0,
                        -40 * math.sin((math.pi * 2 * _controller.value) + (index / 5 + 10)),
                        _controller.value * 20,
                      ),
                    child: child,
                  ),
                  Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        0.0,
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
          );
        },
      ),
    );
  }
}
