import 'package:data_management/core.dart';

class LocalDataException extends DataException {
  const LocalDataException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw LocalDataException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw LocalDataException("$error");
  }
}
