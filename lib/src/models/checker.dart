class Checker {
  final String field;
  final String? value;
  final CheckerType type;

  const Checker({
    required this.field,
    this.type = CheckerType.contains,
    this.value,
  });

  @override
  int get hashCode => field.hashCode ^ value.hashCode ^ type.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Checker &&
        other.field == field &&
        other.value == value &&
        other.type == type;
  }

  @override
  String toString() => "$Checker(field: $field, value: $value, type: $type)";
}

enum CheckerType {
  contains,
  equal;

  bool get isContains => this == CheckerType.contains;

  bool get isEqual => this == CheckerType.equal;
}
