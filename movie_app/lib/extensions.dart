import 'dart:developer' as dev show log;
import 'package:flutter/material.dart';

extension Log on Object {
  void log([String tag = 'Log']) => dev.log(toString(), name: tag);
}

extension Constraints on BuildContext {
  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;
}
