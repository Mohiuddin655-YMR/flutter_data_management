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
  void isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.isAvailable(id, builder: source));
  }

  /// Use for create single data
  @override
  void create<R>(
    T data, {
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.insert(data, builder: source));
  }

  /// Use for create multiple data
  @override
  void creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.inserts(data, builder: source));
  }

  /// Use for update single data
  @override
  void update<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.update(id, data, builder: source));
  }

  @override
  void delete<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.delete(id, builder: source));
  }

  @override
  void clear<R>({
    OnDataSourceBuilder<R>? source,
  }) async {
    _change(() => handler.clear(builder: source));
  }

  @override
  void get<R>(
    String id, {
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.get(id, builder: source));
  }

  @override
  void gets<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.gets(builder: source));
  }

  @override
  void getUpdates<R>({
    OnDataSourceBuilder<R>? source,
  }) {
    _change(() => handler.getUpdates(builder: source));
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
