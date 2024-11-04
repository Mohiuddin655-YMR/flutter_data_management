import 'package:data_management/core.dart';

class ApiDataExtensionalException extends DataException {
  const ApiDataExtensionalException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw ApiDataExtensionalException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw ApiDataExtensionalException("$error");
  }
}
