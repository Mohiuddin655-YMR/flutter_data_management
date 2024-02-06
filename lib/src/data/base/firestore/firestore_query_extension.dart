part of '../../sources/fire_store_data_source.dart';

extension _FireStoreQueryExtension on fdb.Query {
  Future<GetsResponse<T, FS>> fetch<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    return get().then((_) async {
      result.clear();
      docs.clear();
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
      try {
        if (onlyUpdates) {
          docs = _.docChanges.map((e) => e.doc).toList();
        } else {
          docs = _.docs;
        }
      } catch (_) {}
      return (result, docs);
    });
  }

  Stream<GetsResponse<T, FS>> lives<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<GetsResponse<T, FS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    snapshots().listen((_) async {
      result.clear();
      docs.clear();
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
      try {
        if (onlyUpdates) {
          docs = _.docChanges.map((e) => e.doc).toList();
        } else {
          docs = _.docs;
        }
      } catch (_) {}
      controller.add((result, docs));
    });
    return controller.stream;
  }

  Future<GetsResponse<T, FS>> query<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
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
    ).get().then((_) async {
      result.clear();
      docs.clear();
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
      try {
        if (onlyUpdates) {
          docs = _.docChanges.map((e) => e.doc).toList();
        } else {
          docs = _.docs;
        }
      } catch (_) {}
      return (result, docs);
    });
  }

  Stream<GetsResponse<T, FS>> queryLives<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<GetsResponse<T, FS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    List<fdb.DocumentSnapshot> docs = [];
    _QHelper.query(
      reference: this,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).snapshots().listen((_) async {
      result.clear();
      docs.clear();
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
      try {
        if (onlyUpdates) {
          docs = _.docChanges.map((e) => e.doc).toList();
        } else {
          docs = _.docs;
        }
      } catch (_) {}
      controller.add((result, docs));
    });
    return controller.stream;
  }

  Future<GetsResponse<T, FS>> search<T extends Entity>({
    Encryptor? encryptor,
    required Checker checker,
    required LocalDataBuilder<T> builder,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.search(this, checker).get().then((_) async {
      result.clear();
      if (_.docs.isNotEmpty || _.docChanges.isNotEmpty) {
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
