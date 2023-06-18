part of 'sources.dart';

abstract class LocalDataSourceImpl<T extends Entity>
    extends LocalDataSource<T> {
  LocalDataSourceImpl({
    required super.path,
    super.preferences,
  });

  String _source<R>(
    OnDataSourceBuilder<R>? source,
  ) {
    final parent = path;
    dynamic current = source?.call(parent as R);
    if (current is String) {
      return current;
    } else {
      return parent;
    }
  }

  bool isExisted(String id, List<T>? data) {
    if (data != null && data.isNotEmpty) {
      return data.where((E) => E.id.equals(id)).isNotEmpty;
    } else {
      return false;
    }
  }

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      return database.input(_source(source), null).then((value) {
        if (value) {
          return response.withResult([]);
        } else {
          return response.withException(
            "Something went wrong!",
            status: Status.error,
          );
        }
      }).onError((e, s) {
        return response.withException(e, status: Status.failure);
      });
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      var I = await gets(source: source);
      var request = I.result.where((E) => !id.equals(E.id)).toList();
      return database.input(_source(source), request._).then((value) {
        if (value) {
          return response.withResult(request);
        } else {
          return response.withException(
            "Insertion error!",
            status: Status.error,
          );
        }
      }).onError((e, s) {
        return response.withException(e, status: Status.failure);
      });
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      var I = await gets(source: source);
      final result = I.result.where((E) => E.id.equals(id));
      if (result.isNotEmpty) {
        return response.withData(result.first);
      } else {
        return response.withException("Data not found!");
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return gets(source: source);
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      return database.output<T>(_source(source), build).then((value) {
        return response.withResult(value);
      }).onError((e, s) {
        return response.withException(e, status: Status.failure);
      });
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      var I = await gets(source: source);
      final request = I.result;
      final isInsertable = !isExisted(data.id, request);
      if (isInsertable) {
        request.add(data);
        return database.input(_source(source), request._).then((value) {
          if (value) {
            return response.withResult(request);
          } else {
            return response.withException(
              "Insertion error!",
              status: Status.error,
            );
          }
        }).onError((e, s) {
          return response.withException(e, status: Status.failure);
        });
      } else {
        return response.withIgnore(data, message: "Already data added!");
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      var I = await gets(source: source);
      final request = I.result;
      for (var item in data) {
        final isInsertable = !isExisted(item.id, request);
        if (isInsertable) {
          request.add(item);
          await database.input(_source(source), request._).then((value) {
            if (value) {
              response.withResult(request);
            } else {
              response.withException(
                "Insertion error!",
                status: Status.error,
              );
            }
          }).onError((e, s) {
            response.withException(e, status: Status.failure);
          });
        } else {
          var ignores = response.ignores;
          ignores.insert(0, item);
          response.withIgnores(
            ignores,
            message: "Already data added!",
          );
        }
      }
      return response;
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      var I = await gets(source: source);
      var result = I.result.where((_) => _.id == id).isEmpty;
      return response.withAvailable(result);
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty) {
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
          final I = await get(id, source: source);
          var result = I.data;
          if (result.isValid) {
            controller.add(response.withData(result));
          } else {
            controller.add(
              response.withException("Data not found!").withData(null),
            );
          }
        });
      } else {
        controller.add(response.modify(
          exception: "Undefined ID [$id]",
          status: Status.undefined,
        ));
      }
    } catch (_) {
      controller.add(response.withException(_, status: Status.failure));
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      Timer.periodic(const Duration(milliseconds: 500), (timer) async {
        final I = await gets(source: source);
        var result = I.result;
        if (result.isValid) {
          controller.add(response.withResult(result));
        } else {
          controller.add(
            response.withException("Data not found!").withResult([]),
          );
        }
      });
    } catch (_) {
      controller.add(response.withException(_, status: Status.failure));
    }
    return controller.stream;
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      final I = await gets(source: source);
      var request = I.result;
      var i = request.indexWhere((_) => _.id == data.id);
      if (i > -1) {
        request.removeAt(i);
        request.insert(i, data);
        return inserts(request, source: source);
      } else {
        return response.withException(
          "Data not inserted!",
          status: Status.notFound,
        );
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }
}

extension LocalExtension on Future<SharedPreferences> {
  Future<bool> input(
    String key,
    String? value,
  ) async {
    try {
      final db = await this;
      if (value.isValid) {
        return db.setString(key, value.use);
      } else {
        return db.remove(key);
      }
    } catch (_) {
      return Future.error(_);
    }
  }

  Future<List<T>> output<T extends Entity>(
    String key,
    OnDataBuilder<T> builder,
  ) async {
    try {
      final db = await this;
      return db.getString(key)._.map((E) => builder(E)).toList();
    } catch (_) {
      return Future.error(_);
    }
  }
}

extension LocalListExtension<T extends Entity> on List<T> {
  String get _ => jsonEncode(map((_) => _.source).toList());
}

extension LocalStringExtension on String? {
  List get _ => isValid ? jsonDecode(this ?? "[]") : [];
}
