import 'dart:async';

import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_query/in_app_query.dart';

import '../../core/configs.dart';
import '../../core/extensions.dart';
import '../../models/checker.dart';
import '../../models/updating_info.dart';
import '../../services/sources/remote.dart';
import '../../utils/encryptor.dart';
import '../../utils/errors.dart';

part '../base/realtime/config.dart';
part '../base/realtime/extension.dart';
part '../base/realtime/finder.dart';

///
/// You can use base class [Data] without [Entity]
///

typedef _RS = rdb.DataSnapshot;

abstract class RealtimeDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  RealtimeDataSource({
    required this.path,
    super.encryptor,
  });

  rdb.FirebaseDatabase? _db;

  rdb.FirebaseDatabase get database => _db ??= rdb.FirebaseDatabase.instance;

  rdb.DatabaseReference _source(FieldParams? params) {
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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        var finder = await _source(params).checkById(
          builder: build,
          encryptor: encryptor,
          id: id,
        );
        return Response(
          data: finder.$1?.$1,
          snapshot: finder.$1?.$2,
          error: finder.$2,
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
      var finder = await _source(params).clear(
        builder: build,
        encryptor: encryptor,
      );
      return Response(
        backups: finder.$1,
        error: finder.$2,
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
        final finder = await _source(params).create(
          builder: build,
          encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (data.isNotEmpty) {
        final finder = await _source(params).creates(
          builder: build,
          encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        var finder = await _source(params).deleteById(
          builder: build,
          encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (ids.isNotEmpty) {
        var finder = await _source(params).deleteByIds(
          builder: build,
          encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await _source(params).fetch(
        builder: build,
        encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
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
      var finder = await _source(params).query(
        builder: build,
        encryptor: encryptor,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
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
        _source(params)
            .listen(
          builder: build,
          encryptor: encryptor,
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
    bool isConnected = false,
    FieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<Response<T>>();
    if (isConnected) {
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await _source(params).search(
        builder: build,
        encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        final finder = await _source(params).updateById(
          builder: build,
          encryptor: encryptor,
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
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (updates.isNotEmpty) {
        final finder = await _source(params).updateByIds(
          builder: build,
          encryptor: encryptor,
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
