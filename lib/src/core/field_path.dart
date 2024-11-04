part of 'configs.dart';

enum FieldPaths {
  documentId,
  none;

  bool get isDocumentId => this == documentId;

  bool get isNone => this == none;
}

class FieldPath {
  final Object? field;
  final FieldPaths type;

  const FieldPath(
    this.field, [
    this.type = FieldPaths.none,
  ]);

  static FieldPath get documentId {
    return const FieldPath(null, FieldPaths.documentId);
  }
}
