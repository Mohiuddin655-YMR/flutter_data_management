part of 'sources.dart';

///
/// You can use base class [Data] without [Entity]
///
abstract class LocalDataSourceImpl<T extends Entity>
    extends LocalDataSource<T> {
  LocalDataSourceImpl({
    required super.path,
    super.database,
  });

  String _source<R>(OnDataSourceBuilder<R>? source,) {
    final parent = path;
    dynamic current = source?.call(parent as R);
    if (current is String) {
      return current;
    } else {
      return parent;
    }
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (id.isValid) {
      var finder = await database.findById(
        id: id,
        path: _source(builder),
        builder: build,
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
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> insert<R>(T data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    try {
      if (data.id.isValid) {
        final finder = await database.setByData(
          data: data,
          path: _source(builder),
          builder: build,
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
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> inserts<R>(List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    try {
      if (data.isValid) {
        final finder = await database.setByList(
          data: data,
          path: _source(builder),
          builder: build,
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
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>(String id,
      Map<String, dynamic> data, {
        OnDataSourceBuilder<R>? builder,
      }) async {
    final response = DataResponse<T>();
    try {
      if (id.isValid) {
        final finder = await database.updateByData(
          id: id,
          data: data,
          path: _source(builder),
          builder: build,
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
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for delete single data
  @override
  Future<DataResponse<T>> delete<R>(String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    try {
      if (id.isValid) {
        var finder = await database.deleteById(
          id: id,
          path: _source(builder),
          builder: build,
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
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for delete all data
  @override
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    try {
      var finder = await database.clearBy(
        path: _source(builder),
        builder: build,
      );
      if (finder.$1) {
        return response.withBackups(finder.$2, status: finder.$4);
      } else {
        return response.withException(finder.$3, status: finder.$4);
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for fetch single data
  @override
  Future<DataResponse<T>> get<R>(String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    try {
      var finder = await database.findById(
        id: id,
        path: _source(builder),
        builder: build,
      );
      if (finder.$1) {
        return response.withData(finder.$2).withResult(finder.$3);
      } else {
        return response.withException(finder.$4, status: finder.$5);
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for fetch all data
  @override
  Future<DataResponse<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) async {
    final response = DataResponse<T>();
    try {
      var finder = await database.findBy(
        path: _source(builder),
        builder: build,
      );
      if (finder.$1) {
        return response.withResult(finder.$2);
      } else {
        return response.withException(finder.$3, status: finder.$4);
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  /// Use for fetch all recent updated data
  @override
  Future<DataResponse<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return gets(builder: builder, forUpdates: true);
  }

  /// Use for fetch single observable data when data update
  @override
  Stream<DataResponse<T>> live<R>(String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    try {
      if (id.isNotEmpty) {
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
          final I = await get(id, builder: builder);
          var result = I.data;
          if (result.isValid) {
            controller.add(response.withData(result));
          } else {
            controller.add(
              response.withData(null, status: Status.notFound),
            );
          }
        });
      } else {
        controller.add(response.withStatus(Status.invalidId));
      }
    } catch (_) {
      controller.add(response.withException(_, status: Status.failure));
    }
    return controller.stream;
  }

  /// Use for fetch all observable data when data update
  @override
  Stream<DataResponse<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    try {
      Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        final I = await gets(builder: builder);
        var result = I.result;
        if (result.isValid) {
          controller.add(response.withResult(result));
        } else {
          controller.add(
            response.withResult([], status: Status.notFound),
          );
        }
      });
    } catch (_) {
      controller.add(response.withException(_, status: Status.failure));
    }
    return controller.stream;
  }
}
