part of 'entities.dart';

class Follow {
  final bool active;
  final int timeMills;
  final String currentId;
  final String noneId;

  const Follow({
    this.active = true,
    required this.timeMills,
    required this.currentId,
    required this.noneId,
  });

  factory Follow.from(Map<String, dynamic> map) {
    final active = map["active"];
    final ms = map["time_mills"];
    final ci = map["current_id"];
    final ni = map["none_id"];
    return Follow(
      active: active,
      timeMills: ms,
      currentId: ci,
      noneId: ni,
    );
  }

  Map<String, dynamic> get map => {
        "active": active,
        "time_mills": timeMills,
        "current_id": currentId,
        "none_id": noneId,
      };

  Follow modify({
    bool? active,
    int? timeMills,
    String? currentId,
    String? noneId,
  }) {
    return Follow(
      active: active ?? this.active,
      timeMills: timeMills ?? this.timeMills,
      currentId: currentId ?? this.currentId,
      noneId: noneId ?? this.noneId,
    );
  }
}
