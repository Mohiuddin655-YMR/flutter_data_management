part of 'controllers.dart';

class RemoteDataController<T extends Entity> extends DataController<T> {
  final RemoteDataHandler<T> handler;

  RemoteDataController({
    required this.handler,
  });

  @override
  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.isAvailable(id, source: source));
  }

  @override
  void create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.insert(data, source: source));
  }

  @override
  void creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.inserts(data, source: source));
  }

  @override
  void update<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.update(id, data, source: source));
  }

  @override
  void delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.delete(id, source: source));
  }

  @override
  void clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    request(() => handler.clear(source: source));
  }

  @override
  void get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.get(id, source: source));
  }

  @override
  void gets<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.gets(source: source));
  }

  @override
  void getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.getUpdates(source: source));
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.live(id, source: source);
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.lives(source: source);
  }
}
