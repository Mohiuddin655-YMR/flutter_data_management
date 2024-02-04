part of '../sources/realtime_data_source.dart';

extension _RealtimeQueryExtension on rdb.Query {
  Future<List<T>> getAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return get().then((_) async {
      if (_.children.isNotEmpty) {
        for (var i in _.children) {
          var data = i.value;
          if (i.exists) {
            var v = isEncryptor ? await encryptor.output(data) : data;
            result.add(builder(v));
          }
        }
      }
      return result;
    });
  }

  Stream<List<T>> livesAll<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    bool onlyUpdates = false,
  }) {
    final controller = StreamController<List<T>>();
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
      controller.add(result);
    });
    return controller.stream;
  }

  Future<List<T>> paging<T extends Entity>({
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const RealtimePagingOptions.empty(),
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    return _QHelper.query(
      reference: this,
      queries: queries,
      sorts: sorts,
      options: options is RealtimePagingOptions
          ? options
          : const RealtimePagingOptions.empty(),
    ).get().then((_) async {
      if (_.children.isNotEmpty) {
        for (var i in _.children) {
          var data = i.value;
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
