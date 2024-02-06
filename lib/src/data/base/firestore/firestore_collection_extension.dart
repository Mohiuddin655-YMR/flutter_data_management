part of '../../sources/fire_store_data_source.dart';

extension _FireStoreCollectionExtension on fdb.CollectionReference {
  Future<GetResponse<T, FS>> getAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
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
    }).onError(Future.error);
  }

  Future<GetsResponse<T, FS>> getAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    if (ids.length > _Limitations.whereIn) {
      List<fdb.DocumentSnapshot<Object?>> snaps = [];
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
    } else {
      return where(FieldPath.documentId, whereIn: ids).get().then((_) async {
        result.clear();
        if (_.docs.isNotEmpty) {
          for (var i in _.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
        return (result, _.docs);
      });
    }
  }

  Stream<GetResponse<T, FS>> liveAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final con = StreamController<GetResponse<T, FS>>();

    if (id.isNotEmpty) {
      var isEncryptor = encryptor != null;
      doc(id).snapshots().listen((i) async {
        var data = i.data();
        if (i.exists && data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          con.add((builder(v), i));
        } else {
          con.add((null, i));
        }
      });
    }
    return con.stream;
  }

  Stream<GetsResponse<T, FS>> liveAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) {
    final con = StreamController<GetsResponse<T, FS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    if (ids.length > _Limitations.whereIn) {
      Map<String, T> map = {};
      Map<String, fdb.DocumentSnapshot<Object?>> snaps = {};
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
            if (snap != null) {
              snaps[snap.id] = snap;
            }
          });
        } catch (_) {}
      }
      con.add((map.values.toList(), snaps.values.toList()));
    } else {
      where(FieldPath.documentId, whereIn: ids).snapshots().listen((_) async {
        result.clear();
        if (_.docs.isNotEmpty) {
          for (var i in _.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
        con.add((result, _.docs));
      });
    }
    return con.stream;
  }

  Future<bool> setAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    var ref = doc(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        return ref.set(raw).then((_) => true);
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      return ref
          .set(data.source, fdb.SetOptions(merge: true))
          .then((_) => true);
    }
  }

  Future<bool> setAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await setAt(
        builder: builder,
        encryptor: encryptor,
        data: i,
      )) counter++;
    }
    return data.length == counter;
  }

  Future<bool> deleteAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    return doc(id).delete().then((value) {
      return true;
    });
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
            return doc(id).update(v).then((value) {
              return true;
            });
          } else {
            return Future.error("Encryption error!");
          }
        });
      } else {
        return doc(id).update(data).then((value) {
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
