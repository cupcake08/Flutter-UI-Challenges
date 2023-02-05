import 'package:flutter/material.dart';

class BoxNotifier extends ChangeNotifier {
  late Offset _firstBoxPosition, _secondBoxPosition;
  bool _liftFirstBox = false;
  bool _liftSecondBox = false;

  // Getters
  Offset get fbp => _firstBoxPosition;
  Offset get sbp => _secondBoxPosition;
  bool get lfb => _liftFirstBox;
  bool get lsb => _liftSecondBox;

  init() {
    _firstBoxPosition = Offset.zero;
    _secondBoxPosition = Offset.zero;
  }

  set liftFirstBox(bool value) {
    _liftFirstBox = value;
    notifyListeners();
  }

  set liftSecondBox(bool value) {
    _liftSecondBox = value;
    notifyListeners();
  }

  void changeBoxPosition(Offset first, Offset second, {bool notify = false}) {
    _firstBoxPosition = first;
    _secondBoxPosition = second;
    if (notify) {
      notifyListeners();
    }
  }
}
