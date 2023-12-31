part of 'sources.dart';

extension RealtimeDataFinder on DatabaseReference {
  Future<FindByFinder<T>> findBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    try {
      return getAll<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on FirebaseException catch (_) {
      return (false, null, _.message, Status.failure);
    }
  }

  Future<FindByIdFinder<T>> findById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return getAt<T>(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).then((value) {
          if (value != null) {
            return (true, value, null, null, Status.alreadyFound);
          } else {
            return (false, null, null, null, Status.notFound);
          }
        });
      } on FirebaseException catch (_) {
        return (false, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<FindByFinder<T>> getBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    return findBy(
      builder: builder,
      encryptor: encryptor,
      onlyUpdates: onlyUpdates,
    );
  }

  Future<FindByIdFinder<T>> getById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    return findById(builder: builder, encryptor: encryptor, id: id);
  }

  Future<FindByFinder<T>> getByIds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    try {
      return getAts<T>(
        builder: builder,
        encryptor: encryptor,
        ids: ids,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on FirebaseException catch (_) {
      return (false, null, _.message, Status.failure);
    }
  }

  Stream<FindByIdFinder<T>> liveById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<FindByIdFinder<T>>();
    if (id.isNotEmpty) {
      try {
        liveAt<T>(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).listen((value) {
          if (value != null) {
            controller.add((true, value, null, null, Status.alreadyFound));
          } else {
            controller.add((false, null, null, null, Status.notFound));
          }
        });
      } on FirebaseException catch (_) {
        controller.add((false, null, null, _.message, Status.failure));
      }
    } else {
      controller.add((false, null, null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<FindByFinder<T>> liveBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<FindByFinder<T>>();
    try {
      livesAll<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
      ).listen((value) {
        if (value.isNotEmpty) {
          controller.add((true, value, null, Status.alreadyFound));
        } else {
          controller.add((false, null, null, Status.notFound));
        }
      });
    } on FirebaseException catch (_) {
      controller.add((false, null, _.message, Status.failure));
    }
    return controller.stream;
  }

  Future<SetByDataFinder<T>> setByOnce<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
    bool withPriority = false,
  }) async {
    if (data.id.isNotEmpty) {
      try {
        return getAt<T>(
          builder: builder,
          encryptor: encryptor,
          id: data.id,
        ).then((value) {
          if (value == null) {
            return setAt(
              builder: builder,
              encryptor: encryptor,
              data: data,
              withPriority: withPriority,
            ).then((successful) {
              if (successful) {
                return (true, null, null, null, Status.ok);
              } else {
                return (false, null, null, "Database error!", Status.error);
              }
            }).onError((e, s) {
              return (false, null, null, "$e", Status.error);
            });
          } else {
            return (false, data, null, null, Status.alreadyFound);
          }
        });
      } on FirebaseException catch (_) {
        return (false, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<SetByListFinder<T>> setByMultiple<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
    bool withPriority = false,
  }) async {
    if (data.isNotEmpty) {
      try {
        return getAll<T>(
          builder: builder,
          encryptor: encryptor,
        ).then((value) {
          List<T> current = [];
          List<T> ignores = [];
          for (var i in data) {
            final insertable = value.where((E) => E.id == i.id).isEmpty;
            if (insertable) {
              current.add(i);
            } else {
              ignores.add(i);
            }
          }
          if (data.length != ignores.length) {
            return setAll(
              builder: builder,
              encryptor: encryptor,
              data: current,
              withPriority: withPriority,
            ).then((successful) {
              if (successful) {
                return (true, current, ignores, value, null, Status.ok);
              } else {
                return (
                  false,
                  null,
                  null,
                  null,
                  "Database error!",
                  Status.error,
                );
              }
            }).onError((e, s) {
              return (false, null, null, null, "$e", Status.failure);
            });
          } else {
            return (false, null, ignores, null, null, Status.alreadyFound);
          }
        });
      } on FirebaseException catch (_) {
        return (false, null, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, null, Status.invalidId);
    }
  }

  Future<UpdateByDataFinder<T>> updateById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    if (id.isNotEmpty) {
      try {
        return getAt<T>(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).then((value) {
          if (value != null) {
            return updateAt(
              builder: builder,
              encryptor: encryptor,
              data: encryptor != null
                  ? value.source.attach(data)
                  : data.withId(id),
            ).then((successful) {
              if (successful) {
                return (true, value, null, null, Status.ok);
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
      } on FirebaseException catch (_) {
        return (false, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<DeleteByIdFinder<T>> deleteById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return getAt<T>(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).then((value) {
          if (value != null) {
            return deleteAt(
              builder: builder,
              encryptor: encryptor,
              data: value,
            ).then((successful) {
              if (successful) {
                return (true, value, null, null, Status.ok);
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
      } on FirebaseException catch (_) {
        return (false, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<DeleteByIdFinder<T>> deleteByIds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    if (ids.isNotEmpty) {
      try {
        return getAts<T>(
          builder: builder,
          encryptor: encryptor,
          ids: ids,
        ).then((value) {
          if (value.isNotEmpty) {
            return deleteAll(
              builder: builder,
              encryptor: encryptor,
              data: value,
            ).then((successful) {
              if (successful) {
                return (true, null, value, null, Status.ok);
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
      } on FirebaseException catch (_) {
        return (false, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<ClearByFinder<T>> clearBy<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
  }) async {
    try {
      return getAll<T>(
        builder: builder,
        encryptor: encryptor,
      ).then((value) {
        if (value.isNotEmpty) {
          return deleteAll(
            builder: builder,
            encryptor: encryptor,
            data: value,
          ).then((successful) {
            if (successful) {
              return (true, value, null, Status.ok);
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
    } on FirebaseException catch (_) {
      return (false, null, _.message, Status.failure);
    }
  }
}

extension _RealtimeExtension on DatabaseReference {
  Future<T?> getAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return child(id).get().then((i) async {
      var data = i.value;
      if (i.exists && data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return builder(v);
      }
      return null;
    });
  }

  Future<List<T>> getAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    List<T> result = [];
    for (String id in ids) {
      var data = await getAt(
        builder: builder,
        id: id,
      );
      if (data != null) result.add(data);
    }
    return result;
  }

  Future<List<T>> getAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return get().then((_) async {
      if (_.children.isNotEmpty) {
        for (var i in _.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return result;
    });
  }

  Stream<T?> liveAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<T?>();
    if (id.isNotEmpty) {
      var isEncryptor = encryptor != null;
      child(id).onValue.listen((i) async {
        var data = i.snapshot.value;
        if (i.snapshot.exists && data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          controller.add(builder(v));
        } else {
          controller.add(null);
        }
      });
    }
    return controller.stream;
  }

  Stream<List<T>> livesAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<List<T>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    onValue.listen((_) async {
      result.clear();
      var value = _.snapshot.children;
      if (value.isNotEmpty) {
        for (var i in value) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      controller.add(result);
    });
    return controller.stream;
  }

  Future<bool> setAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
    bool withPriority = false,
  }) async {
    var isEncryptor = encryptor != null;
    var ref = child(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        if (withPriority) {
          return ref.setWithPriority(raw, data.timeMills).then((value) {
            return true;
          });
        } else {
          return ref.set(raw).then((value) {
            return true;
          });
        }
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      if (withPriority) {
        return ref.setWithPriority(data.source, data.timeMills).then((value) {
          return true;
        });
      } else {
        return ref.set(data.source).then((value) {
          return true;
        });
      }
    }
  }

  Future<bool> setAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
    bool withPriority = false,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await setAt(
        builder: builder,
        encryptor: encryptor,
        data: i,
        withPriority: withPriority,
      )) counter++;
    }
    return data.length == counter;
  }

  Future<bool> updateAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      var v = isEncryptor ? await encryptor.input(data) : data;
      if (v.isNotEmpty) {
        return child(id).update(v).then((value) {
          return true;
        });
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      return Future.error("Id isn't valid!");
    }
  }

  Future<bool> deleteAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
  }) {
    return child(data.id).remove().then((value) {
      return true;
    });
  }

  Future<bool> deleteAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await deleteAt(
        builder: builder,
        encryptor: encryptor,
        data: i,
      )) counter++;
    }
    return data.length == counter;
  }
}

abstract class RealtimeDataSourceImpl<T extends Data>
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
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await _source(builder).findById(
          builder: build,
          encryptor: encryptor,
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
        final finder = await _source(builder).setByOnce(
          builder: build,
          encryptor: encryptor,
          data: data,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          result: finder.$3,
          ignores: finder.$2 != null ? [finder.$2!] : null,
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
        final finder = await _source(builder).setByMultiple(
          builder: build,
          encryptor: encryptor,
          data: data,
        );
        return response.modify(
          error: !finder.$1,
          successful: finder.$1,
          ignores: finder.$3,
          result: finder.$4,
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
        final finder = await _source(builder).updateById(
          builder: build,
          encryptor: encryptor,
          id: id,
          data: data,
        );
        return response.modify(
          successful: finder.$1,
          error: !finder.$1,
          backups: finder.$2 != null ? [finder.$2!] : null,
          result: finder.$3,
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
        var finder = await _source(builder).deleteById(
          builder: build,
          encryptor: encryptor,
          id: id,
        );
        if (finder.$1) {
          return response
              .withBackup(finder.$2)
              .withResult(finder.$3, status: finder.$5);
        } else {
          return response.withException(finder.$4, status: finder.$5);
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
      var finder = await _source(builder).clearBy(
        builder: build,
        encryptor: encryptor,
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
      var finder = await _source(builder).findById(
        builder: build,
        encryptor: encryptor,
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
      var finder = await _source(builder).getBy(
        builder: build,
        encryptor: encryptor,
        onlyUpdates: forUpdates,
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
      try {
        _source(builder)
            .liveById(builder: build, encryptor: encryptor, id: id)
            .listen((finder) {
          if (finder.$1) {
            controller.add(response.withData(finder.$2));
          } else {
            controller.add(
              response.withData(null, message: finder.$4, status: finder.$5),
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
        _source(builder)
            .liveBy(
          builder: build,
          encryptor: encryptor,
          onlyUpdates: forUpdates,
        )
            .listen((finder) {
          if (finder.$1) {
            controller.add(response.withResult(finder.$2));
          } else {
            controller.add(
              response.withResult(null, message: finder.$3, status: finder.$4),
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
