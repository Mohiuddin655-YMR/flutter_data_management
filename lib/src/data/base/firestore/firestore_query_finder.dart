part of '../../sources/fire_store_data_source.dart';

extension _FireStoreQueryFinder on fdb.Query {
  Future<GetsFinder<T, FS>> getAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    try {
      return fetch<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return (value, null, Status.ok);
        } else {
          return (value, null, Status.notFound);
        }
      });
    } on fdb.FirebaseException catch (_) {
      return (null, _.message, Status.failure);
    }
  }

  Stream<GetsFinder<T, FS>> liveBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<GetsFinder<T, FS>>();
    try {
      lives<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
      ).listen((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          controller.add((value, null, Status.ok));
        } else {
          controller.add((value, null, Status.notFound));
        }
      });
    } on fdb.FirebaseException catch (_) {
      controller.add((null, _.message, Status.failure));
    }
    return controller.stream;
  }

  Stream<GetsFinder<T, FS>> liveByQuery<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<GetsFinder<T, FS>>();
    try {
      queryLives<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ).listen((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          controller.add((value, null, Status.alreadyFound));
        } else {
          controller.add((value, null, Status.notFound));
        }
      });
    } on fdb.FirebaseException catch (_) {
      controller.add((null, _.message, Status.failure));
    }
    return controller.stream;
  }

  Future<GetsFinder<T, FS>> queryBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) async {
    try {
      return query<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return (value, null, Status.ok);
        } else {
          return (value, null, Status.notFound);
        }
      });
    } on fdb.FirebaseException catch (_) {
      return (null, _.message, Status.failure);
    }
  }

  Future<GetsFinder<T, FS>> searchBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required Checker checker,
  }) async {
    try {
      return search<T>(
        builder: builder,
        checker: checker,
        encryptor: encryptor,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return (value, null, Status.ok);
        } else {
          return (value, null, Status.notFound);
        }
      });
    } catch (_) {
      return (null, "$_", Status.failure);
    }
  }
}
