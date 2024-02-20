part of '../../sources/local_store_data_source.dart';

class LocalstoreFieldPath {
  const LocalstoreFieldPath._();

  static String get documentId => EntityKey.i.id;
}

enum LocalstoreFieldValueType {
  arrayUnion,
  arrayRemove,
  delete,
  serverTimestamp,
  increment,
}

class LocalstoreFieldValue {
  final Object? value;
  final LocalstoreFieldValueType type;

  const LocalstoreFieldValue._(this.value, this.type);

  factory LocalstoreFieldValue.arrayUnion(List<dynamic> elements) {
    return LocalstoreFieldValue._(
        elements, LocalstoreFieldValueType.arrayUnion);
  }

  factory LocalstoreFieldValue.arrayRemove(List<dynamic> elements) {
    return LocalstoreFieldValue._(
        elements, LocalstoreFieldValueType.arrayRemove);
  }

  factory LocalstoreFieldValue.delete() {
    return const LocalstoreFieldValue._(null, LocalstoreFieldValueType.delete);
  }

  factory LocalstoreFieldValue.serverTimestamp() {
    return const LocalstoreFieldValue._(
        null, LocalstoreFieldValueType.serverTimestamp);
  }

  factory LocalstoreFieldValue.increment(num value) {
    return LocalstoreFieldValue._(
        value, LocalstoreFieldValueType.serverTimestamp);
  }
}

enum LocalstoreFilters {
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
  isNull;

  bool isMatched(Object? request, Object? response) {
    switch (this) {
      case LocalstoreFilters.arrayContains:
        return response is Iterable ? response.contains(request) : false;
      case LocalstoreFilters.arrayContainsAny:
        return response is Iterable && request is Iterable
            ? response.where(request.contains).isNotEmpty
            : false;
      case LocalstoreFilters.isEqualTo:
        return response == request;
      case LocalstoreFilters.isGreaterThan:
        return response is num && request is num ? response > request : false;
      case LocalstoreFilters.isGreaterThanOrEqualTo:
        return response is num && request is num ? response >= request : false;
      case LocalstoreFilters.isLessThan:
        return response is num && request is num ? response < request : false;
      case LocalstoreFilters.isLessThanOrEqualTo:
        return response is num && request is num ? response <= request : false;
      case LocalstoreFilters.isNotEqualTo:
        return response != request;
      case LocalstoreFilters.isNull:
        return response == null;
      case LocalstoreFilters.whereIn:
        return request is Iterable ? request.contains(response) : false;
      case LocalstoreFilters.whereNotIn:
        return request is Iterable ? !request.contains(response) : false;
    }
  }
}

class LocalstoreFilter extends Query {
  final Map<LocalstoreFilters, Object?> values;

  LocalstoreFilter(
    super.field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Object? arrayContainsAny,
    Object? whereIn,
    Object? whereNotIn,
    Object? isNull,
  }) : values = {
          LocalstoreFilters.isEqualTo: isEqualTo,
          LocalstoreFilters.isNotEqualTo: isNotEqualTo,
          LocalstoreFilters.isLessThan: isLessThan,
          LocalstoreFilters.isLessThanOrEqualTo: isLessThanOrEqualTo,
          LocalstoreFilters.isGreaterThan: isGreaterThan,
          LocalstoreFilters.isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          LocalstoreFilters.arrayContains: arrayContains,
          LocalstoreFilters.arrayContainsAny: arrayContainsAny,
          LocalstoreFilters.whereIn: whereIn,
          LocalstoreFilters.whereNotIn: whereNotIn,
          LocalstoreFilters.isNull: isNull,
        };
}

