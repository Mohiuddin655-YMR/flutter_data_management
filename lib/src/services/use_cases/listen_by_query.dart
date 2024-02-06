import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../utils/response.dart';
import 'base.dart';

class ListenQueryDataUseCase<T extends Entity> extends BaseDataUseCase<T> {
  const ListenQueryDataUseCase(super.repository);

  Stream<DataResponse<T>> call<R>({
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return repository.listenByQuery(
      builder: builder,
      forUpdates: forUpdates,
      queries: queries,
      sorts: sorts,
      options: options,
    );
  }
}
