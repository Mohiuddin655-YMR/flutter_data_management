import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetsDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const GetsDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.get(forUpdates: forUpdates, builder: builder);
  }
}
