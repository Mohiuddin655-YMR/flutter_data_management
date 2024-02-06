import 'package:flutter_andomie/utils/entities/entities.dart';

import '../../core/configs.dart';
import '../../core/typedefs.dart';
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
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.clear(builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.clear(
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.clear(builder: builder);
      }
      return response;
    }
  }

  @override
  Future<DataResponse<T>> deleteById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.deleteById(id, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.deleteById(
        id,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.deleteById(id, builder: builder);
      }
      return response;
    }
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> create<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.create(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.create(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.create(data, builder: builder);
      }
      return response;
    }
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> creates<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.creates(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.creates(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.creates(data, builder: builder);
      }
      return response;
    }
  }

  /// Use for check current data
  @override
  Future<DataResponse<T>> checkById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.checkById(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.checkById(
          id,
          builder: builder,
        );
      } else {
        return source.checkById(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> getById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getById(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getById(id, builder: builder);
      } else {
        return source.getById(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> listenById<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenById(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenById(
          id,
          builder: builder,
        );
      } else {
        yield* source.listenById(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> get<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.get(
        builder: builder,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.get(
          builder: builder,
        );
      } else {
        return source.get(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> getByQuery<R>({
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getByQuery(
        builder: builder,
        forUpdates: forUpdates,
        queries: queries,
        sorts: sorts,
        options: options,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getByQuery(
          builder: builder,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      } else {
        return source.getByQuery(
          builder: builder,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> listenByQuery<R>({
    OnDataSourceBuilder<R>? builder,
    bool forUpdates = false,
    List<Query> queries = const [],
    List<Selection> selections = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listenByQuery(
        builder: builder,
        forUpdates: forUpdates,
        queries: queries,
        sorts: sorts,
        options: options,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listenByQuery(
          builder: builder,
          forUpdates: forUpdates,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      } else {
        yield* source.listenByQuery(
          builder: builder,
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
  Stream<DataResponse<T>> listen<R>({
    bool forUpdates = false,
    OnDataSourceBuilder<R>? builder,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.listen(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.listen(
          builder: builder,
        );
      } else {
        yield* source.listen(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> updateById<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.updateById(id, data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.updateById(
        id,
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.updateById(id, data, builder: builder);
      }
      return response;
    }
  }
}
