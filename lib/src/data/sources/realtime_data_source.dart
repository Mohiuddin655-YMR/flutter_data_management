import 'dart:async';

import 'package:data_management/core.dart';
import 'package:firebase_database/firebase_database.dart' as rdb;
import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';

part '../helpers/realtime_collection_extension.dart';
part '../helpers/realtime_collection_finder.dart';
part '../helpers/realtime_query_config.dart';
part '../helpers/realtime_query_extension.dart';
part '../helpers/realtime_query_finder.dart';

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

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await _source(builder).findById(
          builder: build,
          encryptor: encryptor,
          id: id,
        );
        return response.withAvailable(
          !finder.$1,
          data: finder.$2,
          message: finder.$4,
          status: finder.$5,
        );
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (data.id.isValid) {
        final finder = await _source(builder).setByOnce(
          builder: build,
          encryptor: encryptor,
          data: data,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          result: finder.$3,
          ignores: finder.$2 != null ? [finder.$2!] : null,
          message: finder.$4,
          status: finder.$5,
        );
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (data.isValid) {
        final finder = await _source(builder).setByMultiple(
          builder: build,
          encryptor: encryptor,
          data: data,
        );
        return response.modify(
          error: !finder.$1,
          successful: finder.$1,
          ignores: finder.$3,
          result: finder.$4,
          message: finder.$5,
          status: finder.$6,
        );
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (id.isValid) {
        final finder = await _source(builder).updateById(
          builder: build,
          encryptor: encryptor,
          id: id,
          data: data,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          backups: finder.$2 != null ? [finder.$2!] : null,
          result: finder.$3,
          message: finder.$4,
          status: finder.$5,
        );
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for delete single data
  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await _source(builder).deleteById(
          builder: build,
          encryptor: encryptor,
          id: id,
        );
        if (finder.$1) {
          return response
              .withBackup(finder.$2)
              .withResult(finder.$3, status: finder.$5);
        } else {
          return response.withException(finder.$4, status: finder.$5);
        }
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for delete all data
  @override
  Future<DataResponse<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _source(builder).clearBy(
        builder: build,
        encryptor: encryptor,
      );
      return response.modify(
        successful: finder.$1,
        error: !finder.$1,
        backups: finder.$2,
        message: finder.$3,
        status: finder.$4,
      );
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for fetch single data
  @override
  Future<DataResponse<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _source(builder).getById(
        builder: build,
        encryptor: encryptor,
        id: id,
      );
      if (finder.$1) {
        return response.withData(finder.$2).withResult(finder.$3);
      } else {
        return response.withException(finder.$4, status: finder.$5);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for fetch all data
  @override
  Future<DataResponse<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _query(builder).getBy(
        builder: build,
        encryptor: encryptor,
        onlyUpdates: forUpdates,
      );
      if (finder.$1) {
        return response.withResult(finder.$2);
      } else {
        return response.withException(finder.$3, status: finder.$4);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for fetch all recent updated data
  @override
  Future<DataResponse<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return gets(
      isConnected: isConnected,
      forUpdates: true,
      builder: builder,
    );
  }

  /// Use for fetch single observable data when data update
  @override
  Stream<DataResponse<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    if (isConnected) {
      try {
        _source(builder)
            .liveById(builder: build, encryptor: encryptor, id: id)
            .listen((finder) {
          if (finder.$1) {
            controller.add(response.withData(finder.$2));
          } else {
            controller.add(
              response.withData(null, message: finder.$4, status: finder.$5),
            );
          }
        });
      } catch (_) {
        controller.add(response.withException(_, status: Status.failure));
      }
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }

  /// Use for fetch all observable data when data update
  @override
  Stream<DataResponse<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    if (isConnected) {
      try {
        _query(builder)
            .liveBy(
          builder: build,
          encryptor: encryptor,
          onlyUpdates: forUpdates,
        )
            .listen((finder) {
          if (finder.$1) {
            controller.add(response.withResult(finder.$2));
          } else {
            controller.add(
              response.withResult(null, message: finder.$3, status: finder.$4),
            );
          }
        });
      } catch (_) {
        controller.add(response.withException(_, status: Status.failure));
      }
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }

  /// Use for fetch data by query
  @override
  Future<DataResponse<T>> query<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const RealtimePagingOptions.empty(),
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _query(builder).getByPaging(
        builder: build,
        encryptor: encryptor,
        queries: queries,
        sorts: sorts,
        options: options,
      );
      if (finder.$1) {
        return response.withResult(finder.$2);
      } else {
        return response.withException(finder.$3, status: finder.$4);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }
}
