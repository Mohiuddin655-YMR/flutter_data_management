import 'package:data_management/core.dart';

class RealtimeDataException extends DataException {
  const RealtimeDataException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw RealtimeDataException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw RealtimeDataException("$error");
  }
}
