part of '../sources/realtime_data_source.dart';

extension _RealtimeReferenceFinder on rdb.DatabaseReference {
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
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
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
      } catch (_) {
        controller.add((false, null, null, "$_", Status.failure));
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
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
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
        return getAts<T>(
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
      } catch (_) {
        return (false, null, null, null, "$_", Status.failure);
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
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
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
      } catch (_) {
        return (false, null, null, "$_", Status.failure);
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
    } catch (_) {
      return (false, null, "$_", Status.failure);
    }
  }
}
