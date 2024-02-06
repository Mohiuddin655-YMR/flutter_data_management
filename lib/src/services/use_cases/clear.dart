import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class ClearDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const ClearDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.clear(builder: builder);
  }
}
