part of '../../sources/realtime.dart';

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

    final fetchingSizeInit = options.initialSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    if (queries.isNotEmpty) {
      for (final i in queries) {
        if (i.isEqualTo != null) {
          reference = reference.equalTo(i.isEqualTo);
        }
      }
    }
    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        reference = reference.orderByChild(i.field);
      }
    }

    if (selections.isNotEmpty) {
      for (final i in selections) {
        const key = null;
        final value = i.value;
        final type = i.type;
        isFetchingMode = value != null;
        if (type.isEndAt) {
          reference = reference.endAt(value, key: key);
        } else if (type.isEndBefore) {
          reference = reference.endBefore(value, key: key);
        } else if (type.isStartAfter) {
          reference = reference.startAfter(value, key: key);
        } else if (type.isStartAt) {
          reference = reference.startAt(value, key: key);
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
