part of 'source.dart';

class ApiPagingOptions extends DataPagingOptions {
  final Object? body;
  final Map<String, dynamic>? queryParams;
  final ApiRequest request;

  const ApiPagingOptions({
    this.body,
    this.queryParams,
    this.request = ApiRequest.get,
  });

  const ApiPagingOptions.empty() : this();
}

class _QHelper {
  const _QHelper._();

  static Map<String, dynamic> search<T extends Object?>(
    dio.Dio ref,
    Checker checker,
  ) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;

    if (value is String) {
      if (type.isContains) {
        return {
          field: {
            "start_at": value,
            "end_at": "$value\uf8ff",
          }
        };
      } else {
        return {
          field: {
            "is_equal_to": value,
          }
        };
      }
    } else {
      return {};
    }
  }

  static ApiPagingOptions query({
    List<DataQuery> queries = const [],
    List<DataSorting> sorts = const [],
    ApiPagingOptions options = const ApiPagingOptions.empty(),
  }) {
    return options;
  }
}
