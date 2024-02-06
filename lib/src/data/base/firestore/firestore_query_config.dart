part of '../../sources/fire_store_data_source.dart';

class _Limitations {
  const _Limitations._();

  static const whereIn = 10;
}

class FieldPath extends fdb.FieldPath {
  FieldPath(super.components);

  static FieldPathType get documentId {
    return fdb.FieldPath.documentId;
  }
}

class FieldValue {
  static fdb.FieldValue arrayUnion(List<dynamic> elements) {
    return fdb.FieldValue.arrayUnion(elements);
  }

  static fdb.FieldValue arrayRemove(List<dynamic> elements) {
    return fdb.FieldValue.arrayRemove(elements);
  }

  static fdb.FieldValue delete() => fdb.FieldValue.delete();

  static fdb.FieldValue serverTimestamp() => fdb.FieldValue.serverTimestamp();

  static fdb.FieldValue increment(num value) => fdb.FieldValue.increment(value);
}

class Filter extends fdb.Filter {
  Filter(
    super.field, {
    super.isEqualTo,
    super.isNotEqualTo,
    super.isLessThan,
    super.isLessThanOrEqualTo,
    super.isGreaterThan,
    super.isGreaterThanOrEqualTo,
    super.arrayContains,
    super.arrayContainsAny,
    super.whereIn,
    super.whereNotIn,
    super.isNull,
  });
}

class FirestoreQuery extends Query {
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final Iterable<Object?>? arrayContainsAny;
  final Iterable<Object?>? whereIn;
  final Iterable<Object?>? whereNotIn;
  final bool? isNull;

  const FirestoreQuery(
    String super.field, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });

  FirestoreQuery.filter(
    Filter super.filter, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });

  FirestoreQuery.path(
    FieldPath super.path, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

enum FirestoreSelectionTypes {
  endAt,
  endAtDocument,
  endBefore,
  endBeforeDocument,
  startAfter,
  startAfterDocument,
  startAt,
  startAtDocument,
  none;

  bool get isNone => this == none;

  bool get isEndAt => this == endAt;

  bool get isEndAtDocument => this == endAtDocument;

  bool get isEndBefore => this == endBefore;

  bool get isEndBeforeDocument => this == endBeforeDocument;

  bool get isStartAfter => this == startAfter;

  bool get isStartAfterDocument => this == startAfterDocument;

  bool get isStartAt => this == startAt;

  bool get isStartAtDocument => this == startAtDocument;
}

class FirestoreSelection extends Selection {
  final FirestoreSelectionTypes type;

  Iterable<Object?>? get values {
    return value is Iterable<Object?> ? value as Iterable<Object?> : null;
  }

  const FirestoreSelection._(
    super.value, {
    this.type = FirestoreSelectionTypes.none,
  });

  const FirestoreSelection.empty() : this._(null);

  const FirestoreSelection.endAt(Iterable<Object?>? values)
      : this._(values, type: FirestoreSelectionTypes.endAt);

  const FirestoreSelection.endAtDocument(Object? snapshot)
      : this._(snapshot, type: FirestoreSelectionTypes.endAtDocument);

  const FirestoreSelection.endBefore(Iterable<Object?>? values)
      : this._(values, type: FirestoreSelectionTypes.endBefore);

  const FirestoreSelection.endBeforeDocument(Object? snapshot)
      : this._(snapshot, type: FirestoreSelectionTypes.endBeforeDocument);

  const FirestoreSelection.startAfter(Iterable<Object?>? values)
      : this._(values, type: FirestoreSelectionTypes.startAfter);

  const FirestoreSelection.startAfterDocument(Object? snapshot)
      : this._(snapshot, type: FirestoreSelectionTypes.startAfterDocument);

  const FirestoreSelection.startAt(Iterable<Object?>? values)
      : this._(values, type: FirestoreSelectionTypes.startAt);

  const FirestoreSelection.startAtDocument(Object? snapshot)
      : this._(snapshot, type: FirestoreSelectionTypes.startAtDocument);
}

class FirestoreSorting extends Sorting {
  final bool descending;

  const FirestoreSorting(
    super.field, {
    this.descending = true,
  });
}

class _QHelper {
  const _QHelper._();

  static fdb.Query<T> search<T extends Object?>(
    fdb.Query<T> ref,
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

  static fdb.Query<T> query<T extends Object?>({
    required fdb.Query<T> reference,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) {
    var isFetchingMode = true;
    final fetchingSizeInit = options.initialFetchingSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    if (queries.isNotEmpty) {
      for (final i in queries) {
        if (i is FirestoreQuery) {
          final field = i.field;
          if (field != null) {
            reference = reference.where(
              field,
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
      }
    }

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        if (i is FirestoreSorting) {
          reference = reference.orderBy(i.field, descending: i.descending);
        }
      }
    }

    if (selections.isNotEmpty) {
      for (final i in selections) {
        if (i is FirestoreSelection) {
          final type = i.type;
          final value = i.value;
          final values = i.values;
          final isValidValues = values != null && values.isNotEmpty;
          final isValidSnapshot = value is fdb.DocumentSnapshot;
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
