import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as fdb;
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:data_management/core.dart';
import 'package:flutter_andomie/core.dart';

part '../base/firestore/config.dart';
part '../base/firestore/extension.dart';
part '../base/firestore/finder.dart';

///
/// You can use base class [Data] without [Entity]
///

typedef _FS = fdb.DocumentSnapshot;

abstract class FirestoreDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  FirestoreDataSource({
    required this.path,
    super.encryptor,
  });

  fdb.FirebaseFirestore? _db;

  fdb.FirebaseFirestore get database => _db ??= fdb.FirebaseFirestore.instance;

  fdb.CollectionReference _source(FieldParams? params) {
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
  Future<DataResponse<T>> checkById(
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
        return DataResponse(
          data: finder.$1?.$1,
          snapshot: finder.$1?.$2,
          exception: finder.$2,
          status: finder.$3,
        );
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await _source(params).clear(
        builder: build,
        encryptor: encryptor,
      );
      return DataResponse(
        backups: finder.$1,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (data.id.isValid) {
        final finder = await _source(params).create(
          builder: build,
          encryptor: encryptor,
          data: data,
        );
        return DataResponse(exception: finder.$1, status: finder.$2);
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      if (data.isValid) {
        final finder = await _source(params).creates(
          builder: build,
          encryptor: encryptor,
          data: data,
        );
        return DataResponse(exception: finder.$1, status: finder.$2);
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
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
        return DataResponse(exception: finder.$1, status: finder.$2);
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
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
        return DataResponse(exception: finder.$1, status: finder.$2);
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    bool forUpdates = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await _source(params).fetch(
        builder: build,
        encryptor: encryptor,
        onlyUpdates: forUpdates,
      );
      return DataResponse(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await _source(params).fetchById(
        builder: build,
        encryptor: encryptor,
        id: id,
      );
      return DataResponse(
        data: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        message: finder.$2,
        status: finder.$3,
      );
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    bool forUpdates = false,
    FieldParams? params,
  }) async {
    if (isConnected) {
      var finder = await _source(params).fetchByIds(
        builder: build,
        encryptor: encryptor,
        ids: ids,
      );
      return DataResponse(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        message: finder.$2,
        status: finder.$3,
      );
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    bool forUpdates = false,
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async {
    if (isConnected) {
      var finder = await _source(params).query(
        builder: build,
        encryptor: encryptor,
        onlyUpdates: forUpdates,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      );
      return DataResponse(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return DataResponse(status: Status.networkError);
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
    bool isConnected = false,
    bool forUpdates = false,
    FieldParams? params,
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _source(params)
            .listen(
          builder: build,
          encryptor: encryptor,
          onlyUpdates: forUpdates,
        )
            .listen((finder) {
          controller.add(DataResponse(
            result: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            exception: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(DataResponse(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(DataResponse(status: Status.networkError));
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
  Stream<DataResponse<T>> listenById(
    String id, {
    bool isConnected = false,
    FieldParams? params,
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _source(params)
            .liveById(builder: build, encryptor: encryptor, id: id)
            .listen((finder) {
          controller.add(DataResponse(
            data: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            message: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(DataResponse(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(DataResponse(status: Status.networkError));
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
  Stream<DataResponse<T>> listenByIds(
    List<String> ids, {
    bool isConnected = false,
    bool forUpdates = false,
    FieldParams? params,
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _source(params)
            .liveByIds(builder: build, encryptor: encryptor, ids: ids)
            .listen((finder) {
          controller.add(DataResponse(
            result: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            message: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(DataResponse(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(DataResponse(status: Status.networkError));
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
  Stream<DataResponse<T>> listenByQuery({
    bool isConnected = false,
    bool forUpdates = false,
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _source(params)
            .listenByQuery(
          builder: build,
          encryptor: encryptor,
          onlyUpdates: forUpdates,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        )
            .listen((finder) {
          controller.add(DataResponse(
            result: finder.$1?.$1,
            snapshot: finder.$1?.$2,
            exception: finder.$2,
            status: finder.$3,
          ));
        });
      } catch (_) {
        controller.add(DataResponse(
          exception: "$_",
          status: Status.failure,
        ));
      }
    } else {
      controller.add(DataResponse(status: Status.networkError));
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
  Future<DataResponse<T>> search(
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
      return DataResponse(
        result: finder.$1?.$1,
        snapshot: finder.$1?.$2,
        exception: finder.$2,
        status: finder.$3,
      );
    } else {
      return DataResponse(status: Status.networkError);
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
        return DataResponse(exception: finder.$1, status: finder.$2);
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
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
        return DataResponse(exception: finder.$1, status: finder.$2);
      } else {
        return DataResponse(status: Status.invalidId);
      }
    } else {
      return DataResponse(status: Status.networkError);
    }
  }
}
