import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class CreatesDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const CreatesDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.creates(data, builder: builder);
  }
}
