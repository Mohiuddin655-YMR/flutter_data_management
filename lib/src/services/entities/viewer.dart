part of 'entities.dart';

class Viewer extends Entity {
  final String viewerId;
  final String documentId;

  Viewer({
    required super.timeMills,
    required this.viewerId,
    required this.documentId,
  });

  factory Viewer.from(Map<String, dynamic> map) {
    final timeMills = map["time_mills"];
    final documentId = map["document_id"];
    final viewerId = map["viewer_id"];
    return Viewer(
      timeMills: timeMills,
      viewerId: viewerId,
      documentId: documentId,
    );
  }

  Map<String, dynamic> get map => {
        "time_mills": timeMills,
        "document_id": documentId,
        "viewer_id": viewerId,
      };

  Viewer modify({
    int? timeMills,
    String? uid,
    String? documentId,
  }) {
    return Viewer(
      timeMills: timeMills ?? this.timeMills,
      viewerId: uid ?? viewerId,
      documentId: documentId ?? this.documentId,
    );
  }
}
