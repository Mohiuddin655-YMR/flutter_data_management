import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fdb;
import 'package:data_management/core.dart';

part 'config.dart';

///
/// You can use base class [Data] without [Entity]
///
abstract class FirestoreDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  FirestoreDataSource({
    required this.path,
    super.encryptor,
  });

  fdb.FirebaseFirestore? _db;

  fdb.FirebaseFirestore get database => _db ??= fdb.FirebaseFirestore.instance;

  fdb.CollectionReference _source(DataFieldParams? params) {
    return database.collection(params.generate(path));
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
    return _source(params).doc(id).get().then((value) async {
      if (!value.exists) return Response(status: Status.notFound);
      final v = isEncryptor ? await encryptor.output(value.data) : value.data;
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
      if (value.docs.isEmpty) return Response(status: Status.notFound);
      final ids = value.docs.map((e) => e.id).toList();
      if (ids.isEmpty) return Response(status: Status.notFound);
      return deleteByIds(ids, params: params).then((deleted) {
        return deleted.copy(
          backups: value.docs.map((e) => build(e.data)).toList(),
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
    return _source(params).count().get().then((value) {
      return Response(status: Status.ok, data: value.count);
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
    final ref = _source(params).doc(data.id);
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
      final options = fdb.SetOptions(merge: true);
      return ref.set(data.source, options).then((value) {
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
    return _source(params).doc(id).delete().then((value) {
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
    bool onlyUpdates = false,
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return _source(params).get().then((event) async {
      if (event.docs.isEmpty && event.docChanges.isEmpty) {
        return Response(status: Status.notFound);
      }
      result.clear();
      docs.clear();
      docs = onlyUpdates
          ? event.docChanges.map((e) => e.doc).toList()
          : event.docs;
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.data) : i.data;
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
    return _source(params).doc(id).get().then((event) async {
      if (!event.exists) return Response(status: Status.notFound);
      final data = event.data;
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
    if (ids.length > _Limitations.whereIn) {
      final callbacks = ids.map((e) => getById(e, params: params));
      return Future.wait(callbacks).then((value) {
        final x = value.where((e) => e.isSuccessful);
        return Response(
          status: x.length == ids.length ? Status.ok : Status.canceled,
          result: value.map((e) => e.data).whereType<T>().toList(),
        );
      }, onError: error);
    } else {
      List<T> result = [];
      return _source(params)
          .where(DataFieldPath.documentId, whereIn: ids)
          .get()
          .then((event) async {
        if (event.docs.isEmpty) return Response(status: Status.notFound);
        result.clear();
        for (var i in event.docs) {
          if (i.exists) {
            var data = i.data;
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(build(v));
          }
        }
        if (result.isEmpty) return Response(status: Status.notFound);
        return Response(status: Status.ok, result: result, snapshot: event);
      }, onError: error);
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
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
    bool onlyUpdates = false,
    bool isConnected = false,
  }) async {
    if (!isConnected) return Response(status: Status.networkError);
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return _QHelper.query(
      reference: _source(params),
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).get().then((event) async {
      if (event.docs.isEmpty && event.docChanges.isEmpty) {
        return Response(status: Status.notFound);
      }
      result.clear();
      docs.clear();
      docs = onlyUpdates
          ? event.docChanges.map((e) => e.doc).toList()
          : event.docs;
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.data) : i.data;
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
    bool onlyUpdates = false,
    bool isConnected = false,
  }) {
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return _source(params).snapshots().asyncMap((event) async {
      if (event.docs.isEmpty && event.docChanges.isEmpty) {
        return Response(status: Status.notFound);
      }
      result.clear();
      docs.clear();
      docs = onlyUpdates
          ? event.docChanges.map((e) => e.doc).toList()
          : event.docs;
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.data) : i.data;
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
    return Stream.fromFuture(_source(params).count().get().then((e) {
      return Response(data: e.count, status: Status.ok);
    }));
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
    return _source(params).doc(id).snapshots().asyncMap((event) async {
      if (!event.exists) return Response(status: Status.notFound);
      var data = event.data;
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
    if (ids.length > _Limitations.whereIn) {
      Map<String, T> map = {};
      Map<String, fdb.DocumentSnapshot> snaps = {};
      return StreamGroup.merge(ids.map((e) {
        return listenById(e, params: params);
      })).map((event) {
        final data = event.data;
        final snap = event.snapshot;
        if (data != null) map[data.id] = data;
        if (snap is fdb.DocumentSnapshot) snaps[snap.id] = snap;
        if (map.isEmpty) return Response(status: Status.notFound);
        return Response(
          result: map.values.toList(),
          snapshot: snaps.values.toList(),
          status: Status.ok,
        );
      });
    } else {
      List<T> result = [];
      return _source(params)
          .where(DataFieldPath.documentId, whereIn: ids)
          .snapshots()
          .asyncMap((event) async {
        result.clear();
        if (event.docs.isNotEmpty) {
          for (final i in event.docs) {
            final data = i.data;
            if (i.exists) {
              final v = isEncryptor ? await encryptor.output(data) : data;
              result.add(build(v));
            }
          }
          if (result.isEmpty) return Response(status: Status.notFound);
          return Response(
            status: Status.ok,
            result: result,
            snapshot: event.docs,
          );
        }
        return Response(status: Status.notFound);
      });
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
  Stream<Response<T>> listenByQuery({
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
    bool onlyUpdates = false,
    bool isConnected = false,
  }) {
    if (!isConnected) {
      return Stream.value(Response(status: Status.networkError));
    }
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return _QHelper.query(
      reference: _source(params),
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).snapshots().asyncMap((event) async {
      if (event.docs.isEmpty && event.docChanges.isEmpty) {
        return Response(status: Status.notFound);
      }
      result.clear();
      docs.clear();
      docs = onlyUpdates
          ? event.docChanges.map((e) => e.doc).toList()
          : event.docs;
      for (var i in docs) {
        if (!i.exists) continue;
        final v = isEncryptor ? await encryptor.output(i.data) : i.data;
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
      if (event.docs.isEmpty) return Response(status: Status.notFound);
      result.clear();
      for (final i in event.docs) {
        if (i.exists) {
          final data = i.data;
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
    final ref = _source(params).doc(id);
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
