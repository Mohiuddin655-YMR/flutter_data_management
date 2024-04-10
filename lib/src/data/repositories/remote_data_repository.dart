import 'package:flutter_andomie/utils/entities/entities.dart';

import '../../core/configs.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../services/repositories/remote_data_repository.dart';
import '../../utils/response.dart';

///
/// You can use [Data] without [Entity]
///
class RemoteDataRepositoryImpl<T extends Entity>
    extends RemoteDataRepository<T> {
  RemoteDataRepositoryImpl({
    required super.source,
    super.connectivity,
    super.backup,
    super.isCacheMode,
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
  Future<DataResponse<T>> checkById(
    String id, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.checkById(id, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.checkById(
          id,
          params: params,
        );
      } else {
        return source.checkById(
          id,
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.clear(params: params);
    } else {
      var connected = await isConnected;
      var response = await source.clear(
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.clear(params: params);
      }
      return response;
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.create(data, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.create(
        data,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.create(data, params: params);
      }
      return response;
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.creates(data, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.creates(
        data,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.creates(data, params: params);
      }
      return response;
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.deleteById(id, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.deleteById(
        id,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.deleteById(id, params: params);
      }
      return response;
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.deleteByIds(ids, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.deleteByIds(
        ids,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.deleteByIds(ids, params: params);
      }
      return response;
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.get(
        params: params,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.get(
          params: params,
        );
      } else {
        return source.get(
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getById(id, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getById(id, params: params);
      } else {
        return source.getById(
          id,
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getByIds(ids, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getByIds(ids, params: params);
      } else {
        return source.getByIds(
          ids,
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getByQuery(
        params: params,
        forUpdates: forUpdates,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getByQuery(
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        );
      } else {
        return source.getByQuery(
          isConnected: connected,
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        );
      }
    }
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
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listen(params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listen(
          params: params,
        );
      } else {
        yield* source.listen(
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenById(id, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenById(
          id,
          params: params,
        );
      } else {
        yield* source.listenById(
          id,
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenByIds(ids, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenByIds(
          ids,
          params: params,
        );
      } else {
        yield* source.listenByIds(
          ids,
          isConnected: connected,
          params: params,
        );
      }
    }
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
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenByQuery(
        params: params,
        forUpdates: forUpdates,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenByQuery(
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        );
      } else {
        yield* source.listenByQuery(
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
          isConnected: connected,
        );
      }
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.search(
        checker,
        params: params,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.search(
          checker,
          params: params,
        );
      } else {
        return source.search(
          checker,
          isConnected: connected,
          params: params,
        );
      }
    }
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
  Future<DataResponse<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.updateById(id, data, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.updateById(
        id,
        data,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.updateById(id, data, params: params);
      }
      return response;
    }
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
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.updateByIds(updates, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.updateByIds(
        updates,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.updateByIds(updates, params: params);
      }
      return response;
    }
  }
}
