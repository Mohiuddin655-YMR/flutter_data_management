part of 'configs.dart';

/// Utility class for replacing placeholders in a path with provided values.
class FieldReplacer {
  const FieldReplacer._();

  /// Replaces placeholders in the given [path] using the provided [params] map.
  ///
  /// Example:
  /// ```dart
  /// Map<String, String> params = {'param1': 'value1', 'param2': 'value2'};
  /// String result = PathReplacer.replace('/path/{param1}/endpoint/{param2}', params);
  /// // Result: '/path/value1/endpoint/value2'
  /// ```
  static String replace(String path, Map<String, String> params) {
    return path.replaceAllMapped(RegExp(r'{(\w+)}'), (match) {
      String key = match.group(1)!;
      return params.containsKey(key) ? params[key]! : match.group(0)!;
    });
  }

  /// Replaces placeholders in the given [path] using values from the [params] iterable.
  ///
  /// Example:
  /// ```dart
  /// Iterable<String> params = ['value1', 'value2'];
  /// String result = PathReplacer.replaceByIterable('/path/{param1}/endpoint/{param2}', params);
  /// // Result: '/path/value1/endpoint/value2'
  /// ```
  static String replaceByIterable(String path, Iterable<String> params) {
    int i = 0;
    return path.replaceAllMapped(RegExp(r'{(\w+)}'), (match) {
      return i < params.length ? params.elementAt(i++) : match.group(0)!;
    });
  }
}
