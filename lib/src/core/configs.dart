/// You can use like
/// * [ApiPagingOptions]
/// * [FirestorePagingOptions]
/// * [RealtimePagingOptions]
abstract class PagingOptions {
  final Object? snapshot;
  final bool fetchFromLast;
  final int? fetchingSize;
  final int? initialFetchingSize;

  const PagingOptions({
    int? initialFetchSize,
    this.snapshot,
    this.fetchFromLast = false,
    this.fetchingSize,
  }) : initialFetchingSize = initialFetchSize ?? fetchingSize;
}

class PagingOptionsImpl extends PagingOptions {
  const PagingOptionsImpl();
}

/// You can use like
/// * [ApiSorting]
/// * [FirestoreSorting]
/// * [RealtimeSorting]
abstract class Sorting {
  final String field;

  const Sorting(this.field);
}

/// You can use like
/// * [ApiQuery]
/// * [FirestoreQuery]
/// * [RealtimeQuery]
abstract class Query {
  final Object? field;

  const Query([this.field]);
}
