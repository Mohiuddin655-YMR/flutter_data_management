import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class DeleteByIdDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const DeleteByIdDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.deleteById(id, builder: builder);
  }
}
