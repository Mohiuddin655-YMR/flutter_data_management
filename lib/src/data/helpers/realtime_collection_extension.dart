part of '../sources/realtime_data_source.dart';

extension _RealtimeReferenceExtension on rdb.DatabaseReference {
  Future<T?> getAt<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    return child(id).get().then((i) async {
      var data = i.value;
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
    if (id.isNotEmpty) {
      var isEncryptor = encryptor != null;
      child(id).onValue.listen((i) async {
        var data = i.snapshot.value;
        if (i.snapshot.exists && data is Map<String, dynamic>) {
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
    bool withPriority = false,
  }) async {
    var isEncryptor = encryptor != null;
    var ref = child(data.id);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        if (withPriority) {
          return ref.setWithPriority(raw, data.timeMills).then((value) {
            return true;
          });
        } else {
          return ref.set(raw).then((value) {
            return true;
          });
        }
      } else {
        return Future.error("Encryption error!");
      }
    } else {
      if (withPriority) {
        return ref.setWithPriority(data.source, data.timeMills).then((value) {
          return true;
        });
      } else {
        return ref.set(data.source).then((value) {
          return true;
        });
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
        return child(id).update(v).then((value) {
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
    return child(data.id).remove().then((value) {
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
