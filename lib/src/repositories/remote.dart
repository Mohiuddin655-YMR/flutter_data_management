import 'dart:async';

import 'package:flutter_entity/entity.dart';

import '../core/cache_manager.dart';
import '../core/configs.dart';
import '../models/checker.dart';
import '../models/updating_info.dart';
import '../sources/local.dart';
import '../sources/remote.dart';
import 'base.dart';

typedef FutureConnectivityCallback = Future<bool> Function();
typedef StreamConnectivityCallback = Stream<bool> Function();

///
/// You can use [Data] without [Entity]
///
class RemoteDataRepository<T extends Entity> extends DataRepository<T> {
  /// Flag indicating whether the repository is operating in cache mode.
  /// When in cache mode, the repository may use a local backup data source.
  final bool cacheMode;
  final bool localMode;

  /// The primary remote data source responsible for fetching data.
  final RemoteDataSource<T> source;

  /// An optional local data source used as a backup or cache when in cache mode.
  final LocalDataSource<T>? backup;

  /// Connectivity provider for checking internet connectivity.
  final FutureConnectivityCallback? _connectivityAsync;
  final StreamConnectivityCallback? _connectivityStream;

  /// Getter for checking if the device is connected to the internet.
  Future<bool> get isConnected async {
    if (_connectivityAsync != null) return _connectivityAsync!();
    return false;
  }

  /// Getter for checking if the device is disconnected from the internet.
  Future<bool> get isDisconnected async => !(await isConnected);

  /// Getter for checking if the device is connected to the internet.
  Stream<bool> get connectivityChanges {
    if (_connectivityStream != null) return _connectivityStream!();
    return Stream.fromFuture(isConnected);
  }

  /// Method to check if the repository is using a local backup data source.
  ///
  /// Example:
  /// ```dart
  /// if (userRepository.isLocalMode) {
  ///   // Handle local backup logic
  /// }
  /// ```
  bool get isBackupMode => backup != null;

  bool get isCacheMode => cacheMode && isBackupMode;

  bool get isLocalMode => localMode && isBackupMode;

  /// Constructor for creating a [RemoteDataRepository] implement.
  ///
  /// Parameters:
  /// - [source]: The primary remote data source. Ex: [ApiDataSource], [FirestoreDataSource], and [RealtimeDataSource].
  /// - [backup]: An optional local backup or cache data source. Ex: [LocalDataSourceImpl].
  /// - [isCacheMode]: Flag indicating whether the repository should operate in cache mode.
  ///
  RemoteDataRepository({
    required this.source,
    this.backup,
    this.cacheMode = true,
    this.localMode = false,
    FutureConnectivityCallback? connectivity,
    StreamConnectivityCallback? connectivityChanges,
  })  : _connectivityAsync = connectivity,
        _connectivityStream = connectivityChanges;

  Future<Response<S>> _cache<S extends Object>({
    bool auto = true,
    required Future<Response<S>> Function() backup,
    required Future<Response<S>> Function() source,
    Future<Response<S>> Function(Response<S> feedback)? keep,
  }) async {
    try {
      if (isLocalMode) return await backup();
      if (await isDisconnected) {
        if (!isCacheMode) return Response<S>(status: Status.networkError);
        return await backup();
      }
      final feedback = await source();
      if (isCacheMode && feedback.isSuccessful) {
        if (keep != null && feedback.isValid) await keep(feedback);
        if (auto) return await backup();
      }
      return feedback;
    } catch (error) {
      return Response<S>(status: Status.failure, error: error.toString());
    }
  }

  Future<Response<S>> cache<S extends Object>(
    String name, {
    bool? cached,
    bool auto = true,
    Iterable<Object?> keyProps = const [],
    required Future<Response<S>> Function() backup,
    required Future<Response<S>> Function() source,
    Future<Response<S>> Function(Response<S> feedback)? keep,
  }) {
    return DataCacheManager.i.cache(
      name,
      cached: cached,
      keyProps: keyProps,
      callback: () => _cache(
        auto: auto,
        backup: backup,
        source: source,
        keep: keep,
      ),
    );
  }

