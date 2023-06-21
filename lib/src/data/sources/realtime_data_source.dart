part of 'sources.dart';

abstract class RealtimeDataSourceImpl<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  RealtimeDataSourceImpl({
    required this.path,
    super.encryptor,
  });

  FirebaseDatabase? _db;

  FirebaseDatabase get database => _db ??= FirebaseDatabase.instance;

  DatabaseReference _source<R>(
    OnDataSourceBuilder<R>? source,
  ) {
    final parent = database.ref(path);
    dynamic current = source?.call(parent as R);
    if (current is DatabaseReference) {
      return current;
    } else {
      return parent;
    }
  }

  @override
  Future<(bool, T?, String?, Status)> isExisted<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (id.isValid) {
      try {
        return await _source(source).child(id).get().then((_) async {
          if (_.exists) {
            var v = _.value;
            if (isEncryptor && v is String) {
              return (true, build(await output(v)), null, Status.alreadyFound);
            } else {
              return (true, build(v), null, Status.alreadyFound);
            }
          } else {
            return (false, null, null, Status.notFound);
          }
        });
      } on FirebaseException catch (_) {
        return (false, null, _.message, Status.notFound);
      }
    } else {
      return (false, null, null, Status.invalidId);
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
        var finder = await isExisted(id, source: source);
        return response.withAvailable(
          !finder.$1,
          data: finder.$2,
          message: finder.$3,
          status: finder.$4,
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
      if (data.id.isValid) {
        final finder = await isExisted(data.id, source: source);
        if (!finder.$1) {
          final I = _source(source).child(data.id);
          await (isEncryptor
              ? I.setWithPriority(await input(data.source), data.timeMills)
              : I.setWithPriority(data.source, data.timeMills));
          return response.withData(data);
        } else {
          return response.withIgnore(
            finder.$2,
            message: finder.$3,
            status: finder.$4,
          );
        }
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
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        final I = _source(source).child(id);
        return await I.get().then((_) async {
          if (_.exists) {
            var v = _.value;
            if (isEncryptor) {
              var e = v is String ? await output(v) : <String, dynamic>{};
              await I.update(await input(e.attach(data)));
            } else {
              await I.update(data);
            }
            return response.withBackup(build(v));
          } else {
            return response.withStatus(Status.notFound);
          }
        });
      } catch (_) {
        return response.withException(_, status: Status.failure);
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
      try {
        final I = _source(source).child(id);
        return await I.get().then((value) async {
          if (value.exists) {
            await I.remove();
            return response.withBackup(build(value.value));
          } else {
            return response.withStatus(Status.notFound);
          }
        });
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
      try {
        var I = _source(source);
        return I.get().then((value) async {
          await I.remove();
          return response.withBackups(
            value.children.map((e) => build(e.value)).toList(),
          );
        });
      } catch (_) {
        return response.withException(_, status: Status.failure);
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
      try {
        final result = await _source(source).child(id).get();
        if (result.exists && result.value != null) {
          return response.withData(build(result.value));
        } else {
          return response.withStatus(Status.error);
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
        final result = await _source(source).get();
        if (result.exists) {
          return response.withResult(
            result.children.map((e) => build(e.value)).toList(),
          );
        } else {
          return response.withStatus(Status.error);
        }
      } catch (_) {
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
      isConnected: isConnected,
      forUpdates: true,
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
        _source(source).child(id).onValue.listen((event) {
          if (event.snapshot.exists || event.snapshot.value != null) {
            controller.add(response.withData(build(event.snapshot.value)));
          } else {
            controller.add(
              response.withException("Data not found!").withData(null),
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

  @override
  Stream<Response<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      try {
        _source(source).onValue.listen((event) {
          if (event.snapshot.exists) {
            controller.add(response.withResult(
              event.snapshot.children.map((e) => build(e.value)).toList(),
            ));
          } else {
            controller.add(
              response.withException("Data not found!").withResult([]),
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
}
