part of '../../sources/realtime_data_source.dart';

extension _RealtimeQueryExtension on rdb.Query {
  Future<GetsResponse<T, RS>> fetch<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return get().then((_) async {
      final value = _.children;
      if (value.isNotEmpty) {
        for (var i in value) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return (result, value);
    });
  }

  Stream<GetsResponse<T, RS>> lives<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<GetsResponse<T, RS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    onValue.listen((_) async {
      result.clear();
      var value = _.snapshot.children;
      if (value.isNotEmpty) {
        for (var i in value) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      controller.add((result, value));
    });
    return controller.stream;
  }

  Future<GetsResponse<T, RS>> query<T extends Entity>({
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
    return _QHelper.query(
      reference: this,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).get().then((_) async {
      result.clear();
      final value = _.children;
      if (value.isNotEmpty) {
        for (var i in value) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return (result, value);
    });
  }

  Stream<GetsResponse<T, RS>> queryLives<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    final controller = StreamController<GetsResponse<T, RS>>();
    var isEncryptor = encryptor != null;
    List<T> result = [];
    _QHelper.query(
      reference: this,
      queries: queries,
      selections: selections,
      sorts: sorts,
      options: options,
    ).onValue.listen((_) async {
      result.clear();
      var value = _.snapshot.children;
      if (value.isNotEmpty) {
        for (var i in value) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      controller.add((result, value));
    });
    return controller.stream;
  }

  Future<GetsResponse<T, RS>> search<T extends Entity>({
    Encryptor? encryptor,
    required Checker checker,
    required LocalDataBuilder<T> builder,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.search(this, checker).get().then((_) async {
      result.clear();
      final value = _.children;
      if (value.isNotEmpty) {
        for (var i in value) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return (result, value);
    });
  }
}
