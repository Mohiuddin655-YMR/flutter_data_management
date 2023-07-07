part of 'sources.dart';

abstract class FireStoreDataSourceImpl<T extends Data>
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
  Future<(bool, List<T>, String?, Status)> findBy<R>({
    OnDataSourceBuilder<R>? builder,
    bool onlyUpdates = false,
  }) async {
    List<T> result = [];
    try {
      return await _source(builder).get().then((_) async {
        if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
          if (onlyUpdates) {
            for (var i in _.docChanges) {
              if (i.doc.exists && i.doc.data() is Map<String, dynamic>) {
                var v = isEncryptor ? await output(i.doc.data()) : i.doc.data();
                result.add(build(v));
              }
            }
          } else {
            for (var i in _.docs) {
              if (i.exists && i.data() is Map<String, dynamic>) {
                var v = isEncryptor ? await output(i.data()) : i.data();
                result.add(build(v));
              }
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (id.isValid) {
      try {
        return await _source(builder).doc(id).get().then((_) async {
          if (_.exists && _.data() is Map<String, dynamic>) {
            var v = isEncryptor ? await output(_.data()) : _.data();
            return (true, build(v), null, Status.alreadyFound);
          } else {
            return (false, null, null, Status.notFound);
          }
        });
      } on FirebaseException catch (_) {
        return (false, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, Status.invalidId);
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
        var finder = await findById(id, builder: builder);
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.id.isValid) {
        final finder = await findById(data.id, builder: builder);
        if (!finder.$1) {
          final I = _source(builder).doc(data.id);
          if (isEncryptor) {
            var raw = await input(data.source);
            if (raw.isValid) {
              await I.set(raw, SetOptions(merge: true));
              return response.withData(data);
            } else {
              return response.withStatus(Status.invalid);
            }
          } else {
            await I.set(data.source, SetOptions(merge: true));
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.isValid) {
        for (var i in data) {
          var result = await insert(i, isConnected: true, builder: builder);
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid && data.isValid) {
        final finder = await findById(id, builder: builder);
        final I = _source(builder).doc(id);
        if (finder.$1) {
          try {
            var v = isEncryptor
                ? await input(finder.$2?.source.attach(data))
                : data;
            await I.update(v);
            return response.withBackup(finder.$2);
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        final finder = await findById(id, builder: builder);
        final I = _source(builder).doc(id);
        if (finder.$1) {
          try {
            await I.delete();
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      var I = await gets(isConnected: true, builder: builder);
      if (I.isSuccessful && I.result.isValid) {
        await _source(builder).get().then((value) async {
          for (var i in value.docs) {
            await delete(i.id, builder: builder, isConnected: true);
          }
        });
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
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      final finder = await findById(id, builder: builder);
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
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      final finder = await findBy(builder: builder, onlyUpdates: forUpdates);
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
      try {
        _source(builder).doc(id).snapshots().listen((event) async {
          var value = event.data();
          if (event.exists || value != null) {
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
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      try {
        _source(builder).snapshots().listen((event) async {
          if (event.docs.isNotEmpty) {
            List<T> result = [];
            for (var i in event.docs) {
              var v = isEncryptor ? await output(i.data()) : i.data();
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
