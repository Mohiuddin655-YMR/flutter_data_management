part of 'core.dart';

class Data<Key extends EntityKey> extends Entity<Key> {
  Data({
    super.id = "",
    super.timeMills = 0,
  });

  static String get generateID => Entity.generateID;

  static int get generateTimeMills => Entity.generateTimeMills;

  static String? autoId(dynamic source) => Entity.autoId(source);

  static int? autoTimeMills(dynamic source) => Entity.autoTimeMills(source);

  static T? value<T>(String key, dynamic source) => Entity.value(key, source);

  static List<T>? values<T>(String key, dynamic source) {
    return Entity.values(key, source);
  }

  static T? type<T>(String key, dynamic source, EntityBuilder<T> builder) {
    return Entity.type(key, source, builder);
  }

  static T? object<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    return Entity.object(key, source, builder);
  }

  static List<T>? objects<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    return Entity.objects(key, source, builder);
  }

  factory Data.from(dynamic source) {
    return Data(
      id: Entity.autoId(source),
      timeMills: Entity.autoTimeMills(source),
    );
  }

  @override
  Map<String, dynamic> get source {
    if (id.isNotEmpty || timeMills > 0) {
      return super.source;
    } else {
      return {};
    }
  }
}

extension DataHelper on Object? {
  bool get isEntity => this is Map<String, dynamic>;

  String? get entityId => isEntity ? Data.autoId(this) : null;

  int? get entityTimeMills => isEntity ? Data.autoTimeMills(this) : null;

  String get generateID => Data.generateID;

  int get generateTimeMills => Data.generateTimeMills;

  T? entityObject<T>(String key, EntityBuilder<T> builder) {
    return isEntity ? Data.object(key, this, builder) : null;
  }

  List<T>? entityObjects<T>(String key, EntityBuilder<T> builder) {
    return isEntity ? Data.objects(key, this, builder) : null;
  }

  T? entityType<T>(String key, EntityBuilder<T> builder) {
    return isEntity ? Data.type(key, this, builder) : null;
  }

  T? entityValue<T>(String key) {
    return isEntity ? Data.value(key, this) : null;
  }

  List<T>? entityValues<T>(String key) {
    return isEntity ? Data.values(key, this) : null;
  }
}

extension DataMapHelper on Map<String, dynamic>? {
  Map<String, dynamic> attach(Map<String, dynamic> current) {
    final data = use;
    data.addAll(current);
    return data;
  }

  Map<String, dynamic> adjust(Map<String, dynamic> current) => attach(current);
}
