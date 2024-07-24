part of '../../sources/api.dart';

extension _ApiDataFinder on dio.Dio {
  Future<CheckFinder<T, _AS>> checkById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _checkById<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          id: id,
        ).then((value) {
          if (value.$1 != null) {
            return (value, null, Status.ok);
          } else {
            return (null, null, Status.notFound);
          }
        });
      } catch (_) {
        return (null, "$_", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Future<ClearFinder<T>> clear<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
  }) async {
    try {
      return _fetch<T>(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return _deleteByIds(
            builder: builder,
            encryptor: encryptor,
            api: api,
            endPoint: endPoint,
            ids: (value.$1 ?? []).map((e) => e.id).toList(),
          ).then((successful) {
            if (successful) {
              return (value.$1, null, Status.ok);
            } else {
              return (null, "Database error!", Status.error);
            }
          }).onError((_, __) {
            return (null, "$_", Status.failure);
          });
        } else {
          return (null, null, Status.notFound);
        }
      });
    } catch (_) {
      return (null, "$_", Status.failure);
    }
  }

  Future<CreationFinder> create<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required T data,
  }) async {
    if (data.id.isNotEmpty) {
      try {
        return _add(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          data: data,
        ).then((successful) {
          if (successful) {
            return (null, Status.ok);
          } else {
            return ("Database error!", Status.error);
          }
        }).onError((_, __) {
          return ("$_", Status.error);
        });
      } catch (_) {
        return ("$_", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<CreationFinder> creates<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<T> data,
  }) async {
    if (data.isNotEmpty) {
      try {
        return _adds(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          data: data,
        ).then((successful) {
          if (successful) {
            return (null, Status.ok);
          } else {
            return ("Database error!", Status.error);
          }
        }).onError((_, __) {
          return ("$_", Status.failure);
        });
      } catch (_) {
        return ("$_", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DeletionFinder> deleteById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _deleteById(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          id: id,
        ).then((value) {
          if (value) {
            return (null, Status.ok);
          } else {
            return ("Database error!", Status.error);
          }
        }).onError((_, __) {
          return ("$_", Status.failure);
        });
      } catch (_) {
        return ("$_", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DeletionFinder> deleteByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) async {
    if (ids.isNotEmpty) {
      try {
        return _deleteByIds<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          ids: ids,
        ).then((value) {
          if (value) {
            return (null, Status.ok);
          } else {
            return ("Database error!", Status.error);
          }
        }).onError((_, __) {
          return ("$_", Status.failure);
        });
      } catch (_) {
        return ("$_", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<GetsFinder<T, _AS>> fetchAll<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
  }) async {
    try {
      return _fetch<T>(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return (value, null, Status.ok);
        } else {
          return (value, null, Status.notFound);
        }
      });
    } catch (_) {
      return (null, "$_", Status.failure);
    }
  }

  Future<GetFinder<T, _AS>> fetchById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _fetchById<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          id: id,
        ).then((value) {
          if (value.$1 != null) {
            return (value, null, Status.ok);
          } else {
            return (value, null, Status.notFound);
          }
        });
      } catch (_) {
        return (null, "$_", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Future<GetsFinder<T, _AS>> fetchByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) async {
    if (ids.isNotEmpty) {
      try {
        return _fetchByIds<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          ids: ids,
        ).then((value) {
          if (value.$1 != null) {
            return (value, null, Status.ok);
          } else {
            return (value, null, Status.notFound);
          }
        });
      } catch (_) {
        return (null, "$_", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Stream<GetsFinder<T, _AS>> listen<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
  }) {
    final controller = StreamController<GetsFinder<T, _AS>>();
    try {
      _listen<T>(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
      ).listen((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          controller.add((value, null, Status.ok));
        } else {
          controller.add((value, null, Status.notFound));
        }
      });
    } catch (_) {
      controller.add((null, "$_", Status.failure));
    }
    return controller.stream;
  }

  Stream<GetFinder<T, _AS>> liveById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) {
    final controller = StreamController<GetFinder<T, _AS>>();
    if (id.isNotEmpty) {
      try {
        _listenById<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          id: id,
        ).listen((value) {
          if (value.$1 != null) {
            controller.add((value, null, Status.ok));
          } else {
            controller.add((value, null, Status.notFound));
          }
        }).onError((_) {
          controller.add((null, "$_", Status.error));
        });
      } catch (_) {
        controller.add((null, "$_", Status.failure));
      }
    } else {
      controller.add((null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<GetsFinder<T, _AS>> liveByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) {
    final controller = StreamController<GetsFinder<T, _AS>>();
    if (ids.isNotEmpty) {
      try {
        _listenByIds<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          ids: ids,
        ).listen((value) {
          if (value.$1 != null) {
            controller.add((value, null, Status.ok));
          } else {
            controller.add((value, null, Status.notFound));
          }
        }).onError((_) {
          controller.add((null, "$_", Status.error));
        });
      } catch (_) {
        controller.add((null, "$_", Status.failure));
      }
    } else {
      controller.add((null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<GetsFinder<T, _AS>> listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<DataSorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<GetsFinder<T, _AS>>();
    try {
      _listenByQuery<T>(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ).listen((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          controller.add((value, null, Status.alreadyFound));
        } else {
          controller.add((value, null, Status.notFound));
        }
      });
    } catch (_) {
      controller.add((null, "$_", Status.failure));
    }
    return controller.stream;
  }

  Future<GetsFinder<T, _AS>> query<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) async {
    try {
      return _query<T>(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return (value, null, Status.ok);
        } else {
          return (value, null, Status.notFound);
        }
      });
    } catch (_) {
      return (null, "$_", Status.failure);
    }
  }

  Future<GetsFinder<T, _AS>> search<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required Checker checker,
  }) async {
    try {
      return _search<T>(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
        checker: checker,
      ).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return (value, null, Status.ok);
        } else {
          return (value, null, Status.notFound);
        }
      });
    } catch (_) {
      return (null, "$_", Status.failure);
    }
  }

  Future<UpdatingFinder> updateById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _updateById(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          data: data.withId(id),
        ).then((successful) {
          if (successful) {
            return (null, Status.ok);
          } else {
            return ("Database error!", Status.error);
          }
        }).onError((_, __) {
          return ("$_", Status.failure);
        });
      } catch (_) {
        return ("$_", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<UpdatingFinder> updateByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<UpdatingInfo> data,
  }) async {
    if (data.isNotEmpty) {
      try {
        return _updateByIds<T>(
          builder: builder,
          encryptor: encryptor,
          api: api,
          endPoint: endPoint,
          data: data,
        ).then((value) {
          if (value) {
            return (null, Status.ok);
          } else {
            return ("Database error!", Status.error);
          }
        }).onError((_, __) {
          return ("$_", Status.failure);
        });
      } catch (_) {
        return ("$_", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }
}
