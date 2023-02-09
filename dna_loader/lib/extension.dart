import 'dart:developer' as dev show log;
extension Log on Object {
  void log() => dev.log(toString());
}