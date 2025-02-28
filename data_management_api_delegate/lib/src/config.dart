part of 'source.dart';

class _QHelper {
  const _QHelper._();

  static Map<String, dynamic> search<T extends Object?>(Checker checker) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;
    if (value is String) {
      if (type.isContains) {
        return {
          field: {
            "start_at": value,
            "end_at": "$value\uf8ff",
          }
        };
      } else {
        return {
          field: {
            "is_equal_to": value,
          }
        };
      }
    } else {
      return {};
    }
  }

  static Map<String, dynamic> query({
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
  }) {
    var isFetchingMode = true;
    final fetchingSizeInit = options.initialSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    Map<String, dynamic> mQueries = {};
    if (queries.isNotEmpty) {
      for (final i in queries) {
        final field = i.field.toString();
        mQueries[field] = {
          if (i.arrayContains != null) "arrayContains": i.arrayContains,
          if (i.arrayNotContains != null)
            "arrayNotContains": i.arrayNotContains,
          if (i.arrayContainsAny != null)
            "arrayContainsAny": i.arrayContainsAny,
          if (i.arrayNotContainsAny != null)
            "arrayNotContainsAny": i.arrayNotContainsAny,
          if (i.isEqualTo != null) "isEqualTo": i.isEqualTo,
          if (i.isNotEqualTo != null) "isNotEqualTo": i.isNotEqualTo,
          if (i.isGreaterThan != null) "isGreaterThan": i.isGreaterThan,
          if (i.isGreaterThanOrEqualTo != null)
            "isGreaterThanOrEqualTo": i.isGreaterThanOrEqualTo,
          if (i.isLessThan != null) "isLessThan": i.isLessThan,
          if (i.isLessThanOrEqualTo != null)
            "isLessThanOrEqualTo": i.isLessThanOrEqualTo,
          if (i.isNull != null) "isNull": i.isNull,
          if (i.whereIn != null) "whereIn": i.whereIn,
          if (i.whereNotIn != null) "whereNotIn": i.whereNotIn,
        };
      }
    }

    Map<String, String> mSorts = {};

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        mSorts[i.field] = i.descending ? "des" : "asc";
      }
    }

    Map<String, dynamic> mSelections = {};

    if (selections.isNotEmpty) {
      for (final i in selections) {
        final type = i.type;
        final value = i.value;
        final values = i.values;
        final isValidValues = values != null && values.isNotEmpty;
        final isValidSnapshot = value is Map;
        isFetchingMode = (isValidValues || isValidSnapshot) && !type.isNone;
        if (isValidValues) {
          if (type.isEndAt) {
            mSelections["endAt"] = values;
          } else if (type.isEndBefore) {
            mSelections["endBefore"] = values;
          } else if (type.isStartAfter) {
            mSelections["startAfter"] = values;
          } else if (type.isStartAt) {
            mSelections["startAt"] = values;
          }
        } else if (isValidSnapshot) {
          if (type.isEndAtDocument) {
            mSelections["endAtDocument"] = value;
          } else if (type.isEndBeforeDocument) {
            mSelections["endBeforeDocument"] = value;
          } else if (type.isStartAfterDocument) {
            mSelections["startAfterDocument"] = value;
          } else if (type.isStartAtDocument) {
            mSelections["startAtDocument"] = value;
          }
        }
      }
    }

    Map<String, dynamic> mLimit = {};
    if (isValidLimit) {
      mLimit["type"] = options.fetchFromLast ? "limitToLast" : "limit";
      mLimit["count"] = isFetchingMode ? fetchingSize : fetchingSizeInit;
    }
    return {
      "queries": mQueries,
      "orders": mSorts,
      "selections": mSelections,
      "limit": mLimit,
    };
  }
}
