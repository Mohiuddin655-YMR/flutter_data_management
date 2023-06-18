part of 'handlers.dart';

abstract class DataHandler<T extends Entity> {
  Future<Response<T>> isAvailable<R>(
    String id, {
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

  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  });

  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  });

  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  });
}
