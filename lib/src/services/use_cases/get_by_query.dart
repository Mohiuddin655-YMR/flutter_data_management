import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class GetsByQueryDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const GetsByQueryDataUseCase(super.repository);

  Future<DataResponse<T>> call<R>({
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return repository.getByQuery(
      builder: builder,
      forUpdates: forUpdates,
      queries: queries,
      sorts: sorts,
      options: options,
    );
  }
}
