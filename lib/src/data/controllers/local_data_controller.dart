part of '../../services/controllers/controller.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataController<T extends Entity> extends DataController<T> {
  final LocalDataHandler<T> handler;

  LocalDataController(this.handler) : super._();

  LocalDataController.fromSource({
    required LocalDataSource<T> source,
  })  : handler = LocalDataHandlerImpl<T>.fromSource(source),
        super._();

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.isAvailable(id, builder: source));
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.insert(data, builder: source));
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.inserts(data, builder: source));
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.update(id, data, builder: source));
  }

  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.delete(id, builder: source));
  }

  @override
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    return _change(() => handler.clear(builder: source));
  }

  @override
  Future<DataResponse<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.get(id, builder: source));
  }

  @override
  Future<DataResponse<T>> gets<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.gets(builder: source));
  }

  @override
  Future<DataResponse<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    return _change(() => handler.getUpdates(builder: source));
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

  @override
  Future<DataResponse<T>> query<R>({
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return _change(() => handler.gets(builder: builder));
  }
}
