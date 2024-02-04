import 'package:flutter_andomie/core.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../utils/response.dart';
import '../repositories/remote_data_repository.dart';
import 'data_handler.dart';

/// # Won't Use Directly
/// You can use:
/// * <b>[RemoteDataHandlerImpl]</b> : Use for all remote database related data.
///
abstract class RemoteDataHandler<T extends Entity> extends DataHandler<T> {
  final RemoteDataRepository<T> repository;

  RemoteDataHandler({
    required this.repository,
  });

  /// Use for fetch data by query
  Future<DataResponse<T>> query<R>({
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  });
}
