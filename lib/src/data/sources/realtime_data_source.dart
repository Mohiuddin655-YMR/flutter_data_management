part of 'sources.dart';

abstract class RealtimeDataSourceImpl<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  RealtimeDataSourceImpl({required this.path});

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
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isNotEmpty) {
        try {
          return _source(source).child(id).get().then((value) {
            return response.withAvailable(!value.exists);
          });
        } catch (_) {
          return response.withException(_, status: Status.failure);
        }
      } else {
        return response.withException(
          "Id isn't valid!",
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
      if (data.id.isNotEmpty) {
        final ref = _source(source).child(data.id);
        return await ref.get().then((value) async {
          if (!value.exists) {
            await ref.setWithPriority(data.source, data.timeMills);
            return response.withData(data, message: "Inserted successful!");
          } else {
            return response.withException(
              'Already inserted!',
              status: Status.invalid,
            );
          }
        });
      } else {
        return response.withException(
          "ID isn't valid!",
          status: Status.invalid,
        );
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
      if (data.isNotEmpty) {
        try {
          final I = _source(source);
          for (var i in data) {
            await I.child(i.id).get().then(
              (value) async {
                if (!value.exists) {
                  await I
                      .child(i.id)
                      .setWithPriority(i.source, i.timeMills);
                } else {
                  var ignores = response.ignores;
                  ignores.insert(0, i);
                  response.withIgnores(
                    ignores,
                    message: "Already data added!",
                  );
                }
              },
            );
          }
          return response.withResult(data);
        } catch (_) {
          return response.withException(_, status: Status.failure);
        }
      } else {
        return response.withException(
          "Id isn't valid!",
          status: Status.invalid,
        );
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
        return await I.get().then((value) async {
          if (value.exists) {
            await I.update(data);
            return response.withBackup(build(value.value));
          } else {
            return response.withException(
              'Data not found!',
              status: Status.notFound,
            );
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
            return response.withException(
              'Data not found!',
              status: Status.notFound,
            );
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
          var old = value.children.map((e) => build(e.value)).toList();
          await I.remove();
          return response.withBackups(old);
        }).onError((e, s) {
          return response.withException(
            e,
            status: Status.failure,
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
          return response.withException(
            "Data not found!",
            status: Status.error,
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
        final result = await _source(source).get();
        if (result.exists) {
          var list = result.children.map((e) => build(e.value)).toList();
          return response.withResult(list);
        } else {
          return response.withException(
            "Data not found!",
            status: Status.error,
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
            var v = event.snapshot.children.map((e) => build(e.value)).toList();
            controller.add(response.withResult(v));
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
