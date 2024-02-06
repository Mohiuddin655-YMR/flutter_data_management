import 'package:flutter_andomie/core.dart';

import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class CreateDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const CreateDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.create(data, builder: builder);
  }
}
