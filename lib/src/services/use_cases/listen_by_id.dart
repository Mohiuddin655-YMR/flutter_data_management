import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetByIdForRealtimeDataUseCase<T extends Entity>
    extends BaseDataUseCase<T> {
  const GetByIdForRealtimeDataUseCase(super.repository);

  Stream<DataResponse<T>> call<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.listenById(id, builder: builder);
  }
}
