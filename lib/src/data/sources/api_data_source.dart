import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../services/sources/remote_data_source.dart';
import '../../utils/response.dart';

part '../base/api/api_base_config.dart';
part '../base/api/api_data_finder.dart';
part '../base/api/api_extension.dart';
part '../base/api/api_path_extension.dart';
part '../base/api/api_query_config.dart';

///
/// You can use base class [Data] without [Entity]
///

typedef AS = String;

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

  String _source(OnDataSourceBuilder? source) {
    return source?.call(_path) ?? _path;
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await database.getById(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: _source(builder),
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
  Future<DataResponse<T>> create(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (data.id.isValid) {
        final finder = await database.insert(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: _source(builder),
          data: data,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          result: finder.$3,
          feedback: finder.$2,
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
  Future<DataResponse<T>> creates(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (data.isValid) {
        final finder = await database.inserts(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: _source(builder),
          data: data,
        );
        return response.modify(
          error: !finder.$1,
          successful: finder.$1,
          ignores: finder.$3,
          feedback: finder.$4,
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
  Future<DataResponse<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (id.isValid) {
        final finder = await database.update(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: _source(builder),
          id: id,
          data: data,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          backups: finder.$2 != null ? [finder.$2!] : null,
          feedback: finder.$3,
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
  Future<DataResponse<T>> deleteById(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await database.deleteById(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: _source(builder),
          id: id,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          backups: finder.$2 != null ? [finder.$2!] : null,
          feedback: finder.$3,
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

  /// Use for delete all data
  @override
  Future<DataResponse<T>> clear({
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await database.clear(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: _source(builder),
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
  Future<DataResponse<T>> getById(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await database.getById(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: _source(builder),
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
  Future<DataResponse<T>> get({
    bool isConnected = false,
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await database.gets(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: _source(builder),
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

  /// Use for fetch data by paging
  @override
  Future<DataResponse<T>> getByQuery({
    bool isConnected = false,
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const ApiPagingOptions.empty(),
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await database.getsByQuery(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: _source(builder),
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

  /// Use for fetch query observable data when changes
  @override
  Stream<DataResponse<T>> listenByQuery({
    OnDataSourceBuilder? builder,
    bool isConnected = false,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    if (isConnected) {
      database
          .getsByQueryRealtime(
              api: api,
              builder: build,
              encryptor: encryptor,
              path: _source(builder))
          .listen((finder) {
        if (finder.$1) {
          controller.add(response.withResult(finder.$2));
        } else {
          controller.add(
            response.withResult(null, message: finder.$3, status: finder.$4),
          );
        }
      });
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }

  /// Use for fetch single observable data when data update
  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    if (isConnected) {
      database
          .getByRealtime(
              api: api,
              builder: build,
              encryptor: encryptor,
              path: _source(builder),
              id: id)
          .listen((finder) {
        if (finder.$1) {
          controller.add(response.withData(finder.$2));
        } else {
          controller.add(
            response.withData(null, message: finder.$4, status: finder.$5),
          );
        }
      });
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }

  /// Use for fetch all observable data when data update
  @override
  Stream<DataResponse<T>> listen({
    bool isConnected = false,
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    if (isConnected) {
      database
          .getsByQueryRealtime(
              api: api,
              builder: build,
              encryptor: encryptor,
              path: _source(builder))
          .listen((finder) {
        if (finder.$1) {
          controller.add(response.withResult(finder.$2));
        } else {
          controller.add(
            response.withResult(null, message: finder.$3, status: finder.$4),
          );
        }
      });
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }
}
