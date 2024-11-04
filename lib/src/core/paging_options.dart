part of 'configs.dart';

class DataPagingOptions {
  final bool fetchFromLast;
  final int? fetchingSize;
  final int? initialSize;

  const DataPagingOptions({
    int? initialFetchSize,
    this.fetchFromLast = false,
    this.fetchingSize,
  }) : initialSize = initialFetchSize ?? fetchingSize;

  DataPagingOptions copy({
    bool? fetchFromLast,
    int? fetchingSize,
    int? initialSize,
  }) {
    return DataPagingOptions(
      initialFetchSize: initialSize ?? this.initialSize,
      fetchingSize: fetchingSize ?? this.fetchingSize,
      fetchFromLast: fetchFromLast ?? this.fetchFromLast,
    );
  }
}
