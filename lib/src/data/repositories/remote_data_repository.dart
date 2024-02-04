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

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.isAvailable(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.isAvailable(
          id,
          builder: builder,
        );
      } else {
        return source.isAvailable(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  /// Use for create single data
  @override
  Future<DataResponse<T>> insert<R>(
    T data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.insert(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.insert(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.insert(data, builder: builder);
      }
      return response;
    }
  }

  /// Use for create multiple data
  @override
  Future<DataResponse<T>> inserts<R>(
    List<T> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.inserts(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.inserts(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.inserts(data, builder: builder);
      }
      return response;
    }
  }

  /// Use for update single data
  @override
  Future<DataResponse<T>> update<R>(
    String id,
    Map<String, dynamic> data, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.update(id, data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.update(
        id,
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.update(id, data, builder: builder);
      }
      return response;
    }
  }

  @override
  Future<DataResponse<T>> delete<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.delete(id, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await source.delete(
        id,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await backup!.delete(id, builder: builder);
      }
      return response;
    }
  }

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
  Future<DataResponse<T>> get<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.get(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.get(id, builder: builder);
      } else {
        return source.get(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> gets<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.gets(
        builder: builder,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.gets(
          builder: builder,
        );
      } else {
        return source.gets(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Future<DataResponse<T>> getUpdates<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.getUpdates(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.getUpdates(
          builder: builder,
        );
      } else {
        return source.getUpdates(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> live<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.live(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.live(
          id,
          builder: builder,
        );
      } else {
        yield* source.live(
          id,
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  @override
  Stream<DataResponse<T>> lives<R>({
    OnDataSourceBuilder<R>? builder,
  }) async* {
    if (isCacheMode && isLocal) {
      yield* backup!.lives(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* backup!.lives(
          builder: builder,
        );
      } else {
        yield* source.lives(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }

  /// Use for fetch data by query
  @override
  Future<DataResponse<T>> query<R>({
    OnDataSourceBuilder<R>? builder,
    List<Query> queries = const [],
    List<Sorting> sorts = const [],
    PagingOptions options = const PagingOptionsImpl(),
  }) async {
    if (isCacheMode && isLocal) {
      return backup!.gets(
        builder: builder,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return backup!.gets(
          builder: builder,
        );
      } else {
        return source.query(
          isConnected: connected,
          builder: builder,
          queries: queries,
          sorts: sorts,
          options: options,
        );
      }
    }
  }
}
