part of 'configs.dart';

class DataFilter extends Filter {
  const DataFilter(
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

  const DataFilter.and(super.filters) : super.and();

  const DataFilter.or(super.filters) : super.or();
}
