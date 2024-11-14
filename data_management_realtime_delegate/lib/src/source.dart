import 'dart:async';

import 'package:async/async.dart';
import 'package:data_management/core.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;

part 'config.dart';

///
/// You can use base class [Data] without [Entity]
///

abstract class RealtimeDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  RealtimeDataSource({
    required this.path,
    super.encryptor,
  });

  rdb.FirebaseDatabase? _db;

  rdb.FirebaseDatabase get database => _db ??= rdb.FirebaseDatabase.instance;

  rdb.DatabaseReference _source(DataFieldParams? params) {
    return database.ref(params.generate(path));
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
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    return _source(params).child(id).get().then((value) async {
      if (!value.exists) return Response(status: Status.notFound);
      final data = value.value;
      final v = isEncryptor ? await encryptor.output(data) : data;
      return Response(status: Status.ok, data: build(v), snapshot: value);
    }, onError: error);
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
    return _source(params).get().then((value) async {
      if (!value.exists) return Response(status: Status.notFound);
      final ids = value.children.map((e) => e.key).whereType<String>().toList();
      if (ids.isEmpty) return Response(status: Status.notFound);
      return deleteByIds(ids, params: params).then((deleted) {
        return deleted.copy(
          backups: value.children.map((e) => build(e.value)).toList(),
          snapshot: value,
          status: Status.ok,
        );
      }, onError: error);
    }, onError: error);
  }

  @override
  Future<Response<int>> count({
    DataFieldParams? params,
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    return _source(params).get().then((value) {
      return Response(status: Status.ok, data: value.children.length);
    }, onError: error);
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
    bool isConnected = false,
  }) async {
    if (data.id.isEmpty) return Response(status: Status.invalidId);
    if (!isConnected) return Response(status: Status.networkError);
    final ref = _source(params).child(data.id);
    if (isEncryptor) {
      final raw = await encryptor.input(data.source);
      if (raw.isEmpty) {
        return Response(
          status: Status.error,
          error: "Encryption error!",
        );
      }
      return ref.set(raw).then((value) {
        return Response(status: Status.ok, data: data);
      }, onError: error);
    } else {
      return ref.set(data.source).then((value) {
        return Response(status: Status.ok, data: data);
      }, onError: error);
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
    bool store = false,
    bool isConnected = false,
  }) async {
    if (data.isEmpty) return Response(status: Status.invalid);
    if (!isConnected) return Response(status: Status.networkError);
    final callbacks = data.map((e) => create(e, params: params));
    return Future.wait(callbacks).then((value) {
      final x = value.where((e) => e.isSuccessful);
      return Response(
        status: x.length == data.length ? Status.ok : Status.canceled,
        snapshot: value,
      );
    }, onError: error);
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
    bool isConnected = false,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    if (!isConnected) return Response(status: Status.networkError);
    final old = await getById(id);
    return _source(params).child(id).remove().then((value) {
      return Response(
        status: Status.ok,
        backups: [if (old.isValid) old.data!],
      );
    }, onError: error);
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
    bool isConnected = false,
  }) async {
    if (ids.isEmpty) return Response(status: Status.invalid);
    if (!isConnected) return Response(status: Status.networkError);
    final callbacks = ids.map((e) => deleteById(e, params: params));
    return Future.wait(callbacks).then((value) {
      final x = value.where((e) => e.isSuccessful);
      return Response(
        status: x.length == ids.length ? Status.ok : Status.canceled,
        snapshot: value,
        backups: value.map((e) => e.data).whereType<T>().toList(),
      );
    }, onError: error);
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
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    List<T> result = [];
    List<rdb.DataSnapshot> docs = [];
    return _source(params).get().then((event) async {
      if (!event.exists) return Response(status: Status.notFound);
      result.clear();
      docs.clear();
      docs = event.children.toList();
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.value) : i.value;
        result.add(build(v));
      }
      if (result.isEmpty) return Response(status: Status.notFound);
      return Response(result: result, snapshot: docs, status: Status.ok);
    }, onError: error);
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
    bool isConnected = false,
  }) async {
    if (id.isEmpty) return Response(status: Status.invalidId);
    if (!isConnected) return Response(status: Status.networkError);
    return _source(params).child(id).get().then((event) async {
      if (!event.exists) return Response(status: Status.notFound);
      final data = event.value;
      final v = isEncryptor ? await encryptor.output(data) : data;
      return Response(status: Status.ok, data: build(v), snapshot: event);
    }, onError: error);
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
    final callbacks = ids.map((e) => getById(e, params: params));
    return Future.wait(callbacks).then((value) {
      final x = value.where((e) => e.isSuccessful);
      return Response(
        status: x.length == ids.length ? Status.ok : Status.canceled,
        result: value.map((e) => e.data).whereType<T>().toList(),
      );
    }, onError: error);
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
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    List<T> result = [];
    List<rdb.DataSnapshot> docs = [];
    return _QHelper.query(
      reference: _source(params),
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).get().then((event) async {
      if (!event.exists) return Response(status: Status.notFound);
      result.clear();
      docs.clear();
      docs = event.children.toList();
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.value) : i.value;
        result.add(build(v));
      }
      if (result.isEmpty) return Response(status: Status.notFound);
      return Response(result: result, snapshot: docs, status: Status.ok);
    }, onError: error);
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
    bool isConnected = false,
  }) {
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    List<T> result = [];
    List<rdb.DataSnapshot> docs = [];
    return _source(params).onValue.asyncMap((event) async {
      if (!event.snapshot.exists) return Response(status: Status.notFound);
      result.clear();
      docs.clear();
      docs = event.snapshot.children.toList();
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.value) : i.value;
        result.add(build(v));
      }
      if (result.isEmpty) return Response(status: Status.notFound);
      return Response(result: result, snapshot: docs, status: Status.ok);
    });
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
    bool isConnected = false,
  }) {
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    return _source(params).onValue.map((e) {
      return Response(data: e.snapshot.children.length, status: Status.ok);
    });
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
    bool isConnected = false,
  }) {
    if (id.isEmpty) return Stream.value(Response(status: Status.invalidId));
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    return _source(params).child(id).onValue.asyncMap((event) async {
      if (!event.snapshot.exists) return Response(status: Status.notFound);
      var data = event.snapshot.value;
      final v = isEncryptor ? await encryptor.output(data) : data;
      return Response(status: Status.ok, data: build(v), snapshot: event);
    });
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
    bool isConnected = false,
  }) {
    if (ids.isEmpty) return Stream.value(Response(status: Status.invalid));
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    Map<String, T> map = {};
    Map<String, rdb.DataSnapshot> snaps = {};
    return StreamGroup.merge(ids.map((e) {
      return listenById(e, params: params);
    })).map((event) {
      final data = event.data;
      final snap = event.snapshot;
      if (data != null) map[data.id] = data;
      if (snap is rdb.DataSnapshot) snaps[snap.key ?? ''] = snap;
      if (map.isEmpty) return Response(status: Status.notFound);
      return Response(
        result: map.values.toList(),
        snapshot: snaps.values.toList(),
        status: Status.ok,
      );
    });
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
    bool isConnected = false,
  }) {
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    List<T> result = [];
    List<rdb.DataSnapshot> docs = [];
    return _QHelper.query(
      reference: _source(params),
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).onValue.asyncMap((event) async {
      if (!event.snapshot.exists) return Response(status: Status.notFound);
      result.clear();
      docs.clear();
      docs = event.snapshot.children.toList();
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.value) : i.value;
        result.add(build(v));
      }
      if (result.isEmpty) return Response(status: Status.notFound);
      return Response(result: result, snapshot: docs, status: Status.ok);
    });
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
    bool isConnected = false,
  }) async {
    if (checker.field.isEmpty) return Response(status: Status.invalid);
    if (!isConnected) return Response(status: Status.networkError);
    List<T> result = [];
    return _QHelper.search(_source(params), checker).get().then((event) async {
      if (!event.exists) return Response(status: Status.notFound);
      result.clear();
      for (final i in event.children) {
        if (i.exists) {
          final data = i.value;
          final v = isEncryptor ? await encryptor.output(data) : data;
          result.add(build(v));
        }
      }
      if (result.isEmpty) return Response(status: Status.notFound);
      return Response(status: Status.ok, result: result, snapshot: event);
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
    bool isConnected = false,
  }) async {
    if (id.isEmpty || data.isEmpty) return Response(status: Status.invalid);
    if (!isConnected) return Response(status: Status.networkError);
    final ref = _source(params).child(id);
    if (!isEncryptor) {
      return ref.update(data).then((value) => Response(status: Status.ok));
    }
    return getById(id, params: params).then((value) async {
      final x = value.data?.source ?? {};
      x.addAll(data);
      final v = await encryptor.input(x);
      if (v.isEmpty) return Response(status: Status.nullable);
      return ref.update(v).then((value) => Response(status: Status.ok));
    });
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
    bool isConnected = false,
  }) async {
    if (updates.isEmpty) return Response(status: Status.invalid);
    if (!isConnected) return Response(status: Status.networkError);
    final callbacks = updates.map((e) {
      return updateById(e.id, e.data, params: params);
    });
    return Future.wait(callbacks).then((value) {
      final x = value.where((e) => e.isSuccessful);
      return Response(
        status: x.length == updates.length ? Status.ok : Status.canceled,
        snapshot: value,
        backups: value.map((e) => e.data).whereType<T>().toList(),
      );
    }, onError: error);
  }
}

Future<Response<T>> error<T extends Object>(
  Object? error,
  StackTrace stackTrace,
) async {
  return Response(status: Status.failure, error: error.toString());
}
