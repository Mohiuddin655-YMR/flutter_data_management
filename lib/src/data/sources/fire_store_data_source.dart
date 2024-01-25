import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as fdb;
import 'package:flutter_andomie/core.dart';

import '../../core/extensions.dart';
import '../../core/typedefs.dart';
import '../../services/sources/remote_data_source.dart';
import '../../utils/response.dart';

///
/// You can use base class [Data] without [Entity]
///
abstract class FireStoreDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  final String path;

  FireStoreDataSource({
    required this.path,
    super.encryptor,
  });

  fdb.FirebaseFirestore? _db;

  fdb.FirebaseFirestore get database => _db ??= fdb.FirebaseFirestore.instance;

  fdb.CollectionReference _source<R>(OnDataSourceBuilder<R>? source) {
    final parent = database.collection(path);
    dynamic current = source?.call(parent as R);
    if (current is fdb.CollectionReference) {
      return current;
    } else {
      return parent;
    }
  }

  fdb.Query _query<R>(OnDataSourceBuilder<R>? source) {
    final parent = database.collection(path);
    dynamic current = source?.call(parent as R);
    if (current is fdb.Query || current is fdb.CollectionReference) {
      return current;
    } else {
      return parent;
    }
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
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

  /// Use for create single data
  @override
  Future<DataResponse<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
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

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
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

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
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

  /// Use for delete single data
  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
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

  /// Use for delete all data
  @override
  Future<DataResponse<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _source(builder).clearBy(
        builder: build,
        encryptor: encryptor,
      );
      if (finder.$1) {
        return response.withBackups(finder.$2, status: finder.$4);
      } else {
        return response.withException(finder.$3, status: finder.$4);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  /// Use for fetch single data
  @override
  Future<DataResponse<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _source(builder).getById(
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

  /// Use for fetch all data
  @override
  Future<DataResponse<T>> gets<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) async {
    final response = DataResponse<T>();
    if (isConnected) {
      var finder = await _query(builder).getBy(
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

  /// Use for fetch all recent updated data
  @override
  Future<DataResponse<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return gets(
      isConnected: isConnected,
      forUpdates: true,
      builder: builder,
    );
  }

  /// Use for fetch single observable data when data update
  @override
  Stream<DataResponse<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
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
      } on fdb.FirebaseException catch (_) {
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

  /// Use for fetch all observable data when data update
  @override
  Stream<DataResponse<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
  }) {
    final controller = StreamController<DataResponse<T>>();
    final response = DataResponse<T>();
    if (isConnected) {
      try {
        _query(builder)
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
      } on fdb.FirebaseException catch (_) {
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

extension _FireStoreCollectionFinder on fdb.CollectionReference {
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
      } on fdb.FirebaseException catch (_) {
        return (false, null, null, _.message, Status.failure);
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<FindByIdFinder<T>> getById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    return findById(builder: builder, encryptor: encryptor, id: id);
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
      } on fdb.FirebaseException catch (_) {
        controller.add((false, null, null, _.message, Status.failure));
      }
    } else {
      controller.add((false, null, null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Future<SetByDataFinder<T>> setByOnce<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
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
      } on fdb.FirebaseException catch (_) {
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
  }) async {
    if (data.isNotEmpty) {
      try {
        return getAts(
          builder: builder,
          encryptor: encryptor,
          ids: data.map((e) => e.id).toList(),
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
      } on fdb.FirebaseException catch (_) {
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
                  ? value.source.adjust(data)
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
      } on fdb.FirebaseException catch (_) {
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
      } on fdb.FirebaseException catch (_) {
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
    } on fdb.FirebaseException catch (_) {
      return (false, null, _.message, Status.failure);
    }
  }
}

extension _FireStoreQueryFinder on fdb.Query {
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
    } on fdb.FirebaseException catch (_) {
      return (false, null, _.message, Status.failure);
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
    } on fdb.FirebaseException catch (_) {
      controller.add((false, null, _.message, Status.failure));
    }
    return controller.stream;
  }
}

extension _FireStoreCollectionExtension on fdb.CollectionReference {
  Future<T?> getAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return doc(id).get().then((i) async {
      var data = i.data();
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

  Stream<T?> liveAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<T?>();
    if (id.isValid) {
      var isEncryptor = encryptor != null;
      doc(id).snapshots().listen((i) async {
        var data = i.data();
        if (i.exists && data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          controller.add(builder(v));
        } else {
          controller.add(null);
        }
      });
    }
    return controller.stream;
  }

  Future<bool> setAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    var ref = doc(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        return ref.set(raw, fdb.SetOptions(merge: true)).then((value) {
          return true;
        });
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      return ref.set(data.source, fdb.SetOptions(merge: true)).then((value) {
        return true;
      });
    }
  }

  Future<bool> setAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await setAt(
        builder: builder,
        encryptor: encryptor,
        data: i,
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
        return doc(id).update(v).then((value) {
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
    return doc(data.id).delete().then((value) {
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

extension _FireStoreQueryExtension on fdb.Query {
  Future<List<T>> getAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return get().then((_) async {
      if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in _.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in _.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      return result;
    });
  }

  Stream<List<T>> livesAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<List<T>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    snapshots().listen((_) async {
      result.clear();
      if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in _.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in _.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      controller.add(result);
    });
    return controller.stream;
  }
}
