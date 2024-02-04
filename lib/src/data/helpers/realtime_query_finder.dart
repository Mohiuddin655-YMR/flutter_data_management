part of '../sources/realtime_data_source.dart';

extension _RealtimeQueryFinder on rdb.Query {
  Future<FindByFinder<T>> findBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    try {
      return getAll<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } catch (_) {
      return (false, null, "$_", Status.failure);
    }
  }

  Future<FindByFinder<T>> getBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    return findBy(
      builder: builder,
      encryptor: encryptor,
      onlyUpdates: onlyUpdates,
    );
  }

  Future<FindByFinder<T>> getByPaging<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const FirestorePagingOptions.empty(),
  }) async {
    try {
      return paging<T>(
        builder: builder,
        encryptor: encryptor,
        queries: queries,
        sorts: sorts,
        options: options,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } catch (_) {
      return (false, null, "$_", Status.failure);
    }
  }

  Stream<FindByFinder<T>> liveBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<FindByFinder<T>>();
    try {
      livesAll<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
      ).listen((value) {
        if (value.isNotEmpty) {
          controller.add((true, value, null, Status.alreadyFound));
        } else {
          controller.add((false, null, null, Status.notFound));
        }
      });
    } catch (_) {
      controller.add((false, null, "$_", Status.failure));
    }
    return controller.stream;
  }
}
