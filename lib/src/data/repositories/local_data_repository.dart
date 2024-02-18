import 'package:flutter_andomie/utils/entities/entities.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
import '../../services/repositories/local_data_repository.dart';
import '../../utils/response.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataRepositoryImpl<T extends Entity> extends LocalDataRepository<T> {
  LocalDataRepositoryImpl({
    required super.source,
    super.connectivity,
  });

  @override
  Future<DataResponse<T>> clear({
    OnDataSourceBuilder? builder,
  }) {
    return source.clear(builder: builder);
  }

  @override
  Future<DataResponse<T>> deleteById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return source.deleteById(id, builder: builder);
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create(
    T data, {
    OnDataSourceBuilder? builder,
  }) {
    return source.create(data, builder: builder);
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates(
    List<T> data, {
    OnDataSourceBuilder? builder,
  }) {
    return source.creates(data, builder: builder);
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return source.checkById(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> getById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return source.getById(id, builder: builder);
  }

  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return source.listenById(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
  }) {
    return source.get(builder: builder);
  }

  @override
  Future<DataResponse<T>> getByQuery({
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return source.getByQuery(
      builder: builder,
      forUpdates: forUpdates,
      queries: queries,
      sorts: sorts,
      options: options,
    );
  }

  @override
  Stream<DataResponse<T>> listenByQuery({
    OnDataSourceBuilder? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return source.listenByQuery(
      builder: builder,
      forUpdates: forUpdates,
      queries: queries,
      sorts: sorts,
      options: options,
    );
  }

  @override
  Stream<DataResponse<T>> listen({
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
  }) {
    return source.listen(builder: builder);
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder? builder,
  }) {
    return source.updateById(id, data, builder: builder);
  }
}
