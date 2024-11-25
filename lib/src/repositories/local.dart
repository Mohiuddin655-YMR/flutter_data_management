import 'package:flutter_entity/entity.dart';

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
    DataFieldParams? params,
  }) {
    return source.checkById(id, params: params);
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
    DataFieldParams? params,
  }) {
    return source.clear(params: params);
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
    DataFieldParams? params,
  }) {
    return source.count(params: params);
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
    DataFieldParams? params,
  }) {
    return source.create(data, params: params);
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
    DataFieldParams? params,
  }) {
    return source.creates(data, params: params);
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
    DataFieldParams? params,
  }) {
    return source.deleteById(id, params: params);
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
    DataFieldParams? params,
  }) {
    return source.deleteByIds(ids, params: params);
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
  Future<Response<T>> get({
    DataFieldParams? params,
  }) {
    return source.get(params: params);
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
    bool singleton = false,
    DataFieldParams? params,
  }) {
    return DataSingletonCallback.i.call(
      "getById",
      singleton: singleton,
      callback: () async => source.getById(id, params: params),
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
    DataFieldParams? params,
  }) {
    return source.getByIds(ids, params: params);
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
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    return source.getByQuery(
      params: params,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
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
  Stream<Response<T>> listen({
    DataFieldParams? params,
  }) {
    return source.listen(params: params);
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
  Stream<Response<int>> listenCount({
    DataFieldParams? params,
  }) {
    return source.listenCount(params: params);
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
    DataFieldParams? params,
  }) {
    return source.listenById(id, params: params);
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
    DataFieldParams? params,
  }) {
    return source.listenByIds(ids, params: params);
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
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    return source.listenByQuery(
      params: params,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
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
    DataFieldParams? params,
  }) {
    return source.search(checker, params: params);
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
    DataFieldParams? params,
  }) {
    return source.updateById(id, data, params: params);
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
    DataFieldParams? params,
  }) {
    return source.updateByIds(updates, params: params);
  }
}
