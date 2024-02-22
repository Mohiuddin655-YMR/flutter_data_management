part of '../../services/controllers/controller.dart';

///
/// You can use [Data] without [Entity]
///
class RemoteDataController<T extends Entity> extends DataController<T> {
  final RemoteDataRepository<T> repository;

  RemoteDataController(this.repository) : super._();

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
  Future<DataResponse<T>> checkById(
    String id, {
    FieldParams? params,
  }) {
    return notifier(() => repository.checkById(id, params: params));
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
  Future<DataResponse<T>> clear({
    FieldParams? params,
  }) {
    return notifier(() => repository.clear(params: params));
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
  Future<DataResponse<T>> create(
    T data, {
    FieldParams? params,
  }) {
    return notifier(() => repository.create(data, params: params));
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
  Future<DataResponse<T>> creates(
    List<T> data, {
    FieldParams? params,
  }) {
    return notifier(() => repository.creates(data, params: params));
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
  Future<DataResponse<T>> deleteById(
    String id, {
    FieldParams? params,
  }) {
    return notifier(() => repository.deleteById(id, params: params));
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
  Future<DataResponse<T>> deleteByIds(
    List<String> ids, {
    FieldParams? params,
  }) {
    return notifier(() => repository.deleteByIds(ids, params: params));
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
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    FieldParams? params,
  }) {
    return notifier(() {
      return repository.get(forUpdates: forUpdates, params: params);
    });
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
  Future<DataResponse<T>> getById(
    String id, {
    FieldParams? params,
  }) {
    return notifier(() => repository.getById(id, params: params));
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
  Future<DataResponse<T>> getByIds(
    List<String> ids, {
    bool forUpdates = false,
    FieldParams? params,
  }) {
    return notifier(() {
      return repository.getByIds(ids, forUpdates: forUpdates, params: params);
    });
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
  Future<DataResponse<T>> getByQuery({
    FieldParams? params,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return notifier(() {
      return repository.getByQuery(
        params: params,
        forUpdates: forUpdates,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      );
    });
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
  Stream<DataResponse<T>> listen({
    FieldParams? params,
  }) {
    return repository.listen(params: params);
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
  Stream<DataResponse<T>> listenById(
    String id, {
    FieldParams? params,
  }) {
    return repository.listenById(id, params: params);
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
  Stream<DataResponse<T>> listenByIds(
    List<String> ids, {
    bool forUpdates = false,
    FieldParams? params,
  }) {
    return repository.listenByIds(ids, forUpdates: forUpdates, params: params);
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
  Stream<DataResponse<T>> listenByQuery({
    FieldParams? params,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return repository.listenByQuery(
      params: params,
      forUpdates: forUpdates,
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
  Future<DataResponse<T>> search(
    Checker checker, {
    FieldParams? params,
  }) {
    return notifier(() => repository.search(checker, params: params));
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
  Future<DataResponse<T>> updateById({
    required String id,
    required Map<String, dynamic> data,
    FieldParams? params,
  }) {
    return notifier(() => repository.updateById(id, data, params: params));
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
  Future<DataResponse<T>> updateByIds(
    List<UpdatingInfo> updates, {
    FieldParams? params,
  }) {
    return notifier(() => repository.updateByIds(updates, params: params));
  }
}
