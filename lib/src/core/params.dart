part of 'configs.dart';

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

extension FieldParamsHelper on FieldParams? {
  String generate(String root) {
    final params = this;
    if (params is Params) {
      return FieldReplacer.replace(root, params.values);
    } else if (params is IterableParams) {
      return FieldReplacer.replaceByIterable(root, params.values);
    } else {
      return root;
    }
  }
}
