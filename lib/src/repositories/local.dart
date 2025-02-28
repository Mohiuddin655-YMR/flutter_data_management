import 'dart:async';

import 'package:flutter_entity/entity.dart';

import '../core/configs.dart';
import '../models/checker.dart';
import '../models/updating_info.dart';
import '../sources/base.dart';
import 'base.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataRepository<T extends Entity> extends DataRepository<T> {
  final bool backupOnlineData;

  /// Constructor for creating a [RemoteDataRepository] implement.
  ///
  /// Parameters:
  /// - [source]: The primary remote data source. Ex: [LocalDataSourceImpl].
  /// - [backup]: An optional local backup or cache data source. Ex: [ApiDataSource], [FirestoreDataSource], and [RealtimeDataSource].
  ///
  const LocalDataRepository({
    super.id,
    required super.source,
    super.backup,
    super.connectivity,
    super.lazy,
    this.backupOnlineData = true,
  }) : super.local();

  Future<Response<S>> _backup<S extends Object>(
    Future<Response<S>> Function(DataSource<T> source) callback,
  ) async {
    try {
      if (optional == null) return Response(status: Status.undefined);
      final connected = await isConnected;
      if (!connected) return Response(status: Status.networkError);
      return callback(optional!);
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  /// Method to restore remote data as local data
  ///
  /// Example:
  /// ```dart
  /// repository.pull(
  ///   params: Params({"field1": "value1", "field2": "value2"}),
  /// );
  /// ```
  Future<void> pull({
    DataFieldParams? params,
    Object? args,
    bool? lazy,
  }) async {
    if (!backupOnlineData) return;
    final local = await _backup((source) {
      return source.get(params: params, args: args);
    });
    if (local.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(local.result, params: params, args: args);
      } else {
        await primary.creates(local.result, params: params, args: args);
      }
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
    DataFieldParams? params,
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.checkById(id, params: params, args: args);
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.checkById(id, params: params, args: args);
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return remote;
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) => source.clear(params: params, args: args));
    } else {
      await _backup((source) => source.clear(params: params, args: args));
    }
    return primary.clear(params: params, args: args);
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
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.count(params: params, args: args);
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.get(params: params, args: args);
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return local.copy(data: remote.result.length);
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) => source.create(data, params: params, args: args));
    } else {
      await _backup((source) {
        return source.create(data, params: params, args: args);
      });
    }
    return primary.create(data, params: params, args: args);
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) => source.creates(data, params: params, args: args));
    } else {
      await _backup((source) {
        return source.creates(data, params: params, args: args);
      });
    }
    return primary.creates(data, params: params, args: args);
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) => source.deleteById(id, params: params, args: args));
    } else {
      await _backup((source) {
        return source.deleteById(id, params: params, args: args);
      });
    }
    return primary.deleteById(id, params: params, args: args);
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) => source.deleteByIds(ids, params: params, args: args));
    } else {
      await _backup((source) {
        return source.deleteByIds(ids, params: params, args: args);
      });
    }
    return primary.deleteByIds(ids, params: params, args: args);
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
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.get(params: params, args: args);
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.get(params: params, args: args);
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return remote;
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
    DataFieldParams? params,
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.getById(id, params: params, args: args);
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.getById(id, params: params, args: args);
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return remote;
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
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.getByIds(ids, params: params, args: args);
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.getByIds(ids, params: params, args: args);
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return remote;
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
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.getByQuery(
      params: params,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
      args: args,
    );
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.getByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
        args: args,
      );
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return remote;
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
    Object? args,
  }) {
    return primary.listen(params: params, args: args);
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
    Object? args,
  }) {
    return primary.listenCount(params: params, args: args);
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
    Object? args,
  }) {
    return primary.listenById(id, params: params, args: args);
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
    Object? args,
  }) {
    return primary.listenByIds(ids, params: params, args: args);
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
    Object? args,
  }) {
    return primary.listenByQuery(
      params: params,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
      args: args,
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
    Object? args,
    bool? lazy,
  }) async {
    final local = await primary.search(checker, params: params, args: args);
    if (local.isValid) return local;
    final remote = await _backup((source) {
      return source.search(checker, params: params, args: args);
    });
    if (remote.isValid) {
      if (lazy ?? this.lazy) {
        primary.creates(remote.result, params: params, args: args);
      } else {
        await primary.creates(remote.result, params: params, args: args);
      }
    }
    return remote;
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) {
        return source.updateById(id, data, params: params, args: args);
      });
    } else {
      await _backup((source) {
        return source.updateById(id, data, params: params, args: args);
      });
    }
    return primary.updateById(id, data, params: params, args: args);
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
    Object? args,
    bool? lazy,
  }) async {
    if (lazy ?? this.lazy) {
      _backup((source) {
        return source.updateByIds(updates, params: params, args: args);
      });
    } else {
      await _backup((source) {
        return source.updateByIds(updates, params: params, args: args);
      });
    }
    return primary.updateByIds(updates, params: params, args: args);
  }
}
