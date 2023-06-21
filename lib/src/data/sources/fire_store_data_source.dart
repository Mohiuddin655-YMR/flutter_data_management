part of 'sources.dart';

abstract class FireStoreDataSourceImpl<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  FireStoreDataSourceImpl({
    required this.path,
    super.encryptor,
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
  Future<(bool, T?, String?, Status)> isExisted<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (id.isValid) {
      try {
        return await _source(source).doc(id).get().then((_) async {
          if (_.exists) {
            var v = _.data();
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
          final I = _source(source).doc(data.id);
          await (isEncryptor
              ? I.set(await input(data.source))
              : I.set(data.source));
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
        return response.withStatus(Status.invalid);
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
