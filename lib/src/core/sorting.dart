part of 'configs.dart';

class DataSorting {
  final String field;
  final bool descending;

  const DataSorting(
    this.field, {
    this.descending = false,
  });

  @override
  int get hashCode => field.hashCode;

  @override
  bool operator ==(Object other) {
    return field.hashCode == other.hashCode;
  }

  @override
  String toString() {
    return field;
  }
}
