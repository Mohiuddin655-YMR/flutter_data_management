class DataException {
  final String? _exp;

  const DataException([this._exp]);

  String get message {
    if (_exp != null) {
      return _exp!;
    } else {
      return "DataProvider not initialization.";
    }
  }

  @override
  String toString() => message;
}
