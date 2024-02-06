import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class DeleteByIdsDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const DeleteByIdsDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    List<String> ids, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.deleteByIds(ids, builder: builder);
  }
}
