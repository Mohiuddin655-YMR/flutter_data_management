part of 'entities.dart';

class Entity {
  String? _id;
  int? _timeMills;

  String get id => _id ?? key;

  int get timeMills => _timeMills ?? ms;

  set id(String value) => _id = value;

  set timeMills(int value) => _timeMills = value;

  Entity({
    String? id,
    int? timeMills,
  })  : _id = id,
        _timeMills = timeMills;

  factory Entity.from(dynamic source) {
    return Entity(
      id: Entity.value(EntityKeys.id, source),
      timeMills: Entity.value(EntityKeys.timeMills, source),
    );
  }

  Map<String, dynamic> get source {
    return {
      EntityKeys.id: id,
      EntityKeys.timeMills: timeMills,
    };
  }

  static String get key => ms.toString();

  static int get ms => DateTime.now().millisecondsSinceEpoch;

  static dynamic _v(String key, dynamic source) {
    if (source is Map<String, dynamic>) {
      return source[key];
    } else if (source is DocumentSnapshot) {
      return source.get(key);
    } else if (source is DataSnapshot) {
      return source.child(key);
    } else {
      return null;
    }
  }

  static T? value<T>(String key, dynamic source) {
    final data = _v(key, source);
    if (data is T) {
      return data;
    } else {
      return null;
    }
  }

  static List<T>? values<T>(String key, dynamic source) {
    final data = _v(key, source);
    if (data is List) {
      final list = <T>[];
      for (var item in data) {
        if (item is T) {
          list.add(item);
        }
      }
      return list;
    } else {
      return null;
    }
  }

  static T? type<T>(
    String key,
    dynamic source,
    T Function(dynamic value) builder,
  ) {
    final data = _v(key, source);
    if (data is String) {
      return builder.call(data);
    } else {
      return null;
    }
  }

  static T? object<T>(
    String key,
    dynamic source,
    T Function(dynamic value) builder,
  ) {
    final data = _v(key, source);
    if (data is Map) {
      return builder.call(data);
    } else {
      return null;
    }
  }

  static List<T>? objects<T>(
    String key,
    dynamic source,
    T Function(dynamic value) builder,
  ) {
    final data = _v(key, source);
    if (data is List<Map<String, dynamic>>) {
      return data.map((e) => builder.call(e)).toList();
    } else {
      return null;
    }
  }

  String get time {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMills);
    return DateFormat("hh:mm a").format(date);
  }

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMills);
    return DateFormat("MMM dd, yyyy").format(date);
  }

  @override
  String toString() => source.toString();
}

class EntityKeys {
  const EntityKeys._();

  static const String id = "id";
  static const String timeMills = "time_mills";
}

extension EntityBoolHelper on bool? {
  bool get isValid => this != null;

  bool get isNotValid => !isValid;

  bool get use => this ?? false;
}

extension EntityObjectHelper on Object? {
  bool get isValid => this != null;

  bool get isNotValid => !isValid;

  bool equals(dynamic compareValue) {
    return this == compareValue;
  }
}

extension EntityIntHelper on int? {
  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  int get use => this ?? 0;
}

extension EntityDoubleHelper on double? {
  bool get isValid => use > 0;

  bool get isNotValid => !isValid;

  double get use => this ?? 0;
}

extension EntityStringHelper on String? {
  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  String get use => this ?? "";
}

extension EntityListHelper<E> on List<E>? {
  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  List<E> get use => this ?? [];

  E? get at => isValid ? use[0] : null;

  E? get end => isValid ? use.last : null;
}

extension EntityMapHelper on Map<String, dynamic>? {
  bool get isValid => use.isNotEmpty;

  bool get isNotValid => !isValid;

  Map<String, dynamic> get use => this ?? {};

  Map<String, dynamic> attach(Map<String, dynamic> current) {
    final data = use;
    data.addAll(current);
    return data;
  }
}

class PathFinder {
  static const String _pathRegs = r"^[a-zA-Z_]\w*(/[a-zA-Z_]\w*)*$";

  static List<String> segments(String path) {
    return RegExp(_pathRegs).hasMatch(path) ? path.split("/") : [];
  }

  static PathInfo info(String path) {
    final isValid = path.isNotEmpty && RegExp(_pathRegs).hasMatch(path);
    if (isValid) {
      var segments = path.split("/");
      int length = segments.length;
      String end = length.isOdd ? segments.last : "";
      List<String> x = [];
      List<String> y = [];
      List.generate(length.isOdd ? length - 1 : length, (i) {
        i.isEven ? x.add(segments[i]) : y.add(segments[i]);
      });
      return PathInfo(
        ending: end,
        pairs: List.generate(x.length, (index) {
          return PathTween(x[index], y[index]);
        }),
      );
    }
    return PathInfo(invalid: true);
  }
}

class PathInfo {
  final bool invalid;
  final String ending;
  final List<PathTween> pairs;

  PathInfo({
    this.invalid = false,
    this.ending = "",
    this.pairs = const [],
  });

  @override
  String toString() {
    return "Invalid: $invalid, Ending: $ending, Pairs: $pairs";
  }
}

class PathTween {
  final String x1;
  final String x2;

  PathTween(this.x1, this.x2);

  @override
  String toString() {
    return "Pair($x1 : $x2)";
  }
}
