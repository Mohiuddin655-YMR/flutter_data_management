part of 'configs.dart';

typedef OnDataBuilder<T extends Entity> = T Function(dynamic);
typedef OnDataSourceBuilder = DataFieldParams Function(DataFieldParams params);
typedef OnDataValueBuilder<T> = T Function(dynamic value);

typedef DataCheckResponse<T extends Entity, S extends Object> = (
  T? data,
  S? snapshot,
);
typedef DataGetResponse<T extends Entity, S extends Object> = (
  T? data,
  S? snapshot,
);
typedef DataGetsResponse<T extends Entity, S extends Object> = (
  List<T>? data,
  Iterable<S?>? snapshot,
);
typedef DataClearFinder<T extends Entity> = (
  List<T>? backups,
  String? error,
  Status? status,
);

typedef DataCheckFinder<T extends Entity, S extends Object> = (
  DataGetResponse<T, S>? value,
  String? error,
  Status? status,
);
typedef DataCreationFinder = (String? error, Status? status);
typedef DataDeletionFinder = (String? error, Status? status);
typedef DataUpdatingFinder = (String? error, Status? status);
typedef DataGetFinder<T extends Entity, S extends Object> = (
  DataGetResponse<T, S>? value,
  String? error,
  Status? status,
);
typedef DataGetsFinder<T extends Entity, S extends Object> = (
  DataGetsResponse<T, S>? value,
  String? error,
  Status? status,
);

typedef DataBuilder<T extends Entity> = T Function(dynamic);

typedef DataClearByFinder<T extends Entity> = (
  bool isValid,
  List<T>? backups,
  String? message,
  Status? status,
);
typedef DataDeleteByIdFinder<T extends Entity> = (
  bool isValid,
  T? find,
  List<T>? result,
  String? message,
  Status? status,
);
typedef DataFindByFinder<T extends Entity> = (
  bool isValid,
  List<T>? result,
  String? message,
  Status? status,
);
typedef DataFindByIdFinder<T extends Entity> = (
  bool isValid,
  T? find,
  List<T>? result,
  String? message,
  Status? status,
);
typedef DataUpdateByDataFinder<T extends Entity> = (
  bool isValid,
  T? data,
  List<T>? result,
  String? message,
  Status? status,
);
typedef DataSetByDataFinder<T extends Entity> = (
  bool isValid,
  T? ignore,
  List<T>? result,
  String? message,
  Status? status,
);
typedef DataSetByListFinder<T extends Entity> = (
  bool isValid,
  List<T>? current,
  List<T>? ignores,
  List<T>? result,
  String? message,
  Status? status,
);
