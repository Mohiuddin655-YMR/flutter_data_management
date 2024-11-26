import 'package:flutter_entity/entity.dart';

import '../core/cache_manager.dart';
import '../core/configs.dart';
import '../models/checker.dart';
import '../models/updating_info.dart';
import '../sources/local.dart';
import 'base.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  /// The primary local data source responsible for data operations.
  final LocalDataSource<T> source;

  /// Constructor for creating a [LocalDataRepository].
  ///
  /// Parameters:
  /// - [source]: The primary local data source. Ex [LocalDataSourceImpl].
  ///
  /// Example:
  /// ```dart
  /// LocalDataRepository<User> userRepository = LocalDataRepository.create(
  ///   source: LocalDataSourceImpl<User>(),
  /// );
  /// ```
  const LocalDataRepository({
    required this.source,
  });

  Future<Response<S>> cache<S extends Object>(
    String name, {
    bool? cached,
    Iterable<Object?> keyProps = const [],
    required Future<Response<S>> Function() callback,
  }) async {
    try {
      return DataCacheManager.i.cache(
        name,
        cached: cached,
        keyProps: keyProps,
        callback: callback,
      );
    } catch (error) {
      return Response<S>(status: Status.failure, error: error.toString());
    }
  }

  Stream<Response<S>> cacheStream<S extends Object>(
    String name, {
    bool? cached,
    bool auto = true,
    Iterable<Object?> keyProps = const [],
    required Stream<Response<S>> Function() callback,
  }) async* {
    try {
      yield* callback();
    } catch (error) {
      yield Response<S>(status: Status.failure, error: error.toString());
    }
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
      callback: () => source.checkById(id, params: params),
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
  Future<Response<T>> clear({
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "CLEAR",
      cached: cached,
      keyProps: [params],
      callback: () => source.clear(params: params),
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
  Future<Response<int>> count({
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "COUNT",
      cached: cached,
      keyProps: [params],
      callback: () => source.count(params: params),
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
  Future<Response<T>> create(
    T data, {
    bool? cached,
    DataFieldParams? params,
  }) {
    return cache(
      "CREATE",
      cached: cached,
      keyProps: [params, data],
      callback: () => source.create(data, params: params),
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
      callback: () => source.creates(data, params: params),
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
      callback: () => source.deleteById(id, params: params),
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
      callback: () => source.deleteByIds(ids, params: params),
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
      callback: () => source.get(params: params),
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
      callback: () => source.getById(id, params: params),
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
      callback: () => source.getByIds(ids, params: params),
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
      callback: () => source.getByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ),
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
      callback: () => source.listen(params: params),
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
      callback: () => source.listenCount(params: params),
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
      callback: () => source.listenById(id, params: params),
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
      callback: () => source.listenByIds(ids, params: params),
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
      callback: () => source.listenByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ),
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
      callback: () => source.search(checker, params: params),
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
      callback: () => source.updateById(id, data, params: params),
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
      callback: () => source.updateByIds(updates, params: params),
    );
  }
}
