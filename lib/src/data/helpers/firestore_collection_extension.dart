part of '../sources/fire_store_data_source.dart';

extension _FireStoreCollectionExtension on fdb.CollectionReference {
  Future<T?> getAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return doc(id).get().then((i) async {
      var data = i.data();
      if (i.exists && data is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(data) : data;
        return builder(v);
      }
      return null;
    });
  }

  Future<List<T>> getAts<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<String> ids,
  }) async {
    List<T> result = [];
    for (String id in ids) {
      var data = await getAt(
        builder: builder,
        id: id,
      );
      if (data != null) result.add(data);
    }
    return result;
  }

  Stream<T?> liveAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) {
    final controller = StreamController<T?>();
    if (id.isValid) {
      var isEncryptor = encryptor != null;
      doc(id).snapshots().listen((i) async {
        var data = i.data();
        if (i.exists && data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          controller.add(builder(v));
        } else {
          controller.add(null);
        }
      });
    }
    return controller.stream;
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
        return ref.set(raw, fdb.SetOptions(merge: true)).then((value) {
          return true;
        });
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      return ref.set(data.source, fdb.SetOptions(merge: true)).then((value) {
        return true;
      });
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

  Future<bool> updateAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      var v = isEncryptor ? await encryptor.input(data) : data;
      if (v.isNotEmpty) {
        return doc(id).update(v).then((value) {
          return true;
        });
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      return Future.error("Id isn't valid!");
    }
  }

  Future<bool> deleteAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required T data,
  }) {
    return doc(data.id).delete().then((value) {
      return true;
    });
  }

  Future<bool> deleteAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required List<T> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await deleteAt(
        builder: builder,
        encryptor: encryptor,
        data: i,
      )) counter++;
    }
    return data.length == counter;
  }
}
