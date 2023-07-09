part of 'controllers.dart';

class RemoteDataController<T extends Data> extends DataController<T> {
  final RemoteDataHandler<T> handler;

  RemoteDataController(this.handler);

  RemoteDataController.fromSource({
    required RemoteDataSource<T> source,
    LocalDataSource<T>? backup,
    ConnectivityProvider? connectivity,
    bool isCacheMode = false,
  }) : handler = RemoteDataHandlerImpl<T>.fromSource(
          source: source,
          backup: backup,
          connectivity: connectivity,
          isCacheMode: isCacheMode,
        );

  @override
  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.isAvailable(id, builder: source));
  }

  @override
  void create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.insert(data, builder: source));
  }

  @override
  void creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.inserts(data, builder: source));
  }

  @override
  void update<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.update(id, data, builder: source));
  }

  @override
  void delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.delete(id, builder: source));
  }

  @override
  void clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    request(() => handler.clear(builder: source));
  }

  @override
  void get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.get(id, builder: source));
  }

  @override
  void gets<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.gets(builder: source));
  }

  @override
  void getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    request(() => handler.getUpdates(builder: source));
  }

  @override
  Stream<Response<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.live(id, builder: source);
  }

  @override
  Stream<Response<T>> lives<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return handler.lives(builder: source);
  }
}
