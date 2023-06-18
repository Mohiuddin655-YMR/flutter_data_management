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
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        var reference = _source(source);
        return reference.get().then((value) async {
          for (var i in value.docs) {
            await reference.doc(build(i.data()).id).delete();
          }
          return response.withResult([]);
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
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        await _source(source).doc(id).delete();
        return response.withData(null);
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
            var v = result.docChanges.map((e) => build(e.doc.data())).toList();
            return response.withResult(v);
          } else {
            var v = result.docs.map((e) => build(e.data())).toList();
            return response.withResult(v);
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
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.id.isNotEmpty) {
        try {
          final reference = _source(source).doc(data.id);
          return await reference.get().then((value) async {
            if (!value.exists) {
              await reference.set(data.source, SetOptions(merge: true));
              return response.withData(data);
            } else {
              return response.modify(
                snapshot: value,
                message: 'Already inserted!',
              );
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
          final reference = _source(source);
          for (var i in data) {
            await reference.doc(i.id).get().then((value) async {
              if (!value.exists) {
                await reference
                    .doc(i.id)
                    .set(i.source, SetOptions(merge: true));
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
            var v = event.docs.map((e) => build(e.data())).toList();
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

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        await _source(source).doc(data.id).update(data.source);
        return response.withData(data);
      } catch (_) {
        return response.withException(_, status: Status.failure);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }
}