class LocalstoreQuery extends LocalstoreFilter {
  LocalstoreQuery(
    String super.field, {
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

  LocalstoreQuery.filter(
    LocalstoreFilter super.filter, {
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

  LocalstoreQuery.path(
    LocalstoreFieldPath super.path, {
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

enum LocalstoreSelectionTypes {
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

class LocalstoreSelection extends Selection {
  final LocalstoreSelectionTypes type;

  Iterable<Object?>? get values {
    return value is Iterable<Object?> ? value as Iterable<Object?> : null;
  }

  const LocalstoreSelection._(
    super.value, {
    this.type = LocalstoreSelectionTypes.none,
  });

  const LocalstoreSelection.empty() : this._(null);

  const LocalstoreSelection.endAt(Iterable<Object?>? values)
      : this._(values, type: LocalstoreSelectionTypes.endAt);

  const LocalstoreSelection.endAtDocument(Object? snapshot)
      : this._(snapshot, type: LocalstoreSelectionTypes.endAtDocument);

  const LocalstoreSelection.endBefore(Iterable<Object?>? values)
      : this._(values, type: LocalstoreSelectionTypes.endBefore);

  const LocalstoreSelection.endBeforeDocument(Object? snapshot)
      : this._(snapshot, type: LocalstoreSelectionTypes.endBeforeDocument);

  const LocalstoreSelection.startAfter(Iterable<Object?>? values)
      : this._(values, type: LocalstoreSelectionTypes.startAfter);

  const LocalstoreSelection.startAfterDocument(Object? snapshot)
      : this._(snapshot, type: LocalstoreSelectionTypes.startAfterDocument);

  const LocalstoreSelection.startAt(Iterable<Object?>? values)
      : this._(values, type: LocalstoreSelectionTypes.startAt);

  const LocalstoreSelection.startAtDocument(Object? snapshot)
      : this._(snapshot, type: LocalstoreSelectionTypes.startAtDocument);
}

class LocalstoreSorting extends Sorting {
  final bool descending;

  const LocalstoreSorting(
    super.field, {
    this.descending = true,
  });
}

class _QHelper {
  const _QHelper._();

  static Future<Map<String, dynamic>?> search<T extends Object?>(
    ldb.CollectionRef reference,
    Checker checker,
  ) {
    final field = checker.field;
    final value = checker.value;
    final type = checker.type;
    if (value is String) {
      if (type.isContains) {
        return _q(reference).then((collection) {
          return collection.entries.where((i) {
            final k = i.key;
            final v = i.value;
            if (k == field && v is String) {
              if (v.startsWith(value) || v.endsWith('$value\uf8ff')) {
                return true;
              }
            }
            return false;
          });
        }).then(Map.fromEntries);
      } else {
        return reference.where(field, isEqualTo: value).get();
      }
    } else {
      return reference.get();
    }
  }

  static Future<Map<String, dynamic>?> query({
    required ldb.CollectionRef reference,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptions(),
  }) async {
    var isFetchingMode = true;
    final fetchingSizeInit = options.initialFetchingSize ?? 0;
    final fetchingSize = options.fetchingSize ?? fetchingSizeInit;
    final isValidLimit = fetchingSize > 0;

    Future<Map<String, dynamic>> data = reference.get().then((i) => i ?? {});

    if (queries.isNotEmpty) {
      for (final q in queries) {
        if (q is LocalstoreQuery) {
          final field = q.field;
          final values = q.values;
          if (field != null && values.isNotEmpty) {
            data = data.then((collection) {
              return collection.entries.where((i) {
                final k = i.key;
                if (field == k) {
                  return values.entries.where((item) {
                    return item.key.isMatched(item.value, i.value);
                  }).isNotEmpty;
                } else {
                  return false;
                }
              });
            }).then(Map.fromEntries);
          }
        }
      }
    }

    if (sorts.isNotEmpty) {
      for (final i in sorts) {
        if (i is FirestoreSorting) {
          data = data.then((collection) {
            if (i.descending) {
              return collection.entries.toList().reversed;
            } else {
              return collection.entries;
            }
          }).then(Map.fromEntries);
        }
      }
    }

    if (selections.isNotEmpty) {
      for (final i in selections) {
        if (i is LocalstoreSelection) {
          final type = i.type;
          final value = i.value;
          final isValidSnapshot = value is Map<String, dynamic>;
          isFetchingMode = (value != null || isValidSnapshot) && !type.isNone;
          data = data.then((collection) {
            final current = collection.entries.toList();
            final length = current.length;
            if (value is int && (type.isStartAt || type.isEndAt)) {
              if (type.isEndAt) {
                return current.getRange(0, value);
              } else {
                return current.getRange(value, length);
              }
            } else if (value != null &&
                (type.isStartAfter || type.isEndBefore)) {
              final index = current.indexWhere((i) => i.value == value);
              if (type.isStartAfter) {
                return current.getRange(index, length);
              } else {
                return current.getRange(0, index);
              }
            } else if (value is int &&
                (type.isStartAtDocument || type.isEndAtDocument)) {
              if (type.isStartAtDocument) {
                return current.getRange(value, length);
              } else {
                return current.getRange(0, value);
              }
            } else if (value is Map<String, dynamic> &&
                (type.isStartAfterDocument || type.isEndBeforeDocument)) {
              final index = current.indexWhere((i) => i.value == value);
              if (type.isStartAfterDocument) {
                return current.getRange(index, length);
              } else {
                return current.getRange(0, index);
              }
            } else {
              return <MapEntry<String, dynamic>>[];
            }
          }).then(Map.fromEntries);
        }
      }
    }

    if (isValidLimit) {
      final x = await data.then((i) => i.entries.toList());
      if (options.fetchFromLast) {
        final y = x.reversed.toList();
        if (isFetchingMode) {
          data = Future.value(Map.fromEntries(y.getRange(0, fetchingSize)));
        } else {
          data = Future.value(Map.fromEntries(y.getRange(0, fetchingSizeInit)));
        }
      } else {
        if (isFetchingMode) {
          data = Future.value(Map.fromEntries(x.getRange(0, fetchingSize)));
        } else {
          data = Future.value(Map.fromEntries(x.getRange(0, fetchingSizeInit)));
        }
      }
    }
    return reference.get();
  }

  static Future<Map<String, dynamic>> _q(ldb.CollectionRef ref) {
    return ref.get().then((value) => value ?? {});
  }
}
