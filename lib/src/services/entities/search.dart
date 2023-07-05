part of 'entities.dart';

class Search {
  final String key;
  final String type;
  final dynamic result;

  const Search({
    required this.key,
    required this.type,
    required this.result,
  });

  factory Search.from(Map<String, dynamic> map) {
    final key = map["key"];
    final type = map["type"];
    final result = map["result"];
    return Search(
      key: key,
      type: type,
      result: result,
    );
  }

  Map<String, dynamic> get map => {
        "key": key,
        "type": type,
        "result": result,
      };

  Search modify({
    String? key,
    String? type,
    dynamic result,
  }) {
    return Search(
      key: key ?? this.key,
      type: type ?? this.type,
      result: result ?? this.result,
    );
  }
}
