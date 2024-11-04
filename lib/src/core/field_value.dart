part of 'configs.dart';

enum FieldValues {
  arrayUnion,
  arrayRemove,
  delete,
  serverTimestamp,
  increment,
  none;

  bool get isArrayUnion => this == arrayUnion;

  bool get isArrayRemove => this == arrayRemove;

  bool get isDelete => this == delete;

  bool get isServerTimestamp => this == serverTimestamp;

  bool get isIncrement => this == increment;

  bool get isNone => this == none;
}

class FieldValue {
  final Object? value;
  final FieldValues type;

  const FieldValue(this.value, [this.type = FieldValues.none]);

  factory FieldValue.arrayUnion(List<dynamic> elements) {
    return FieldValue(elements, FieldValues.arrayUnion);
  }

  factory FieldValue.arrayRemove(List<dynamic> elements) {
    return FieldValue(elements, FieldValues.arrayRemove);
  }

  factory FieldValue.delete() {
    return const FieldValue(null, FieldValues.delete);
  }

  factory FieldValue.serverTimestamp() {
    return const FieldValue(null, FieldValues.serverTimestamp);
  }

  factory FieldValue.increment(num value) {
    return FieldValue(value, FieldValues.increment);
  }
}
