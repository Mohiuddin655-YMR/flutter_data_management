import '../../core.dart';

class PagingOptions {
  final bool fetchFromLast;
  final int? fetchingSize;
  final int? initialFetchingSize;

  const PagingOptions({
    int? initialFetchSize,
    this.fetchFromLast = false,
    this.fetchingSize,
  }) : initialFetchingSize = initialFetchSize ?? fetchingSize;
}

class PagingOptionsImpl extends PagingOptions {
  const PagingOptionsImpl();
}

/// You can use like
/// * [ApiSorting]
/// * [FirestoreSorting]
/// * [LocalstoreSorting]
/// * [RealtimeSorting]
abstract class Sorting {
  final String field;

  const Sorting(this.field);
}

/// You can use like
/// * [ApiQuery]
/// * [FirestoreQuery]
/// * [LocalstoreQuery]
/// * [RealtimeQuery]
abstract class Query {
  final Object? field;

  const Query([this.field]);
}

/// You can use like
/// * [ApiSelection]
/// * [FirestoreSelection]
/// * [LocalstoreSelection]
/// * [RealtimeSelection]
abstract class Selection {
  final Object? value;

  const Selection(this.value);
}

/// You can use like
/// * [Params]
/// * [IterableParams]
abstract class FieldParams {
  const FieldParams();
}

/// Replaces placeholders in the given [path] using the provided [params] map.
///
/// Example:
/// ```dart
/// FieldParams params = Params({'param1': 'value1', 'param2': 'value2'});     // Params: param1 = value1, param2 = value2
/// String root = "/path/{param1}/endpoint/{param2}";                          // Input : /path/{param1}/endpoint/{param2}
/// String path = params.generate(root);                                       // Output: /path/value1/endpoint/value2
/// ```
class Params extends FieldParams {
  final Map<String, String> values;

  const Params(this.values);
}

/// Replaces placeholders in the given [path] using values from the [params] iterable.
///
/// Example:
/// ```dart
/// FieldParams params = IterableParams(['value1', 'value2']);     // Params: param1 = value1, param2 = value2
/// String root = "/path/{param1}/endpoint/{param2}";              // Input : /path/{param1}/endpoint/{param2}
/// String path = params.generate(root);                           // Output: /path/value1/endpoint/value2
/// ```
class IterableParams extends FieldParams {
  final List<String> values;

  const IterableParams(this.values);
}
