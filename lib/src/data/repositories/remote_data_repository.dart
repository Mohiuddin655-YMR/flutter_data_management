part of 'repositories.dart';

///
/// You can use [Data] without [Entity]
///
class RemoteDataRepositoryImpl<T extends Entity>
    extends RemoteDataRepository<T> {
  RemoteDataRepositoryImpl({
    required super.remote,
    super.connectivity,
    super.local,
    super.isCacheMode,
  });

  /// Use for check current data
  @override
  Future<DataResponse<T>> isAvailable<R>(
    String id, {
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.isAvailable(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.isAvailable(
          id,
          builder: builder,
        );
      } else {
        return remote.isAvailable(
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
      return local!.insert(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await remote.insert(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await local!.insert(data, builder: builder);
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
      return local!.inserts(data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await remote.inserts(
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await local!.inserts(data, builder: builder);
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
      return local!.update(id, data, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await remote.update(
        id,
        data,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await local!.update(id, data, builder: builder);
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
      return local!.delete(id, builder: builder);
    } else {
      var connected = await isConnected;
      var response = await remote.delete(
        id,
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await local!.delete(id, builder: builder);
      }
      return response;
    }
  }

  @override
  Future<DataResponse<T>> clear<R>({
    OnDataSourceBuilder<R>? builder,
  }) async {
    if (isCacheMode && isLocal) {
      return local!.clear(builder: builder);
    } else {
      var connected = await isConnected;
      var response = await remote.clear(
        isConnected: connected,
        builder: builder,
      );
      if (response.isSuccessful && isLocal) {
        await local!.clear(builder: builder);
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
      return local!.get(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.get(id, builder: builder);
      } else {
        return remote.get(
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
      return local!.gets(
        builder: builder,
      );
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.gets(
          builder: builder,
        );
      } else {
        return remote.gets(
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
      return local!.getUpdates(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        return local!.getUpdates(
          builder: builder,
        );
      } else {
        return remote.getUpdates(
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
      yield* local!.live(id, builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* local!.live(
          id,
          builder: builder,
        );
      } else {
        yield* remote.live(
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
      yield* local!.lives(builder: builder);
    } else {
      var connected = await isConnected;
      if (!connected && isLocal) {
        yield* local!.lives(
          builder: builder,
        );
      } else {
        yield* remote.lives(
          isConnected: connected,
          builder: builder,
        );
      }
    }
  }
}
