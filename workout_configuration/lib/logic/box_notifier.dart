import 'package:flutter/material.dart';

class BoxNotifier extends ChangeNotifier {
  late Offset _firstBoxPosition, _secondBoxPosition;

  Offset get fbp => _firstBoxPosition;
  Offset get sbp => _secondBoxPosition;

  bool _liftFirstBox = false;
  bool _liftSecondBox = false;

  bool get lfb => _liftFirstBox;
  bool get lsb => _liftSecondBox;

  init() {
    _firstBoxPosition = Offset.zero;
    _secondBoxPosition = Offset.zero;
  }

  // TODO: unite left box functions

  set liftFirstBox(bool value) {
    _liftFirstBox = value;
    notifyListeners();
  }

  set liftSecondBox(bool value) {
    _liftSecondBox = value;
    notifyListeners();
  }

  changeBoxPosition(Offset first, Offset second, {bool notify = false}) {
    _firstBoxPosition = first;
    _secondBoxPosition = second;
    if (notify) {
      notifyListeners();
    }
  }
}
