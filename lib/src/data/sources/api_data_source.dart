part of 'sources.dart';

abstract class ApiDataSourceImpl<T extends Entity> extends RemoteDataSource<T> {
  final Api api;
  final String path;

  ApiDataSourceImpl({
    required this.api,
    required this.path,
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

  String currentUrl<R>(String id, OnDataSourceBuilder<R>? source) {
    return "${currentSource(source)}/$id";
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      return response.withException(
        "Currently not initialized!",
        status: Status.undefined,
      );
    } else {
      return response.withStatus(
        Status.networkError,
      );
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
      if (data.source.isNotEmpty) {
        final url = data.id.isNotEmpty
            ? currentUrl(data.id, source)
            : currentSource(source);
        final reference = await database.post(url, data: data.source);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == api.status.created) {
          final result = reference.data;
          return response.modify(result: result);
        } else {
          return response.modify(
            snapshot: reference,
            exception: "Data unmodified [${reference.statusCode}]",
            status: Status.unmodified,
          );
        }
      } else {
        return response.withException(
          "Undefined data $data",
          status: Status.invalid,
        );
      }
    } else {
      return response.withStatus(
        Status.networkError,
      );
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
      return response.withException(
        "Currently not initialized!",
        status: Status.undefined,
      );
    } else {
      return response.withStatus(
        Status.networkError,
      );
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
      try {
        if (id.isValid && data.isValid) {
          final url = currentUrl(id, source);
          final reference = await database.put(url, data: data);
          final code = reference.statusCode;
          if (code == 200 || code == 201 || code == api.status.updated) {
            return response.withStatus(Status.ok);
          } else {
            return response.modify(
              status: Status.unmodified,
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
            );
          }
        } else {
          return response.withException(
            "Undefined data $data",
            status: Status.undefined,
          );
        }
      } catch (_) {
        return response.withException(_, status: Status.failure);
      }
    } else {
      return response.withStatus(
        Status.networkError,
      );
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
      try {
        if (id.isNotEmpty) {
          final url = currentUrl(id, source);
          final result = await database.delete(url);
          final code = result.statusCode;
          if (code == 200 || code == 201 || code == api.status.deleted) {
            return response.withFeedback(result.data);
          } else {
            return response.withFeedback(
              result,
              exception: "Data unmodified [${result.statusCode}]",
              status: Status.unmodified,
            );
          }
        } else {
          return response.withException(
            "Undefined ID [$id]",
            status: Status.invalid,
          );
        }
      } catch (_) {
        return response.withException(_, status: Status.failure);
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
      return response.withStatus(Status.undefined);
    } else {
      return response.withStatus(
        Status.networkError,
      );
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
      try {
        if (id.isNotEmpty) {
          final url = currentUrl(id, source);
          final result = await database.get(url);
          final data = result.data;
          final code = result.statusCode;
          if ((code == 200 || code == api.status.ok) && data is Map) {
            return response.withData(build(data));
          } else {
            return response.modify(
              snapshot: result,
              exception: "Data unmodified [${result.statusCode}]",
              status: Status.unmodified,
            );
          }
        } else {
          return response.withException(
            "Undefined ID [$id]",
            status: Status.invalid,
          );
        }
      } catch (_) {
        return response.withException(_, status: Status.failure);
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
        final url = currentSource(source);
        final reference = await database.get(url);
        final data = reference.data;
        final code = reference.statusCode;
        if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
          List<T> result = data.map((item) {
            return build(item);
          }).toList();
          return response.withResult(result);
        } else {
          return response.modify(
            snapshot: reference,
            exception: "Data unmodified [${reference.statusCode}]",
            status: Status.unmodified,
          );
        }
      } catch (_) {
        return response.withException(_, status: Status.failure);
      }
    } else {
      return response.withStatus(
        Status.networkError,
      );
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
      try {
        if (id.isNotEmpty) {
          final url = currentUrl(id, source);
          Timer.periodic(const Duration(milliseconds: 300), (timer) async {
            final reference = await database.get(url);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == api.status.ok) && data is Map) {
              controller.add(response.withData(build(data)));
            } else {
              controller.add(response.modify(
                snapshot: reference,
                exception: "Data unmodified [${reference.statusCode}]",
                status: Status.unmodified,
                data: null,
              ));
            }
          });
        } else {
          controller.add(response.withException(
            "Undefined ID [$id]",
            status: Status.undefined,
          ));
        }
      } catch (_) {
        controller.add(response.withException(_, status: Status.failure));
      }
    } else {
      controller.add(response.withStatus(
        Status.networkError,
      ));
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
      try {
        final url = currentSource(source);
        Timer.periodic(const Duration(milliseconds: 300), (timer) async {
          final reference = await database.get(url);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == api.status.ok) && data is List<dynamic>) {
            List<T> result = data.map((item) {
              return build(item);
            }).toList();
            controller.add(response.withResult(result));
          } else {
            controller.add(response.modify(
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: Status.unmodified,
              result: [],
            ));
          }
        });
      } catch (_) {
        controller.add(response.withException(_, status: Status.failure));
      }
    } else {
      controller.add(response.withStatus(
        Status.networkError,
      ));
    }

    return controller.stream;
  }
}

class Api {
  final String api;
  final ApiStatus status;

  const Api({
    required this.api,
    this.status = const ApiStatus(),
  });
}

class ApiStatus {
  final int ok;
  final int canceled;
  final int created;
  final int updated;
  final int deleted;

  const ApiStatus({
    this.ok = 200,
    this.created = 201,
    this.updated = 202,
    this.deleted = 203,
    this.canceled = 204,
  });
}

enum ApiRequest { get, post }
