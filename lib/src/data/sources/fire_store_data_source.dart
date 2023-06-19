part of 'sources.dart';

abstract class FireStoreDataSourceImpl<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  FireStoreDataSourceImpl({
    required this.path,
  });

  FirebaseFirestore? _db;

  FirebaseFirestore get database => _db ??= FirebaseFirestore.instance;

  CollectionReference _source<R>(
    OnDataSourceBuilder<R>? source,
  ) {
    final parent = database.collection(path);
    dynamic current = source?.call(parent as R);
    if (current is CollectionReference) {
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
          return _source(source).doc(id).get().then((value) {
            var available = !value.exists;
            return response.withAvailable(
              available,
              data: available ? null : build(value.data()),
              message: available ? "Currently available" : "Already inserted!",
            );
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
        try {
          final I = _source(source).doc(data.id);
          return await I.get().then((value) async {
            if (!value.exists) {
              await I.set(data.source, SetOptions(merge: true));
              return response.withData(data);
            } else {
              return response.withIgnore(data, message: 'Already inserted!');
            }
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
            await I.doc(i.id).get().then((value) async {
              if (!value.exists) {
                await I.doc(i.id).set(i.source, SetOptions(merge: true));
              } else {
                response.withIgnore(i, message: 'Already inserted!');
              }
            });
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
        final I = _source(source).doc(id);
        return await I.get().then((value) async {
          if (value.exists) {
            await I.update(data);
            return response.withBackup(build(value.data()));
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
        final I = _source(source).doc(id);
        return await I.get().then((value) async {
          if (value.exists) {
            await I.delete();
            return response.withBackup(build(value.data()));
          } else {
            return response.withException(
              'Data not inserted!',
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
        List<T> old = [];
        return I.get().then((value) async {
          for (var i in value.docs) {
            var single = build(i.data());
            old.add(single);
            await I.doc(single.id).delete();
          }
          return response.withBackups(old);
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
        final result = await _source(source).doc(id).get();
        if (result.exists && result.data() != null) {
          return response.withData(build(result.data()));
        } else {
          return response.withException("Data not found!");
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
        if (result.docs.isNotEmpty || result.docChanges.isNotEmpty) {
          if (forUpdates) {
            return response.withResult(
              result.docChanges.map((e) => build(e.doc.data())).toList(),
            );
          } else {
            return response.withResult(
              result.docs.map((e) => build(e.data())).toList(),
            );
          }
        } else {
          return response.withException("Data not found!");
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
        _source(source).doc(id).snapshots().listen((event) {
          if (event.exists || event.data() != null) {
            controller.add(response.withData(build(event.data())));
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
    bool forUpdates = false,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      try {
        _source(source).snapshots().listen((event) {
          if (event.docs.isNotEmpty) {
            controller.add(response.withResult(
              event.docs.map((e) => build(e.data())).toList(),
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
