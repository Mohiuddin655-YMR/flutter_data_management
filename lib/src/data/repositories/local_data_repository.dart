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
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.clear(builder: builder);
  }

  @override
  Future<DataResponse<T>> deleteById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.deleteById(id, builder: builder);
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.create(data, builder: builder);
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.creates(data, builder: builder);
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.checkById(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> getById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.getById(id, builder: builder);
  }

  @override
  Stream<DataResponse<T>> listenById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.listenById(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> get<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.get(builder: builder);
  }

  @override
  Future<DataResponse<T>> getByQuery<R>({
    OnDataSourceBuilder<R>? builder,
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
  Stream<DataResponse<T>> listenByQuery<R>({
    OnDataSourceBuilder<R>? builder,
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
  Stream<DataResponse<T>> listen<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.listen(builder: builder);
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.updateById(id, data, builder: builder);
  }
}
