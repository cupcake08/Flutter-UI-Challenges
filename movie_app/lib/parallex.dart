import 'package:flutter/material.dart';

class ParallexFlowDelegate extends FlowDelegate {
  ParallexFlowDelegate(this.offset) : super(repaint: offset);
  final ValueNotifier<double> offset;

  @override
  void paintChildren(FlowPaintingContext context) {
    context.paintChild(
      0,
      transform: Matrix4.translationValues(100 * offset.value, 0, 0.0),
    );
  }

  @override
  bool shouldRepaint(covariant ParallexFlowDelegate oldDelegate) => false;
}
