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

  String _source<R>(String id, OnDataSourceBuilder<R>? source) {
    if (api.autoGenerateId) {
      return currentSource(source);
    } else {
      return "${currentSource(source)}/$id";
    }
  }

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
      return (false, null, "Id isn't valid!", Status.invalid);
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
      if (id.isNotEmpty) {
        var finder = await isExisted(id);
        return response.withAvailable(
          !finder.$1,
          data: finder.$2,
          message: finder.$3,
        );
      } else {
        return response.withException(
          "Undefined ID [$id]",
          status: Status.invalid,
        );
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
      var id = "${data.id}";
      if (id.isValid && data.source.isValid) {
        final finder = await isExisted(id, source: source);
        final I = _source(id, source);
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
                return response.withFeedback(
                  feedback,
                  status: Status.unmodified,
                );
              }
            } else {
              return response.withException('Data not inserted!');
            }
          } on dio.DioException catch (_) {
            return response.withException(_.message, status: Status.failure);
          }
        } else {
          return response.withIgnore(finder.$2, message: 'Already inserted!');
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
      for (var i in data) {
        var result = await insert(i, isConnected: true, source: source);
        if (result.ignores.isValid) response.withIgnore(result.ignores[0]);
      }
      return response.withResult(data);
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
      if (id.isValid && data.isValid) {
        final finder = await isExisted(id, source: source);
        final I = _source(id, source);
        if (finder.$1) {
          try {
            final result = await database.put(I, data: data);
            final feedback = result.data;
            final code = result.statusCode;
            if (code == 200 || code == 201 || code == api.status.updated) {
              if (feedback is Map) {
                return response.withData(build(feedback));
              } else if (feedback is List) {
                return response.withResult(
                  feedback.map((e) => build(e)).toList(),
                );
              } else {
                return response.withFeedback(
                  feedback,
                  status: Status.unmodified,
                );
              }
            } else {
              return response.withException('Data not updated!');
            }
          } on dio.DioException catch (_) {
            return response.withException(_.message, status: Status.failure);
          }
        } else {
          return response.withIgnore(finder.$2, message: 'Data not found!');
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
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        if (id.isNotEmpty) {
          final url = _source(id, source);
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
          final url = _source(id, source);
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
          final url = _source(id, source);
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
