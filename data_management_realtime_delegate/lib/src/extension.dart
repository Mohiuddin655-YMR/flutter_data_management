part of 'source.dart';

extension _RealtimeReferenceExtension on rdb.DatabaseReference {
  Future<bool> _add<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required T data,
    bool withPriority = false,
  }) async {
    var isEncryptor = encryptor != null;
    var reference = child(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        if (withPriority) {
          return reference
              .setWithPriority(raw, data.timeMills)
              .then((_) => true)
              .onError(RealtimeDataException.future);
        } else {
          return reference
              .set(raw)
              .then((_) => true)
              .onError(RealtimeDataException.future);
        }
      } else {
        throw const RealtimeDataException("Encryption error!");
      }
    } else {
      if (withPriority) {
        return reference
            .setWithPriority(data.source, data.timeMills)
            .then((_) => true)
            .onError(RealtimeDataException.future);
      } else {
        return reference
            .set(data.source)
            .then((_) => true)
            .onError(RealtimeDataException.future);
      }
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

  Future<DataCheckResponse<T, _RS>> _checkById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return child(id).get().then((i) async {
      var data = i.value;
      if (i.exists && data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return (builder(v), i);
      }
      return (null, i);
    }).onError(RealtimeDataException.future);
  }

  Future<int> _count() {
    return get()
        .then((response) => response.children.length)
        .onError(RealtimeDataException.future);
  }

  Future<bool> _deleteById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) {
    return child(id).remove().then((value) {
      return true;
    }).onError(RealtimeDataException.future);
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

  Future<DataGetsResponse<T, _RS>> _fetch<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<rdb.DataSnapshot> children = [];
    return get().then((response) async {
      result.clear();
      children.clear();
      if (response.children.isNotEmpty) {
        for (var i in response.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      try {
        children = response.children.toList();
      } catch (_) {}
      return (result, children);
    }).onError(RealtimeDataException.future);
  }

  Future<DataGetResponse<T, _RS>> _fetchById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return child(id).get().then((i) async {
      var data = i.value;
      if (i.exists && data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return (builder(v), i);
      }
      return (null, i);
    }).onError(RealtimeDataException.future);
  }

  Future<DataGetsResponse<T, _RS>> _fetchByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<String> ids,
  }) async {
    List<T> result = [];
    List<rdb.DataSnapshot> snaps = [];
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

  Stream<DataGetsResponse<T, _RS>> _listen<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
  }) {
    final controller = StreamController<DataGetsResponse<T, _RS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<rdb.DataSnapshot> children = [];
    onValue.listen((response) async {
      result.clear();
      children.clear();
      if (response.snapshot.children.isNotEmpty) {
        for (var i in response.snapshot.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      try {
        children = response.snapshot.children.toList();
      } catch (_) {}
      controller.add((result, children));
    }).onError(RealtimeDataException.stream);
    return controller.stream;
  }

  Stream<DataGetResponse<T, _RS>> _listenById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<DataGetResponse<T, _RS>>();
    if (id.isNotEmpty) {
      var isEncryptor = encryptor != null;
      child(id).onValue.listen((i) async {
        var data = i.snapshot.value;
        if (i.snapshot.exists && data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          controller.add((builder(v), i.snapshot));
        } else {
          controller.add((null, i.snapshot));
        }
      }).onError(RealtimeDataException.stream);
    }
    return controller.stream;
  }

  Stream<DataGetsResponse<T, _RS>> _listenByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required List<String> ids,
  }) {
    final controller = StreamController<DataGetsResponse<T, _RS>>();
    Map<String, T> map = {};
    Map<String, rdb.DataSnapshot> snaps = {};
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
            snaps[snap.key ?? ""] = snap;
          }
        });
      } catch (_) {}
    }
    controller.add((map.values.toList(), snaps.values.toList()));
    return controller.stream;
  }

  Stream<DataGetsResponse<T, _RS>> _listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    final controller = StreamController<DataGetsResponse<T, _RS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<rdb.DataSnapshot> children = [];
    _QHelper.query(
      reference: this,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).onValue.listen((response) async {
      result.clear();
      children.clear();
      if (response.snapshot.children.isNotEmpty) {
        for (var i in response.snapshot.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      try {
        children = response.snapshot.children.toList();
      } catch (_) {}
      controller.add((result, children));
    }).onError(RealtimeDataException.stream);
    return controller.stream;
  }

  Future<DataGetsResponse<T, _RS>> _query<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<rdb.DataSnapshot> children = [];
    return _QHelper.query(
      reference: this,
      queries: queries,
      sorts: sorts,
      selections: selections,
      options: options,
    ).get().then((response) async {
      result.clear();
      children.clear();
      if (response.children.isNotEmpty) {
        for (var i in response.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      try {
        children = response.children.toList();
      } catch (_) {}
      return (result, children);
    }).onError(RealtimeDataException.future);
  }

  Future<DataGetsResponse<T, _RS>> _search<T extends Entity>({
    DataEncryptor? encryptor,
    required Checker checker,
    required DataBuilder<T> builder,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.search(this, checker).get().then((response) async {
      result.clear();
      if (response.children.isNotEmpty) {
        for (var i in response.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return (result, response.children);
    }).onError(RealtimeDataException.future);
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
            return child(id).update(v).then((value) {
              return true;
            });
          } else {
            throw const RealtimeDataException("Encryption error!");
          }
        });
      } else {
        return child(id).update(data).then((value) {
          return true;
        }).onError(RealtimeDataException.future);
      }
    } else {
      throw const RealtimeDataException("Id isn't valid!");
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
