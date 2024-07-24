part of '../../sources/local.dart';

extension _LocalDataFinder on fdb.InAppQueryReference {
  Future<CheckFinder<T, _Snapshot>> checkById<T extends Entity>({
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

  Future<GetsFinder<T, _Snapshot>> fetch<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    try {
      return _fetch<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
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

  Future<GetFinder<T, _Snapshot>> fetchById<T extends Entity>({
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
      } catch (_) {
        return (null, "$_", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Future<GetsFinder<T, _Snapshot>> fetchByIds<T extends Entity>({
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
      } catch (_) {
        return (null, "$_", Status.failure);
      }
    } else {
      return (null, null, Status.invalidId);
    }
  }

  Stream<GetsFinder<T, _Snapshot>> listen<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<GetsFinder<T, _Snapshot>>();
    try {
      _listen<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
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

  Stream<GetFinder<T, _Snapshot>> liveById<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<GetFinder<T, _Snapshot>>();
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

  Stream<GetsFinder<T, _Snapshot>> liveByIds<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) {
    final controller = StreamController<GetsFinder<T, _Snapshot>>();
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

  Stream<GetsFinder<T, _Snapshot>> listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<GetsFinder<T, _Snapshot>>();
    try {
      _listenByQuery<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
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

  Future<GetsFinder<T, _Snapshot>> query<T extends Entity>({
    required DataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) async {
    try {
      return _query<T>(
        builder: builder,
        encryptor: encryptor,
        onlyUpdates: onlyUpdates,
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

  Future<GetsFinder<T, _Snapshot>> search<T extends Entity>({
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
    } catch (_) {
      return (null, "$_", Status.failure);
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

  Future<CreationFinder> keep<T extends Entity>(List<T> data) async {
    if (data.isNotEmpty) {
      try {
        final children = List.of(data.map((e) {
          return fdb.InAppDocumentSnapshot(e.id, e.source);
        }));
        return set(children)
            .then((_) => true)
            .onError(LocalDataExtensionalException.future)
            .then((successful) {
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
      return (null, Status.notFound);
    }
  }
}
