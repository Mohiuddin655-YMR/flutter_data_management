import 'package:flutter_andomie/core.dart';

import 'configs.dart';

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
