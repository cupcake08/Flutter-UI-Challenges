import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

extension Dimensions on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

extension DurationExt on num {
  Duration get microsecond => Duration(microseconds: round());
  Duration get ms => (1000 * this).microsecond;
}

extension Log on Object {
  void log() => devtools.log(toString());
}