  Stream<Response<S>> _cacheStream<S extends Object>({
    bool auto = true,
    required Stream<Response<S>> Function() backup,
    required Stream<Response<S>> Function() source,
    Future<Response<S>> Function(Response<S> feedback)? keep,
  }) async* {
    try {
      if (isLocalMode) {
        yield* backup();
        return;
      }
      await for (final isConnected in connectivityChanges) {
        if (!isConnected) {
          if (!isCacheMode) {
            yield Response<S>(status: Status.networkError);
            continue;
          }
          yield* backup();
          continue;
        }

        await for (final feedback in source()) {
          if (isCacheMode && feedback.isSuccessful) {
            if (keep != null && feedback.isValid) await keep(feedback);
            if (auto) {
              yield* backup();
              continue;
            }
          }
          yield feedback;
        }
      }
    } catch (error) {
      yield Response<S>(status: Status.failure, error: error.toString());
    }
  }

  Stream<Response<S>> cacheStream<S extends Object>(
    String name, {
    bool? cached,
    bool auto = true,
    Iterable<Object?> keyProps = const [],
    required Stream<Response<S>> Function() backup,
    required Stream<Response<S>> Function() source,
    Future<Response<S>> Function(Response<S> feedback)? keep,
  }) {
    return _cacheStream(
      auto: auto,
      backup: backup,
      source: source,
      keep: keep,
    );
  }

