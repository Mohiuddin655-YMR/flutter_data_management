part of '../sources/fire_store_data_source.dart';

extension _FireStoreQueryExtension on fdb.Query {
  Future<List<T>> fetch<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return get().then((_) async {
      if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in _.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in _.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      return result;
    });
  }

  Stream<List<T>> lives<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<List<T>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    snapshots().listen((_) async {
      result.clear();
      if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
        if (onlyUpdates) {
          for (var i in _.docChanges) {
            var data = i.doc.data();
            if (i.doc.exists && data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        } else {
          for (var i in _.docs) {
            var data = i.data();
            if (i.exists) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
      }
      controller.add(result);
    });
    return controller.stream;
  }

  Future<List<T>> paging<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const FirestorePagingOptions.empty(),
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.query(
      reference: this,
      queries: queries,
      sorts: sorts,
      options: options is FirestorePagingOptions
          ? options
          : const FirestorePagingOptions.empty(),
    ).get().then((_) async {
      if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
        for (var i in _.docs) {
          var data = i.data();
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return result;
    });
  }
}
