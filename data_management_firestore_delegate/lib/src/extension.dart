part of 'source.dart';

extension _FireStoreCollectionExtension on fdb.CollectionReference {
  Future<bool> _add<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    var reference = doc(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        return reference
            .set(raw)
            .then((_) => true)
            .onError(FirestoreDataExtensionalException.future);
      } else {
        throw const FirestoreDataExtensionalException("Encryption error!");
      }
    } else {
      return reference
          .set(data.source, fdb.SetOptions(merge: true))
          .then((_) => true)
          .onError(FirestoreDataExtensionalException.future);
    }
  }

  Future<bool> _adds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<T> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await _add(
        builder: builder,
        encryptor: encryptor,
        data: i,
      )) counter++;
    }
    return data.length == counter;
  }

  Future<DataCheckResponse<T, _FS>> _checkById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return doc(id).get().then((i) async {
      var data = i.data();
      if (i.exists && data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return (builder(v), i);
      }
      return (null, i);
    }).onError(FirestoreDataExtensionalException.future);
  }

  Future<bool> _deleteById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) {
    return doc(id).delete().then((value) {
      return true;
    }).onError(FirestoreDataExtensionalException.future);
  }

  Future<bool> _deleteByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<String> ids,
  }) async {
    var counter = 0;
    for (var i in ids) {
      if (await _deleteById(
        builder: builder,
        encryptor: encryptor,
        id: i,
      )) counter++;
    }
    return ids.length == counter;
  }

  Future<DataGetsResponse<T, _FS>> _fetch<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return get().then((response) async {
      result.clear();
      docs.clear();
      if (response.docs.isNotEmpty || response.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in response.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in response.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      try {
        if (onlyUpdates) {
          docs = response.docChanges.map((e) => e.doc).toList();
        } else {
          docs = response.docs;
        }
      } catch (_) {}
      return (result, docs);
    }).onError(FirestoreDataExtensionalException.future);
  }

  Future<DataGetResponse<T, _FS>> _fetchById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return doc(id).get().then((i) async {
      var data = i.data();
      if (i.exists && data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return (builder(v), i);
      }
      return (null, i);
    }).onError(FirestoreDataExtensionalException.future);
  }

  Future<DataGetsResponse<T, _FS>> _fetchByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<String> ids,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    if (ids.length > _Limitations.whereIn) {
      List<fdb.DocumentSnapshot<Object?>> snaps = [];
      for (String id in ids) {
        try {
          var value = await _fetchById(
            builder: builder,
            encryptor: encryptor,
            id: id,
          );
          final data = value.$1;
          final snap = value.$2;
          if (data != null) {
            result.add(data);
          }
          if (snap != null) {
            snaps.add(snap);
          }
        } catch (_) {}
      }
      return (result, snaps);
    } else {
      return where(
        DataFieldPath.documentId,
        whereIn: ids,
      ).get().then((response) async {
        result.clear();
        if (response.docs.isNotEmpty) {
          for (var i in response.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
        return (result, response.docs);
      }).onError(FirestoreDataExtensionalException.future);
    }
  }

  Stream<DataGetsResponse<T, _FS>> _listen<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<DataGetsResponse<T, _FS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    snapshots().listen((event) async {
      result.clear();
      docs.clear();
      if (event.docs.isNotEmpty || event.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in event.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in event.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      try {
        if (onlyUpdates) {
          docs = event.docChanges.map((e) => e.doc).toList();
        } else {
          docs = event.docs;
        }
      } catch (_) {}
      controller.add((result, docs));
    }).onError(FirestoreDataExtensionalException.stream);
    return controller.stream;
  }

  Stream<DataGetResponse<T, _FS>> _listenById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<DataGetResponse<T, _FS>>();
    if (id.isNotEmpty) {
      var isEncryptor = encryptor != null;
      doc(id).snapshots().listen((i) async {
        var data = i.data();
        if (i.exists && data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          controller.add((builder(v), i));
        } else {
          controller.add((null, i));
        }
      }).onError(FirestoreDataExtensionalException.stream);
    }
    return controller.stream;
  }

  Stream<DataGetsResponse<T, _FS>> _listenByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<String> ids,
  }) {
    final controller = StreamController<DataGetsResponse<T, _FS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    if (ids.length > _Limitations.whereIn) {
      Map<String, T> map = {};
      Map<String, fdb.DocumentSnapshot<Object?>> snaps = {};
      for (String id in ids) {
        try {
          _listenById(
            builder: builder,
            encryptor: encryptor,
            id: id,
          ).listen((value) {
            final data = value.$1;
            final snap = value.$2;
            if (data != null) {
              map[data.id] = data;
            }
            if (snap != null) {
              snaps[snap.id] = snap;
            }
          });
        } catch (_) {}
      }
      controller.add((map.values.toList(), snaps.values.toList()));
    } else {
      where(
        DataFieldPath.documentId,
        whereIn: ids,
      ).snapshots().listen((event) async {
        result.clear();
        if (event.docs.isNotEmpty) {
          for (var i in event.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
        controller.add((result, event.docs));
      }).onError(FirestoreDataExtensionalException.stream);
    }
    return controller.stream;
  }

  Stream<DataGetsResponse<T, _FS>> _listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    bool onlyUpdates = false,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    final controller = StreamController<DataGetsResponse<T, _FS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    _QHelper.query(
      reference: this,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).snapshots().listen((event) async {
      result.clear();
      docs.clear();
      if (event.docs.isNotEmpty || event.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in event.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in event.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      try {
        if (onlyUpdates) {
          docs = event.docChanges.map((e) => e.doc).toList();
        } else {
          docs = event.docs;
        }
      } catch (_) {}
      controller.add((result, docs));
    }).onError(FirestoreDataExtensionalException.stream);
    return controller.stream;
  }

  Future<DataGetsResponse<T, _FS>> _query<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    bool onlyUpdates = false,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return _QHelper.query(
      reference: this,
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).get().then((response) async {
      result.clear();
      docs.clear();
      if (response.docs.isNotEmpty || response.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in response.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in response.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      try {
        if (onlyUpdates) {
          docs = response.docChanges.map((e) => e.doc).toList();
        } else {
          docs = response.docs;
        }
      } catch (_) {}
      return (result, docs);
    }).onError(FirestoreDataExtensionalException.future);
  }

  Future<DataGetsResponse<T, _FS>> _search<T extends Entity>({
    DataEncryptor? encryptor,
    required Checker checker,
    required DataBuilder<T> builder,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.search(this, checker).get().then((response) async {
      result.clear();
      if (response.docs.isNotEmpty || response.docChanges.isNotEmpty) {
        for (var i in response.docs) {
          var data = i.data();
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return (result, response.docs);
    }).onError(FirestoreDataExtensionalException.future);
  }

  Future<bool> _updateById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      if (isEncryptor) {
        return _fetchById(builder: builder, id: id).then((value) async {
          final x = value.$1?.source ?? {};
          x.addAll(data);
          var v = await encryptor.input(x);
          if (v.isNotEmpty) {
            return doc(id).update(v).then((value) {
              return true;
            });
          } else {
            throw const FirestoreDataExtensionalException("Encryption error!");
          }
        });
      } else {
        return doc(id).update(data).then((value) {
          return true;
        }).onError(FirestoreDataExtensionalException.future);
      }
    } else {
      throw const FirestoreDataExtensionalException("Id isn't valid!");
    }
  }

  Future<bool> _updateByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<UpdatingInfo> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await _updateById(
        builder: builder,
        encryptor: encryptor,
        data: i.data.withId(i.id),
      )) counter++;
    }
    return data.length == counter;
  }
}
