part of '../../services/controllers/controller.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataController<T extends Entity> extends DataController<T> {
  final LocalDataRepository<T> repository;

  LocalDataController(this.repository) : super._();

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() => repository.checkById(id, builder: builder));
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() => repository.create(data, builder: builder));
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() => repository.creates(data, builder: builder));
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById<R>({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() => repository.updateById(id, data, builder: builder));
  }

  @override
  Future<DataResponse<T>> deleteById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() => repository.deleteById(id, builder: builder));
  }

  @override
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    return notifier(() => repository.clear(builder: builder));
  }

  @override
  Future<DataResponse<T>> getById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() => repository.getById(id, builder: builder));
  }

  @override
  Future<DataResponse<T>> get<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) {
    return notifier(() {
      return repository.get(builder: builder, forUpdates: forUpdates);
    });
  }

  @override
  Stream<DataResponse<T>> listenById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.listenById(id, builder: builder);
  }

  @override
  Stream<DataResponse<T>> listen<R>({
    OnDataSourceBuilder<R>? builder,
  }) {
    return repository.listen(builder: builder);
  }

  @override
  Future<DataResponse<T>> getByQuery<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return notifier(() {
      return repository.get(builder: builder, forUpdates: forUpdates);
    });
  }
}
