part of '../sources/fire_store_data_source.dart';

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

enum FirestorePagingTypes {
  endAt,
  endAtDocument,
  endBefore,
  endBeforeDocument,
  startAfter,
  startAfterDocument,
  startAt,
  startAtDocument,
  none;

  bool get isEndAt => this == endAt;

  bool get isEndAtDocument => this == endAtDocument;

  bool get isEndBefore => this == endBefore;

  bool get isEndBeforeDocument => this == endBeforeDocument;

  bool get isStartAfter => this == startAfter;

  bool get isStartAfterDocument => this == startAfterDocument;

  bool get isStartAt => this == startAt;

  bool get isStartAtDocument => this == startAtDocument;

  bool get isSnapshotMode =>
      isEndAtDocument ||
      isEndBeforeDocument ||
      isStartAfterDocument ||
      isStartAtDocument;

  bool get isListMode => isEndAt || isEndBefore || isStartAfter || isStartAt;
}

class FirestorePagingOptions extends PagingOptions {
  final FirestorePagingTypes type;

  Iterable<Object?>? get values {
    return snapshot is Iterable<Object?> ? snapshot as Iterable<Object?> : null;
  }

  const FirestorePagingOptions._({
    super.snapshot,
    super.fetchFromLast,
    super.fetchingSize,
    super.initialFetchSize,
    this.type = FirestorePagingTypes.none,
  });

  const FirestorePagingOptions.empty() : this._();

  const FirestorePagingOptions.endAt(
    Iterable<Object?>? values, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: values,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.endAt,
        );

  const FirestorePagingOptions.endAtDocument(
    Object? snapshot, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: snapshot,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.endAtDocument,
        );

  const FirestorePagingOptions.endBefore(
    Iterable<Object?>? values, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: values,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.endBefore,
        );

  const FirestorePagingOptions.endBeforeDocument(
    Object? snapshot, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: snapshot,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.endBeforeDocument,
        );

  const FirestorePagingOptions.startAfter(
    Iterable<Object?>? values, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: values,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.startAfter,
        );

  const FirestorePagingOptions.startAfterDocument(
    Object? snapshot, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: snapshot,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.startAfterDocument,
        );

  const FirestorePagingOptions.startAt(
    Iterable<Object?>? values, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: values,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.startAt,
        );

  const FirestorePagingOptions.startAtDocument(
    Object? snapshot, {
    bool fetchFromLast = false,
    int? fetchSize,
    int? initialFetchSize,
  }) : this._(
          snapshot: snapshot,
          fetchFromLast: fetchFromLast,
          fetchingSize: fetchSize,
          initialFetchSize: initialFetchSize,
          type: FirestorePagingTypes.startAtDocument,
        );
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

  static fdb.Query<T> query<T extends Object?>({
    required fdb.Query<T> reference,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    FirestorePagingOptions options = const FirestorePagingOptions.empty(),
  }) {
    final type = options.type;
    final values = options.values;
    final snapshot = options.snapshot;
    final fetchingSizeInit = options.initialFetchingSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidSnapshot = snapshot is fdb.DocumentSnapshot;
    final isValidValues = values != null && values.isNotEmpty;
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
        reference = reference.endAtDocument(snapshot);
      } else if (type.isEndBeforeDocument) {
        reference = reference.endBeforeDocument(snapshot);
      } else if (type.isStartAfterDocument) {
        reference = reference.startAfterDocument(snapshot);
      } else if (type.isStartAtDocument) {
        reference = reference.startAtDocument(snapshot);
      }
    }

    if (isValidLimit) {
      if (options.fetchFromLast) {
        if (isValidSnapshot || isValidValues) {
          reference = reference.limitToLast(fetchingSize);
        } else {
          reference = reference.limitToLast(fetchingSizeInit);
        }
      } else {
        if (isValidSnapshot || isValidValues) {
          reference = reference.limit(fetchingSize);
        } else {
          reference = reference.limit(fetchingSizeInit);
        }
      }
    }
    return reference;
  }
}
