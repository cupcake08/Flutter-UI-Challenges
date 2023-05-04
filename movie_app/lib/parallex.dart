import 'package:flutter/material.dart';

class ParallexFlowDelegate extends FlowDelegate {
  ParallexFlowDelegate(this.offset);
  final double offset;

  @override
  void paintChildren(FlowPaintingContext context) {
    context.paintChild(
      0,
      transform: Matrix4.translationValues(-10, 0, 0.0),
    );
  }

  @override
  bool shouldRepaint(covariant ParallexFlowDelegate oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
