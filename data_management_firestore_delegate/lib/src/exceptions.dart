import 'package:data_management/core.dart';

class FirestoreDataExtensionalException extends DataException {
  const FirestoreDataExtensionalException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw FirestoreDataExtensionalException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw FirestoreDataExtensionalException("$error");
  }
}
