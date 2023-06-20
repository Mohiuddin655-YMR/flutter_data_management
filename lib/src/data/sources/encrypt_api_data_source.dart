part of 'sources.dart';

abstract class EncryptApiDataSourceImpl<T extends Entity>
    extends ApiDataSourceImpl<T> {
  final EncryptedApi encryptedApi;

  EncryptApiDataSourceImpl({
    required super.path,
    required this.encryptedApi,
  }) : super(api: encryptedApi);

  Future<Map<String, dynamic>> input(Map<String, dynamic>? data) async {
    return encryptedApi.input(data ?? {});
  }

  Future<Map<String, dynamic>> output(String data) async {
    return encryptedApi.output(data);
  }

  Future<(bool, T?, String? message, Status status)> isExisted<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) async {
    if (id.isValid) {
      var data = await input(id.toMappableId);
      if (data.isValid) {
        try {
          final I = _source(id, source);
          final result = encryptedApi.type.isPost
              ? await database.post(I, data: data)
              : await database.get(I, data: data);
          final value = result.data;
          final code = result.statusCode;
          if ((code == 200 || code == api.status.ok) && value is Map) {
            return (true, build(value), "Currently existed", Status.ok);
          } else {
            return (false, null, "Data not existed!", Status.notFound);
          }
        } on dio.DioException catch (_) {
          var code = _.response?.statusCode.use;
          if (code == 404 || code == api.status.notFound) {
            return (false, null, "Data not existed!", Status.notFound);
          }
          return (false, null, _.message, Status.notFound);
        }
      } else {
        return (false, null, "Encryption failed!", Status.invalid);
      }
    } else {
      return (false, null, "Id isn't valid!", Status.invalidId);
    }
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        var finder = await isExisted(id, source: source);
        return response.withAvailable(
          !finder.$1,
          data: finder.$2,
          message: finder.$3,
        );
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.id.isValid && data.source.isValid) {
        final encryptor = await input(data.source);
        if (encryptor.isValid) {
          final finder = await isExisted(data.id, source: source);
          final I = _source(data.id, source, api.autoGenerateId);
          if (!finder.$1) {
            try {
              final result = encryptedApi.type.isGet
                  ? await database.get(I, data: encryptor)
                  : await database.post(I, data: encryptor);
              final feedback = result.data;
              final code = result.statusCode;
              if (code == 200 || code == 201 || code == api.status.created) {
                if (feedback is Map) {
                  return response.withData(build(feedback));
                } else if (feedback is List) {
                  return response.withResult(
                    feedback.map((e) => build(e)).toList(),
                  );
                } else {
                  return response.withFeedback(feedback, status: Status.ok);
                }
              } else {
                return response.withStatus(Status.error);
              }
            } on dio.DioException catch (_) {
              return response.withException(_.message, status: Status.failure);
            }
          } else {
            return response.withIgnore(finder.$2, status: Status.alreadyFound);
          }
        } else {
          return response.withStatus(Status.invalid);
        }
      } else {
        return response.withStatus(Status.invalid);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (data.isValid) {
        for (var i in data) {
          var result = await insert(i, isConnected: true, source: source);
          if (result.ignores.isValid) response.withIgnore(result.ignores[0]);
        }
        return response.withResult(data);
      } else {
        return response.withException(Status.invalid);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid && data.isValid) {
        final encryptor = await input(data.attach(id.toMappableId));
        if (encryptor.isValid) {
          final finder = await isExisted(id, source: source);
          final I = _source(id, source);
          if (finder.$1) {
            try {
              final result = await database.put(I, data: encryptor);
              final feedback = result.data;
              final code = result.statusCode;
              if (code == 200 || code == 201 || code == api.status.updated) {
                return response.withBackup(
                  finder.$2,
                  feedback: feedback,
                  status: Status.ok,
                );
              } else {
                return response.withStatus(Status.error);
              }
            } on dio.DioException catch (_) {
              return response.withException(_.message, status: Status.failure);
            }
          } else {
            return response.withIgnore(finder.$2, status: Status.notFound);
          }
        } else {
          return response.withStatus(Status.invalid);
        }
      } else {
        return response.withStatus(Status.invalid);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        var encryptor = await input(extra.attach(id.toMappableId));
        if (encryptor.isValid) {
          final finder = await isExisted(id, source: source);
          final I = _source(id, source);
          if (finder.$1) {
            try {
              final result = await database.delete(I, data: encryptor);
              final feedback = result.data;
              final code = result.statusCode;
              if (code == 200 || code == 201 || code == api.status.deleted) {
                return response.withBackup(
                  finder.$2,
                  feedback: feedback,
                  status: Status.ok,
                );
              } else {
                return response.withStatus(Status.error);
              }
            } on dio.DioException catch (_) {
              return response.withException(_.message, status: Status.failure);
            }
          } else {
            return response.withIgnore(finder.$2, status: Status.notFound);
          }
        } else {
          return response.withStatus(Status.invalid);
        }
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      var I = await gets(isConnected: true, source: source);
      if (I.isSuccessful && I.result.isValid) {
        for (var i in I.result) {
          await delete(i.id, source: source, isConnected: true);
        }
        return response.withBackups(I.result, status: Status.ok);
      } else {
        return response.withStatus(Status.notFound);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        final encryptor = await input(extra.attach(id.toMappableId));
        if (encryptor.isValid) {
          try {
            final I = _source(id, source);
            final result = encryptedApi.type.isPost
                ? await database.post(I, data: encryptor)
                : await database.get(I, data: encryptor);
            if (result.statusCode == api.status.ok) {
              final value = await encryptedApi.output(result.data);
              if (value is Map<String, dynamic>) {
                return response.withData(build(value));
              } else {
                return response.withSnapshot(value, status: Status.unmodified);
              }
            } else {
              return response.withStatus(Status.notFound);
            }
          } on dio.DioException catch (_) {
            var code = _.response?.statusCode.use;
            if (code == api.status.notFound) {
              return response.withStatus(Status.notFound);
            }
            return response.withException(_, status: Status.failure);
          }
        } else {
          return response.withStatus(Status.invalid);
        }
      } else {
        return response.withStatus(Status.invalidId);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async {
    final response = Response<T>();
    if (isConnected) {
      try {
        final I = currentSource(source);
        final encryptor = extra.isValid ? await input(extra): null;
        final result = encryptedApi.type.isPost
            ? await database.post(I, data: encryptor)
            : await database.get(I, data: encryptor);
        if (result.statusCode == api.status.ok) {
          final value = await encryptedApi.output(result.data);
          if (value is List<dynamic>) {
            return response.withResult(
              value.map((_) => build(_)).toList(),
            );
          } else {
            return response.withSnapshot(value, status: Status.unmodified);
          }
        } else {
          return response.withStatus(Status.notFound);
        }
      } on dio.DioException catch (_) {
        var code = _.response?.statusCode.use;
        if (code == 404 || code == api.status.notFound) {
          return response.withStatus(Status.notFound);
        }
        return response.withException(_, status: Status.failure);
      }
    } else {
      return response.withStatus(Status.networkError);
    }
  }

  @override
  Future<Response<T>> getUpdates<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) {
    return gets(
      isConnected: isConnected,
      forUpdates: true,
      extra: extra,
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      if (id.isValid) {
        Timer.periodic(const Duration(milliseconds: 300), (timer) async {
          controller.add(response.from(await get(
            id,
            source: source,
            isConnected: true,
            extra: extra,
          )));
        });
      } else {
        controller.add(response.withStatus(Status.invalidId));
      }
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    if (isConnected) {
      Timer.periodic(const Duration(milliseconds: 300), (timer) async {
        controller.add(response.from(await gets(
          source: source,
          extra: extra,
          isConnected: true,
        )));
      });
    } else {
      controller.add(response.withStatus(Status.networkError));
    }
    return controller.stream;
  }
}

class EncryptedApi extends Api {
  final String key;
  final String iv;
  final String passcode;
  final ApiRequest type;
  final Map<String, dynamic> Function(
    String request,
    String passcode,
  ) request;
  final dynamic Function(Map<String, dynamic> data) response;

  const EncryptedApi({
    required super.api,
    required this.key,
    required this.iv,
    required this.passcode,
    required this.request,
    required this.response,
    this.type = ApiRequest.post,
    super.status = const ApiStatus(),
  });

  crypto.Key get _key => crypto.Key.fromUtf8(key);

  crypto.IV get _iv => crypto.IV.fromUtf8(iv);

  crypto.Encrypter get _en {
    return crypto.Encrypter(
      crypto.AES(_key, mode: crypto.AESMode.cbc),
    );
  }

  Future<Map<String, dynamic>> input(dynamic data) => compute(_encoder, data);

  dynamic output(dynamic data) => compute(_decoder, data);

  Future<Map<String, dynamic>> _encoder(dynamic data) async {
    final encrypted = _en.encrypt(jsonEncode(data), iv: _iv);
    return request.call(encrypted.base64, passcode);
  }

  Future<Map<String, dynamic>> _decoder(dynamic source) async {
    final value = await response.call(source);
    final encrypted = crypto.Encrypted.fromBase64(value);
    final data = _en.decrypt(encrypted, iv: _iv);
    return jsonDecode(data);
  }
}

extension _StringExtension on String {
  Map<String, dynamic> get toMappableId => {EntityKeys.id: this};
}
