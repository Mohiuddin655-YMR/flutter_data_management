part of '../../sources/api_data_source.dart';

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
