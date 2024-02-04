part of '../sources/api_data_source.dart';

class ApiPagingOptions extends PagingOptions {
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

class ApiQuery extends Query {
  const ApiQuery();
}

class ApiSorting extends Sorting {
  const ApiSorting() : super("");
}

class _QHelper {
  const _QHelper._();

  static ApiPagingOptions query({
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    ApiPagingOptions options = const ApiPagingOptions.empty(),
  }) {
    return options;
  }
}
