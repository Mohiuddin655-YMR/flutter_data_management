import 'dart:async';

import 'package:data_management/core.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';

part '../base/realtime/realtime_collection_extension.dart';
part '../base/realtime/realtime_collection_finder.dart';
part '../base/realtime/realtime_query_config.dart';
part '../base/realtime/realtime_query_extension.dart';
part '../base/realtime/realtime_query_finder.dart';

///
/// You can use base class [Data] without [Entity]
///

typedef RS = rdb.DataSnapshot;

abstract class RealtimeDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  RealtimeDataSource({
    required this.path,
    super.encryptor,
  });

  rdb.FirebaseDatabase? _db;

  rdb.FirebaseDatabase get database => _db ??= rdb.FirebaseDatabase.instance;

  rdb.DatabaseReference _source<R>(OnDataSourceBuilder<R>? source) {
    final parent = database.ref(path);
    dynamic current = source?.call(parent as R);
    if (current is rdb.DatabaseReference) {
      return current;
    } else {
      return parent;
    }
  }

  rdb.Query _query<R>(OnDataSourceBuilder<R>? source) {
    final parent = database.ref(path);
    dynamic current = source?.call(parent as R);
    if (current is rdb.Query || current is rdb.DatabaseReference) {
      return current;
    } else {
      return parent;
    }
  }

  /// Method to check data by ID with optional data source builder.
  ///
  /// Example:
  /// ```dart
  /// repository.checkById(
  ///   'userId123',
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> checkById<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        var finder = await _source(builder).checkById(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      var finder = await _source(builder).clear(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> create<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (data.id.isValid) {
        final finder = await _source(builder).create(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> creates<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (data.isValid) {
        final finder = await _source(builder).creates(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> deleteById<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        var finder = await _source(builder).deleteById(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> deleteByIds<R>(
    List<String> ids, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (ids.isNotEmpty) {
        var finder = await _source(builder).deleteByIds(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> get<R>({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      var finder = await _query(builder).getAll(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> getById<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      var finder = await _source(builder).getById(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> getByIds<R>(
    List<String> ids, {
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      var finder = await _source(builder).getByIds(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  ///   queries: queries,
  /// );
  /// ```
  @override
  Future<DataResponse<T>> getByQuery<R>({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async {
    if (isConnected) {
      var finder = await _query(builder).queryBy(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Stream<DataResponse<T>> listen<R>({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _query(builder)
            .liveBy(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Stream<DataResponse<T>> listenById<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _source(builder)
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Stream<DataResponse<T>> listenByIds<R>(
    List<String> ids, {
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _source(builder)
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  ///   queries: queries,
  /// );
  /// ```
  @override
  Stream<DataResponse<T>> listenByQuery<R>({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    final controller = StreamController<DataResponse<T>>();
    if (isConnected) {
      try {
        _query(builder)
            .liveByQuery(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> search<R>(
    Checker checker, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      var finder = await _source(builder).searchBy(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> updateById<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (id.isNotEmpty) {
        final finder = await _source(builder).updateById(
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
  ///   builder: (dataSource) {
  ///     // Using Purpose: Build the data source path or URL based on the data source type.
  ///     if (dataSource is Map<String, dynamic>) {
  ///       // For Local database
  ///       return dataSource["sub_collection_id"]["sub_collection_name"];
  ///     } else if (dataSource is CollectionReference) {
  ///       // For Firestore database
  ///       return dataSource.doc("sub_collection_id").collection("sub_collection_name");
  ///     } else if (dataSource is DatabaseReference) {
  ///       // For Realtime database
  ///       return dataSource.child("sub_collection_id").child("sub_collection_name");
  ///     } else if (dataSource is String) {
  ///       // For Api endpoint
  ///       return "$dataSource/{sub_collection_id}/sub_collection_name";
  ///     } else {
  ///       // Back to default source from use case
  ///       return null;
  ///     }
  ///   },
  /// );
  /// ```
  @override
  Future<DataResponse<T>> updateByIds<R>(
    List<UpdatingInfo> updates, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isConnected) {
      if (updates.isNotEmpty) {
        final finder = await _source(builder).updateByIds(
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
