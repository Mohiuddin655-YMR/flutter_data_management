part of 'sources.dart';

typedef OnDataBuilder<T extends Entity> = T Function(dynamic);
typedef OnDataSourceBuilder<R> = R? Function(R parent);

abstract class DataSource<T extends Entity> {
  const DataSource();

  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  });

  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  });

  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  });

  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  });

  T build(dynamic source);
}
