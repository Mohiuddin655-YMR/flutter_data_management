part of 'sources.dart';

abstract class ApiDataSourceImpl<T extends Entity> extends RemoteDataSource<T> {
  final Api api;
  final String path;

  ApiDataSourceImpl({
    required this.api,
    required this.path,
    super.encryptor,
  });

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  String currentSource<R>(
    OnDataSourceBuilder<R>? source,
  ) {
    final reference = "${api.api}/$path";
    dynamic current = source?.call(reference as R);
    if (current is String) {
      return current;
    } else {
      return reference;
    }
  }

  String _source<R>(
    String id,
    OnDataSourceBuilder<R>? source, [
    bool ignoreId = false,
  ]) {
    if (ignoreId) {
      return currentSource(source);
    } else {
      return "${currentSource(source)}/$id";
    }
  }

  @override
  Future<(bool, T?, String? message, Status status)> isExisted<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (id.isValid) {
      try {
        final I = _source(id, source);
        final result = await database.get(I);
        final value = result.data;
        final code = result.statusCode;
        if ((code == 200 || code == api.status.ok) && value is Map) {
          return (true, build(value), "Currently existed", Status.ok);
        } else {
          return (false, null, "Data not existed!", Status.notFound);
        }
      } on dio.DioException catch (_) {
        var code = _.response?.statusCode.use;
        if (code == 404 || code == api.status.notFound) {
          return (false, null, "Data not existed!", Status.notFound);
        }
        return (false, null, _.message, Status.notFound);
      }
    } else {
      return (false, null, "Id isn't valid!", Status.invalidId);
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await isExisted(id);
        return response.withAvailable(
          !finder.$1,
          data: finder.$2,
          message: finder.$3,
        );
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.id.isValid && data.source.isValid) {
        final finder = await isExisted(data.id, source: source);
        final I = _source(data.id, source, api.autoGenerateId);
        if (!finder.$1) {
          try {
            final result = await database.post(I, data: data.source);
            final feedback = result.data;
            final code = result.statusCode;
            if (code == 200 || code == 201 || code == api.status.created) {
              if (feedback is Map) {
                return response.withData(build(feedback));
              } else if (feedback is List) {
                return response.withResult(
                  feedback.map((e) => build(e)).toList(),
                );
              } else {
                return response.withFeedback(feedback, status: Status.ok);
              }
            } else {
              return response.withStatus(Status.error);
            }
          } on dio.DioException catch (_) {
            return response.withException(_.message, status: Status.failure);
          }
        } else {
          return response.withIgnore(finder.$2, status: Status.alreadyFound);
        }
      } else {
        return response.withStatus(Status.invalid);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.isValid) {
        for (var i in data) {
          var result = await insert(i, isConnected: true, source: source);
          if (result.ignores.isValid) response.withIgnore(result.ignores[0]);
        }
        return response.withResult(data);
      } else {
        return response.withException(Status.invalid);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid && data.isValid) {
        final finder = await isExisted(id, source: source);
        final I = _source(id, source);
        if (finder.$1) {
          try {
            final result = await database.put(I, data: data);
            final feedback = result.data;
            final code = result.statusCode;
            if (code == 200 || code == 201 || code == api.status.updated) {
              return response.withBackup(
                finder.$2,
                feedback: feedback,
                status: Status.ok,
              );
            } else {
              return response.withStatus(Status.error);
            }
          } on dio.DioException catch (_) {
            return response.withException(_.message, status: Status.failure);
          }
        } else {
          return response.withIgnore(finder.$2, status: Status.notFound);
        }
      } else {
        return response.withStatus(Status.invalid);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        final finder = await isExisted(id, source: source);
        final I = _source(id, source);
        if (finder.$1) {
          try {
            final result = await database.delete(I);
            final feedback = result.data;
            final code = result.statusCode;
            if (code == 200 || code == 201 || code == api.status.deleted) {
              return response.withBackup(
                finder.$2,
                feedback: feedback,
                status: Status.ok,
              );
            } else {
              return response.withStatus(Status.error);
            }
          } on dio.DioException catch (_) {
            return response.withException(_.message, status: Status.failure);
          }
        } else {
          return response.withIgnore(finder.$2, status: Status.notFound);
        }
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      var I = await gets(isConnected: true, source: source);
      if (I.isSuccessful && I.result.isValid) {
        for (var i in I.result) {
          await delete(i.id, source: source, isConnected: true);
        }
        return response.withBackups(I.result, status: Status.ok);
      } else {
        return response.withStatus(Status.notFound);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        try {
          final I = _source(id, source);
          final result = await database.get(I);
          final value = result.data;
          final code = result.statusCode;
          if (code == 200 || code == api.status.ok) {
            if (value is Map<String, dynamic>) {
              return response.withData(build(value));
            } else {
              return response.withSnapshot(value, status: Status.unmodified);
            }
          } else {
            return response.withStatus(Status.notFound);
          }
        } on dio.DioException catch (_) {
          var code = _.response?.statusCode.use;
          if (code == 404 || code == api.status.notFound) {
            return response.withStatus(Status.notFound);
          }
          return response.withException(_, status: Status.failure);
        }
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    bool forUpdates = false,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        final I = currentSource(source);
        final result = await database.get(I);
        final value = result.data;
        final code = result.statusCode;
        if (code == 200 || code == api.status.ok) {
          if (value is List<dynamic>) {
            return response.withResult(
              value.map((_) => build(_)).toList(),
            );
          } else {
            return response.withSnapshot(value, status: Status.unmodified);
          }
        } else {
          return response.withStatus(Status.notFound);
        }
      } on dio.DioException catch (_) {
        var code = _.response?.statusCode.use;
        if (code == 404 || code == api.status.notFound) {
          return response.withStatus(Status.notFound);
        }
        return response.withException(_, status: Status.failure);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return gets(
      forUpdates: true,
      isConnected: isConnected,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        Timer.periodic(const Duration(milliseconds: 300), (timer) async {
          controller.add(response.from(await get(
            id,
            source: source,
            isConnected: true,
          )));
        });
      } else {
        controller.add(response.withStatus(Status.invalidId));
      }
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();

    if (isConnected) {
      Timer.periodic(const Duration(milliseconds: 300), (timer) async {
        controller.add(response.from(await gets(
          source: source,
          isConnected: true,
        )));
      });
    } else {
      controller.add(response.withStatus(Status.networkError));
    }

    return controller.stream;
  }
}

class Api {
  final bool autoGenerateId;
  final String api;
  final ApiStatus status;

  const Api({
    required this.api,
    this.autoGenerateId = true,
    this.status = const ApiStatus(),
  });
}

class ApiStatus {
  final int ok;
  final int canceled;
  final int created;
  final int updated;
  final int deleted;
  final int notFound;

  const ApiStatus({
    this.ok = 200,
    this.created = 201,
    this.updated = 202,
    this.deleted = 203,
    this.canceled = 204,
    this.notFound = 404,
  });
}

enum ApiRequest { get, post }

extension ApiRequestTypeExtension on ApiRequest? {
  ApiRequest get use => this ?? ApiRequest.post;

  bool get isGet => use == ApiRequest.get;

  bool get isPost => use == ApiRequest.post;
}
