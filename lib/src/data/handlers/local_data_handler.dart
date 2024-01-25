import 'package:flutter_andomie/utils.dart';

import '../../core/typedefs.dart';
import '../../services/handlers/local_data_handler.dart';
import '../../services/sources/local_data_source.dart';
import '../../utils/response.dart';
import '../repositories/local_data_repository.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataHandlerImpl<T extends Entity> extends LocalDataHandler<T> {
  LocalDataHandlerImpl({
    required super.repository,
  });

  LocalDataHandlerImpl.fromSource(LocalDataSource<T> source)
      : super(repository: LocalDataRepositoryImpl(source: source));

  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.isAvailable(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.insert(data, builder: builder);
  }

  @override
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.inserts(data, builder: builder);
  }

  @override
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.update(id, data, builder: builder);
  }

  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.delete(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.clear(builder: builder);
  }

  @override
  Future<DataResponse<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.get(id, builder: builder);
  }

  @override
  Future<DataResponse<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.gets(builder: builder);
  }

  @override
  Future<DataResponse<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.getUpdates(builder: builder);
  }

  @override
  Stream<DataResponse<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.live(id, builder: builder);
  }

  @override
  Stream<DataResponse<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.lives(builder: builder);
  }
}
