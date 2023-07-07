part of 'sources.dart';

abstract class ApiDataSourceImpl<T extends Data> extends RemoteDataSource<T> {
  final Api api;
  final String _path;

  ApiDataSourceImpl({
    required this.api,
    required String path,
    super.encryptor,
  }) : _path = path;

  dio.Dio? _db;

  dio.Dio get database => _db ??= dio.Dio();

  String path<R>(
    OnDataSourceBuilder<R>? source,
  ) {
    final root = _path;
    dynamic current = source?.call(root as R);
    if (current is String) {
      return current;
    } else {
      return root;
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await database.findById(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: path(builder),
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

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.id.isValid) {
        final finder = await database.setByOnce(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: path(builder),
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

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.isValid) {
        final finder = await database.setByMultiple(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: path(builder),
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

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        final finder = await database.updateById(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: path(builder),
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

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await database.deleteById(
          api: api,
          builder: build,
          encryptor: encryptor,
          path: path(builder),
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

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      var finder = await database.clearBy(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: path(builder),
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

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      var finder = await database.findById(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: path(builder),
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

  @override
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      var finder = await database.getBy(
        api: api,
        builder: build,
        encryptor: encryptor,
        path: path(builder),
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

  @override
  Future<Response<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return gets(
      isConnected: isConnected,
      forUpdates: true,
      builder: builder,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      database
          .liveById(
              api: api,
              builder: build,
              encryptor: encryptor,
              path: path(builder),
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

  @override
  Stream<Response<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      database
          .liveBy(
              api: api,
              builder: build,
              encryptor: encryptor,
              path: path(builder))
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

class Api {
  final bool autoGenerateId;
  final String api;
  final ApiStatus status;
  final ApiTimer timer;

  const Api({
    required this.api,
    this.autoGenerateId = true,
    this.status = const ApiStatus(),
    this.timer = const ApiTimer(),
  });

  String parent(String parent) => "$api/$parent";
}

class ApiTimer {
  final int reloadTime;
  final int streamReloadTime;

  const ApiTimer({
    this.reloadTime = 0,
    this.streamReloadTime = 300,
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

extension ApiDataFinder on dio.Dio {
  Future<FindByFinder<T>> findBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) async {
    try {
      return getAll<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        return (false, null, null, Status.notFound);
      } else {
        return (false, null, _.message, Status.failure);
      }
    }
  }

  Future<FindByIdFinder<T>> findById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return getAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).then((value) {
          if (value != null) {
            return (true, value, null, null, Status.alreadyFound);
          } else {
            return (false, null, null, null, Status.notFound);
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<FindByFinder<T>> getBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) {
    return findBy(
      api: api,
      builder: builder,
      encryptor: encryptor,
      path: path,
    );
  }

  Future<FindByIdFinder<T>> getById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) {
    return findById(api: api, builder: builder, path: path, id: id);
  }

  Future<FindByFinder<T>> getByIds<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<String> ids,
  }) async {
    try {
      return getAts<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
        ids: ids,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        return (false, null, null, Status.notFound);
      } else {
        return (false, null, _.message, Status.failure);
      }
    }
  }

  Stream<FindByIdFinder<T>> liveById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) {
    final controller = StreamController<FindByIdFinder<T>>();
    if (id.isNotEmpty) {
      try {
        liveAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).listen((value) {
          if (value != null) {
            controller.add((true, value, null, null, Status.alreadyFound));
          } else {
            controller.add((false, null, null, null, Status.notFound));
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          controller.add((false, null, null, null, Status.notFound));
        } else {
          controller.add((false, null, null, _.message, Status.failure));
        }
      }
    } else {
      controller.add((false, null, null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<FindByFinder<T>> liveBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) {
    final controller = StreamController<FindByFinder<T>>();
    try {
      livesAll<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
      ).listen((value) {
        if (value.isNotEmpty) {
          controller.add((true, value, null, Status.alreadyFound));
        } else {
          controller.add((false, null, null, Status.notFound));
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        controller.add((false, null, null, Status.notFound));
      } else {
        controller.add((false, null, _.message, Status.failure));
      }
    }
    return controller.stream;
  }

  Future<SetByDataFinder<T>> setByOnce<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required T data,
  }) async {
    if (data.id.isNotEmpty) {
      try {
        return setAt(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          data: data,
        ).then((feedback) {
          if (feedback != null) {
            if (feedback is T) {
              return (true, feedback, null, null, Status.ok);
            } else if (feedback is List<T>) {
              return (true, null, feedback, null, Status.ok);
            } else {
              return (true, null, null, null, Status.ok);
            }
          } else {
            return (false, null, null, "Database error!", Status.error);
          }
        }).onError((e, s) {
          return (false, null, null, "$e", Status.error);
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, null);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<SetByListFinder<T>> setByMultiple<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<T> data,
  }) async {
    if (data.isNotEmpty) {
      try {
        return setAll<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          data: data,
        ).then((value) {
          if (value.isNotEmpty) {
            var feedback = value.whereType<T>().toList();
            var feedback2 = value.whereType<List<T>>().toList();
            feedback2.forEach(feedback.addAll);
            return (true, null, null, feedback, null, Status.ok);
          } else {
            return (false, null, null, null, "Database error!", Status.error);
          }
        }).onError((e, s) {
          return (false, null, null, null, "$e", Status.failure);
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, null, null);
        } else {
          return (false, null, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, null, Status.invalidId);
    }
  }

  Future<UpdateByDataFinder<T>> updateById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    if (id.isNotEmpty) {
      try {
        return getAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).then((value) {
          if (value != null) {
            return updateAt(
              api: api,
              builder: builder,
              encryptor: encryptor,
              path: path,
              data: encryptor != null
                  ? value.source.attach(data)
                  : data.withId(id),
            ).then((feedback) {
              if (feedback != null) {
                if (feedback is T) {
                  return (true, value, [feedback], null, Status.ok);
                } else if (feedback is List<T>) {
                  return (true, value, feedback, null, Status.ok);
                } else {
                  return (true, value, null, null, Status.ok);
                }
              } else {
                return (false, null, null, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, null, null, "$e", Status.failure);
            });
          } else {
            return (false, null, null, null, Status.notFound);
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<DeleteByIdFinder<T>> deleteById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return getAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).then((value) {
          if (value != null) {
            return deleteAt(
              api: api,
              builder: builder,
              encryptor: encryptor,
              path: path,
              data: value,
            ).then((feedback) {
              if (feedback != null) {
                if (feedback is T) {
                  return (true, value, [feedback], null, Status.ok);
                } else if (feedback is List<T>) {
                  return (true, value, feedback, null, Status.ok);
                } else {
                  return (true, value, null, null, Status.ok);
                }
              } else {
                return (false, null, null, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, null, null, "$e", Status.failure);
            });
          } else {
            return (false, null, null, null, Status.notFound);
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<DeleteByIdFinder<T>> deleteByIds<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<String> ids,
  }) async {
    if (ids.isNotEmpty) {
      try {
        return getAts<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          ids: ids,
        ).then((value) {
          if (value.isNotEmpty) {
            return deleteAll(
              api: api,
              builder: builder,
              encryptor: encryptor,
              path: path,
              data: value,
            ).then((_) {
              if (_.isNotEmpty) {
                var feedback = _.whereType<T>().toList();
                var feedback2 = _.whereType<List<T>>().toList();
                feedback2.forEach(feedback.addAll);
                return (true, null, feedback, null, Status.ok);
              } else {
                return (false, null, null, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, null, null, "$e", Status.failure);
            });
          } else {
            return (false, null, null, null, Status.notFound);
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<ClearByFinder<T>> clearBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) async {
    try {
      return getAll<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
      ).then((value) {
        if (value.isNotEmpty) {
          return deleteAll(
            api: api,
            builder: builder,
            encryptor: encryptor,
            path: path,
            data: value,
          ).then((_) {
            if (_.isNotEmpty) {
              var feedback = _.whereType<T>().toList();
              var feedback2 = _.whereType<List<T>>().toList();
              feedback2.forEach(feedback.addAll);
              return (true, feedback, null, Status.ok);
            } else {
              return (false, null, "Database error!", Status.error);
            }
          }).onError((e, s) {
            return (false, null, "$e", Status.failure);
          });
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        return (false, null, null, Status.notFound);
      } else {
        return (false, null, _.message, Status.failure);
      }
    }
  }
}

extension _ApiExtension on dio.Dio {
  Future<T?> getAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) async {
    try {
      var isEncryptor = encryptor != null;
      final I = api.parent(path).child(id);
      final result = await get(I);
      final value = result.data;
      final code = result.statusCode;
      if (code == api.status.ok && value is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(value) : value;
        return builder(v);
      } else {
        return Future.error("Data not found!");
      }
    } catch (_) {
      return Future.error("Data not found!");
    }
  }

  Future<List<T>> getAts<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<String> ids,
  }) async {
    List<T> result = [];
    for (String id in ids) {
      var data = await getAt(
        builder: builder,
        encryptor: encryptor,
        api: api,
        path: path,
        id: id,
      );
      if (data != null) result.add(data);
    }
    return result;
  }

  Future<List<T>> getAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    final I = api.parent(path);
    return get(I).then((_) async {
      if (_.statusCode == api.status.ok) {
        if (_.data is List) {
          for (var i in _.data) {
            if (i != null && i is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(i) : i;
              result.add(builder(v));
            }
          }
        }
        return result;
      } else {
        return Future.error("Data not found!");
      }
    });
  }

  Stream<T?> liveAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) {
    final controller = StreamController<T?>();
    if (id.isNotEmpty) {
      Timer.periodic(
        Duration(milliseconds: api.timer.streamReloadTime),
        (timer) async {
          var I = await getAt(
            api: api,
            builder: builder,
            encryptor: encryptor,
            path: path,
            id: id,
          );
          controller.add(I);
        },
      );
    } else {
      controller.addError("Invalid id!");
    }
    return controller.stream;
  }

  Stream<List<T>> livesAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) {
    final controller = StreamController<List<T>>();
    Timer.periodic(
      Duration(milliseconds: api.timer.streamReloadTime),
      (timer) async {
        var I = await getAll(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
        );
        controller.add(I);
      },
    );
    return controller.stream;
  }

  Future<dynamic> setAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api.parent(path).child(data.id, api.autoGenerateId);
    final v = isEncryptor ? await encryptor.output(data.source) : data.source;
    if (v.isNotEmpty) {
      final result = await post(I, data: v);
      final code = result.statusCode;
      if (code == api.status.created || code == api.status.ok) {
        var feedback =
            isEncryptor ? await encryptor.output(result.data) : result.data;
        if (feedback is Map) {
          return builder(feedback);
        } else if (feedback is List) {
          return feedback.map((_) => builder(_)).toList();
        } else {
          return feedback;
        }
      } else {
        return Future.error("Data not inserted!");
      }
    } else {
      return Future.error("Encryption failed!");
    }
  }

  Future<List<dynamic>> setAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<T> data,
  }) async {
    List<dynamic> feedback = [];
    for (var i in data) {
      feedback.add(await setAt(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
        data: i,
      ));
    }
    return feedback;
  }

  Future<dynamic> updateAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      var I = api.parent(path).child(id);
      var v = isEncryptor ? await encryptor.input(data) : data;
      if (v.isNotEmpty) {
        final result = await put(I, data: v);
        var code = result.statusCode;
        if (code == api.status.ok || code == api.status.updated) {
          var feedback =
              isEncryptor ? await encryptor.output(result.data) : result.data;
          if (feedback is Map) {
            return builder(feedback);
          } else if (feedback is List) {
            return feedback.map((_) => builder(_)).toList();
          } else {
            return feedback;
          }
        } else {
          return Future.error("Data not updated!");
        }
      } else {
        return Future.error("Encryption failed!");
      }
    } else {
      return Future.error("Id isn't valid!");
    }
  }

  Future<dynamic> deleteAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api.parent(path).child(data.id);
    var result = await delete(I);
    var code = result.statusCode;
    if (code == api.status.ok || code == api.status.deleted) {
      var feedback =
          isEncryptor ? await encryptor.output(result.data) : result.data;
      if (feedback is Map) {
        return builder(feedback);
      } else if (feedback is List) {
        return feedback.map((_) => builder(_)).toList();
      } else {
        return feedback;
      }
    } else {
      return Future.error("Data not deleted!");
    }
  }

  Future<List<dynamic>> deleteAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<T> data,
  }) async {
    List<dynamic> feedback = [];
    for (var i in data) {
      var v = await deleteAt(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
        data: i,
      );
      if (v != null) feedback.add(v);
    }
    return feedback;
  }
}

extension _ApiPathExtension on String {
  String child(
    String path, [
    bool ignoreId = false,
  ]) {
    if (ignoreId) {
      return this;
    } else {
      return "$this/$path";
    }
  }
}

extension ApiRequestTypeExtension on ApiRequest? {
  ApiRequest get use => this ?? ApiRequest.post;

  bool get isGet => use == ApiRequest.get;

  bool get isPost => use == ApiRequest.post;
}
