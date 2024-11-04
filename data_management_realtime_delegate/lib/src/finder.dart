part of 'source.dart';

extension _RealtimeReferenceFinder on rdb.DatabaseReference {
  Future<CheckFinder<T, _RS>> checkById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _checkById<T>(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).then((value) {
          if (value.$1 != null) {
            return (value, null, Status.ok);
          } else {
            return (null, null, Status.notFound);
          }
        });
      } catch (error) {
        return (null, "$error", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Future<ClearFinder<T>> clear<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
  }) async {
    try {
      return _fetch<T>(builder: builder, encryptor: encryptor).then((value) {
        if ((value.$1 ?? []).isNotEmpty) {
          return _deleteByIds(
            builder: builder,
            encryptor: encryptor,
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
    } catch (error) {
      return (null, "$error", Status.failure);
    }
  }

  Future<CreationFinder> create<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
  }) async {
    if (data.id.isNotEmpty) {
      try {
        return _add(
          builder: builder,
          encryptor: encryptor,
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
      } catch (error) {
        return ("$error", Status.failure);
      }
    } else {
      return (null, Status.invalidId);
    }
  }

  Future<CreationFinder> creates<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
  }) async {
    if (data.isNotEmpty) {
      try {
        return _adds(
          builder: builder,
          encryptor: encryptor,
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

  Future<DeletionFinder> deleteById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _deleteById(
          builder: builder,
          encryptor: encryptor,
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

  Future<DeletionFinder> deleteByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    if (ids.isNotEmpty) {
      try {
        return _deleteByIds<T>(
          builder: builder,
          encryptor: encryptor,
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

  Future<GetsFinder<T, _RS>> fetch<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
  }) async {
    try {
      return _fetch<T>(
        builder: builder,
        encryptor: encryptor,
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

  Future<GetFinder<T, _RS>> fetchById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _fetchById<T>(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).then((value) {
          if (value.$1 != null) {
            return (value, null, Status.ok);
          } else {
            return (value, null, Status.notFound);
          }
        });
      } catch (error) {
        return (null, "$error", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Future<GetsFinder<T, _RS>> fetchByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    if (ids.isNotEmpty) {
      try {
        return _fetchByIds<T>(
          builder: builder,
          encryptor: encryptor,
          ids: ids,
        ).then((value) {
          if (value.$1 != null) {
            return (value, null, Status.ok);
          } else {
            return (value, null, Status.notFound);
          }
        });
      } catch (error) {
        return (null, "$error", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Stream<GetsFinder<T, _RS>> listen<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
  }) {
    final controller = StreamController<GetsFinder<T, _RS>>();
    try {
      _listen<T>(
        builder: builder,
        encryptor: encryptor,
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

  Stream<GetFinder<T, _RS>> liveById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<GetFinder<T, _RS>>();
    if (id.isNotEmpty) {
      try {
        _listenById<T>(
          builder: builder,
          encryptor: encryptor,
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

  Stream<GetsFinder<T, _RS>> liveByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) {
    final controller = StreamController<GetsFinder<T, _RS>>();
    if (ids.isNotEmpty) {
      try {
        _listenByIds<T>(
          builder: builder,
          encryptor: encryptor,
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

  Stream<GetsFinder<T, _RS>> listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    final controller = StreamController<GetsFinder<T, _RS>>();
    try {
      _listenByQuery<T>(
        builder: builder,
        encryptor: encryptor,
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

  Future<GetsFinder<T, _RS>> query<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) async {
    try {
      return _query<T>(
        builder: builder,
        encryptor: encryptor,
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
    } catch (error) {
      return (null, "$error", Status.failure);
    }
  }

  Future<GetsFinder<T, _RS>> search<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required Checker checker,
  }) async {
    try {
      return _search<T>(
        builder: builder,
        checker: checker,
        encryptor: encryptor,
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

  Future<UpdatingFinder> updateById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    if (id.isNotEmpty) {
      try {
        return _updateById(
          builder: builder,
          encryptor: encryptor,
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

  Future<UpdatingFinder> updateByIds<T extends Entity>({
    Encryptor? encryptor,
    required List<UpdatingInfo> data,
    required DataBuilder<T> builder,
  }) async {
    if (data.isNotEmpty) {
      try {
        return _updateByIds<T>(
          builder: builder,
          encryptor: encryptor,
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
