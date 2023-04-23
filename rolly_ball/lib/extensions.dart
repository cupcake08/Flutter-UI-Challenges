import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';

extension Log on Object {
  void log([String? message]) {
    dev.log(message ?? toString());
  }
}

// extension on bulidcontext to get the size of the screen
extension ScreenSize on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get width => screenSize.width;
  double get height => screenSize.height;
}
