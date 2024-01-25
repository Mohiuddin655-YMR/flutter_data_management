import 'package:flutter_andomie/core.dart';

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
