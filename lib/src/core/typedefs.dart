part of 'configs.dart';

typedef OnDataBuilder<T extends Entity> = T Function(dynamic);
typedef OnDataSourceBuilder = FieldParams Function(FieldParams params);
typedef OnValueBuilder<T> = T Function(dynamic value);

typedef CheckResponse<T extends Entity, S extends Object> = (
  T? data,
  S? snapshot,
);
typedef GetResponse<T extends Entity, S extends Object> = (
  T? data,
  S? snapshot,
);
typedef GetsResponse<T extends Entity, S extends Object> = (
  List<T>? data,
  Iterable<S?>? snapshot,
);
typedef ClearFinder<T extends Entity> = (
  List<T>? backups,
  String? error,
  Status? status,
);

typedef CheckFinder<T extends Entity, S extends Object> = (
  GetResponse<T, S>? value,
  String? error,
  Status? status,
);
typedef CreationFinder = (String? error, Status? status);
typedef DeletionFinder = (String? error, Status? status);
typedef UpdatingFinder = (String? error, Status? status);
typedef GetFinder<T extends Entity, S extends Object> = (
  GetResponse<T, S>? value,
  String? error,
  Status? status,
);
typedef GetsFinder<T extends Entity, S extends Object> = (
  GetsResponse<T, S>? value,
  String? error,
  Status? status,
);

///
///

typedef DataBuilder<T extends Entity> = T Function(dynamic);

typedef InAppClearByFinder<T extends Entity> = (
  bool isValid,
  List<T>? backups,
  String? message,
  Status? status,
);
typedef InAppDeleteByIdFinder<T extends Entity> = (
  bool isValid,
  T? find,
  List<T>? result,
  String? message,
  Status? status,
);
typedef InAppFindByFinder<T extends Entity> = (
  bool isValid,
  List<T>? result,
  String? message,
  Status? status,
);
typedef InAppFindByIdFinder<T extends Entity> = (
  bool isValid,
  T? find,
  List<T>? result,
  String? message,
  Status? status,
);
typedef InAppUpdateByDataFinder<T extends Entity> = (
  bool isValid,
  T? data,
  List<T>? result,
  String? message,
  Status? status,
);
typedef InAppSetByDataFinder<T extends Entity> = (
  bool isValid,
  T? ignore,
  List<T>? result,
  String? message,
  Status? status,
);
typedef InAppSetByListFinder<T extends Entity> = (
  bool isValid,
  List<T>? current,
  List<T>? ignores,
  List<T>? result,
  String? message,
  Status? status,
);
