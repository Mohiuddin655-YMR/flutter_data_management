import 'package:flutter_andomie/utils/entities/entities.dart';

import '../../core/configs.dart';
import '../../services/repositories/remote_data_repository.dart';
import '../../utils/response.dart';

///
/// You can use [Data] without [Entity]
///
class RemoteDataRepositoryImpl<T extends Entity>
    extends RemoteDataRepository<T> {
  RemoteDataRepositoryImpl({
    required super.source,
    super.connectivity,
    super.backup,
    super.isCacheMode,
  });

  @override
  Future<DataResponse<T>> clear({
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.clear(params: params);
    } else {
      var connected = await isConnected;
      var response = await source.clear(
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.clear(params: params);
      }
      return response;
    }
  }

  @override
  Future<DataResponse<T>> deleteById(
    String id, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.deleteById(id, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.deleteById(
        id,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.deleteById(id, params: params);
      }
      return response;
    }
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create(
    T data, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.create(data, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.create(
        data,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.create(data, params: params);
      }
      return response;
    }
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates(
    List<T> data, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.creates(data, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.creates(
        data,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.creates(data, params: params);
      }
      return response;
    }
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById(
    String id, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.checkById(id, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.checkById(
          id,
          params: params,
        );
      } else {
        return source.checkById(
          id,
          isConnected: connected,
          params: params,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> getById(
    String id, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getById(id, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getById(id, params: params);
      } else {
        return source.getById(
          id,
          isConnected: connected,
          params: params,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> listenById(
    String id, {
    FieldParams? params,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenById(id, params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenById(
          id,
          params: params,
        );
      } else {
        yield* source.listenById(
          id,
          isConnected: connected,
          params: params,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> get({
    bool forUpdates = false,
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.get(
        params: params,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.get(
          params: params,
        );
      } else {
        return source.get(
          isConnected: connected,
          params: params,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> getByQuery({
    FieldParams? params,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getByQuery(
        params: params,
        forUpdates: forUpdates,
        queries: queries,
        sorts: sorts,
        options: options,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getByQuery(
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      } else {
        return source.getByQuery(
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> listenByQuery({
    FieldParams? params,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenByQuery(
        params: params,
        forUpdates: forUpdates,
        queries: queries,
        sorts: sorts,
        options: options,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenByQuery(
          params: params,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      } else {
        yield* source.listenByQuery(
          params: params,
          isConnected: connected,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> listen({
    bool forUpdates = false,
    FieldParams? params,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listen(params: params);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listen(
          params: params,
        );
      } else {
        yield* source.listen(
          isConnected: connected,
          params: params,
        );
      }
    }
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById(
    String id,
    Map<String, dynamic> data, {
    FieldParams? params,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.updateById(id, data, params: params);
    } else {
      var connected = await isConnected;
      var response = await source.updateById(
        id,
        data,
        isConnected: connected,
        params: params,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.updateById(id, data, params: params);
      }
      return response;
    }
  }
}
