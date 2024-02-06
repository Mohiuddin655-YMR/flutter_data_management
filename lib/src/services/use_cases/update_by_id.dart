import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class UpdateByIdDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const UpdateByIdDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.updateById(id, data, builder: builder);
  }
}
