part of 'entities.dart';

class Report {
  final int? timeMills;
  final bool? verified;
  final String? documentId;
  final String? publisherId;
  final String? reportText;
  final ReportType? reportType;
  final String? reporterId;
  final String? reporterName;
  final String? reporterTitle;
  final String? reporterAvatar;

  const Report({
    this.timeMills,
    this.verified,
    this.documentId,
    this.publisherId,
    this.reportText,
    this.reportType,
    this.reporterId,
    this.reporterName,
    this.reporterTitle,
    this.reporterAvatar,
  });

  factory Report.from(Map<String, dynamic> map) {
    final timeMills = map["time_mills"];
    final verified = map["verified"];
    final documentId = map["document_id"];
    final publisherId = map["publisher_id"];
    final reportText = map["report_text"];
    final reportType = map["report_type"];
    final reporterId = map["reporter_id"];
    final reporterName = map["reporter_name"];
    final reporterTitle = map["reporter_title"];
    final reporterAvatar = map["reporter_avatar"];
    return Report(
      timeMills: timeMills,
      verified: verified,
      documentId: documentId,
      publisherId: publisherId,
      reportText: reportText,
      reportType: reportType,
      reporterId: reporterId,
      reporterName: reporterName,
      reporterTitle: reporterTitle,
      reporterAvatar: reporterAvatar,
    );
  }

  Map<String, dynamic> get map => {
        "time_mills": timeMills,
        "verified": verified,
        "document_id": documentId,
        "publisher_id": publisherId,
        "report_text": reportText,
        "report_type": reportType,
        "reporter_id": reporterId,
        "reporter_name": reporterName,
        "reporter_title": reporterTitle,
        "reporter_avatar": reporterAvatar,
      };

  Report modify({
    int? timeMills,
    bool? verified,
    String? documentId,
    String? publisherId,
    String? reportText,
    ReportType? reportType,
    String? reporterId,
    String? reporterName,
    String? reporterTitle,
    String? reporterAvatar,
  }) {
    return Report(
      timeMills: timeMills ?? this.timeMills,
      verified: verified ?? this.verified,
      documentId: documentId ?? this.documentId,
      publisherId: publisherId ?? this.publisherId,
      reportText: reportText ?? this.reportText,
      reportType: reportType ?? this.reportType,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      reporterTitle: reporterTitle ?? this.reporterTitle,
      reporterAvatar: reporterAvatar ?? this.reporterAvatar,
    );
  }
}

enum ReportType {
  blackmail("Blackmail"),
  copyRight("Copy Right"),
  inappropriate("Inappropriate"),
  personal("Personal");

  final String value;

  const ReportType(this.value);
}
