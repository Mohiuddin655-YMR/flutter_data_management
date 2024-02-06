import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetsForRealtimeDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const GetsForRealtimeDataUseCase(super.repository);

  Stream<DataResponse<T>> call<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.listen(builder: builder);
  }
}
