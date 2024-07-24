part of 'configs.dart';

class FieldPath extends InAppFieldPath {
  const FieldPath(
    super.field, [
    super.type = InAppFieldPaths.none,
  ]);

  static FieldPath get documentId {
    return const FieldPath(null, InAppFieldPaths.documentId);
  }
}
