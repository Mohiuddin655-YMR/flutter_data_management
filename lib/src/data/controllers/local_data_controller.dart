part of '../../services/controllers/controller.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataController<T extends Entity> extends DataController<T> {
  final LocalDataRepository<T> repository;

  LocalDataController(this.repository) : super._();

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() => repository.checkById(id, builder: builder));
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create(
    T data, {
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() => repository.create(data, builder: builder));
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates(
    List<T> data, {
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() => repository.creates(data, builder: builder));
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById({
    required String id,
    required Map<String, dynamic> data,
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() => repository.updateById(id, data, builder: builder));
  }

  @override
  Future<DataResponse<T>> deleteById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() => repository.deleteById(id, builder: builder));
  }

  @override
  Future<DataResponse<T>> clear({
    OnDataSourceBuilder? builder,
  }) async {
    return notifier(() => repository.clear(builder: builder));
  }

  @override
  Future<DataResponse<T>> getById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() => repository.getById(id, builder: builder));
  }

  @override
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
  }) {
    return notifier(() {
      return repository.get(builder: builder, forUpdates: forUpdates);
    });
  }

  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    OnDataSourceBuilder? builder,
  }) {
    return repository.listenById(id, builder: builder);
  }

  @override
  Stream<DataResponse<T>> listen({
    OnDataSourceBuilder? builder,
  }) {
    return repository.listen(builder: builder);
  }

  @override
  Future<DataResponse<T>> getByQuery({
    bool forUpdates = false,
    OnDataSourceBuilder? builder,
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
