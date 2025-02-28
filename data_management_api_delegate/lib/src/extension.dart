part of 'source.dart';

extension _ApiPathExtension on String {
  String child(
    String path, [
    bool ignoreId = false,
  ]) {
    if (ignoreId) {
      return this;
    } else {
      return "$this/$path";
    }
  }
}

extension _ApiExtension on dio.Dio {
  Future<bool> _add<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required T data,
  }) async {
    var isEncryptor = encryptor != null;
    var I = api._parent(endPoint).child(data.id, api.autoGenerateId);
    if (isEncryptor) {
      var raw = await encryptor.input(data.source);
      if (raw.isNotEmpty) {
        final result = await post(I, data: raw)
            .onError(ApiDataExtensionalException.future);
        final code = result.statusCode;
        if (code == api.status.created || code == api.status.ok) {
          return true;
        } else {
          throw const ApiDataExtensionalException("Data hasn't inserted!");
        }
      } else {
        throw const ApiDataExtensionalException("Encryption error!");
      }
    } else {
      final result = await post(I, data: data.source)
          .onError(ApiDataExtensionalException.future);
      final code = result.statusCode;
      if (code == api.status.created || code == api.status.ok) {
        return true;
      } else {
        throw const ApiDataExtensionalException("Data hasn't inserted!");
      }
    }
  }

  Future<bool> _adds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<T> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await _add(
        builder: builder,
        api: api,
        endPoint: endPoint,
        encryptor: encryptor,
        data: i,
      )) counter++;
    }
    return data.length == counter;
  }

  Future<bool> _deleteById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) {
    final I = api._parent(endPoint).child(id);
    return delete(I).then((value) {
      var code = value.statusCode;
      if (code == api.status.ok || code == api.status.deleted) {
        return true;
      } else {
        throw const ApiDataExtensionalException("Data hasn't deleted!");
      }
    }).onError(ApiDataExtensionalException.future);
  }

  Future<bool> _deleteByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) async {
    var counter = 0;
    for (var i in ids) {
      if (await _deleteById(
        builder: builder,
        api: api,
        endPoint: endPoint,
        encryptor: encryptor,
        id: i,
      )) counter++;
    }
    return ids.length == counter;
  }

  Future<DataGetsResponse<T, _AS>> _fetch<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api._parent(endPoint);
    final request = api.request.isGetRequest ? get(I) : post(I);
    List<T> result = [];
    List<_AS> snaps = [];
    return request.then((response) async {
      result.clear();
      snaps.clear();
      if (response.statusCode == api.status.ok) {
        if (response.data is List) {
          for (var i in response.data) {
            snaps.add(i);
            final data = i is Map<String, dynamic>
                ? i
                : i is String
                    ? jsonDecode(i)
                    : null;
            if (data is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(data) : data;
              result.add(builder(v));
            }
          }
        }
        return (result, snaps);
      } else {
        throw const ApiDataExtensionalException("Data hasn't found!");
      }
    });
  }

  Future<DataGetResponse<T, _AS>> _fetchById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api._parent(endPoint);
    final request = api.request.isGetRequest ? get(I) : post(I);
    return request.then((i) async {
      var data = i.data;
      if (i.statusCode == api.status.ok) {
        if (data is Map<String, dynamic>) {
          var v = isEncryptor ? await encryptor.output(data) : data;
          return (builder(v), i);
        }
      }
      return (null, i.data);
    }).onError(ApiDataExtensionalException.future);
  }

  Future<DataGetsResponse<T, _AS>> _fetchByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) async {
    List<T> result = [];
    List<_AS> snaps = [];
    for (String id in ids) {
      try {
        var value = await _fetchById(
          builder: builder,
          api: api,
          endPoint: endPoint,
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

  Stream<DataGetsResponse<T, _AS>> _listen<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
  }) {
    final controller = StreamController<DataGetsResponse<T, _AS>>();
    Timer.periodic(
      Duration(milliseconds: api.timer.streamReloadTime),
      (timer) {
        _fetch(
          builder: builder,
          api: api,
          endPoint: endPoint,
          encryptor: encryptor,
        ).then(controller.add).onError(ApiDataExtensionalException.future);
      },
    );
    return controller.stream;
  }

  Stream<DataGetResponse<T, _AS>> _listenById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required String id,
  }) {
    final controller = StreamController<DataGetResponse<T, _AS>>();
    Timer.periodic(
      Duration(milliseconds: api.timer.streamReloadTime),
      (timer) {
        _fetchById(
          builder: builder,
          api: api,
          endPoint: endPoint,
          encryptor: encryptor,
          id: id,
        ).then(controller.add).onError(ApiDataExtensionalException.future);
      },
    );
    return controller.stream;
  }

  Stream<DataGetsResponse<T, _AS>> _listenByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<String> ids,
  }) {
    final controller = StreamController<DataGetsResponse<T, _AS>>();
    Timer.periodic(
      Duration(milliseconds: api.timer.streamReloadTime),
      (timer) {
        _fetchByIds(
          builder: builder,
          api: api,
          endPoint: endPoint,
          encryptor: encryptor,
          ids: ids,
        ).then(controller.add).onError(ApiDataExtensionalException.future);
      },
    );
    return controller.stream;
  }

  Stream<DataGetsResponse<T, _AS>> _listenByQuery<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    final controller = StreamController<DataGetsResponse<T, _AS>>();
    Timer.periodic(
      Duration(milliseconds: api.timer.streamReloadTime),
      (timer) {
        _query(
          builder: builder,
          api: api,
          endPoint: endPoint,
          encryptor: encryptor,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        ).then(controller.add).onError(ApiDataExtensionalException.future);
      },
    );
    return controller.stream;
  }

  Future<DataGetsResponse<T, _AS>> _query<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) async {
    var isEncryptor = encryptor != null;
    final I = api._parent(endPoint);
    final query = _QHelper.query(
        queries: queries,
        sorts: sorts,
        options: options is ApiPagingOptions
            ? options
            : const ApiPagingOptions.empty());

    final request = query.request.isPostRequest
        ? post(I, queryParameters: query.queryParams, data: query.body)
        : get(I, queryParameters: query.queryParams, data: query.body);

    List<T> result = [];
    List<_AS> docs = [];

    return request.then((response) async {
      result.clear();
      docs.clear();
      if (response.statusCode == api.status.ok) {
        if (response.data is List) {
          for (var i in response.data) {
            docs.add(i);
            if (i != null && i is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(i) : i;
              result.add(builder(v));
            }
          }
        }
        return (result, docs);
      } else {
        throw const ApiDataExtensionalException("Data hasn't found!");
      }
    }).onError(ApiDataExtensionalException.future);
  }

  Future<DataGetsResponse<T, _AS>> _search<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required Checker checker,
  }) async {
    var isEncryptor = encryptor != null;
    final I = api._parent(endPoint);
    final query = _QHelper.search(this, checker);

    final request = api.request.isPostRequest
        ? post(I, queryParameters: query, data: query)
        : get(I, queryParameters: query, data: query);

    List<T> result = [];
    List<_AS> docs = [];

    return request.then((response) async {
      result.clear();
      docs.clear();
      if (response.statusCode == api.status.ok) {
        if (response.data is List) {
          for (var i in response.data) {
            docs.add(i);
            if (i != null && i is Map<String, dynamic>) {
              var v = isEncryptor ? await encryptor.output(i) : i;
              result.add(builder(v));
            }
          }
        }
        return (result, docs);
      } else {
        throw const ApiDataExtensionalException("Data hasn't found!");
      }
    }).onError(ApiDataExtensionalException.future);
  }

  Future<bool> _updateById<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required Map<String, dynamic> data,
  }) async {
    var isEncryptor = encryptor != null;
    var id = data.id;
    if (id != null && id.isNotEmpty) {
      var I = api._parent(endPoint).child(id);
      if (isEncryptor) {
        return _fetchById(
                builder: builder, api: api, endPoint: endPoint, id: id)
            .then((value) async {
          final x = value.$1?.primary ?? {};
          x.addAll(data);
          var v = await encryptor.input(x);
          if (v.isNotEmpty) {
            return put(I, data: v).then((value) {
              final code = value.statusCode;
              if (code == api.status.ok || code == api.status.updated) {
                return true;
              } else {
                throw const ApiDataExtensionalException("Data hasn't updated!");
              }
            }).onError(ApiDataExtensionalException.future);
          } else {
            throw const ApiDataExtensionalException("Encryption error!");
          }
        });
      } else {
        return put(I, data: data).then((value) {
          final code = value.statusCode;
          if (code == api.status.ok || code == api.status.updated) {
            return true;
          } else {
            throw const ApiDataExtensionalException("Data hasn't updated!");
          }
        }).onError(ApiDataExtensionalException.future);
      }
    } else {
      throw const ApiDataExtensionalException("Id isn't valid!");
    }
  }

  Future<bool> _updateByIds<T extends Entity>({
    required DataBuilder<T> builder,
    DataEncryptor? encryptor,
    required Api api,
    required String endPoint,
    required List<UpdatingInfo> data,
  }) async {
    var counter = 0;
    for (var i in data) {
      if (await _updateById(
        builder: builder,
        encryptor: encryptor,
        api: api,
        endPoint: endPoint,
        data: i.data.withId(i.id),
      )) counter++;
    }
    return data.length == counter;
  }
}
