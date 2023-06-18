part of 'handlers.dart';

class LocalDataHandlerImpl<T extends Entity> extends LocalDataHandler<T> {
  LocalDataHandlerImpl({
    required super.repository,
  });

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.isAvailable(
      id,
      source: source,
    );
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.insert(
      data,
      source: source,
    );
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.inserts(
      data,
      source: source,
    );
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.update(
      id,
      data,
      source: source,
    );
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.delete(
      id,
      source: source,
    );
  }

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.clear(
      source: source,
    );
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.get(
      id,
      source: source,
    );
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.gets(
      source: source,
    );
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.getUpdates(
      source: source,
    );
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.live(
      id,
      source: source,
    );
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return repository.lives(
      source: source,
    );
  }
}
