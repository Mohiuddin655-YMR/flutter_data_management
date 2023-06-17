part of 'sources.dart';

typedef OnDataBuilder<T extends Entity> = T Function(dynamic);
typedef OnDataSourceBuilder<R> = R? Function(R parent);

abstract class DataSource<T extends Entity> {
  const DataSource();

  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> update<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  });

  T build(dynamic source);
}
