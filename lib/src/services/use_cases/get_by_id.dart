import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetByIdDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const GetByIdDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.getById(id, builder: builder);
  }
}
