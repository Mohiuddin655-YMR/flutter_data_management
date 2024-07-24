part of 'configs.dart';

class FieldValue extends InAppFieldValue {
  const FieldValue(super.value, [super.type = InAppFieldValues.none]);

  factory FieldValue.arrayUnion(List<dynamic> elements) {
    return FieldValue(elements, InAppFieldValues.arrayUnion);
  }

  factory FieldValue.arrayRemove(List<dynamic> elements) {
    return FieldValue(elements, InAppFieldValues.arrayRemove);
  }

  factory FieldValue.delete() {
    return const FieldValue(null, InAppFieldValues.delete);
  }

  factory FieldValue.serverTimestamp() {
    return const FieldValue(null, InAppFieldValues.serverTimestamp);
  }

  factory FieldValue.increment(num value) {
    return FieldValue(value, InAppFieldValues.increment);
  }
}
