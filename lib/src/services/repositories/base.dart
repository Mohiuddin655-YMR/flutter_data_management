import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_query/in_app_query.dart';

import '../../core/configs.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../utils/errors.dart';

/// ## Abstract class representing a generic data repository with methods for CRUD operations.
///
/// This abstract class defines the structure of a generic data repository.
/// It is not intended to be used directly. Instead, use its implementations:
/// * <b>[RemoteDataRepositoryImpl]</b> : Use for all remote database related data.
/// * <b>[LocalDataRepositoryImpl]</b> : Use for all local database related data.
///
/// Example:
/// ```dart
/// final DataRepository userRepository = RemoteDataRepositoryImpl();
/// final DataRepository<Post> postRepository = LocalDataRepositoryImpl<Post>();
/// ```

abstract class DataRepository<T extends Entity> {
  const DataRepository();

  /// Method to check data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.checkById(
  ///   'userId123',
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  Future<Response<T>> checkById(
    String id, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('checkById method is not implemented');
  }

  /// Method to clear data with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.clear(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  Future<Response<T>> clear({
    FieldParams? params,
  }) {
    throw const DataRepositoryException('clear method is not implemented');
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
  Future<Response<T>> create(
    T data, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('create method is not implemented');
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
  Future<Response<T>> creates(
    List<T> data, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('creates method is not implemented');
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
  Future<Response<T>> deleteById(
    String id, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('deleteById method is not implemented');
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
  Future<Response<T>> deleteByIds(
    List<String> ids, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException(
      'deleteByIds method is not implemented',
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
  Future<Response<T>> get({
    FieldParams? params,
  }) {
    throw const DataRepositoryException('get method is not implemented');
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
  Future<Response<T>> getById(
    String id, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('getById method is not implemented');
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
  Future<Response<T>> getByIds(
    List<String> ids, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('getByIds method is not implemented');
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
  Future<Response<T>> getByQuery({
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    throw const DataRepositoryException('getByQuery method is not implemented');
  }

  /// Stream method to listen for data changes with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.listen(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  Stream<Response<T>> listen({
    FieldParams? params,
  }) {
    throw const DataRepositoryException('listen method is not implemented');
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
  Stream<Response<T>> listenById(
    String id, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('listenById method is not implemented');
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
  Stream<Response<T>> listenByIds(
    List<String> ids, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException(
      'listenByIds method is not implemented',
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
  Stream<Response<T>> listenByQuery({
    FieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    throw const DataRepositoryException(
      'listenByQuery method is not implemented',
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
  Future<Response<T>> search(
    Checker checker, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('search method is not implemented');
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
  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException('updateById method is not implemented');
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
  Future<Response<T>> updateByIds(
    List<UpdatingInfo> updates, {
    FieldParams? params,
  }) {
    throw const DataRepositoryException(
      'updateByIds method is not implemented',
    );
  }
}
