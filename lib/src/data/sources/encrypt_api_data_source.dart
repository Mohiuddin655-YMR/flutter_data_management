part of 'sources.dart';

abstract class EncryptApiDataSourceImpl<T extends Entity>
    extends ApiDataSourceImpl<T> {
  final EncryptedApi encryptor;

  EncryptApiDataSourceImpl({
    required super.path,
    required this.encryptor,
  }) : super(api: encryptor);

  Future<Map<String, dynamic>> input(Map<String, dynamic>? data) async {
    return encryptor.input(data ?? {});
  }

  Future<Map<String, dynamic>> output(String data) async {
    return encryptor.output(data);
  }

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async {
    final response = Response<T>();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = await database.delete(url, data: value);
          final code = reference.statusCode;
          if (code == 200 || code == encryptor.status.deleted) {
            final result = reference.data;
            return response.modify(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            return response.modify(snapshot: reference, exception: error);
          }
        } else {
          const error = "Unacceptable request!";
          return response.modify(exception: error);
        }
      } else {
        const error = "Undefined request!";
        return response.modify(exception: error);
      }
    } catch (_) {
      return response.modify(exception: _.toString());
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
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          final reference = encryptor.type == ApiRequest.get
              ? await database.get(url, data: value)
              : await database.post(url, data: value);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == encryptor.status.ok) &&
              data is Map<String, dynamic>) {
            final result = build(data);
            return response.modify(data: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            return response.modify(snapshot: reference, exception: error);
          }
        } else {
          const error = "Unacceptable request.";
          return response.modify(exception: error);
        }
      } else {
        const error = "Undefined request.";
        return response.modify(exception: error);
      }
    } catch (_) {
      return response.modify(exception: _.toString());
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
  Future<Response<T>> gets<R>({
    bool isConnected = false,
    bool forUpdates = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async {
    final response = Response<T>();
    try {
      final value = await input(extra);
      if (value.isNotEmpty) {
        final url = currentSource(source);
        final reference = encryptor.type == ApiRequest.get
            ? await database.get(url, data: value)
            : await database.post(url, data: value);
        final code = reference.statusCode;
        if (code == 200 || code == encryptor.status.ok) {
          final data = await encryptor.output(reference.data);
          if (data is Map<String, dynamic> || data is List<dynamic>) {
            List<T> result = [];
            if (data is Map) {
              result = [build(data)];
            } else {
              result = data.map((item) {
                return build(item);
              }).toList();
            }
            return response.modify(result: result);
          } else {
            const error = "Data unmodified!";
            return response.modify(snapshot: data, exception: error);
          }
        } else {
          final error = "Unacceptable response [${reference.statusCode}]";
          return response.modify(exception: error);
        }
      } else {
        const error = "Unacceptable request!";
        return response.modify(exception: error);
      }
    } catch (_) {
      return response.modify(exception: _.toString());
    }
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    if (data.source.isNotEmpty) {
      final value = await input(data.source);
      if (value.isNotEmpty) {
        final url = data.id.isNotEmpty
            ? currentUrl(data.id, source)
            : currentSource(source);
        final reference = await database.post(url, data: value);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == encryptor.status.created) {
          final result = reference.data;
          return response.modify(result: result);
        } else {
          final error = "Data unmodified [${reference.statusCode}]";
          return response.modify(snapshot: reference, exception: error);
        }
      } else {
        const error = "Unacceptable request!";
        return response.modify(exception: error);
      }
    } else {
      const error = "Undefined data!";
      return response.modify(exception: error);
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) {
    return Future.error("Currently not initialized!");
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async* {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentUrl(id, source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = encryptor.type == ApiRequest.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == encryptor.status.ok) &&
                data is Map<String, dynamic>) {
              final result = build(data);
              controller.add(
                response.modify(data: result),
              );
            } else {
              final error = "Data unmodified [${reference.statusCode}]";
              controller.addError(
                response.modify(snapshot: reference, exception: error),
              );
            }
          });
        } else {
          const error = "Unacceptable request!";
          controller.addError(
            response.modify(exception: error),
          );
        }
      } else {
        const error = "Undefined request!";
        controller.addError(
          response.modify(exception: error),
        );
      }
    } catch (_) {
      controller.addError(_);
    }
    controller.stream;
  }

  @override
  Stream<Response<T>> lives<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
    Map<String, dynamic>? extra,
  }) async* {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = currentSource(source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = encryptor.type == ApiRequest.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == encryptor.status.ok) &&
                data is List<dynamic>) {
              List<T> result = data.map((item) {
                return build(item);
              }).toList();
              controller.add(
                response.modify(result: result),
              );
            } else {
              final error = "Data unmodified [${reference.statusCode}]";
              controller.addError(
                response.modify(snapshot: reference, exception: error),
              );
            }
          });
        } else {
          const error = "Unacceptable request!";
          controller.addError(
            response.modify(exception: error),
          );
        }
      } else {
        const error = "Undefined request!";
        controller.addError(
          response.modify(exception: error),
        );
      }
    } catch (_) {
      controller.addError(_);
    }

    controller.stream;
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      if (data.source.isNotEmpty) {
        final value = await input(data.source);
        if (value.isNotEmpty) {
          final url = currentUrl(data.id, source);
          final reference = await database.put(url, data: value);
          final code = reference.statusCode;
          if (code == 200 || code == encryptor.status.updated) {
            final result = reference.data;
            return response.modify(result: result);
          } else {
            final error = "Data unmodified [${reference.statusCode}]";
            return response.modify(snapshot: reference, exception: error);
          }
        } else {
          const error = "Unacceptable request!";
          return response.modify(exception: error);
        }
      } else {
        const error = "Undefined data!";
        return response.modify(exception: error);
      }
    } catch (_) {
      return response.modify(exception: _.toString());
    }
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
