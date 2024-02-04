part of '../sources/realtime_data_source.dart';

class RealtimePagingOptions extends PagingOptions {
  const RealtimePagingOptions.empty();
}

enum RealtimeQueryType {
  endAt,
  endBefore,
  equalTo,
  startAfter,
  startAt,
  none;

  bool get isEndAt => this == endAt;

  bool get isEndBefore => this == endBefore;

  bool get isEqualTo => this == equalTo;

  bool get isStartAfter => this == startAfter;

  bool get isStartAt => this == startAt;
}

class RealtimeQuery extends Query {
  final Object? value;
  final RealtimeQueryType type;

  const RealtimeQuery.endAt(
    super.field,
    this.value,
  ) : type = RealtimeQueryType.endAt;

  const RealtimeQuery.endBefore(
    super.field,
    this.value,
  ) : type = RealtimeQueryType.endBefore;

  const RealtimeQuery.equalTo(
    super.field,
    this.value,
  ) : type = RealtimeQueryType.equalTo;

  const RealtimeQuery.startAfter(
    super.field,
    this.value,
  ) : type = RealtimeQueryType.startAfter;

  const RealtimeQuery.startAt(
    super.field,
    this.value,
  ) : type = RealtimeQueryType.startAt;
}

class RealtimeSorting extends Sorting {
  const RealtimeSorting(super.field);
}

class _QHelper {
  const _QHelper._();

  static rdb.Query query({
    required rdb.Query reference,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    RealtimePagingOptions options = const RealtimePagingOptions.empty(),
  }) {
    final snapshot = options.snapshot;
    final fetchingSizeInit = options.initialFetchingSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidSnapshot = snapshot != null;
    final isValidLimit = fetchingSize > 0;

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        if (i is RealtimeSorting) {
          reference = reference.orderByChild(i.field);
        }
      }
    }

    if (queries.isNotEmpty) {
      for (final i in queries) {
        if (i is RealtimeQuery) {
          final key = i.field is String ? i.field as String : null;
          final value = i.value;
          final type = i.type;
          if (value != null) {
            if (type.isEndAt) {
              reference = reference.endAt(value, key: key);
            } else if (type.isEndBefore) {
              reference = reference.endBefore(value, key: key);
            } else if (type.isEqualTo) {
              reference = reference.equalTo(value, key: key);
            } else if (type.isStartAfter) {
              reference = reference.startAfter(value, key: key);
            } else if (type.isStartAt) {
              reference = reference.startAt(value, key: key);
            }
          }
        }
      }
    }

    if (isValidLimit) {
      if (options.fetchFromLast) {
        if (isValidSnapshot) {
          reference = reference.limitToLast(fetchingSize);
        } else {
          reference = reference.limitToLast(fetchingSizeInit);
        }
      } else {
        if (isValidSnapshot) {
          reference = reference.limitToFirst(fetchingSize);
        } else {
          reference = reference.limitToFirst(fetchingSizeInit);
        }
      }
    }

    return reference;
  }
}
