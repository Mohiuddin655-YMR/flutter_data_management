import 'package:flutter_andomie/utils/entities/entities.dart';

import '../../core/typedefs.dart';
import '../../services/repositories/local_data_repository.dart';
import '../../utils/response.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataRepositoryImpl<T extends Entity> extends LocalDataRepository<T> {
  LocalDataRepositoryImpl({
    required super.source,
  });

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.isAvailable(id, builder: builder);
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.insert(data, builder: builder);
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.inserts(data, builder: builder);
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.update(id, data, builder: builder);
  }

  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.delete(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.clear(builder: builder);
  }

  @override
  Future<DataResponse<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.get(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.gets(builder: builder);
  }

  @override
  Future<DataResponse<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.getUpdates(builder: builder);
  }

  @override
  Stream<DataResponse<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.live(id, builder: builder);
  }

  @override
  Stream<DataResponse<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return source.lives(builder: builder);
  }
}
