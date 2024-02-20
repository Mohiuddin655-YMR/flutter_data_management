import 'dart:async';

class DataException {
  final String? _exp;

  const DataException([this._exp]);

  String get message {
    if (_exp != null) {
      return _exp!;
    } else {
      return "DataProvider not initialization.";
    }
  }

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw DataException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw DataException("$error");
  }

  @override
  String toString() => message;
}
