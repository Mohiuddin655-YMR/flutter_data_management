import 'dart:async';
import 'dart:convert';

import 'package:data_management/data_management.dart';
import 'package:dio/dio.dart' as dio;

part 'base.dart';
part 'config.dart';

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
    Object? args,
  }) async {
    return execute(() {
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
    Object? args,
  }) async {
    return execute(() {
      var isEncryptor = encryptor != null;
      var endPoint = _source(params);
      final I = api._parent(endPoint);
      final request =
          api.request.isGetRequest ? database.get(I) : database.post(I);

      List<T> result = [];
      List<_AS> snaps = [];

      return request.then((value) async {
        if (value.statusCode != api.status.ok) {
          return Response(status: Status.notFound, error: value.statusMessage);
        }
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
            final data = i is Map
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
          final ids = result.map((e) => e.id).toList();
          if (ids.isEmpty) return Response(status: Status.notFound);
          return deleteByIds(ids, params: params, args: args).then((deleted) {
            return deleted.copy(
              backups: result,
              snapshot: snaps,
              status: Status.ok,
            );
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
    DataFieldParams? params,
    Object? args,
  }) async {
    if (data.id.isEmpty) return Response(status: Status.invalidId);
    final endPoint = _source(params);
    var I = api._parent(endPoint).child(data.id, api.autoGenerateId);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        final result = await database.post(I, data: raw);
        final code = result.statusCode;
        if (code == api.status.created || code == api.status.ok) {
          return Response(status: Status.ok);
        } else {
          return Response(error: "Data hasn't inserted!");
        }
      } else {
        return Response(error: "Encryption error!");
      }
    } else {
      final result = await database.post(I, data: data.source);
      final code = result.statusCode;
      if (code == api.status.created || code == api.status.ok) {
        return Response(status: Status.ok);
      } else {
        return Response(error: "Data hasn't inserted!");
      }
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
    DataFieldParams? params,
    Object? args,
  }) async {
    if (data.isEmpty) return Response(status: Status.invalidId);
    return Future.wait(data.map((e) {
      return create(e, params: params, args: args);
    })).then((value) {
      return Response(status: Status.ok);
    });
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
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    final endPoint = _source(params);
    final I = api._parent(endPoint).child(id);
    return database.delete(I).then((value) {
      var code = value.statusCode;
      if (code == api.status.ok || code == api.status.deleted) {
        return Response(status: Status.ok);
      } else {
        return Response(error: "Data hasn't deleted!");
      }
    });
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
  }) async {
    if (ids.isEmpty) return Response(status: Status.invalidId);
    return Future.wait(ids.map((e) {
      return deleteById(e, params: params, args: args);
    })).then((value) {
      return Response(status: Status.ok);
    });
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
  }) async {
    final endPoint = _source(params);
    final I = api._parent(endPoint);
    final request =
        api.request.isGetRequest ? database.get(I) : database.post(I);
    List<T> result = [];
    List<_AS> snaps = [];
    return request.then((response) async {
      result.clear();
      snaps.clear();
      if (response.statusCode == api.status.ok) {
        if (response.data is List) {
          for (var i in response.data) {
            snaps.add(i);
            final data = i is Map<String, dynamic>
                ? i
                : i is String
                    ? jsonDecode(i)
                    : null;
            if (data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(build(v));
            }
          }
        }
        return Response(result: result, snapshot: snaps);
      } else {
        return Response(error: "Data hasn't found!");
      }
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
  Future<Response<T>> getById(
    String id, {
    DataFieldParams? params,
    Object? args,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
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
    Object? args,
  }) async {
    if (ids.isEmpty) return Response(status: Status.invalid);
    return execute(() {
      final callbacks = ids.map((e) {
        return getById(e, params: params, args: args);
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
    Object? args,
    bool onlyUpdates = false,
  }) async {
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
    DataFieldParams? params,
    Object? args,
  }) {
    final controller = StreamController<Response<T>>();
    final duration = Duration(milliseconds: api.timer.streamReloadTime);
    Timer.periodic(duration, (_) async {
      final feedback = await get(params: params, args: args);
      controller.add(feedback);
    });
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
    DataFieldParams? params,
    Object? args,
  }) {
    final controller = StreamController<Response<T>>();
    final duration = Duration(milliseconds: api.timer.streamReloadTime);
    Timer.periodic(duration, (_) async {
      final feedback = await getById(id, params: params, args: args);
      controller.add(feedback);
    });
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
    DataFieldParams? params,
    Object? args,
  }) {
    final controller = StreamController<Response<T>>();
    final duration = Duration(milliseconds: api.timer.streamReloadTime);
    Timer.periodic(duration, (_) async {
      final feedback = await getByIds(ids, params: params, args: args);
      controller.add(feedback);
    });
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
    Object? args,
    bool onlyUpdates = false,
  }) {
    final duration = Duration(milliseconds: api.timer.streamReloadTime);
    final controller = StreamController<Response<T>>();
    Timer.periodic(duration, (_) async {
      final feedback = await getByQuery(
        params: params,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
        args: args,
        onlyUpdates: onlyUpdates,
      );
      controller.add(feedback);
    });
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
    DataFieldParams? params,
    Object? args,
  }) async {
    final endPoint = _source(params);
    final I = api._parent(endPoint);
    final query = _QHelper.search(checker);
    final request = api.request.isPostRequest
        ? database.post(I, data: query)
        : database.get(I, data: query);

    List<T> result = [];
    List<_AS> docs = [];

    return request.then((response) async {
      result.clear();
      docs.clear();
      if (response.statusCode == api.status.ok) {
        if (response.data is List) {
          for (var i in response.data) {
            docs.add(i);
            if (i != null && i is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(i) : i;
              result.add(build(v));
            }
          }
        }
        return Response(result: result, snapshot: docs);
      } else {
        return Response(error: "Data hasn't found!");
      }
    });
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
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    final endPoint = _source(params);
    var I = api._parent(endPoint).child(id);
    if (isEncryptor) {
      return getById(id, params: params, args: args).then((value) async {
        final x = value.data?.source ?? {};
        x.addAll(data);
        var v = await encryptor.input(x);
        if (v.isNotEmpty) {
          return database.put(I, data: v).then((value) {
            final code = value.statusCode;
            if (code == api.status.ok || code == api.status.updated) {
              return Response(status: Status.ok);
            } else {
              return Response(error: "Data hasn't updated!");
            }
          });
        } else {
          return Response(error: "Encryption error!");
        }
      });
    } else {
      return database.put(I, data: data).then((value) {
        final code = value.statusCode;
        if (code == api.status.ok || code == api.status.updated) {
          return Response(status: Status.ok);
        } else {
          return Response(error: "Data hasn't updated!");
        }
      });
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
    DataFieldParams? params,
    Object? args,
  }) async {
    if (updates.isEmpty) return Response(status: Status.invalid);
    return Future.wait(updates.map((e) {
      return updateById(e.id, e.data, params: params, args: args);
    })).then((value) {
      return Response(status: Status.ok);
    });
  }
}

extension _ApiPathExtension on String {
  String child(String path, [bool ignoreId = false]) {
    if (ignoreId) {
      return this;
    } else {
      return "$this/$path";
    }
  }
}
