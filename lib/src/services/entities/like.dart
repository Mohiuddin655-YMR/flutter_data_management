part of 'entities.dart';

class Like extends Entity {
  final String uid;
  final String documentId;

  Like({
    required super.timeMills,
    required this.uid,
    required this.documentId,
  });

  factory Like.from(Map<String, dynamic> map) {
    final timeMills = map["time_mills"];
    final uid = map["user_id"];
    final documentId = map["document_id"];
    return Like(
      timeMills: timeMills,
      uid: uid,
      documentId: documentId,
    );
  }

  Map<String, dynamic> get map => {
        "time_mills": timeMills,
        "user_id": uid,
        "document_id": documentId,
      };

  Like modify({
    int? timeMills,
    String? uid,
    String? documentId,
  }) {
    return Like(
      timeMills: timeMills ?? this.timeMills,
      uid: uid ?? this.uid,
      documentId: documentId ?? this.documentId,
    );
  }
}
