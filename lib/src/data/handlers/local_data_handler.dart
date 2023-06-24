part of 'handlers.dart';

class LocalDataHandlerImpl<T extends Entity> extends LocalDataHandler<T> {
  LocalDataHandlerImpl._({
    required super.repository,
  });

  factory LocalDataHandlerImpl.fromRepository(
    LocalDataRepository<T> repository,
  ) {
    return LocalDataHandlerImpl._(repository: repository);
  }

  factory LocalDataHandlerImpl.fromSource(LocalDataSource<T> source) {
    return LocalDataHandlerImpl._(
      repository: LocalDataRepositoryImpl(source: source),
    );
  }

  @override
  Future<Response<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.isAvailable(id, builder: builder);
  }

  @override
  Future<Response<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.insert(data, builder: builder);
  }

  @override
  Future<Response<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.inserts(data, builder: builder);
  }

  @override
  Future<Response<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.update(id, data, builder: builder);
  }

  @override
  Future<Response<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.delete(id, builder: builder);
  }

  @override
  Future<Response<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.clear(builder: builder);
  }

  @override
  Future<Response<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.get(id, builder: builder);
  }

  @override
  Future<Response<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.gets(builder: builder);
  }

  @override
  Future<Response<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.getUpdates(builder: builder);
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.live(id, builder: builder);
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.lives(builder: builder);
  }
}
