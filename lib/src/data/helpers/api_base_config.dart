part of '../sources/api_data_source.dart';

class Api {
  final bool autoGenerateId;
  final String baseUrl;
  final ApiConfig config;
  final ApiStatus status;
  final ApiTimer timer;
  final ApiRequest request;

  const Api({
    this.autoGenerateId = true,
    required this.baseUrl,
    this.config = const ApiConfig(),
    this.status = const ApiStatus(),
    this.timer = const ApiTimer(),
    this.request = ApiRequest.get,
  });

  String _parent(String parent) => "$baseUrl/$parent";

  dio.BaseOptions get _options {
    return dio.BaseOptions(
      baseUrl: '',
      connectTimeout: config.connectTimeout,
      contentType: config.contentType,
      extra: config.extra,
      followRedirects: config.followRedirects,
      headers: config.headers,
      listFormat: config.listFormat?.format,
      maxRedirects: config.maxRedirects,
      method: config.method,
      persistentConnection: config.persistentConnection,
      preserveHeaderCase: config.preserveHeaderCase,
      queryParameters: config.queryParameters,
      receiveDataWhenStatusError: config.receiveDataWhenStatusError,
      receiveTimeout: config.receiveTimeout,
      requestEncoder: config.requestEncoder,
      responseDecoder: config.responseDecoder,
      responseType: config.responseType?.type,
      sendTimeout: config.sendTimeout,
      validateStatus: config.validateStatus,
    );
  }
}

class ApiTimer {
  final int reloadTime;
  final int streamReloadTime;

  const ApiTimer({
    this.reloadTime = 0,
    this.streamReloadTime = 300,
  });
}

class ApiStatus {
  final int ok;
  final int canceled;
  final int created;
  final int updated;
  final int deleted;
  final int notFound;

  const ApiStatus({
    this.ok = 200,
    this.created = 201,
    this.updated = 202,
    this.deleted = 203,
    this.canceled = 204,
    this.notFound = 404,
  });
}

enum ApiRequest {
  get,
  post;

  bool get isGetRequest => this == get;

  bool get isPostRequest => this == post;
}

class ApiConfig {
  final Duration? connectTimeout;
  final String? contentType;
  final Map<String, dynamic>? extra;
  final bool? followRedirects;
  final Map<String, dynamic>? headers;
  final ApiListFormat? listFormat;
  final int? maxRedirects;
  final String? method;
  final bool preserveHeaderCase;
  final bool? persistentConnection;
  final Map<String, dynamic>? queryParameters;
  final bool? receiveDataWhenStatusError;
  final Duration? receiveTimeout;
  final dio.RequestEncoder? requestEncoder;
  final dio.ResponseDecoder? responseDecoder;
  final ApiResponseType? responseType;
  final Duration? sendTimeout;
  final dio.ValidateStatus? validateStatus;

  const ApiConfig({
    this.connectTimeout,
    this.contentType,
    this.extra,
    this.followRedirects,
    this.headers,
    this.listFormat,
    this.maxRedirects,
    this.method,
    this.preserveHeaderCase = false,
    this.persistentConnection,
    this.queryParameters,
    this.receiveDataWhenStatusError,
    this.receiveTimeout,
    this.requestEncoder,
    this.responseDecoder,
    this.responseType = ApiResponseType.json,
    this.sendTimeout,
    this.validateStatus,
  });

