part of 'core.dart';

class Data<Key extends EntityKey> extends Entity<Key> {
  Data({
    super.id,
    super.timeMills,
  });

  factory Data.from(dynamic source) {
    return Data(
      id: Entity.autoId(source),
      timeMills: Entity.autoTimeMills(source),
    );
  }

  static String get generateID => Entity.generateID;

  static int get generateTimeMills => Entity.generateTimeMills;

  static String? autoId(dynamic source) => Entity.autoId(source);

  static int? autoTimeMills(dynamic source) => Entity.autoTimeMills(source);

  static T? value<T>(String key, dynamic source) => Entity.value(key, source);

  static List<T>? values<T>(String key, dynamic source) =>
      Entity.values(key, source);

  static T? type<T>(String key, dynamic source, EntityBuilder<T> builder) =>
      Entity.type(key, source, builder);

  static T? object<T>(String key, dynamic source, EntityBuilder<T> builder) =>
      Entity.object(key, source, builder);

  static List<T>? objects<T>(
          String key, dynamic source, EntityBuilder<T> builder) =>
      Entity.objects(key, source, builder);
}

extension DataMapHelper on Map<String, dynamic>? {
  Map<String, dynamic> generate(Map<String, dynamic> current) {
    final data = use;
    data.addAll(current);
    return data;
  }
}
