import 'package:flutter/rendering.dart';
import 'package:workout_configuration/util/utils.dart';

class SliderPainter extends CustomPainter {
  final double first, second, third, top;
  final bool showFirstPopup, showSecondPopup;
  final Paint _paint1, _paint2, _paint3; // draw 3 portions of line
  final List<double> stops;
  SliderPainter({
    required this.first,
    required this.second,
    required this.third,
    required this.top,
    this.showFirstPopup = false,
    this.showSecondPopup = false,
  })  : _paint1 = Paint()
          ..color = AppColor.lightOrange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
        _paint2 = Paint()
          ..color = AppColor.lightPurple
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
        _paint3 = Paint()
          ..color = AppColor.lightBlue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6,
        stops = [0.0, 1.0];

  @override
  void paint(Canvas canvas, Size size) {
    // first portion
    canvas.drawLine(Offset(first, top), Offset(second, top), _paint1);

    // second portion
    canvas.drawLine(Offset(second, top), Offset(third, top), _paint2);

    // third portion
    canvas.drawLine(Offset(third, top), Offset(size.width, top), _paint3);
  }

  @override
  bool shouldRepaint(covariant SliderPainter oldDelegate) => true;
}
