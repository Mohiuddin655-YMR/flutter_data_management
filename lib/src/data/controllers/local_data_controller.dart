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
    FieldParams? params,
  }) {
    return notifier(() => repository.checkById(id, params: params));
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create(
    T data, {
    FieldParams? params,
  }) {
    return notifier(() => repository.create(data, params: params));
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates(
    List<T> data, {
    FieldParams? params,
  }) {
    return notifier(() => repository.creates(data, params: params));
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById({
    required String id,
    required Map<String, dynamic> data,
    FieldParams? params,
  }) {
    return notifier(() => repository.updateById(id, data, params: params));
  }

  @override
  Future<DataResponse<T>> deleteById(
    String id, {
    FieldParams? params,
  }) {
    return notifier(() => repository.deleteById(id, params: params));
  }

  @override
  Future<DataResponse<T>> clear({
    FieldParams? params,
  }) async {
    return notifier(() => repository.clear(params: params));
  }

  @override
  Future<DataResponse<T>> getById(
    String id, {
    FieldParams? params,
  }) {
    return notifier(() => repository.getById(id, params: params));
  }

  @override
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    FieldParams? params,
  }) {
    return notifier(() {
      return repository.get(params: params, forUpdates: forUpdates);
    });
  }

  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    FieldParams? params,
  }) {
    return repository.listenById(id, params: params);
  }

  @override
  Stream<DataResponse<T>> listen({
    FieldParams? params,
  }) {
    return repository.listen(params: params);
  }

  @override
  Future<DataResponse<T>> getByQuery({
    bool forUpdates = false,
    FieldParams? params,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return notifier(() {
      return repository.get(params: params, forUpdates: forUpdates);
    });
  }
}
