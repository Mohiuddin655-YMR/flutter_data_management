import 'package:flutter_andomie/core.dart';

typedef OnDataBuilder<T extends Entity> = T Function(dynamic);
typedef OnDataSourceBuilder<R> = R? Function(R parent);
typedef OnValueBuilder<T> = T Function(dynamic value);
