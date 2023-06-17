part of 'repositories.dart';

class LocalDataRepositoryImpl<T extends Entity> extends LocalDataRepository<T> {
  LocalDataRepositoryImpl({
    required super.local,
  });

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return local.clear(source: source);
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.delete(id, source: source);
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.get(id, source: source);
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return local.getUpdates(source: source);
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return local.gets(
      source: source,
    );
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.insert(data, source: source);
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.inserts(data, source: source);
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.isAvailable(id, source: source);
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.live(id, source: source);
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return local.lives(source: source);
  }

  @override
  Future<Response<T>> update<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return local.update(data, source: source);
  }
}
