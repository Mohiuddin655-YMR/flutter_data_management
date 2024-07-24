import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_query/in_app_query.dart';

import '../../core/configs.dart';
import '../../core/extensions.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../services/sources/remote.dart';
import '../../utils/encryptor.dart';
import '../../utils/errors.dart';

part '../base/api/base.dart';
part '../base/api/config.dart';
part '../base/api/extension.dart';
part '../base/api/finder.dart';

///
/// You can use base class [Data] without [Entity]
///

typedef _AS = Object?;

abstract class ApiDataSource<T extends Entity> extends RemoteDataSource<T> {
  final Api api;
  final String _path;

  ApiDataSource({
    required this.api,
    required String path,
    super.encryptor,
  }) : _path = path;

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio(api._options);

  String _source(FieldParams? params) => params.generate(_path);

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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        var finder = await database.checkById(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          id: id,
        );
        return Response(
          data: finder.$1?.$1,
          snapshot: finder.$1?.$2,
          exception: finder.$2,
          status: finder.$3,
        );
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> clear({
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await database.clear(
        builder: build,
        encryptor: encryptor,
        api: api,
        endPoint: _source(params),
      );
      return Response(
        backups: finder.$1,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> create(
    T data, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (data.id.isNotEmpty) {
        final finder = await database.create(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          data: data,
        );
        return Response(exception: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> creates(
    List<T> data, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (data.isNotEmpty) {
        final finder = await database.creates(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          data: data,
        );
        return Response(exception: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> deleteById(
    String id, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        var finder = await database.deleteById(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          id: id,
        );
        return Response(exception: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> deleteByIds(
    List<String> ids, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (ids.isNotEmpty) {
        var finder = await database.deleteByIds(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          ids: ids,
        );
        return Response(exception: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> get({
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await database.fetchAll(
        builder: build,
        encryptor: encryptor,
        api: api,
        endPoint: _source(params),
      );
      return Response(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> getById(
    String id, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await database.fetchById(
        builder: build,
        encryptor: encryptor,
        api: api,
        endPoint: _source(params),
        id: id,
      );
      return Response(
        data: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        message: finder.$2,
        status: finder.$3,
      );
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> getByIds(
    List<String> ids, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await database.fetchByIds(
        builder: build,
        encryptor: encryptor,
        api: api,
        endPoint: _source(params),
        ids: ids,
      );
      return Response(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        message: finder.$2,
        status: finder.$3,
      );
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> getByQuery({
    bool isConnected = false,
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) async {
    if (isConnected) {
      var finder = await database.query(
        builder: build,
        encryptor: encryptor,
        api: api,
        endPoint: _source(params),
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      );
      return Response(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return Response(status: Status.networkError);
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
  Stream<Response<T>> listen({
    bool isConnected = false,
    FieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    if (isConnected) {
      try {
        database
            .listen(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
        )
            .listen((finder) {
          controller.add(Response(
            result: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            exception: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(Response(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(Response(status: Status.networkError));
    }
    return controller.stream;
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
    bool isConnected = false,
    FieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    if (isConnected) {
      try {
        database
            .liveById(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          id: id,
        )
            .listen((finder) {
          controller.add(Response(
            data: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            message: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(Response(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(Response(status: Status.networkError));
    }
    return controller.stream;
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
    bool isConnected = false,
    FieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    if (isConnected) {
      try {
        database
            .liveByIds(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          ids: ids,
        )
            .listen((finder) {
          controller.add(Response(
            result: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            message: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(Response(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(Response(status: Status.networkError));
    }
    return controller.stream;
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
    bool isConnected = false,
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<DataSorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<Response<T>>();
    if (isConnected) {
      try {
        database
            .listenByQuery(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        )
            .listen((finder) {
          controller.add(Response(
            result: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            exception: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(Response(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(Response(status: Status.networkError));
    }
    return controller.stream;
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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await database.search(
        builder: build,
        encryptor: encryptor,
        api: api,
        endPoint: _source(params),
        checker: checker,
      );
      return Response(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        final finder = await database.updateById(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          id: id,
          data: data,
        );
        return Response(exception: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
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
  Future<Response<T>> updateByIds(
    List<UpdatingInfo> updates, {
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (updates.isNotEmpty) {
        final finder = await database.updateByIds(
          builder: build,
          encryptor: encryptor,
          api: api,
          endPoint: _source(params),
          data: updates,
        );
        return Response(exception: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
    }
  }
}
