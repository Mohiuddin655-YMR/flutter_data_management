import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetByIdsDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const GetByIdsDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    List<String> ids, {
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.getByIds(ids, forUpdates: forUpdates, builder: builder);
  }
}
