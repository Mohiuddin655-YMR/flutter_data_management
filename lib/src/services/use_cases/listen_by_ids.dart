import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetByIdsForRealtimeDataUseCase<T extends Entity>
    extends BaseDataUseCase<T> {
  const GetByIdsForRealtimeDataUseCase(super.repository);

  Stream<DataResponse<T>> call<R>(
    List<String> ids, {
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.listenByIds(
      ids,
      forUpdates: forUpdates,
      builder: builder,
    );
  }
}
