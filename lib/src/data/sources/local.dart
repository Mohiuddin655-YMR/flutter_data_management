import 'dart:async';

import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_database/in_app_database.dart' as fdb;
import 'package:in_app_query/in_app_query.dart';

import '../../core/configs.dart';
import '../../core/extensions.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../services/sources/local.dart';
import '../../utils/encryptor.dart';
import '../../utils/errors.dart';

part '../base/local/config.dart';
part '../base/local/extension.dart';
part '../base/local/finder.dart';

typedef _Snapshot = fdb.InAppDocumentSnapshot;

///
/// You can use base class [Data] without [Entity]
///
abstract class LocalDataSourceImpl<T extends Entity>
    extends LocalDataSource<T> {
  const LocalDataSourceImpl({
    required super.path,
    required super.database,
    super.reloadDuration,
  });

  fdb.InAppQueryReference _source(FieldParams? params) {
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
    FieldParams? params,
  }) async {
    if (id.isNotEmpty) {
      var finder = await _source(params).checkById(
        builder: build,
        encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    var finder = await _source(params).clear(
      builder: build,
      encryptor: encryptor,
    );
    return Response(
      backups: finder.$1,
      exception: finder.$2,
      status: finder.$3,
    );
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
    FieldParams? params,
  }) async {
    if (data.id.isNotEmpty) {
      final finder = await _source(params).create(
        builder: build,
        encryptor: encryptor,
        data: data,
      );
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
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
    FieldParams? params,
    bool store = false,
  }) async {
    if (data.isNotEmpty) {
      final finder = await _source(params).creates(
        builder: build,
        encryptor: encryptor,
        data: data,
      );
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
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
    FieldParams? params,
  }) async {
    if (id.isNotEmpty) {
      var finder = await _source(params).deleteById(
        builder: build,
        encryptor: encryptor,
        id: id,
      );
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
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
    FieldParams? params,
  }) async {
    if (ids.isNotEmpty) {
      var finder = await _source(params).deleteByIds(
        builder: build,
        encryptor: encryptor,
        ids: ids,
      );
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
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
    FieldParams? params,
  }) async {
    var finder = await _source(params).fetch(
      builder: build,
      encryptor: encryptor,
    );
    return Response(
      result: finder.$1?.$1,
      snapshot: finder.$1?.$2,
      exception: finder.$2,
      status: finder.$3,
    );
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
    FieldParams? params,
  }) async {
    var finder = await _source(params).fetchById(
      builder: build,
      encryptor: encryptor,
      id: id,
    );
    return Response(
      data: finder.$1?.$1,
      snapshot: finder.$1?.$2,
      message: finder.$2,
      status: finder.$3,
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
    FieldParams? params,
  }) async {
    var finder = await _source(params).fetchByIds(
      builder: build,
      encryptor: encryptor,
      ids: ids,
    );
    return Response(
      result: finder.$1?.$1,
      snapshot: finder.$1?.$2,
      message: finder.$2,
      status: finder.$3,
    );
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
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) async {
    var finder = await _source(params).query(
      builder: build,
      encryptor: encryptor,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    );
    final snapshot = finder.$1?.$2;
    final response = Response(
      result: finder.$1?.$1,
      snapshot: snapshot,
      exception: finder.$2,
      status: finder.$3,
    );
    return response;
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
    FieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    try {
      _source(params)
          .listen(
        builder: build,
        encryptor: encryptor,
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
    FieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    try {
      _source(params)
          .liveById(builder: build, encryptor: encryptor, id: id)
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
    FieldParams? params,
  }) {
    final controller = StreamController<Response<T>>();
    try {
      _source(params)
          .liveByIds(builder: build, encryptor: encryptor, ids: ids)
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
    FieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<Response<T>>();
    try {
      _source(params)
          .listenByQuery(
        builder: build,
        encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    var finder = await _source(params).search(
      builder: build,
      encryptor: encryptor,
      checker: checker,
    );
    return Response(
      result: finder.$1?.$1,
      snapshot: finder.$1?.$2,
      exception: finder.$2,
      status: finder.$3,
    );
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
    FieldParams? params,
  }) async {
    if (id.isNotEmpty) {
      final finder = await _source(params).updateById(
        builder: build,
        encryptor: encryptor,
        id: id,
        data: data,
      );
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
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
    FieldParams? params,
  }) async {
    if (updates.isNotEmpty) {
      final finder = await _source(params).updateByIds(
        builder: build,
        encryptor: encryptor,
        data: updates,
      );
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
    }
  }

  @override
  Future<Response<T>> keep(
    List<T> data, {
    FieldParams? params,
  }) async {
    if (data.isNotEmpty) {
      final finder = await _source(params).keep(data);
      return Response(exception: finder.$1, status: finder.$2);
    } else {
      return Response(status: Status.invalidId);
    }
  }
}
