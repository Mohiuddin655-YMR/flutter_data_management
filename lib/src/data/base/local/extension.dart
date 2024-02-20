part of '../../sources/local_store_data_source.dart';

extension _LocalStoreCollectionExtension on ldb.CollectionRef {
  Future<bool> _add<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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
            .onError(DataException.future);
      } else {
        throw const DataException("Encryption error!");
      }
    } else {
      return reference
          .set(data.source, ldb.SetOptions(merge: true))
          .then((_) => true)
          .onError(DataException.future);
    }
  }

  Future<bool> _adds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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

  Future<CheckResponse<T, _LS>> _checkById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return doc(id).get().then((i) async {
      var data = i;
      if (data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return (builder(v), i);
      }
      return (null, i);
    }).onError(DataException.future);
  }

  Future<bool> _deleteById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    return doc(id).delete().then((value) {
      return true;
    }).onError(DataException.future);
  }

  Future<bool> _deleteByIds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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

  Future<GetsResponse<T, _LS>> _fetch<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    Map<String, T> result = {};
    Map<String, _LS> docs = {};
    return get().then((_) async {
      result.clear();
      docs.clear();
      final data = _ ?? {};
      if (data.isNotEmpty) {
        for (var i in data.entries) {
          docs[i.key] = i.value;
          var v = isEncryptor ? await encryptor.output(i.value) : i.value;
          final item = builder(v);
          result[item.id] == item;
        }
      }
      return (result.values.toList(), docs.values.toList());
    }).onError(DataException.future);
  }

  Future<GetResponse<T, _LS>> _fetchById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return doc(id).get().then((i) async {
      var data = i;
      if (data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return (builder(v), i);
      }
      return (null, i);
    }).onError(DataException.future);
  }

  Future<GetsResponse<T, _LS>> _fetchByIds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    List<T> result = [];
    List<_LS> snaps = [];
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
  }

  Stream<GetsResponse<T, _LS>> _listen<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<GetsResponse<T, _LS>>();
    var isEncryptor = encryptor != null;
    Map<String, T> result = {};
    Map<String, _LS> docs = {};
    stream.listen((_) async {
      result.clear();
      docs.clear();
      final data = _;
      if (data.isNotEmpty) {
        for (var i in data.entries) {
          docs[i.key] = i.value;
          var v = isEncryptor ? await encryptor.output(i.value) : i.value;
          final item = builder(v);
          result[item.id] == item;
        }
      }
      controller.add((result.values.toList(), docs.values.toList()));
    }).onError(DataException.stream);
    return controller.stream;
  }

  Stream<GetResponse<T, _LS>> _listenById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<GetResponse<T, _LS>>();
    if (id.isNotEmpty) {
      var isEncryptor = encryptor != null;
      Map<String, T> result = {};
      Map<String, _LS> docs = {};
      where(LocalstoreFieldPath.documentId, isEqualTo: id)
          .stream
          .listen((_) async {
        result.clear();
        docs.clear();
        final data = _;
        if (data.isNotEmpty) {
          for (var i in data.entries) {
            docs[i.key] = i.value;
            var v = isEncryptor ? await encryptor.output(i.value) : i.value;
            final item = builder(v);
            result[item.id] == item;
          }
        }
        controller.add((result.values.firstOrNull, docs.values.firstOrNull));
      }).onError(DataException.stream);
    }
    return controller.stream;
  }

  Stream<GetsResponse<T, _LS>> _listenByIds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) {
    final controller = StreamController<GetsResponse<T, _LS>>();
    Map<String, T> map = {};
    Map<String, _LS> snaps = {};
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
          controller.add((map.values.toList(), snaps.values.toList()));
        });
      } catch (_) {}
    }
    return controller.stream;
  }

  Stream<GetsResponse<T, _LS>> _listenByQuery<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<GetsResponse<T, _LS>>();
    var isEncryptor = encryptor != null;
    Map<String, T> result = {};
    Map<String, _LS> docs = {};
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _QHelper.query(
        reference: this,
        queries: queries,
        selections: selections,
        sorts: sorts,
        options: options,
      ).then((_) async {
        result.clear();
        docs.clear();
        final data = _ ?? {};
        if (data.isNotEmpty) {
          for (var i in data.entries) {
            docs[i.key] = i.value;
            var v = isEncryptor ? await encryptor.output(i.value) : i.value;
            final item = builder(v);
            result[item.id] = item;
          }
        }
        controller.add((result.values.toList(), docs.values.toList()));
      }).onError(DataException.future);
    });
    return controller.stream;
  }

  Future<GetsResponse<T, _LS>> _query<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    var isEncryptor = encryptor != null;
    Map<String, T> result = {};
    Map<String, _LS> docs = {};
    return _QHelper.query(
      reference: this,
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).then((_) async {
      result.clear();
      docs.clear();
      final data = _ ?? {};
      if (data.isNotEmpty) {
        for (var i in data.entries) {
          docs[i.key] = i.value;
          var v = isEncryptor ? await encryptor.output(i.value) : i.value;
          final item = builder(v);
          result[item.id] == item;
        }
      }
      return (result.values.toList(), docs.values.toList());
    }).onError(DataException.future);
  }

  Future<GetsResponse<T, _LS>> _search<T extends Entity>({
    Encryptor? encryptor,
    required Checker checker,
    required LocalDataBuilder<T> builder,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.search(this, checker).then((_) async {
      result.clear();
      final data = _ ?? {};
      if (data.isNotEmpty) {
        for (var i in data.values) {
          var v = isEncryptor ? await encryptor.output(i) : i;
          final item = builder(v);
          result.add(item);
        }
      }
      return (result, data.values);
    }).onError(DataException.future);
  }

  Future<bool> _updateById<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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
            return doc(id).set(v, ldb.SetOptions(merge: true)).then((value) {
              return true;
            });
          } else {
            throw const DataException("Encryption error!");
          }
        });
      } else {
        return doc(id).set(data, ldb.SetOptions(merge: true)).then((value) {
          return true;
        }).onError(DataException.future);
      }
    } else {
      throw const DataException("Id isn't valid!");
    }
  }

  Future<bool> _updateByIds<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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