  ApiConfig copy({
    String? method,
    Map<String, dynamic>? queryParameters,
    String? path,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, Object?>? extra,
    Map<String, Object?>? headers,
    bool? preserveHeaderCase,
    ApiResponseType? responseType,
    String? contentType,
    dio.ValidateStatus? validateStatus,
    bool? receiveDataWhenStatusError,
    bool? followRedirects,
    int? maxRedirects,
    bool? persistentConnection,
    dio.RequestEncoder? requestEncoder,
    dio.ResponseDecoder? responseDecoder,
    ApiListFormat? listFormat,
  }) {
    return ApiConfig(
      connectTimeout: connectTimeout ?? this.connectTimeout,
      contentType: contentType ?? this.contentType,
      extra: extra ?? this.extra,
      followRedirects: followRedirects ?? this.followRedirects,
      headers: headers ?? this.headers,
      listFormat: listFormat ?? this.listFormat,
      maxRedirects: maxRedirects ?? this.maxRedirects,
      method: method ?? this.method,
      persistentConnection: persistentConnection ?? this.persistentConnection,
      preserveHeaderCase: preserveHeaderCase ?? this.preserveHeaderCase,
      queryParameters: queryParameters ?? this.queryParameters,
      receiveDataWhenStatusError:
          receiveDataWhenStatusError ?? this.receiveDataWhenStatusError,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      requestEncoder: requestEncoder ?? requestEncoder,
      responseDecoder: responseDecoder ?? this.responseDecoder,
      responseType: responseType ?? this.responseType,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      validateStatus: validateStatus ?? this.validateStatus,
    );
  }
}

enum ApiResponseType {
  json,
  stream,
  plain,
  bytes;

  dio.ResponseType get type {
    switch (this) {
      case json:
        return dio.ResponseType.json;
      case stream:
        return dio.ResponseType.stream;
      case plain:
        return dio.ResponseType.plain;
      case bytes:
        return dio.ResponseType.bytes;
      default:
        return dio.ResponseType.json;
    }
  }
}

enum ApiListFormat {
  csv,
  ssv,
  tsv,
  pipes,
  multi,
  multiCompatible;

  dio.ListFormat get format {
    switch (this) {
      case csv:
        return dio.ListFormat.csv;
      case ssv:
        return dio.ListFormat.ssv;
      case tsv:
        return dio.ListFormat.tsv;
      case pipes:
        return dio.ListFormat.pipes;
      case multi:
        return dio.ListFormat.multi;
      case multiCompatible:
        return dio.ListFormat.multiCompatible;
      default:
        return dio.ListFormat.multiCompatible;
    }
  }
}

class ApiOptions extends dio.Options {
  ApiOptions({
    super.method,
    super.sendTimeout,
    super.receiveTimeout,
    super.extra,
    super.headers,
    super.preserveHeaderCase,
    super.responseType,
    super.contentType,
    super.validateStatus,
    super.receiveDataWhenStatusError,
    super.followRedirects,
    super.maxRedirects,
    super.persistentConnection,
    super.requestEncoder,
    super.responseDecoder,
    super.listFormat,
  });

  @override
  ApiOptions copyWith({
    String? method,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    Map<String, Object?>? extra,
    Map<String, Object?>? headers,
    bool? preserveHeaderCase,
    dio.ResponseType? responseType,
    String? contentType,
    dio.ValidateStatus? validateStatus,
    bool? receiveDataWhenStatusError,
    bool? followRedirects,
    int? maxRedirects,
    bool? persistentConnection,
    dio.RequestEncoder? requestEncoder,
    dio.ResponseDecoder? responseDecoder,
    dio.ListFormat? listFormat,
  }) {
    final o = super.copyWith(
      method: method,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      extra: extra,
      headers: headers,
      preserveHeaderCase: preserveHeaderCase,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      persistentConnection: persistentConnection,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      listFormat: listFormat,
    );
    return ApiOptions(
      method: o.method,
      sendTimeout: o.sendTimeout,
      receiveTimeout: o.receiveTimeout,
      extra: o.extra,
      headers: o.headers,
      preserveHeaderCase: o.preserveHeaderCase,
      responseType: o.responseType,
      contentType: o.contentType,
      validateStatus: o.validateStatus,
      receiveDataWhenStatusError: o.receiveDataWhenStatusError,
      followRedirects: o.followRedirects,
      maxRedirects: o.maxRedirects,
      persistentConnection: o.persistentConnection,
      requestEncoder: o.requestEncoder,
      responseDecoder: o.responseDecoder,
      listFormat: o.listFormat,
    );
  }
}
