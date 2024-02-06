import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class IsAvailableDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const IsAvailableDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.checkById(id, builder: builder);
  }
}
