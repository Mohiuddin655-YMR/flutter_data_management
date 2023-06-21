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
  Future<(bool, List<T>, String?, Status)> findBy<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    List<T> result = [];
    try {
      return await _source(source).get().then((_) async {
        if (_.exists) {
          for (var i in _.children) {
            if (i.value != null && i.value is Map<String, dynamic>) {
              var v = isEncryptor ? await output(i.value) : i.value;
              result.add(build(v));
            }
          }
          return (true, result, null, Status.alreadyFound);
        } else {
          return (false, result, null, Status.notFound);
        }
      });
    } on FirebaseException catch (_) {
      return (false, result, _.message, Status.notFound);
    }
  }

  @override
  Future<(bool, T?, String?, Status)> findById<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (id.isValid) {
      try {
        return await _source(source).child(id).get().then((_) async {
          if (_.exists && _.value is Map<String, dynamic>) {
            var v = isEncryptor ? await output(_.value) : _.value;
            return (true, build(v), null, Status.alreadyFound);
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
        var finder = await findById(id, source: source);
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
        final finder = await findById(data.id, source: source);
        if (!finder.$1) {
          final I = _source(source).child(data.id);
          if (isEncryptor) {
            var raw = await input(data.source);
            if (raw.isValid) {
              await I.setWithPriority(raw, data.timeMills);
              return response.withData(data);
            } else {
              return response.withStatus(Status.invalid);
            }
          } else {
            await I.setWithPriority(data.source, data.timeMills);
            return response.withData(data);
          }
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
      if (id.isValid && data.isValid) {
        final finder = await findById(id, source: source);
        final I = _source(source).child(id);
        if (finder.$1) {
          try {
            var v = isEncryptor
                ? await input(finder.$2?.source.attach(data))
                : data;
            await I.update(v);
            return response.withBackup(finder.$2, status: Status.ok);
          } on FirebaseException catch (_) {
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
        final finder = await findById(id, source: source);
        final I = _source(source).child(id);
        if (finder.$1) {
          try {
            await I.remove();
            return response.withBackup(finder.$2, status: Status.ok);
          } on FirebaseException catch (_) {
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
        await _source(source).remove();
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
      final finder = await findById(id, source: source);
      if (finder.$1) {
        return response.withData(finder.$2);
      } else {
        return response.withException(finder.$3, status: finder.$4);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      final finder = await findBy(source: source);
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
    OnDataSourceBuilder<R>? source,
  }) {
    return gets(
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
        _source(source).child(id).onValue.listen((event) async {
          var value = event.snapshot.value;
          if (event.snapshot.exists || value != null) {
            var v = isEncryptor ? await output(value) : value;
            controller.add(response.withData(build(v)));
          } else {
            controller.add(
              response.withData(null, status: Status.notFound),
            );
          }
        });
      } on FirebaseException catch (_) {
        controller.add(response.withException(
          _.message,
          status: Status.failure,
        ));
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
        _source(source).onValue.listen((event) async {
          if (event.snapshot.exists) {
            List<T> result = [];
            for (var i in event.snapshot.children) {
              var v = isEncryptor ? await output(i.value) : i.value;
              result.add(build(v));
            }
            controller.add(response.withResult(result));
          } else {
            controller.add(
              response.withResult([], status: Status.notFound),
            );
          }
        });
      } on FirebaseException catch (_) {
        controller.add(response.withException(
          _.message,
          status: Status.failure,
        ));
      }
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }
}
