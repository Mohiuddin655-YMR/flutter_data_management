import 'package:flutter_andomie/utils/entities/entities.dart';

import '../../core/configs.dart';
import '../../services/repositories/local_data_repository.dart';
import '../../utils/response.dart';

///
/// You can use [Data] without [Entity]
///
class LocalDataRepositoryImpl<T extends Entity> extends LocalDataRepository<T> {
  LocalDataRepositoryImpl({
    required super.source,
    super.connectivity,
  });

  @override
  Future<DataResponse<T>> clear({
    FieldParams? params,
  }) {
    return source.clear(params: params);
  }

  @override
  Future<DataResponse<T>> deleteById(
    String id, {
    FieldParams? params,
  }) {
    return source.deleteById(id, params: params);
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create(
    T data, {
    FieldParams? params,
  }) {
    return source.create(data, params: params);
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates(
    List<T> data, {
    FieldParams? params,
  }) {
    return source.creates(data, params: params);
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById(
    String id, {
    FieldParams? params,
  }) {
    return source.checkById(id, params: params);
  }

  @override
  Future<DataResponse<T>> getById(
    String id, {
    FieldParams? params,
  }) {
    return source.getById(id, params: params);
  }

  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    FieldParams? params,
  }) {
    return source.listenById(id, params: params);
  }

  @override
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    FieldParams? params,
  }) {
    return source.get(params: params);
  }

  @override
  Future<DataResponse<T>> getByQuery({
    FieldParams? params,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return source.getByQuery(
      params: params,
      forUpdates: forUpdates,
      queries: queries,
      sorts: sorts,
      options: options,
    );
  }

  @override
  Stream<DataResponse<T>> listenByQuery({
    FieldParams? params,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) {
    return source.listenByQuery(
      params: params,
      forUpdates: forUpdates,
      queries: queries,
      sorts: sorts,
      options: options,
    );
  }

  @override
  Stream<DataResponse<T>> listen({
    bool forUpdates = false,
    FieldParams? params,
  }) {
    return source.listen(params: params);
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    FieldParams? params,
  }) {
    return source.updateById(id, data, params: params);
  }
}
