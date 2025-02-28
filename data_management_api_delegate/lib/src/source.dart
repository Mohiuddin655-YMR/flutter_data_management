import 'dart:async';
import 'dart:convert';

import 'package:data_management/core.dart';
import 'package:dio/dio.dart' as dio;

import 'exceptions.dart';

part 'base.dart';
part 'config.dart';
part 'extension.dart';
part 'finder.dart';

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

  String _source(DataFieldParams? params) => params.generate(_path);

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
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    return execute(() {
      var isEncryptor = encryptor != null;
      var endPoint = _source(params);
      final I = api._parent(endPoint);
      final request =
          api.request.isGetRequest ? database.get(I) : database.post(I);
      return request.then((value) async {
        if (value.statusCode != api.status.ok) {
          return Response(status: Status.notFound, error: value.statusMessage);
        }
        var data = value.data;
        if (data == null) return Response(status: Status.notFound);
        final v = isEncryptor ? await encryptor.output(data) : data;
        return Response(status: Status.ok, data: build(v), snapshot: value);
      });
    });
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
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    return execute(() {
      var isEncryptor = encryptor != null;
      final endPoint = _source(params);
      final I = api._parent(endPoint);
      final request =
          api.request.isGetRequest ? database.get(I) : database.post(I);

      List<T> result = [];
      List<_AS> snaps = [];
      return request.then((value) {
        result.clear();
        snaps.clear();
        return request.then((value) async {
          if (value.statusCode != api.status.ok) {
            return Response(
              status: Status.notFound,
              error: value.statusMessage,
            );
          }
          var data = value.data;
          if (data is! List) return Response(status: Status.notFound);

          for (var i in value.data) {
            snaps.add(i);
            final data = i is Map<String, dynamic>
                ? i
                : i is String
                    ? jsonDecode(i)
                    : null;
            if (data is Map) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(build(v));
            }
          }

          if (snaps.isEmpty) return Response(status: Status.notFound);
          final ids = value.docs.map((e) => e.id).toList();
          if (ids.isEmpty) return Response(status: Status.notFound);
          return execute(() {
            return deleteByIds(
              ids,
              params: params,
              isConnected: isConnected,
            ).then((deleted) {
              return deleted.copy(
                backups: value.docs.map((e) => build(e.data())).toList(),
                snapshot: value,
                status: Status.ok,
              );
            });
          });
        });
      });
    });
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
    DataFieldParams? params,
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
        return Response(error: finder.$1, status: finder.$2);
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
    DataFieldParams? params,
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
        return Response(error: finder.$1, status: finder.$2);
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
    DataFieldParams? params,
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
        return Response(error: finder.$1, status: finder.$2);
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
    DataFieldParams? params,
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
        return Response(error: finder.$1, status: finder.$2);
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
    DataFieldParams? params,
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
        error: finder.$2,
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
    DataFieldParams? params,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    if (!isConnected) return Response(status: Status.networkError);
    return execute(() {
      final isEncryptor = encryptor != null;
      final endPoint = _source(params);
      final I = api._parent(endPoint);
      final request =
          api.request.isGetRequest ? database.get(I) : database.post(I);
      return request.then((i) async {
        if (i.statusCode != api.status.ok) {
          return Response(status: Status.notFound, error: i.statusMessage);
        }
        var data = i.data;
        if (data is! Map) {
          return Response(status: Status.invalid);
        }
        final v = isEncryptor ? await encryptor.output(data) : data;
        return Response(status: Status.ok, data: build(v), snapshot: i);
      });
    });
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
    bool isConnected = false,
  }) async {
    if (ids.isEmpty) return Response(status: Status.invalid);
    if (!isConnected) return Response(status: Status.networkError);
    return execute(() {
      final callbacks = ids.map((e) {
        return getById(e, params: params, isConnected: isConnected);
      });
      return Future.wait(callbacks).then((value) {
        final x = value.where((e) => e.isSuccessful);
        return Response(
          status: x.length == ids.length ? Status.ok : Status.canceled,
          result: value.map((e) => e.data).whereType<T>().toList(),
          snapshot: value.map((e) => e.snapshot).toList(),
        );
      });
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
  Future<Response<T>> getByQuery({
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
    bool onlyUpdates = false,
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    return execute(() {
      final endPoint = _source(params);
      final I = api._parent(endPoint);
      final query = _QHelper.query(
        queries: queries,
        sorts: sorts,
        options: options,
      );

      final request = api.request.isPostRequest
          ? database.post(I, data: query)
          : database.get(I, data: query);

      List<T> result = [];
      List<_AS> docs = [];

      return request.then((i) async {
        if (i.statusCode != api.status.ok) {
          return Response(status: Status.notFound, error: i.statusMessage);
        }
        var data = i.data;
        if (data is! List) {
          return Response(status: Status.invalid);
        }

        result.clear();
        docs.clear();

        for (var i in data) {
          docs.add(i);
          if (i != null && i is Map<String, dynamic>) {
            var v = isEncryptor ? await encryptor.output(i) : i;
            result.add(build(v));
          }
        }

        if (result.isEmpty) return Response(status: Status.notFound);
        return Response(result: result, snapshot: docs, status: Status.ok);
      });
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
  Stream<Response<T>> listen({
    bool isConnected = false,
    DataFieldParams? params,
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
            error: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (error) {
        controller.add(Response(
          error: "$error",
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
    DataFieldParams? params,
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
      } catch (error) {
        controller.add(Response(
          error: "$error",
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
    DataFieldParams? params,
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
      } catch (e) {
        controller.add(Response(
          error: "$e",
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
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
    bool onlyUpdates = false,
    bool isConnected = false,
    Future<bool> Function()? isConnected2,
  }) {
    final duration = Duration(milliseconds: api.timer.streamReloadTime);
    final controller = StreamController<Response<T>>();
    Timer.periodic(duration, (_) async {
      final feedback = await getByQuery(
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
        isConnected: await isConnected2!(),
      );
      controller.add(feedback);
    });
    return controller.stream;
  }

  Stream<Response<T>> listenByQuery2({
    bool isConnected = false,
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
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
            error: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (e) {
        controller.add(Response(
          error: "$e",
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
    DataFieldParams? params,
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
        error: finder.$2,
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
    DataFieldParams? params,
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
        return Response(error: finder.$1, status: finder.$2);
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
    DataFieldParams? params,
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
        return Response(error: finder.$1, status: finder.$2);
      } else {
        return Response(status: Status.invalidId);
      }
    } else {
      return Response(status: Status.networkError);
    }
  }
}
