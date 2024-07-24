abstract class DataException {
  final String? _exp;

  const DataException([this._exp]);

  String get message {
    if (_exp != null) {
      return _exp!;
    } else {
      return "DataProvider not initialization.";
    }
  }

  @override
  String toString() => message;
}

class DataRepositoryException extends DataException {
  const DataRepositoryException([super._exp]);
}

class DataSourceException extends DataException {
  const DataSourceException([super._exp]);
}

class LocalDataSourceException extends DataException {
  const LocalDataSourceException([super._exp]);
}

class RemoteDataSourceException extends DataException {
  const RemoteDataSourceException([super._exp]);
}

class ApiDataExtensionalException extends DataException {
  const ApiDataExtensionalException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw ApiDataExtensionalException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw ApiDataExtensionalException("$error");
  }
}

class FirestoreDataExtensionalException extends DataException {
  const FirestoreDataExtensionalException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw FirestoreDataExtensionalException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw FirestoreDataExtensionalException("$error");
  }
}

class RealtimeDataExtensionalException extends DataException {
  const RealtimeDataExtensionalException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw RealtimeDataExtensionalException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw RealtimeDataExtensionalException("$error");
  }
}

class LocalDataExtensionalException extends DataException {
  const LocalDataExtensionalException([super._exp]);

  static Future<T> future<T>(Object? error, StackTrace stackTrace) {
    throw LocalDataExtensionalException("$error");
  }

  static void stream<T>(Object? error, StackTrace stackTrace) {
    throw LocalDataExtensionalException("$error");
  }
}
