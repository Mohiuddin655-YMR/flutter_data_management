part of 'configs.dart';

class DataQuery extends Query {
  const DataQuery(
    super.field, {
    super.isEqualTo,
    super.isNotEqualTo,
    super.isLessThan,
    super.isLessThanOrEqualTo,
    super.isGreaterThan,
    super.isGreaterThanOrEqualTo,
    super.arrayContains,
    super.arrayNotContains,
    super.arrayContainsAny,
    super.arrayNotContainsAny,
    super.whereIn,
    super.whereNotIn,
    super.isNull,
  });

  const DataQuery.filter(Filter filter) : this(filter);

  const DataQuery.path(InAppFieldPath path) : this(path);
}
