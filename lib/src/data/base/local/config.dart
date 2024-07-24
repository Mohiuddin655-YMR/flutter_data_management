part of '../../sources/local.dart';

class _Limitations {
  const _Limitations._();

  static const whereIn = 10;
}

class _QHelper {
  const _QHelper._();

  static fdb.InAppQueryReference search(
    fdb.InAppQueryReference ref,
    Checker checker,
  ) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;

    if (value is String) {
      if (type.isContains) {
        ref = ref.orderBy(field).startAt([value]).endAt(['$value\uf8ff']);
      } else {
        ref = ref.where(field, isEqualTo: value);
      }
    }

    return ref;
  }

  static fdb.InAppQueryReference query({
    required fdb.InAppQueryReference reference,
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
        reference = reference.where(
          i.field,
          arrayContains: i.arrayContains,
          arrayContainsAny: i.arrayContainsAny,
          isEqualTo: i.isEqualTo,
          isNotEqualTo: i.isNotEqualTo,
          isGreaterThan: i.isGreaterThan,
          isGreaterThanOrEqualTo: i.isGreaterThanOrEqualTo,
          isLessThan: i.isLessThan,
          isLessThanOrEqualTo: i.isLessThanOrEqualTo,
          isNull: i.isNull,
          whereIn: i.whereIn,
          whereNotIn: i.whereNotIn,
        );
      }
    }

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        reference = reference.orderBy(i.field, descending: i.descending);
      }
    }

    if (selections.isNotEmpty) {
      for (final i in selections) {
        final type = i.type;
        final value = i.value;
        final values = i.values;
        final isValidValues = values != null && values.isNotEmpty;
        final isValidSnapshot = value is fdb.InAppDocumentSnapshot;
        isFetchingMode = (isValidValues || isValidSnapshot) && !type.isNone;
        if (isValidValues) {
          if (type.isEndAt) {
            reference = reference.endAt(values);
          } else if (type.isEndBefore) {
            reference = reference.endBefore(values);
          } else if (type.isStartAfter) {
            reference = reference.startAfter(values);
          } else if (type.isStartAt) {
            reference = reference.startAt(values);
          }
        } else if (isValidSnapshot) {
          if (type.isEndAtDocument) {
            reference = reference.endAtDocument(value);
          } else if (type.isEndBeforeDocument) {
            reference = reference.endBeforeDocument(value);
          } else if (type.isStartAfterDocument) {
            reference = reference.startAfterDocument(value);
          } else if (type.isStartAtDocument) {
            reference = reference.startAtDocument(value);
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
          reference = reference.limit(fetchingSize);
        } else {
          reference = reference.limit(fetchingSizeInit);
        }
      }
    }
    return reference;
  }
}