  /// Method to check data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.checkById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> checkById(
    String id, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "CHECK_BY_ID",
      cached: cached,
      keyProps: [params, id],
      source: () => source.checkById(id, params: params, isConnected: true),
      backup: () => backup!.checkById(id, params: params),
    );
  }

  /// Method to clear data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.clear(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> clear({bool? cached, DataFieldParams? params}) {
    return cache(
      "CLEAR",
      cached: cached,
      keyProps: [params],
      source: () => source.clear(params: params, isConnected: true),
      backup: () => backup!.clear(params: params),
    );
  }

  /// Method to count data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.count(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<int>> count({bool? cached, DataFieldParams? params}) {
    return cache(
      "COUNT",
      cached: cached,
      keyProps: [params],
      source: () => source.count(params: params, isConnected: true),
      backup: () => backup!.count(params: params),
    );
  }

  /// Method to create data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// T newData = //...;
  /// repository.create(
  ///   newData,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> create(T data, {bool? cached, DataFieldParams? params}) {
    return cache(
      "CREATE",
      cached: cached,
      keyProps: [params, data],
      source: () => source.create(data, params: params, isConnected: true),
      backup: () => backup!.create(data, params: params),
    );
  }

  /// Method to create multiple data entries with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<T> newDataList = //...;
  /// repository.creates(
  ///   newDataList,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> creates(
    List<T> data, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "CREATES",
      cached: cached,
      keyProps: [params, data],
      source: () => source.creates(data, params: params, isConnected: true),
      backup: () => backup!.creates(data, params: params),
    );
  }

  /// Method to delete data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.deleteById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> deleteById(
    String id, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "DELETE_BY_ID",
      cached: cached,
      keyProps: [params, id],
      source: () => source.deleteById(id, params: params, isConnected: true),
      backup: () => backup!.deleteById(id, params: params),
    );
  }

  /// Method to delete data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToDelete = ['userId1', 'userId2'];
  /// repository.deleteByIds(
  ///   idsToDelete,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> deleteByIds(
    List<String> ids, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "DELETE_BY_IDS",
      cached: cached,
      keyProps: [params, ids],
      source: () => source.deleteByIds(ids, params: params, isConnected: true),
      backup: () => backup!.deleteByIds(ids, params: params),
    );
  }

  /// Method to get data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.get(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> get({bool? cached, DataFieldParams? params}) {
    return cache(
      "GET",
      cached: cached,
      keyProps: [params],
      source: () => source.get(params: params, isConnected: true),
      backup: () => backup!.get(params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Method to get data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.getById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> getById(
    String id, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "GET_BY_ID",
      cached: cached,
      keyProps: [params, id],
      source: () => source.getById(id, params: params, isConnected: true),
      backup: () => backup!.getById(id, params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Method to get data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToRetrieve = ['userId1', 'userId2'];
  /// repository.getByIds(
  ///   idsToRetrieve,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> getByIds(
    List<String> ids, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "GET_BY_IDS",
      cached: cached,
      keyProps: [params, ids],
      source: () => source.getByIds(ids, params: params, isConnected: true),
      backup: () => backup!.getByIds(ids, params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Method to get data by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<Query> queries = [Query.field('name', 'John')];
  /// repository.getByQuery(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  ///   queries: queries,
  /// );
  /// ```
  @override
  Future<Response<T>> getByQuery({
    bool? cached,
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    return cache(
      "GET_BY_QUERY",
      cached: cached,
      keyProps: [params, queries, selections, sorts, options],
      source: () => source.getByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
        isConnected: true,
      ),
      backup: () => backup!.getByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Stream method to listen for data changes with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listen(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<T>> listen({bool? cached, DataFieldParams? params}) {
    return cacheStream(
      "LISTEN",
      cached: cached,
      keyProps: [params],
      source: () => source.listen(params: params, isConnected: true),
      backup: () => backup!.listen(params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Method to listenCount data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listenCount(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<int>> listenCount({bool? cached, DataFieldParams? params}) {
    return cacheStream(
      "LISTEN_COUNT",
      cached: cached,
      keyProps: [params],
      source: () => source.listenCount(params: params, isConnected: true),
      backup: () => backup!.listenCount(params: params),
    );
  }

  /// Stream method to listen for data changes by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listenById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<T>> listenById(
    String id, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cacheStream(
      "LISTEN_BY_ID",
      cached: cached,
      keyProps: [params, id],
      source: () => source.listenById(id, params: params, isConnected: true),
      backup: () => backup!.listenById(id, params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Stream method to listen for data changes by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<String> idsToListen = ['userId1', 'userId2'];
  /// repository.listenByIds(
  ///   idsToListen,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Stream<Response<T>> listenByIds(
    List<String> ids, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cacheStream(
      "LISTEN_BY_IDS",
      cached: cached,
      keyProps: [params, ids],
      source: () => source.listenByIds(ids, params: params, isConnected: true),
      backup: () => backup!.listenByIds(ids, params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Stream method to listen for data changes by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<Query> queries = [Query.field('name', 'John')];
  /// repository.listenByQuery(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  ///   queries: queries,
  /// );
  /// ```
  @override
  Stream<Response<T>> listenByQuery({
    bool? cached,
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    return cacheStream(
      "LISTEN_BY_QUERY",
      cached: cached,
      keyProps: [params, queries, selections, sorts, options],
      source: () => source.listenByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
        isConnected: true,
      ),
      backup: () => backup!.listenByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Method to check data by query with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// Checker checker = Checker(field: 'status', value: 'active');
  /// repository.search(
  ///   checker,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> search(
    Checker checker, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "SEARCH",
      cached: cached,
      keyProps: [params, checker],
      source: () => source.search(checker, params: params, isConnected: true),
      backup: () => backup!.search(checker, params: params),
      keep: (value) => backup!.keep(value.result, params: params),
    );
  }

  /// Method to update data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.updateById(
  ///   'userId123',
  ///   {'status': 'inactive'},
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "UPDATE_BY_ID",
      cached: cached,
      keyProps: [params, id, data],
      source: () => source.updateById(
        id,
        data,
        params: params,
        isConnected: true,
      ),
      backup: () => backup!.updateById(id, data, params: params),
    );
  }

  /// Method to update data by multiple IDs with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// List<UpdatingInfo> updates = [
  ///   UpdatingInfo('userId1', {'status': 'inactive'}),
  ///   UpdatingInfo('userId2', {'status': 'active'}),
  /// ];
  /// repository.updateByIds(
  ///   updates,
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  @override
  Future<Response<T>> updateByIds(
    List<UpdatingInfo> updates, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "UPDATE_BY_IDS",
      cached: cached,
      keyProps: [params, updates],
      source: () => source.updateByIds(
        updates,
        params: params,
        isConnected: true,
      ),
      backup: () => backup!.updateByIds(updates, params: params),
    );
  }
}
