part of '../../sources/realtime_data_source.dart';

class RealtimeQuery extends Query {}

class RealtimeSelection extends Selection {
  final String? key;
  final RealtimeSelectionType type;

  const RealtimeSelection.endAt(super.value, {this.key})
      : type = RealtimeSelectionType.endAt;

  const RealtimeSelection.endBefore(super.value, {this.key})
      : type = RealtimeSelectionType.endBefore;

  const RealtimeSelection.equalTo(super.value, {this.key})
      : type = RealtimeSelectionType.equalTo;

  const RealtimeSelection.startAfter(super.value, {this.key})
      : type = RealtimeSelectionType.startAfter;

  const RealtimeSelection.startAt(super.value, {this.key})
      : type = RealtimeSelectionType.startAt;
}

enum RealtimeSelectionType {
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

class RealtimeSorting extends Sorting {
  const RealtimeSorting(super.field);
}

class _QHelper {
  const _QHelper._();

  static rdb.Query search(rdb.Query ref, Checker checker) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;

    if (value is String) {
      if (type.isContains) {
        ref = ref.orderByChild(field).startAt([value]).endAt(['$value\uf8ff']);
      } else {
        ref = ref.orderByChild(field).equalTo(value);
      }
    }

    return ref;
  }

  static rdb.Query query({
    required rdb.Query reference,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    var isFetchingMode = true;

    final fetchingSizeInit = options.initialFetchingSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        if (i is RealtimeSorting) {
          reference = reference.orderByChild(i.field);
        }
      }
    }

    if (selections.isNotEmpty) {
      for (final i in selections) {
        if (i is RealtimeSelection) {
          final key = i.key;
          final value = i.value;
          final type = i.type;
          isFetchingMode = value != null;
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

    if (isValidLimit) {
      if (options.fetchFromLast) {
        if (isFetchingMode) {
          reference = reference.limitToLast(fetchingSize);
        } else {
          reference = reference.limitToLast(fetchingSizeInit);
        }
      } else {
        if (isFetchingMode) {
          reference = reference.limitToFirst(fetchingSize);
        } else {
          reference = reference.limitToFirst(fetchingSizeInit);
        }
      }
    }

    return reference;
  }
}
