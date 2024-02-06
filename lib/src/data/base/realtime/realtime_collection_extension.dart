part of '../../sources/realtime_data_source.dart';

extension _RealtimeReferenceExtension on rdb.DatabaseReference {
  Future<GetResponse<T, RS>> getAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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
    }).onError(Future.error);
  }

  Future<GetsResponse<T, RS>> getAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    List<T> result = [];
    List<RS> snaps = [];
    for (String id in ids) {
      try {
        var value = await getAt(
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

  Stream<GetResponse<T, RS>> liveAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<GetResponse<T, RS>>();
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
      });
    }
    return controller.stream;
  }

  Stream<GetsResponse<T, RS>> liveAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) {
    final con = StreamController<GetsResponse<T, RS>>();
    Map<String, T> map = {};
    Map<String, RS> snaps = {};
    for (String id in ids) {
      try {
        liveAt(
          builder: builder,
          encryptor: encryptor,
          id: id,
        ).listen((value) {
          final data = value.$1;
          final snap = value.$2;
          if (data != null) {
            map[data.id] = data;
          }
          if (snap != null && snap.key != null) {
            snaps[snap.key ?? ""] = snap;
          }
        });
      } catch (_) {}
    }
    con.add((map.values.toList(), snaps.values.toList()));
    return con.stream;
  }

  Future<bool> setAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
    bool withPriority = false,
  }) async {
    var isEncryptor = encryptor != null;
    var ref = child(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        if (withPriority) {
          return ref.setWithPriority(raw, data.timeMills).then((_) => true);
        } else {
          return ref.set(raw).then((_) => true);
        }
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      if (withPriority) {
        return ref.setWithPriority(data.source, data.timeMills).then((_) {
          return true;
        });
      } else {
        return ref.set(data.source).then((_) => true);
      }
    }
  }

  Future<bool> setAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
    bool withPriority = false,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await setAt(
        builder: builder,
        encryptor: encryptor,
        data: i,
        withPriority: withPriority,
      )) counter++;
    }
    return data.length == counter;
  }

  Future<bool> deleteAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    return child(id).remove().then((_) => true);
  }

  Future<bool> deleteAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    var counter = 0;
    for (var i in ids) {
      if (await deleteAt(
        builder: builder,
        encryptor: encryptor,
        id: i,
      )) counter++;
    }
    return ids.length == counter;
  }

  Future<bool> updateAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      if (isEncryptor) {
        return getAt(builder: builder, id: id).then((value) async {
          final x = value.$1?.source ?? {};
          x.addAll(data);
          var v = await encryptor.input(x);
          if (v.isNotEmpty) {
            return child(id).update(v).then((value) {
              return true;
            });
          } else {
            return Future.error("Encryption error!");
          }
        });
      } else {
        return child(id).update(data).then((value) {
          return true;
        });
      }
    } else {
      return Future.error("Id isn't valid!");
    }
  }

  Future<bool> updateAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<UpdatingInfo> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await updateAt(
        builder: builder,
        encryptor: encryptor,
        data: i.data.withId(i.id),
      )) counter++;
    }
    return data.length == counter;
  }
}
