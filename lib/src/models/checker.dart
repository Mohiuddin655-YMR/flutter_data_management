class Checker {
  final String field;
  final String? value;
  final CheckerType type;

  const Checker({
    required this.field,
    this.type = CheckerType.contains,
    this.value,
  });
}

enum CheckerType {
  contains,
  equal;

  bool get isContains => this == CheckerType.contains;

  bool get isEqual => this == CheckerType.equal;
}
