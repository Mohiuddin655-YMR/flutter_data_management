part of '../sources/api_data_source.dart';

extension _ApiDataFinder on dio.Dio {
  Future<FindByFinder<T>> _findBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) async {
    try {
      return _getAll<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        return (false, null, null, Status.notFound);
      } else {
        return (false, null, _.message, Status.failure);
      }
    }
  }

  Future<FindByIdFinder<T>> _findById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _getAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).then((value) {
          if (value != null) {
            return (true, value, null, null, Status.alreadyFound);
          } else {
            return (false, null, null, null, Status.notFound);
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<FindByFinder<T>> _getBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) {
    return _findBy(
      api: api,
      builder: builder,
      encryptor: encryptor,
      path: path,
    );
  }

  Future<FindByFinder<T>> _queryBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const ApiPagingOptions.empty(),
  }) async {
    try {
      return _query<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
        queries: queries,
        sorts: sorts,
        options: options,
      ).then((value) {
        if (value.isNotEmpty) {
          return (true, value, null, Status.alreadyFound);
        } else {
          return (false, null, null, Status.notFound);
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        return (false, null, null, Status.notFound);
      } else {
        return (false, null, _.message, Status.failure);
      }
    }
  }

  Stream<FindByIdFinder<T>> _liveById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) {
    final controller = StreamController<FindByIdFinder<T>>();
    if (id.isNotEmpty) {
      try {
        liveAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).listen((value) {
          if (value != null) {
            controller.add((true, value, null, null, Status.alreadyFound));
          } else {
            controller.add((false, null, null, null, Status.notFound));
          }
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          controller.add((false, null, null, null, Status.notFound));
        } else {
          controller.add((false, null, null, _.message, Status.failure));
        }
      }
    } else {
      controller.add((false, null, null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<FindByFinder<T>> _liveBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) {
    final controller = StreamController<FindByFinder<T>>();
    try {
      livesAll<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
      ).listen((value) {
        if (value.isNotEmpty) {
          controller.add((true, value, null, Status.alreadyFound));
        } else {
          controller.add((false, null, null, Status.notFound));
        }
      });
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        controller.add((false, null, null, Status.notFound));
      } else {
        controller.add((false, null, _.message, Status.failure));
      }
    }
    return controller.stream;
  }

  Future<SetByDataFinder<T>> _setByOnce<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required T data,
  }) async {
    if (data.id.isNotEmpty) {
      try {
        return setAt(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          data: data,
        ).then((feedback) {
          if (feedback != null) {
            if (feedback is T) {
              return (true, feedback, null, null, Status.ok);
            } else if (feedback is List<T>) {
              return (true, null, feedback, null, Status.ok);
            } else {
              return (true, null, null, null, Status.ok);
            }
          } else {
            return (false, null, null, "Database error!", Status.error);
          }
        }).onError((e, s) {
          return (false, null, null, "$e", Status.error);
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, null);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<SetByListFinder<T>> _setByMultiple<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<T> data,
  }) async {
    if (data.isNotEmpty) {
      try {
        return setAll<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          data: data,
        ).then((value) {
          if (value.isNotEmpty) {
            var feedback = value.whereType<T>().toList();
            var feedback2 = value.whereType<List<T>>().toList();
            feedback2.forEach(feedback.addAll);
            return (true, null, null, feedback, null, Status.ok);
          } else {
            return (false, null, null, null, "Database error!", Status.error);
          }
        }).onError((e, s) {
          return (false, null, null, null, "$e", Status.failure);
        });
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, null, null);
        } else {
          return (false, null, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, null, Status.invalidId);
    }
  }

  Future<UpdateByDataFinder<T>> _updateById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _getAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).then((value) {
          if (value != null) {
            return updateAt(
              api: api,
              builder: builder,
              encryptor: encryptor,
              path: path,
              data: encryptor != null
                  ? value.source.generate(data)
                  : data.withId(id),
            ).then((feedback) {
              if (feedback != null) {
                if (feedback is T) {
                  return (true, value, [feedback], null, Status.ok);
                } else if (feedback is List<T>) {
                  return (true, value, feedback, null, Status.ok);
                } else {
                  return (true, value, null, null, Status.ok);
                }
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
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<DeleteByIdFinder<T>> _deleteById<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _getAt<T>(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
          id: id,
        ).then((value) {
          if (value != null) {
            return deleteAt(
              api: api,
              builder: builder,
              encryptor: encryptor,
              path: path,
              data: value,
            ).then((feedback) {
              if (feedback != null) {
                if (feedback is T) {
                  return (true, value, [feedback], null, Status.ok);
                } else if (feedback is List<T>) {
                  return (true, value, feedback, null, Status.ok);
                } else {
                  return (true, value, null, null, Status.ok);
                }
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
      } on dio.DioException catch (_) {
        if (_.response?.statusCode.use == api.status.notFound) {
          return (false, null, null, null, Status.notFound);
        } else {
          return (false, null, null, _.message, Status.failure);
        }
      }
    } else {
      return (false, null, null, null, Status.invalidId);
    }
  }

  Future<ClearByFinder<T>> _clearBy<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) async {
    try {
      return _getAll<T>(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
      ).then((value) {
        if (value.isNotEmpty) {
          return deleteAll(
            api: api,
            builder: builder,
            encryptor: encryptor,
            path: path,
            data: value,
          ).then((_) {
            if (_.isNotEmpty) {
              var feedback = _.whereType<T>().toList();
              var feedback2 = _.whereType<List<T>>().toList();
              feedback2.forEach(feedback.addAll);
              return (true, feedback, null, Status.ok);
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
    } on dio.DioException catch (_) {
      if (_.response?.statusCode.use == api.status.notFound) {
        return (false, null, null, Status.notFound);
      } else {
        return (false, null, _.message, Status.failure);
      }
    }
  }
}

extension _DataMapHelper on Map<String, dynamic>? {
  Map<String, dynamic> generate(Map<String, dynamic> current) {
    final data = this ?? {};
    data.addAll(current);
    return data;
  }
}
