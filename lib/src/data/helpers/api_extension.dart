part of '../sources/api_data_source.dart';

extension _ApiExtension on dio.Dio {
  Future<T?> _getAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) async {
    try {
      var isEncryptor = encryptor != null;
      final I = api._parent(path).child(id);
      final result = api.request.isGetRequest ? await get(I) : await post(I);
      final value = result.data;
      final code = result.statusCode;
      if (code == api.status.ok && value is Map<String, dynamic>) {
        var v = isEncryptor ? await encryptor.output(value) : value;
        return builder(v);
      } else {
        return Future.error("Data not found!");
      }
    } catch (_) {
      return Future.error("Data not found!");
    }
  }

  Future<List<T>> _getAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    final I = api._parent(path);
    final request = api.request.isGetRequest ? get(I) : post(I);
    return request.then((_) async {
      if (_.statusCode == api.status.ok) {
        if (_.data is List) {
          for (var i in _.data) {
            if (i != null && i is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(i) : i;
              result.add(builder(v));
            }
          }
        }
        return result;
      } else {
        return Future.error("Data not found!");
      }
    });
  }

  Future<List<T>> _query<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const ApiPagingOptions.empty(),
  }) async {
    var isEncryptor = encryptor != null;
    List<T> result = [];
    final I = api._parent(path);
    final query = _QHelper.query(
      queries: queries,
      sorts: sorts,
      options: options is ApiPagingOptions
          ? options
          : const ApiPagingOptions.empty(),
    );

    final request = query.request.isPostRequest
        ? post(I, queryParameters: query.queryParams, data: query.body)
        : get(I, queryParameters: query.queryParams, data: query.body);

    return request.then((_) async {
      if (_.statusCode == api.status.ok) {
        if (_.data is List) {
          for (var i in _.data) {
            if (i != null && i is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(i) : i;
              result.add(builder(v));
            }
          }
        }
        return result;
      } else {
        return Future.error("Data not found!");
      }
    });
  }

  Stream<T?> liveAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required String id,
  }) {
    final controller = StreamController<T?>();
    if (id.isNotEmpty) {
      Timer.periodic(
        Duration(milliseconds: api.timer.streamReloadTime),
        (timer) async {
          var I = await _getAt(
            api: api,
            builder: builder,
            encryptor: encryptor,
            path: path,
            id: id,
          );
          controller.add(I);
        },
      );
    } else {
      controller.addError("Invalid id!");
    }
    return controller.stream;
  }

  Stream<List<T>> livesAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
  }) {
    final controller = StreamController<List<T>>();
    Timer.periodic(
      Duration(milliseconds: api.timer.streamReloadTime),
      (timer) async {
        var I = await _getAll(
          api: api,
          builder: builder,
          encryptor: encryptor,
          path: path,
        );
        controller.add(I);
      },
    );
    return controller.stream;
  }

  Future<dynamic> setAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api._parent(path).child(data.id, api.autoGenerateId);
    final v = isEncryptor ? await encryptor.output(data.source) : data.source;
    if (v.isNotEmpty) {
      final result = await post(I, data: v);
      final code = result.statusCode;
      if (code == api.status.created || code == api.status.ok) {
        var feedback =
            isEncryptor ? await encryptor.output(result.data) : result.data;
        if (feedback is Map) {
          return builder(feedback);
        } else if (feedback is List) {
          return feedback.map((_) => builder(_)).toList();
        } else {
          return feedback;
        }
      } else {
        return Future.error("Data not inserted!");
      }
    } else {
      return Future.error("Encryption failed!");
    }
  }

  Future<List<dynamic>> setAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<T> data,
  }) async {
    List<dynamic> feedback = [];
    for (var i in data) {
      feedback.add(await setAt(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
        data: i,
      ));
    }
    return feedback;
  }

  Future<dynamic> updateAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      var I = api._parent(path).child(id);
      var v = isEncryptor ? await encryptor.input(data) : data;
      if (v.isNotEmpty) {
        final result = await put(I, data: v);
        var code = result.statusCode;
        if (code == api.status.ok || code == api.status.updated) {
          var feedback =
              isEncryptor ? await encryptor.output(result.data) : result.data;
          if (feedback is Map) {
            return builder(feedback);
          } else if (feedback is List) {
            return feedback.map((_) => builder(_)).toList();
          } else {
            return feedback;
          }
        } else {
          return Future.error("Data not updated!");
        }
      } else {
        return Future.error("Encryption failed!");
      }
    } else {
      return Future.error("Id isn't valid!");
    }
  }

  Future<dynamic> deleteAt<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api._parent(path).child(data.id);
    var result = await delete(I);
    var code = result.statusCode;
    if (code == api.status.ok || code == api.status.deleted) {
      var feedback =
          isEncryptor ? await encryptor.output(result.data) : result.data;
      if (feedback is Map) {
        return builder(feedback);
      } else if (feedback is List) {
        return feedback.map((_) => builder(_)).toList();
      } else {
        return feedback;
      }
    } else {
      return Future.error("Data not deleted!");
    }
  }

  Future<List<dynamic>> deleteAll<T extends Entity>({
    required Api api,
    required LocalDataBuilder<T> builder,
    Encryptor? encryptor,
    required String path,
    required List<T> data,
  }) async {
    List<dynamic> feedback = [];
    for (var i in data) {
      var v = await deleteAt(
        api: api,
        builder: builder,
        encryptor: encryptor,
        path: path,
        data: i,
      );
      if (v != null) feedback.add(v);
    }
    return feedback;
  }
}
