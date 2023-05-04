import 'package:flutter/material.dart';
import 'package:movie_app/extensions.dart';

class ParallexFlowDelegate extends FlowDelegate {
  ParallexFlowDelegate(this.offset) : super(repaint: offset);
  final ValueNotifier offset;

  @override
  void paintChildren(FlowPaintingContext context) {
    offset.log();
    context.paintChild(
      0,
      transform: Matrix4.translationValues(offset.value * 70, 0, 0.0),
    );
  }

  @override
  bool shouldRepaint(covariant ParallexFlowDelegate oldDelegate) => false;
}
