part of 'source.dart';

extension _ApiDataFinder on dio.Dio {

  Future<DataClearFinder<T>> clear<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
          }).onError((error, __) {
            return (null, "$error", Status.failure);
          });
        } else {
          return (null, null, Status.notFound);
        }
      });
    } catch (e) {
      return (null, "$e", Status.failure);
    }
  }

  Future<DataCreationFinder> create<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
        }).onError((error, __) {
          return ("$error", Status.error);
        });
      } catch (e) {
        return ("$e", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DataCreationFinder> creates<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
        }).onError((error, __) {
          return ("$error", Status.failure);
        });
      } catch (error) {
        return ("$error", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DataDeletionFinder> deleteById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
        }).onError((error, __) {
          return ("$error", Status.failure);
        });
      } catch (error) {
        return ("$error", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DataDeletionFinder> deleteByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
        }).onError((error, __) {
          return ("$error", Status.failure);
        });
      } catch (error) {
        return ("$error", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DataGetsFinder<T, _AS>> fetchAll<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
    } catch (error) {
      return (null, "$error", Status.failure);
    }
  }


  Stream<DataGetsFinder<T, _AS>> listen<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
  }) {
    final controller = StreamController<DataGetsFinder<T, _AS>>();
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
    } catch (error) {
      controller.add((null, "$error", Status.failure));
    }
    return controller.stream;
  }

  Stream<DataGetFinder<T, _AS>> liveById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) {
    final controller = StreamController<DataGetFinder<T, _AS>>();
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
        }).onError((error, __) {
          controller.add((null, "$error", Status.error));
        });
      } catch (error) {
        controller.add((null, "$error", Status.failure));
      }
    } else {
      controller.add((null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<DataGetsFinder<T, _AS>> liveByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) {
    final controller = StreamController<DataGetsFinder<T, _AS>>();
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
        }).onError((error, __) {
          controller.add((null, "$error", Status.error));
        });
      } catch (error) {
        controller.add((null, "$error", Status.failure));
      }
    } else {
      controller.add((null, null, Status.invalidId));
    }
    return controller.stream;
  }

  Stream<DataGetsFinder<T, _AS>> listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    final controller = StreamController<DataGetsFinder<T, _AS>>();
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
    } catch (error) {
      controller.add((null, "$error", Status.failure));
    }
    return controller.stream;
  }


  Future<DataGetsFinder<T, _AS>> search<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
    } catch (error) {
      return (null, "$error", Status.failure);
    }
  }

  Future<DataUpdatingFinder> updateById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
        }).onError((error, __) {
          return ("$error", Status.failure);
        });
      } catch (error) {
        return ("$error", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<DataUpdatingFinder> updateByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
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
        }).onError((error, __) {
          return ("$error", Status.failure);
        });
      } catch (error) {
        return ("$error", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }
}
