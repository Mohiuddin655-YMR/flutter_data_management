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
  Future<Response<T>> isAvailable<R>(
    String id, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    return response.withException(
      "Currently not initialized!",
      status: Status.undefined,
    );
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
            ? _source(data.id, source)
            : currentSource(source);
        final reference = await database.post(url, data: value);
        final code = reference.statusCode;
        if (code == 200 || code == 201 || code == encryptor.status.created) {
          return response.withFeedback(reference.data);
        } else {
          return response.modify(
            snapshot: reference,
            exception: "Data unmodified [${reference.statusCode}]",
            status: Status.unmodified,
          );
        }
      } else {
        return response.withException(
          "Unacceptable request!",
          status: Status.invalid,
        );
      }
    } else {
      return response.withException(
        "Undefined data!",
        status: Status.unmodified,
      );
    }
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    return response.withException(
      "Currently not initialized!",
      status: Status.undefined,
    );
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    try {
      if (id.isValid && data.isValid) {
        final value = await input(data);
        if (value.isNotEmpty) {
          final url = _source(id, source);
          final reference = await database.put(url, data: value);
          final code = reference.statusCode;
          if (code == 200 || code == encryptor.status.updated) {
            return response.withFeedback(reference.data);
          } else {
            return response.modify(
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: Status.unmodified,
            );
          }
        } else {
          return response.withException(
            "Unacceptable request!",
            status: Status.invalid,
          );
        }
      } else {
        return response.withException(
          "Undefined data!",
          status: Status.undefined,
        );
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
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
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = _source(id, source);
          final reference = await database.delete(url, data: value);
          final code = reference.statusCode;
          if (code == 200 || code == encryptor.status.deleted) {
            return response.withFeedback(reference.data);
          } else {
            return response.modify(
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: Status.unmodified,
            );
          }
        } else {
          return response.withException(
            "Unacceptable request!",
            status: Status.invalid,
          );
        }
      } else {
        return response.withException(
          "Undefined request!",
          status: Status.error,
        );
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
    }
  }

  @override
  Future<Response<T>> clear<R>({
    bool isConnected = false,
    OnDataSourceBuilder<R>? source,
  }) async {
    final response = Response<T>();
    return response.withException(
      "Currently not initialized!",
      status: Status.undefined,
    );
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
          final url = _source(id, source);
          final reference = encryptor.type == ApiRequest.get
              ? await database.get(url, data: value)
              : await database.post(url, data: value);
          final data = reference.data;
          final code = reference.statusCode;
          if ((code == 200 || code == encryptor.status.ok) &&
              data is Map<String, dynamic>) {
            return response.withData(build(data));
          } else {
            return response.modify(
              snapshot: reference,
              exception: "Data unmodified [${reference.statusCode}]",
              status: Status.unmodified,
            );
          }
        } else {
          return response.withException(
            "Unacceptable request.",
            status: Status.invalid,
          );
        }
      } else {
        return response.withException(
          "Undefined request.",
          status: Status.undefined,
        );
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
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
            return response.withResult(result);
          } else {
            return response.modify(
              snapshot: data,
              exception: "Data unmodified!",
              status: Status.unmodified,
            );
          }
        } else {
          return response.withException(
            "Unacceptable response [${reference.statusCode}]",
            status: Status.invalid,
          );
        }
      } else {
        return response.withException(
          "Unacceptable request!",
          status: Status.invalid,
        );
      }
    } catch (_) {
      return response.withException(_, status: Status.failure);
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
  }) async* {
    final controller = StreamController<Response<T>>();
    final response = Response<T>();
    try {
      if (id.isNotEmpty && extra != null && extra.isNotEmpty) {
        final value = await input(extra);
        if (value.isNotEmpty) {
          final url = _source(id, source);
          Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
            final reference = encryptor.type == ApiRequest.get
                ? await database.get(url, data: value)
                : await database.post(url, data: value);
            final data = reference.data;
            final code = reference.statusCode;
            if ((code == 200 || code == encryptor.status.ok) &&
                data is Map<String, dynamic>) {
              controller.add(
                response.withData(build(data)),
              );
            } else {
              controller.add(
                response.modify(
                  data: null,
                  snapshot: reference,
                  exception: "Data unmodified [${reference.statusCode}]",
                  status: Status.unmodified,
                ),
              );
            }
          });
        } else {
          controller.add(
            response.withException(
              "Unacceptable request!",
              status: Status.invalid,
            ),
          );
        }
      } else {
        controller.add(
          response.withException(
            "Undefined request!",
            status: Status.undefined,
          ),
        );
      }
    } catch (_) {
      controller.add(response.withException(_, status: Status.failure));
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
                response.withResult(result),
              );
            } else {
              controller.add(
                response.modify(
                  result: [],
                  exception: "Unacceptable request!",
                  status: Status.invalid,
                ),
              );
            }
          });
        } else {
          controller.add(
            response.withException(
              "Unacceptable request!",
              status: Status.invalid,
            ),
          );
        }
      } else {
        controller.add(
          response.withException(
            "Undefined request!",
            status: Status.undefined,
          ),
        );
      }
    } catch (_) {
      controller.add(response.withException(_, status: Status.failure));
    }

    controller.stream;
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
